<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Shop;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Storage;

class ShopApplicationController extends Controller
{
    /**
     * Submit a shop application (Customer -> Shopkeeper)
     */
    public function apply(Request $request)
    {
        $user = $request->user();

        // Check if user already has a shop
        if ($user->shop) {
            return response()->json([
                'message' => 'You already have a shop application',
                'shop' => $user->shop,
            ], 422);
        }

        $request->validate([
            'name' => 'required|string|max:255',
            'type' => 'required|string|max:100',
            'description' => 'nullable|string',
            'address' => 'required|string',
            'city' => 'required|string|max:100',
            'province' => 'required|string|max:100',
            'latitude' => 'nullable|numeric',
            'longitude' => 'nullable|numeric',
            'phone' => 'required|string|max:20',
            'email' => 'nullable|email',
            'photos' => 'required|array|min:1|max:3',
            'photos.*' => 'image|max:2048',
            'business_license' => 'required|file|max:5120', // 5MB max
            'owner_nid' => 'nullable|file|max:5120',
        ]);

        // Upload photos
        $photoPaths = [];
        foreach ($request->file('photos') as $photo) {
            $photoPaths[] = $photo->store('shops/photos', 'public');
        }

        // Upload documents
        $licensePath = $request->file('business_license')->store('shops/documents', 'public');
        $nidPath = $request->hasFile('owner_nid') 
            ? $request->file('owner_nid')->store('shops/documents', 'public') 
            : null;

        $shop = Shop::create([
            'owner_id' => $user->id,
            'name' => $request->name,
            'type' => $request->type,
            'description' => $request->description,
            'address' => $request->address,
            'city' => $request->city,
            'province' => $request->province,
            'latitude' => $request->latitude,
            'longitude' => $request->longitude,
            'phone' => $request->phone,
            'email' => $request->email,
            'photos' => $photoPaths,
            'business_license' => $licensePath,
            'owner_nid' => $nidPath,
            'status' => 'pending',
        ]);

        return response()->json([
            'message' => 'Shop application submitted successfully. Awaiting admin approval.',
            'shop' => $shop,
        ], 201);
    }

    /**
     * Get user's shop application status
     */
    public function status(Request $request)
    {
        $shop = $request->user()->shop;

        if (!$shop) {
            return response()->json([
                'has_application' => false,
            ]);
        }

        return response()->json([
            'has_application' => true,
            'shop' => $shop,
        ]);
    }

    /**
     * Admin: List all pending applications
     */
    public function pending(Request $request)
    {
        if (!$request->user()->isAdmin()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $shops = Shop::where('status', 'pending')
            ->with('owner')
            ->orderBy('created_at', 'asc')
            ->get();

        return response()->json($shops);
    }

    /**
     * Admin: Get all applications (with filter)
     */
    public function index(Request $request)
    {
        if (!$request->user()->isAdmin()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $query = Shop::with('owner');

        if ($request->has('status')) {
            $query->where('status', $request->status);
        }

        return response()->json($query->orderBy('created_at', 'desc')->get());
    }

    /**
     * Admin: Approve a shop
     */
    public function approve(Request $request, $id)
    {
        if (!$request->user()->isAdmin()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $shop = Shop::findOrFail($id);
        
        if ($shop->status !== 'pending') {
            return response()->json(['message' => 'Shop is not pending'], 422);
        }

        $shop->update([
            'status' => 'approved',
            'approved_at' => now(),
        ]);

        // Update user role to shopkeeper
        $shop->owner->update(['role' => 'shopkeeper']);

        return response()->json([
            'message' => 'Shop approved successfully',
            'shop' => $shop->load('owner'),
        ]);
    }

    /**
     * Admin: Reject a shop
     */
    public function reject(Request $request, $id)
    {
        if (!$request->user()->isAdmin()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'reason' => 'required|string|max:500',
        ]);

        $shop = Shop::findOrFail($id);

        $shop->update([
            'status' => 'rejected',
            'rejection_reason' => $request->reason,
        ]);

        return response()->json([
            'message' => 'Shop rejected',
            'shop' => $shop,
        ]);
    }

    /**
     * Admin: Suspend a shop
     */
    public function suspend(Request $request, $id)
    {
        if (!$request->user()->isAdmin()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'reason' => 'required|string|max:500',
        ]);

        $shop = Shop::findOrFail($id);

        $shop->update([
            'status' => 'suspended',
            'rejection_reason' => $request->reason,
        ]);

        // Optionally revert user role
        $shop->owner->update(['role' => 'customer']);

        return response()->json([
            'message' => 'Shop suspended',
            'shop' => $shop,
        ]);
    }
}
