<?php

use Illuminate\Support\Facades\Broadcast;
use App\Models\Conversation;

Broadcast::channel('App.Models.User.{id}', function ($user, $id) {
    return (int) $user->id === (int) $id;
});

Broadcast::channel('chat.{conversationId}', function ($user, $conversationId) {
    // We can load conversation to check access
    $conversation = Conversation::with('shop')->find($conversationId);
    
    if (!$conversation) {
        return false;
    }
    
    // Allow if user is the customer
    if ($user->id == $conversation->customer_id) {
        return true;
    }
    
    // Allow if user is the shop owner
    if ($conversation->shop && $conversation->shop->owner_id == $user->id) {
        return true;
    }
    
    return false;
});
