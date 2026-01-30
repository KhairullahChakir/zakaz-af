<?php

namespace App\Filament\Widgets;

use App\Models\User;
use App\Models\Order;
use App\Models\Shop;
use App\Models\Product;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends BaseWidget
{
    protected static ?int $sort = 1;

    protected function getStats(): array
    {
        $totalRevenue = Order::where('status', '!=', 'cancelled')->sum('total_amount');
        $totalOrders = Order::count();
        $totalUsers = User::count();
        $totalProducts = Product::count();
        $totalShops = Shop::where('status', 'approved')->count();
        $pendingShops = Shop::where('status', 'pending')->count();

        return [
            Stat::make('Total Revenue', 'AFN ' . number_format($totalRevenue, 0))
                ->description('All time')
                ->descriptionIcon('heroicon-m-currency-dollar')
                ->color('success'),

            Stat::make('Total Orders', $totalOrders)
                ->description('All orders')
                ->descriptionIcon('heroicon-m-shopping-cart')
                ->color('primary'),

            Stat::make('Total Users', $totalUsers)
                ->description('Registered users')
                ->descriptionIcon('heroicon-m-users')
                ->color('info'),

            Stat::make('Active Shops', $totalShops)
                ->description($pendingShops . ' pending approval')
                ->descriptionIcon('heroicon-m-building-storefront')
                ->color($pendingShops > 0 ? 'warning' : 'success'),

            Stat::make('Products', $totalProducts)
                ->description('Listed products')
                ->descriptionIcon('heroicon-m-cube')
                ->color('gray'),
        ];
    }
}
