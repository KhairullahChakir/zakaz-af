<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use App\Models\Order;
use App\Models\OrderItem;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\DB;

class ShopkeeperController extends Controller
{
    /**
     * Get shopkeeper dashboard stats
     */
    public function dashboard(Request $request)
    {
        $user = $request->user();
        
        if (!$user->isShopkeeper()) {
            return response()->json(['message' => 'Not a shopkeeper'], 403);
        }

        $shop = $user->shop;
        
        if (!$shop || !$shop->isApproved()) {
            return response()->json(['message' => 'Shop not approved'], 403);
        }

        // Get product IDs for this shop
        $productIds = Product::where('shop_id', $shop->id)->pluck('id');

        // Total products
        $totalProducts = $productIds->count();

        // Total orders containing shop's products
        $orderItemsQuery = OrderItem::whereIn('product_id', $productIds);
        $totalOrders = $orderItemsQuery->distinct('order_id')->count('order_id');

        // Total revenue from shop's products
        $totalRevenue = OrderItem::whereIn('product_id', $productIds)
            ->join('orders', 'order_items.order_id', '=', 'orders.id')
            ->whereIn('orders.status', ['processing', 'shipped', 'delivered'])
            ->sum(DB::raw('order_items.price * order_items.quantity'));

        // Pending orders
        $pendingOrders = Order::whereHas('items', function ($q) use ($productIds) {
            $q->whereIn('product_id', $productIds);
        })->where('status', 'pending')->count();

        // Recent orders
        $recentOrders = Order::whereHas('items', function ($q) use ($productIds) {
            $q->whereIn('product_id', $productIds);
        })
            ->with(['items' => function ($q) use ($productIds) {
                $q->whereIn('product_id', $productIds)->with('product');
            }, 'user'])
            ->orderBy('created_at', 'desc')
            ->limit(5)
            ->get();

        return response()->json([
            'shop' => $shop,
            'stats' => [
                'total_products' => $totalProducts,
                'total_orders' => $totalOrders,
                'total_revenue' => $totalRevenue,
                'pending_orders' => $pendingOrders,
            ],
            'recent_orders' => $recentOrders,
        ]);
    }

    /**
     * Get shopkeeper's products
     */
    public function products(Request $request)
    {
        $user = $request->user();
        $shop = $user->shop;

        if (!$shop || !$shop->isApproved()) {
            return response()->json(['message' => 'Shop not approved'], 403);
        }

        $products = Product::where('shop_id', $shop->id)
            ->with('category')
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($products);
    }

    /**
     * Create a product for shopkeeper's shop
     */
    public function storeProduct(Request $request)
    {
        $user = $request->user();
        $shop = $user->shop;

        if (!$shop || !$shop->isApproved()) {
            return response()->json(['message' => 'Shop not approved'], 403);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'required|numeric|min:0',
            'stock' => 'required|integer|min:0',
            'category_id' => 'required|exists:categories,id',
            'image' => 'nullable|image|max:2048',
        ]);

        $data = $request->only(['name', 'description', 'price', 'stock', 'category_id']);
        $data['shop_id'] = $shop->id;

        if ($request->hasFile('image')) {
            $data['image'] = $request->file('image')->store('products', 'public');
        }

        $product = Product::create($data);

        return response()->json([
            'message' => 'Product created successfully',
            'product' => $product->load('category'),
        ], 201);
    }

    /**
     * Update shopkeeper's product
     */
    public function updateProduct(Request $request, $id)
    {
        $user = $request->user();
        $shop = $user->shop;

        $product = Product::where('id', $id)->where('shop_id', $shop->id)->firstOrFail();

        $request->validate([
            'name' => 'sometimes|required|string|max:255',
            'description' => 'nullable|string',
            'price' => 'sometimes|required|numeric|min:0',
            'stock' => 'sometimes|required|integer|min:0',
            'category_id' => 'sometimes|required|exists:categories,id',
            'image' => 'nullable|image|max:2048',
        ]);

        $data = $request->only(['name', 'description', 'price', 'stock', 'category_id']);

        if ($request->hasFile('image')) {
            if ($product->image) {
                Storage::disk('public')->delete($product->image);
            }
            $data['image'] = $request->file('image')->store('products', 'public');
        }

        $product->update($data);

        return response()->json([
            'message' => 'Product updated successfully',
            'product' => $product->load('category'),
        ]);
    }

    /**
     * Delete shopkeeper's product
     */
    public function destroyProduct(Request $request, $id)
    {
        $user = $request->user();
        $shop = $user->shop;

        $product = Product::where('id', $id)->where('shop_id', $shop->id)->firstOrFail();

        if ($product->image) {
            Storage::disk('public')->delete($product->image);
        }

        $product->delete();

        return response()->json(['message' => 'Product deleted successfully']);
    }

    /**
     * Get orders containing shopkeeper's products
     */
    public function orders(Request $request)
    {
        $user = $request->user();
        $shop = $user->shop;

        if (!$shop || !$shop->isApproved()) {
            return response()->json(['message' => 'Shop not approved'], 403);
        }

        $productIds = Product::where('shop_id', $shop->id)->pluck('id');

        $orders = Order::whereHas('items', function ($q) use ($productIds) {
            $q->whereIn('product_id', $productIds);
        })
            ->with(['items' => function ($q) use ($productIds) {
                $q->whereIn('product_id', $productIds)->with('product');
            }, 'user', 'address'])
            ->orderBy('created_at', 'desc')
            ->get();

        return response()->json($orders);
    }

    /**
     * Update order status (for shopkeeper's order items only)
     */
    public function updateOrderStatus(Request $request, $orderId)
    {
        $user = $request->user();
        $shop = $user->shop;

        if (!$shop || !$shop->isApproved()) {
            return response()->json(['message' => 'Shop not approved'], 403);
        }

        $productIds = Product::where('shop_id', $shop->id)->pluck('id');

        // Verify the order contains this shop's products
        $order = Order::whereHas('items', function ($q) use ($productIds) {
            $q->whereIn('product_id', $productIds);
        })->findOrFail($orderId);

        $request->validate([
            'status' => 'required|in:pending,processing,shipped,delivered,cancelled',
        ]);

        $order->update(['status' => $request->status]);

        return response()->json([
            'message' => 'Order status updated',
            'order' => $order->load(['items.product', 'user', 'address']),
        ]);
    }
}
