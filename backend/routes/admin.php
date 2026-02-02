<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Admin\DashboardController;
use App\Http\Controllers\Admin\OrderController;
use App\Http\Controllers\Admin\ProductController;
use App\Http\Controllers\Admin\CategoryController;
use App\Http\Controllers\Admin\ShopController;
use App\Http\Controllers\Admin\UserController;

Route::middleware(['web', 'auth'])->prefix('admin')->name('admin.')->group(function () {
    Route::get('/', [DashboardController::class, 'index'])->name('dashboard');

    // Orders
    Route::resource('orders', OrderController::class)->only(['index', 'show', 'edit', 'update']);

    // Products
    Route::resource('products', ProductController::class);

    // Categories
    Route::resource('categories', CategoryController::class);

    // Shops
    Route::resource('shops', ShopController::class)->only(['index', 'show']);
    Route::post('shops/{shop}/approve', [ShopController::class, 'approve'])->name('shops.approve');
    Route::post('shops/{shop}/reject', [ShopController::class, 'reject'])->name('shops.reject');

    // Users
    Route::resource('users', UserController::class)->only(['index', 'show']);
});
