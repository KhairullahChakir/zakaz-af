<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use Illuminate\Support\Facades\Broadcast;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\CategoryController;
use App\Http\Controllers\Api\ProductController;

Broadcast::routes(['middleware' => ['auth:sanctum']]);


Route::get('/categories', [CategoryController::class, 'index']);
Route::get('/products', [ProductController::class, 'index']);
Route::get('/products/{id}', [ProductController::class, 'show']);
Route::get('/products/{id}/reviews', [App\Http\Controllers\Api\ReviewController::class, 'index']);

// Shop discovery routes (public)
Route::get('/shops/nearby', [App\Http\Controllers\Api\ShopController::class, 'nearby']);
Route::get('/shops', [App\Http\Controllers\Api\ShopController::class, 'index']);
Route::get('/shops/types', [App\Http\Controllers\Api\ShopController::class, 'types']);
Route::get('/shops/{id}', [App\Http\Controllers\Api\ShopController::class, 'show']);

Route::post('/register', [AuthController::class, 'register'])->middleware('throttle:6,1');
Route::post('/login', [AuthController::class, 'login']);
Route::post('/auth/google', [AuthController::class, 'googleLogin']);
Route::post('/password/forgot', [AuthController::class, 'forgotPassword']);
Route::post('/password/reset', [AuthController::class, 'resetPassword']);

Route::middleware(['auth:sanctum'])->group(function () {
    Route::post('/logout', [AuthController::class, 'logout']);
    Route::get('/user', [AuthController::class, 'user']);
    Route::post('/user/profile', [AuthController::class, 'updateProfile']);
    Route::post('/password/change', [AuthController::class, 'changePassword']);
    Route::post('/verify-otp', [AuthController::class, 'verifyOtp']);
    Route::post('/resend-otp', [AuthController::class, 'resendOtp']);
    
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
        
        // Shop management
        Route::get('/shops', [App\Http\Controllers\Api\ShopApplicationController::class, 'index']);
        Route::get('/shops/pending', [App\Http\Controllers\Api\ShopApplicationController::class, 'pending']);
        Route::post('/shops/{id}/approve', [App\Http\Controllers\Api\ShopApplicationController::class, 'approve']);
        Route::post('/shops/{id}/reject', [App\Http\Controllers\Api\ShopApplicationController::class, 'reject']);
        Route::post('/shops/{id}/suspend', [App\Http\Controllers\Api\ShopApplicationController::class, 'suspend']);
    });
    
    // Shop application (for customers wanting to become shopkeepers)
    Route::post('/shop/apply', [App\Http\Controllers\Api\ShopApplicationController::class, 'apply']);
    Route::get('/shop/status', [App\Http\Controllers\Api\ShopApplicationController::class, 'status']);
    
    // Shopkeeper routes
    Route::prefix('shopkeeper')->group(function () {
        Route::get('/dashboard', [App\Http\Controllers\Api\ShopkeeperController::class, 'dashboard']);
        Route::get('/products', [App\Http\Controllers\Api\ShopkeeperController::class, 'products']);
        Route::post('/products', [App\Http\Controllers\Api\ShopkeeperController::class, 'storeProduct']);
        Route::post('/products/{id}', [App\Http\Controllers\Api\ShopkeeperController::class, 'updateProduct']);
        Route::delete('/products/{id}', [App\Http\Controllers\Api\ShopkeeperController::class, 'destroyProduct']);
        Route::get('/orders', [App\Http\Controllers\Api\ShopkeeperController::class, 'orders']);
        Route::patch('/orders/{id}/status', [App\Http\Controllers\Api\ShopkeeperController::class, 'updateOrderStatus']);
    });
    
    // Chat routes
    Route::prefix('chat')->group(function () {
        Route::get('/conversations', [App\Http\Controllers\Api\ChatController::class, 'index']);
        Route::post('/conversations', [App\Http\Controllers\Api\ChatController::class, 'startConversation']);
        Route::get('/conversations/{id}/messages', [App\Http\Controllers\Api\ChatController::class, 'getMessages']);
        Route::post('/conversations/{id}/messages', [App\Http\Controllers\Api\ChatController::class, 'sendMessage']);
        Route::get('/unread-count', [App\Http\Controllers\Api\ChatController::class, 'unreadCount']);
    });

    // Notification routes
    Route::prefix('notifications')->group(function () {
        Route::get('/', [App\Http\Controllers\NotificationController::class, 'index']);
        Route::get('/unread-count', [App\Http\Controllers\NotificationController::class, 'unreadCount']);
        Route::post('/{notification}/read', [App\Http\Controllers\NotificationController::class, 'markAsRead']);
        Route::post('/read-all', [App\Http\Controllers\NotificationController::class, 'markAllAsRead']);
        Route::post('/send', [App\Http\Controllers\NotificationController::class, 'send']); // Admin only
    });
});
