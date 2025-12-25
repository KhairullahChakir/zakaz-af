<?php

namespace Tests\Feature;

use Tests\TestCase;
use App\Models\User;
use App\Models\Shop;
use App\Models\Product;
use App\Models\Category;
use App\Models\Order;
use App\Models\OrderItem;
use App\Models\Address;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Http;

class OrderNotificationTest extends TestCase
{
    use RefreshDatabase;

    public function test_order_status_update_sends_notification()
    {
        // 1. Setup Data
        $shopkeeper = User::factory()->create(['role' => 'shopkeeper']);
        $customer = User::factory()->create(['role' => 'customer', 'fcm_token' => 'dummy_token']);
        
        $shop = Shop::create([
            'owner_id' => $shopkeeper->id,
            'name' => 'Test Shop',
            'type' => 'General Store',
            'phone' => '0799123456',
            'status' => 'approved',
            'description' => 'Test Desc',
            'address' => 'Kabul',
            'city' => 'Kabul',
            'province' => 'Kabul'
        ]);

        $category = Category::create(['name' => 'Test Cat', 'image' => 'test.jpg']);
        
        $product = Product::create([
            'shop_id' => $shop->id,
            'category_id' => $category->id,
            'name' => 'Test Product',
            'price' => 100,
            'stock' => 10,
            'description' => 'Test Desc'
        ]);

        $address = Address::create([
            'user_id' => $customer->id,
            'label' => 'Home',
            'address_line_1' => 'Test Address',
            'city' => 'Kabul'
        ]);

        $order = Order::create([
            'user_id' => $customer->id,
            'address_id' => $address->id,
            'total_amount' => 100,
            'status' => 'pending'
        ]);

        OrderItem::create([
            'order_id' => $order->id,
            'product_id' => $product->id,
            'quantity' => 1,
            'price' => 100
        ]);
        
        // Mock Http to prevent actual network calls (although DB entry test is what we care about primarily)
        // This ensures the test is fast and doesn't rely on google servers
        Http::fake();

        // 2. Action
        $response = $this->actingAs($shopkeeper)
                         ->patchJson("/api/shopkeeper/orders/{$order->id}/status", [
                             'status' => 'processing'
                         ]);

        // 3. Assert
        $response->assertStatus(200);
        
        $this->assertDatabaseHas('orders', [
            'id' => $order->id,
            'status' => 'processing'
        ]);

        $this->assertDatabaseHas('notifications', [
            'user_id' => $customer->id,
            'title' => 'Order Status Updated',
            'type' => 'order'
        ]);
    }
}
