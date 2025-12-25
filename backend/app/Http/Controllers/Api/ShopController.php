<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Shop;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

class ShopController extends Controller
{
    /**
     * Get nearby shops based on user's location
     * Uses Haversine formula to calculate distance
     */
    public function nearby(Request $request)
    {
        $request->validate([
            'latitude' => 'required|numeric|between:-90,90',
            'longitude' => 'required|numeric|between:-180,180',
            'radius' => 'nullable|numeric|min:0.1|max:100', // radius in km, default 10km
        ]);

        $latitude = $request->latitude;
        $longitude = $request->longitude;
        $radius = $request->radius ?? 10; // Default 10km radius

        // Haversine formula to calculate distance in kilometers
        $shops = Shop::select([
                'shops.*',
                DB::raw("(
                    6371 * acos(
                        cos(radians($latitude)) 
                        * cos(radians(latitude)) 
                        * cos(radians(longitude) - radians($longitude)) 
                        + sin(radians($latitude)) 
                        * sin(radians(latitude))
                    )
                ) AS distance")
            ])
            ->where('status', 'approved')
            ->whereNotNull('latitude')
            ->whereNotNull('longitude')
            ->having('distance', '<=', $radius)
            ->orderBy('distance', 'asc')
            ->with('owner:id,name,profile_image')
            ->withCount('products')
            ->get();

        return response()->json([
            'shops' => $shops,
            'total' => $shops->count(),
            'search_radius_km' => (double) $radius,
            'user_location' => [
                'latitude' => (double) $latitude,
                'longitude' => (double) $longitude,
            ],
        ]);
    }

    /**
     * Get a single shop by ID with details
     */
    public function show($id)
    {
        $shop = Shop::where('status', 'approved')
            ->with(['owner:id,name,profile_image', 'products' => function ($query) {
                $query->where('is_active', true)->take(10);
            }])
            ->withCount('products')
            ->findOrFail($id);

        return response()->json($shop);
    }

    /**
     * Get all approved shops (with optional filters)
     */
    public function index(Request $request)
    {
        $query = Shop::where('status', 'approved')
            ->with('owner:id,name,profile_image')
            ->withCount('products');

        // Filter by type
        if ($request->has('type')) {
            $query->where('type', $request->type);
        }

        // Filter by city
        if ($request->has('city')) {
            $query->where('city', 'like', '%' . $request->city . '%');
        }

        // Filter by province
        if ($request->has('province')) {
            $query->where('province', $request->province);
        }

        // Search by name
        if ($request->has('search')) {
            $query->where('name', 'like', '%' . $request->search . '%');
        }

        $shops = $query->orderBy('created_at', 'desc')->paginate(20);

        return response()->json($shops);
    }

    /**
     * Get shop types for filtering
     */
    public function types()
    {
        $types = Shop::where('status', 'approved')
            ->distinct()
            ->pluck('type');

        return response()->json($types);
    }
}
