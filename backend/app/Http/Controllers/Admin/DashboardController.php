<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Order;
use App\Models\Product;
use App\Models\User;
use App\Models\Shop;
use App\Models\Category;
use Illuminate\Http\Request;

class DashboardController extends Controller
{
    public function index()
    {
        $stats = [
            'total_orders' => Order::count(),
            'total_revenue' => Order::where('status', 'delivered')->sum('total_amount'),
            'total_users' => User::count(),
            'total_products' => Product::count(),
            'pending_orders' => Order::where('status', 'pending')->count(),
            'pending_shops' => Shop::where('status', 'pending')->count(),
        ];

        $recentOrders = Order::with('user')
            ->latest()
            ->take(10)
            ->get();

        $pendingShops = Shop::where('status', 'pending')
            ->with('user')
            ->take(5)
            ->get();

        return view('admin.dashboard', compact('stats', 'recentOrders', 'pendingShops'));
    }
}
