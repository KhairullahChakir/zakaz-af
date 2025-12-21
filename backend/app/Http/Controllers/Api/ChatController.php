<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Conversation;
use App\Models\Message;
use App\Models\Shop;
use App\Events\MessageSent;
use Illuminate\Http\Request;

class ChatController extends Controller
{
    /**
     * Get all conversations for the current user
     */
    public function index(Request $request)
    {
        $user = $request->user();
        
        // Get conversations where user is customer OR shop owner
        $conversations = Conversation::with(['customer', 'shop.owner', 'product', 'latestMessage.sender'])
            ->where(function ($query) use ($user) {
                $query->where('customer_id', $user->id)
                    ->orWhereHas('shop', function ($q) use ($user) {
                        $q->where('owner_id', $user->id);
                    });
            })
            ->orderBy('last_message_at', 'desc')
            ->get()
            ->map(function ($conversation) use ($user) {
                // Add other participant info
                $isCustomer = $conversation->customer_id == $user->id;
                $otherParticipant = $isCustomer 
                    ? $conversation->shop?->owner 
                    : $conversation->customer;
                
                return [
                    'id' => $conversation->id,
                    'customer_id' => $conversation->customer_id,
                    'shop_id' => $conversation->shop_id,
                    'product_id' => $conversation->product_id,
                    'last_message_at' => $conversation->last_message_at,
                    'unread_count' => $conversation->unread_count,
                    'other_participant' => $otherParticipant ? [
                        'id' => $otherParticipant->id,
                        'name' => $otherParticipant->name,
                        'profile_image_url' => $otherParticipant->profile_image_url,
                    ] : null,
                    'shop' => $conversation->shop ? [
                        'id' => $conversation->shop->id,
                        'name' => $conversation->shop->name,
                        'main_photo_url' => $conversation->shop->main_photo_url,
                    ] : null,
                    'product' => $conversation->product ? [
                        'id' => $conversation->product->id,
                        'name' => $conversation->product->name,
                        'image_url' => $conversation->product->image_url,
                        'price' => $conversation->product->price,
                    ] : null,
                    'latest_message' => $conversation->latestMessage ? [
                        'content' => $conversation->latestMessage->content,
                        'type' => $conversation->latestMessage->type,
                        'created_at' => $conversation->latestMessage->created_at,
                        'sender_id' => $conversation->latestMessage->sender_id,
                    ] : null,
                    'created_at' => $conversation->created_at,
                ];
            });

        return response()->json($conversations);
    }

    /**
     * Start or get existing conversation with a shop
     */
    public function startConversation(Request $request)
    {
        $request->validate([
            'shop_id' => 'required|exists:shops,id',
            'product_id' => 'nullable|exists:products,id',
        ]);

        $user = $request->user();
        $shop = Shop::findOrFail($request->shop_id);

        // Can't chat with your own shop
        if ($shop->owner_id == $user->id) {
            return response()->json(['error' => 'Cannot chat with your own shop'], 400);
        }

        // Find or create conversation
        $conversation = Conversation::firstOrCreate(
            [
                'customer_id' => $user->id,
                'shop_id' => $request->shop_id,
            ],
            [
                'product_id' => $request->product_id,
            ]
        );

        // Load relationships
    $conversation->load(['customer', 'shop.owner', 'product']);

    $otherParticipant = $conversation->shop->owner;

    return response()->json([
        'id' => $conversation->id,
        'customer_id' => $conversation->customer_id,
        'shop_id' => $conversation->shop_id,
        'product_id' => $conversation->product_id,
        'other_participant' => $otherParticipant ? [
            'id' => $otherParticipant->id,
            'name' => $otherParticipant->name,
            'profile_image_url' => $otherParticipant->profile_image_url,
        ] : null,
        'shop' => $conversation->shop ? [
            'id' => $conversation->shop->id,
            'name' => $conversation->shop->name,
            'main_photo_url' => $conversation->shop->main_photo_url,
            'owner' => $conversation->shop->owner ? [
                'id' => $conversation->shop->owner->id,
                'name' => $otherParticipant->name,
            ] : null,
        ] : null,
        'product' => $conversation->product ? [
            'id' => $conversation->product->id,
            'name' => $conversation->product->name,
            'image_url' => $conversation->product->image_url,
            'price' => $conversation->product->price,
        ] : null,
        'created_at' => $conversation->created_at,
    ]);
    }

    /**
     * Get messages for a conversation
     */
    public function getMessages(Request $request, $conversationId)
    {
        $user = $request->user();
        
        $conversation = Conversation::with('shop')
            ->where(function ($query) use ($user) {
                $query->where('customer_id', $user->id)
                    ->orWhereHas('shop', function ($q) use ($user) {
                        $q->where('owner_id', $user->id);
                    });
            })
            ->findOrFail($conversationId);

        // Mark messages as read
        Message::where('conversation_id', $conversationId)
            ->where('sender_id', '!=', $user->id)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        $messages = Message::with('sender')
            ->where('conversation_id', $conversationId)
            ->orderBy('created_at', 'asc')
            ->get()
            ->map(function ($message) {
                return [
                    'id' => (int) $message->id,
                    'conversation_id' => (int) $message->conversation_id,
                    'sender_id' => (int) $message->sender_id,
                    'content' => $message->content,
                    'type' => $message->type,
                    'metadata' => $message->metadata,
                    'is_read' => (bool) $message->is_read,
                    'created_at' => $message->created_at,
                    'sender' => $message->sender ? [
                        'id' => (int) $message->sender->id,
                        'name' => $message->sender->name,
                        'profile_image_url' => $message->sender->profile_image_url,
                    ] : null,
                ];
            });

        return response()->json($messages);
    }

    /**
     * Send a message
     */
    public function sendMessage(Request $request, $conversationId)
    {
        $request->validate([
            'content' => 'required|string|max:2000',
            'type' => 'nullable|in:text,image,product',
            'metadata' => 'nullable|array',
        ]);

        $user = $request->user();
        
        // Verify user has access to this conversation
        $conversation = Conversation::with('shop')
            ->where(function ($query) use ($user) {
                $query->where('customer_id', $user->id)
                    ->orWhereHas('shop', function ($q) use ($user) {
                        $q->where('owner_id', $user->id);
                    });
            })
            ->findOrFail($conversationId);

        $message = Message::create([
            'conversation_id' => $conversationId,
            'sender_id' => $user->id,
            'content' => $request->content,
            'type' => $request->type ?? 'text',
            'metadata' => $request->metadata,
        ]);

        // Update conversation last_message_at
        $conversation->update(['last_message_at' => now()]);

        $message->load('sender');
        
        // broadcast(new MessageSent($message))->toOthers();

    return response()->json([
        'id' => (int) $message->id,
        'conversation_id' => (int) $message->conversation_id,
        'sender_id' => (int) $message->sender_id,
        'content' => $message->content,
        'type' => $message->type,
        'metadata' => $message->metadata,
        'is_read' => (bool) $message->is_read,
        'created_at' => $message->created_at,
        'sender' => $message->sender ? [
            'id' => (int) $message->sender->id,
            'name' => $message->sender->name,
            'profile_image_url' => $message->sender->profile_image_url,
        ] : null,
    ], 201);
    }

    /**
     * Get unread message count
     */
    public function unreadCount(Request $request)
    {
        $user = $request->user();
        
        $count = Message::whereHas('conversation', function ($query) use ($user) {
            $query->where('customer_id', $user->id)
                ->orWhereHas('shop', function ($q) use ($user) {
                    $q->where('owner_id', $user->id);
                });
        })
        ->where('sender_id', '!=', $user->id)
        ->where('is_read', false)
        ->count();

        return response()->json(['count' => $count]);
    }
}
