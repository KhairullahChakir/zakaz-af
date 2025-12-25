<?php

namespace App\Http\Controllers;

use App\Models\Notification;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Http;
use Google\Auth\Credentials\ServiceAccountCredentials;

class NotificationController extends Controller
{
    // Get user's notifications
    public function index(Request $request)
    {
        $notifications = Notification::where('user_id', $request->user()->id)
            ->orderBy('created_at', 'desc')
            ->paginate(20);

        return response()->json($notifications);
    }

    // Mark notification as read
    public function markAsRead(Request $request, Notification $notification)
    {
        if ($notification->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $notification->update(['is_read' => true]);
        return response()->json(['message' => 'Marked as read']);
    }

    // Mark all as read
    public function markAllAsRead(Request $request)
    {
        Notification::where('user_id', $request->user()->id)
            ->where('is_read', false)
            ->update(['is_read' => true]);

        return response()->json(['message' => 'All marked as read']);
    }

    // Get unread count
    public function unreadCount(Request $request)
    {
        $count = Notification::where('user_id', $request->user()->id)
            ->where('is_read', false)
            ->count();

        return response()->json(['count' => $count]);
    }

    // Admin: Send notification to users
    public function send(Request $request)
    {
        $request->validate([
            'title' => 'required|string|max:255',
            'body' => 'required|string',
            'type' => 'nullable|string|max:50',
            'user_ids' => 'nullable|array',
            'user_ids.*' => 'integer|exists:users,id',
        ]);

        $title = $request->title;
        $body = $request->body;
        $type = $request->type ?? 'general';
        $userIds = $request->user_ids;

        // Get target users
        if ($userIds) {
            $users = User::whereIn('id', $userIds)->get();
        } else {
            $users = User::all();
        }

        $sentCount = 0;
        foreach ($users as $user) {
            // Save to database
            // Send using service
            \App\Services\FCMService::sendToUser($user, $title, $body, ['type' => $type], $type);
            
            if ($user->fcm_token) $sentCount++;
        }

        return response()->json([
            'message' => 'Notification sent',
            'total_users' => $users->count(),
            'push_sent' => $sentCount,
        ]);
    }
}
