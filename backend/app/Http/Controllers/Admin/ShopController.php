<?php

namespace App\Http\Controllers\Admin;

use App\Http\Controllers\Controller;
use App\Models\Shop;
use Illuminate\Http\Request;

class ShopController extends Controller
{
    public function index(Request $request)
    {
        $query = Shop::with('owner');

        if ($request->filled('status')) {
            $query->where('status', $request->status);
        }

        if ($request->filled('search')) {
            $query->where('name', 'like', "%{$request->search}%");
        }

        $shops = $query->latest()->paginate(15);

        return view('admin.shops.index', compact('shops'));
    }

    public function show(Shop $shop)
    {
        $shop->load(['owner', 'products']);
        return view('admin.shops.show', compact('shop'));
    }

    public function approve(Shop $shop)
    {
        $shop->update(['status' => 'approved']);
        return back()->with('success', 'Shop approved successfully.');
    }

    public function reject(Shop $shop)
    {
        $shop->update(['status' => 'rejected']);
        return back()->with('success', 'Shop rejected.');
    }
}
