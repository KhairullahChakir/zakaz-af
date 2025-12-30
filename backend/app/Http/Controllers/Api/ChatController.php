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
        
        // Get conversations where user is customer OR shop owner OR marketplace seller
        $conversations = Conversation::with(['customer', 'shop.owner', 'seller', 'product', 'marketplaceItem', 'latestMessage.sender'])
            ->where(function ($query) use ($user) {
                $query->where('customer_id', $user->id)
                    ->orWhere('seller_id', $user->id)
                    ->orWhereHas('shop', function ($q) use ($user) {
                        $q->where('owner_id', $user->id);
                    });
            })
            ->orderBy('last_message_at', 'desc')
            ->get()
            ->map(function ($conversation) use ($user) {
                // Add other participant info
                $isCustomer = $conversation->customer_id == $user->id;
                
                if ($conversation->marketplace_item_id) {
                    $otherParticipant = $isCustomer ? $conversation->seller : $conversation->customer;
                } else {
                    $otherParticipant = $isCustomer ? $conversation->shop?->owner : $conversation->customer;
                }
                
                return [
                    'id' => $conversation->id,
                    'customer_id' => $conversation->customer_id,
                    'shop_id' => $conversation->shop_id,
                    'seller_id' => $conversation->seller_id,
                    'product_id' => $conversation->product_id,
                    'marketplace_item_id' => $conversation->marketplace_item_id,
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
                    'marketplace_item' => $conversation->marketplaceItem ? [
                        'id' => $conversation->marketplaceItem->id,
                        'name' => $conversation->marketplaceItem->name,
                        'image_url' => $conversation->marketplaceItem->main_image_url,
                        'price' => $conversation->marketplaceItem->price,
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
            'shop_id' => 'nullable|exists:shops,id',
            'seller_id' => 'nullable|exists:users,id',
            'product_id' => 'nullable|exists:products,id',
            'marketplace_item_id' => 'nullable|exists:marketplace_items,id',
        ]);

        if (!$request->shop_id && !$request->seller_id) {
            return response()->json(['error' => 'Either shop_id or seller_id is required'], 422);
        }

        $user = $request->user();

        // Shop conversation
        if ($request->shop_id) {
            $shop = Shop::findOrFail($request->shop_id);
            if ($shop->owner_id == $user->id) {
                return response()->json(['error' => 'Cannot chat with your own shop'], 400);
            }

            $conversation = Conversation::firstOrCreate(
                [
                    'customer_id' => $user->id,
                    'shop_id' => $request->shop_id,
                ],
                [
                    'product_id' => $request->product_id,
                ]
            );
        } else {
            // Marketplace conversation
            if ($request->seller_id == $user->id) {
                return response()->json(['error' => 'Cannot chat with yourself'], 400);
            }

            $conversation = Conversation::firstOrCreate(
                [
                    'customer_id' => $user->id,
                    'seller_id' => $request->seller_id,
                    'marketplace_item_id' => $request->marketplace_item_id,
                ]
            );
        }

        // Load relationships
        $conversation->load(['customer', 'shop.owner', 'seller', 'product', 'marketplaceItem']);

        if ($conversation->marketplace_item_id) {
            $otherParticipant = $conversation->seller;
        } else {
            $otherParticipant = $conversation->shop->owner;
        }

        return response()->json([
            'id' => $conversation->id,
            'customer_id' => $conversation->customer_id,
            'shop_id' => $conversation->shop_id,
            'seller_id' => $conversation->seller_id,
            'product_id' => $conversation->product_id,
            'marketplace_item_id' => $conversation->marketplace_item_id,
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
            'marketplace_item' => $conversation->marketplaceItem ? [
                'id' => $conversation->marketplaceItem->id,
                'name' => $conversation->marketplaceItem->name,
                'image_url' => $conversation->marketplaceItem->main_image_url,
                'price' => $conversation->marketplaceItem->price,
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
        
        $conversation = Conversation::with(['shop', 'seller'])
            ->where(function ($query) use ($user) {
                $query->where('customer_id', $user->id)
                    ->orWhere('seller_id', $user->id)
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
            'content' => 'nullable|string|max:2000',
            'image' => 'nullable|image|max:5120', // Max 5MB
            'type' => 'nullable|in:text,image,product',
            'metadata' => 'nullable|array',
        ]);

        if (!$request->content && !$request->hasFile('image')) {
            return response()->json(['error' => ' content or image is required'], 422);
        }

        $user = $request->user();
        
        // Verify user has access to this conversation
        $conversation = Conversation::with(['shop', 'seller'])
            ->where(function ($query) use ($user) {
                $query->where('customer_id', $user->id)
                    ->orWhere('seller_id', $user->id)
                    ->orWhereHas('shop', function ($q) use ($user) {
                        $q->where('owner_id', $user->id);
                    });
            })
            ->findOrFail($conversationId);

        $content = $request->content;
        $type = $request->type ?? 'text';

        // Handle Image Upload
        if ($request->hasFile('image')) {
            $path = $request->file('image')->store('chat_images', 'public');
            $content = asset('storage/' . $path);
            $type = 'image';
        }

        $message = Message::create([
            'conversation_id' => $conversationId,
            'sender_id' => $user->id,
            'content' => $content,
            'type' => $type,
            'metadata' => $request->metadata,
        ]);

        // Update conversation last_message_at
        $conversation->update(['last_message_at' => now()]);

        $message->load('sender');
        
        // broadcast(new MessageSent($message))->toOthers();

        // Send Push Notification
        try {
            if ($conversation->marketplace_item_id) {
                $receiverId = ($conversation->customer_id == $user->id) 
                    ? $conversation->seller_id 
                    : $conversation->customer_id;
            } else {
                $receiverId = ($conversation->customer_id == $user->id) 
                    ? $conversation->shop->owner_id 
                    : $conversation->customer_id;
            }
            
            $receiver = \App\Models\User::find($receiverId);
            
            if ($receiver && $receiver->fcm_token) {
                $body = $message->type == 'image' ? 'Sent an image' : 
                        ($message->type == 'product' ? 'Sent a product' : \Illuminate\Support\Str::limit($content, 50));
                
                \App\Services\FCMService::send(
                    $receiver->fcm_token,
                    $user->name,
                    $body,
                    [
                        'type' => 'chat',
                        'conversation_id' => (string)$conversationId,
                        'sender_id' => (string)$user->id
                    ]
                );
            }
        } catch (\Exception $e) {
            \Illuminate\Support\Facades\Log::error("Chat notification error: " . $e->getMessage());
        }

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
                ->orWhere('seller_id', $user->id)
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
