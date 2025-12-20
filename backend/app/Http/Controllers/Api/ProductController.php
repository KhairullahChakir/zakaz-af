<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;

class ProductController extends Controller
{
    public function index(Request $request)
    {
        $query = Product::query();

        // Add average rating and order count subqueries
        $query->withAvg('reviews', 'rating')
              ->withCount(['orderItems as order_count' => function($q) {
                  $q->selectRaw('COALESCE(SUM(quantity), 0)');
              }]);

        if ($request->has('category_id')) {
            $query->where('category_id', $request->category_id);
        }

        if ($request->has('search')) {
            $searchTerm = $request->search;
            $query->where(function($q) use ($searchTerm) {
                $q->where('name', 'like', '%' . $searchTerm . '%')
                  ->orWhere('description', 'like', '%' . $searchTerm . '%');
            });
        }

        if ($request->has('sort_by')) {
            $sortBy = $request->sort_by;
            $sortOrder = $request->get('sort_order', 'asc');

            if ($sortBy === 'price') {
                $query->orderBy('price', $sortOrder);
            } elseif ($sortBy === 'newest') {
                $query->orderBy('created_at', 'desc');
            } elseif ($sortBy === 'rating') {
                $query->orderBy('reviews_avg_rating', 'desc');
            } elseif ($sortBy === 'popularity') {
                $query->orderBy('order_count', 'desc');
            }
        } else {
            $query->orderBy('created_at', 'desc');
        }

        return $query->with('category')->get();
    }

    public function show($id)
    {
        return Product::with('category')->findOrFail($id);
    }
}
