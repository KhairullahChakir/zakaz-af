<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Shop;
use App\Models\Conversation;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;

class ChatNotificationTest extends TestCase
{
    use RefreshDatabase;

    public function test_message_sends_push_notification_to_receiver()
    {
        // 1. Setup
        $customer = User::factory()->create(['name' => 'Customer John', 'role' => 'customer']);
        $shopOwner = User::factory()->create(['name' => 'Shop Owner', 'role' => 'shopkeeper', 'fcm_token' => 'token_owner']);
        
        $shop = Shop::create([
            'owner_id' => $shopOwner->id,
            'name' => 'Test Shop',
            'type' => 'General',
            'status' => 'approved',
            'address' => 'Kabul',
            'city' => 'Kabul',
            'province' => 'Kabul',
            'phone' => '0777'
        ]);

        $conversation = Conversation::create([
            'customer_id' => $customer->id,
            'shop_id' => $shop->id
        ]);
        
        // Mock Http
        Http::fake();

        // 2. Action: Customer sends message to Shop
        $response = $this->actingAs($customer)
                         ->postJson("/api/chat/conversations/{$conversation->id}/messages", [
                             'content' => 'Hello Shopkeeper, do you have rice?'
                         ]);

        // 3. Assert
        $response->assertStatus(201);

        // Verify Http Request to FCM
        Http::assertSent(function ($request) use ($shopOwner) {
            // Check URL
            if (!str_contains($request->url(), 'fcm.googleapis.com')) return false;
            
            // Check Token
            if ($request['message']['token'] !== 'token_owner') return false;
            
            // Check Title (Sender Name)
            if ($request['message']['notification']['title'] !== 'Customer John') return false;
            
            // Check Body (Content limited)
            if (!str_contains($request['message']['notification']['body'], 'Hello Shopkeeper')) return false;

            return true;
        });
    }
}
