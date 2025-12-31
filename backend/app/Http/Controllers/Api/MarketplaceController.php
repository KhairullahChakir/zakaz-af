<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\MarketplaceItem;
use App\Models\MarketplaceItemImage;
use Illuminate\Http\Request;

class MarketplaceController extends Controller
{
    public function index(Request $request)
    {
        $query = MarketplaceItem::with(['user', 'category', 'images'])->where('status', 'active');

        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->has('condition')) {
            $query->where('condition', $request->condition);
        }

        if ($request->has('min_price')) {
            $query->where('price', '>=', $request->min_price);
        }

        if ($request->has('max_price')) {
            $query->where('price', '<=', $request->max_price);
        }

        if ($request->has('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        return $query->latest()->paginate(20);
    }

    public function store(Request $request)
    {
        $request->validate([
            'name' => 'required|string|max:255',
            'description' => 'required|string',
            'price' => 'required|numeric|min:0',
            'condition' => 'required|string',
            'phone' => 'required|string',
            'category_id' => 'nullable|exists:categories,id',
            'location' => 'nullable|string',
            'images' => 'required|array|min:1',
            'images.*' => 'image|mimes:jpeg,png,jpg,webp|max:5120',
        ]);

        $item = MarketplaceItem::create([
            'user_id' => $request->user()->id,
            'category_id' => $request->category_id,
            'name' => $request->name,
            'description' => $request->description,
            'price' => $request->price,
            'condition' => $request->condition,
            'phone' => $request->phone,
            'location' => $request->location,
        ]);

        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $path = $image->store('marketplace', 'public');
                MarketplaceItemImage::create([
                    'marketplace_item_id' => $item->id,
                    'image_path' => $path,
                ]);
            }
        }

        return $item->load(['images', 'category']);
    }

    public function show($id)
    {
        return MarketplaceItem::with(['user', 'category', 'images'])->findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $item = MarketplaceItem::findOrFail($id);

        if ($item->user_id !== $request->user()->id) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $request->validate([
            'name' => 'sometimes|string|max:255',
            'description' => 'sometimes|string',
            'price' => 'sometimes|numeric|min:0',
            'condition' => 'sometimes|string',
            'phone' => 'sometimes|string',
            'status' => 'sometimes|string|in:active,sold,archived',
            'location' => 'nullable|string',
            'images' => 'nullable|array',
            'images.*' => 'image|mimes:jpeg,png,jpg,webp|max:5120',
            'deleted_images' => 'nullable|array',
        ]);

        $item->update($request->only([
            'name', 'description', 'price', 'condition', 'phone', 'status', 'location', 'category_id'
        ]));

        // Handle deleted images
        if ($request->has('deleted_images')) {
            foreach ($request->deleted_images as $deletedUrl) {
                // Try to find the image by matching end of URL or path
                $filename = basename($deletedUrl);
                // Look for image where path ends with this filename
                $image = $item->images()->where('image_path', 'like', "%$filename")->first();
                if ($image) {
                    \Storage::disk('public')->delete($image->image_path);
                    $image->delete();
                }
            }
        }

        // Handle new images
        if ($request->hasFile('images')) {
            foreach ($request->file('images') as $image) {
                $path = $image->store('marketplace', 'public');
                MarketplaceItemImage::create([
                    'marketplace_item_id' => $item->id,
                    'image_path' => $path,
                ]);
            }
        }

        // Refresh relation
        return $item->fresh(['images', 'category']);
    }

    public function destroy(Request $request, $id)
    {
        $item = MarketplaceItem::findOrFail($id);

        if ($item->user_id !== $request->user()->id && !$request->user()->isAdmin()) {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Delete images from storage
        foreach ($item->images as $image) {
            \Storage::disk('public')->delete($image->image_path);
        }

        $item->delete();

        return response()->json(['message' => 'Listing deleted successfully']);
    }

    public function myItems(Request $request)
    {
        return MarketplaceItem::with(['images', 'category'])
            ->where('user_id', $request->user()->id)
            ->latest()
            ->paginate(20);
    }
}
