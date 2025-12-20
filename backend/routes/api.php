<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProductController;

Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/{id}', [ProductController::class, 'show']);
Route::get('/products/{id}/reviews', [App\Http\Controllers\Api\ReviewController::class, 'index']);

Route::post('/register', [AuthController::class, 'register']);
Route::post('/login', [AuthController::class, 'login']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/user/profile', [AuthController::class, 'updateProfile']);
    
    Route::post('/orders', [App\Http\Controllers\Api\OrderController::class, 'store']);
    Route::get('/orders', [App\Http\Controllers\Api\OrderController::class, 'index']);
    Route::get('/orders/{id}', [App\Http\Controllers\Api\OrderController::class, 'show']);
    Route::patch('/orders/{id}/status', [App\Http\Controllers\Api\OrderController::class, 'updateStatus']);
    
    Route::post('/reviews', [App\Http\Controllers\Api\ReviewController::class, 'store']);
    
    Route::get('/analytics/stats', [App\Http\Controllers\Api\AnalyticsController::class, 'getStats']);
    
    Route::get('/addresses', [App\Http\Controllers\Api\AddressController::class, 'index']);
    Route::post('/addresses', [App\Http\Controllers\Api\AddressController::class, 'store']);
    Route::put('/addresses/{id}', [App\Http\Controllers\Api\AddressController::class, 'update']);
    Route::delete('/addresses/{id}', [App\Http\Controllers\Api\AddressController::class, 'destroy']);
    
    Route::get('/wishlist', [App\Http\Controllers\Api\WishlistController::class, 'index']);
    Route::post('/wishlist', [App\Http\Controllers\Api\WishlistController::class, 'store']);
    Route::delete('/wishlist/{productId}', [App\Http\Controllers\Api\WishlistController::class, 'destroy']);
    Route::get('/wishlist/check/{productId}', [App\Http\Controllers\Api\WishlistController::class, 'check']);
    
    // Admin routes
    Route::prefix('admin')->group(function () {
        Route::get('/products', [App\Http\Controllers\Api\AdminProductController::class, 'index']);
        Route::post('/products', [App\Http\Controllers\Api\AdminProductController::class, 'store']);
        Route::post('/products/{id}', [App\Http\Controllers\Api\AdminProductController::class, 'update']);
        Route::delete('/products/{id}', [App\Http\Controllers\Api\AdminProductController::class, 'destroy']);
        
        Route::post('/categories', [App\Http\Controllers\Api\AdminCategoryController::class, 'store']);
        Route::post('/categories/{id}', [App\Http\Controllers\Api\AdminCategoryController::class, 'update']);
        Route::delete('/categories/{id}', [App\Http\Controllers\Api\AdminCategoryController::class, 'destroy']);
    });
});
