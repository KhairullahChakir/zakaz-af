@extends('admin.layouts.app')

@section('title', 'Dashboard')
@section('header', 'Dashboard')

@section('content')
<!-- Stats Grid -->
<div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-8">
    <!-- Total Orders -->
    <div class="bg-gray-800 rounded-xl p-6 border border-gray-700">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-gray-400 text-sm">Total Orders</p>
                <p class="text-3xl font-bold text-white mt-1">{{ number_format($stats['total_orders']) }}</p>
            </div>
            <div class="w-12 h-12 bg-primary-600/20 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-primary-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                </svg>
            </div>
        </div>
        @if($stats['pending_orders'] > 0)
            <p class="text-yellow-400 text-sm mt-2">{{ $stats['pending_orders'] }} pending</p>
        @endif
    </div>

    <!-- Total Revenue -->
    <div class="bg-gray-800 rounded-xl p-6 border border-gray-700">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-gray-400 text-sm">Total Revenue</p>
                <p class="text-3xl font-bold text-white mt-1">AFN {{ number_format($stats['total_revenue']) }}</p>
            </div>
            <div class="w-12 h-12 bg-green-600/20 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-green-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8c-1.657 0-3 .895-3 2s1.343 2 3 2 3 .895 3 2-1.343 2-3 2m0-8c1.11 0 2.08.402 2.599 1M12 8V7m0 1v8m0 0v1m0-1c-1.11 0-2.08-.402-2.599-1M21 12a9 9 0 11-18 0 9 9 0 0118 0z"/>
                </svg>
            </div>
        </div>
    </div>

    <!-- Total Users -->
    <div class="bg-gray-800 rounded-xl p-6 border border-gray-700">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-gray-400 text-sm">Total Users</p>
                <p class="text-3xl font-bold text-white mt-1">{{ number_format($stats['total_users']) }}</p>
            </div>
            <div class="w-12 h-12 bg-blue-600/20 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-blue-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                </svg>
            </div>
        </div>
    </div>

    <!-- Total Products -->
    <div class="bg-gray-800 rounded-xl p-6 border border-gray-700">
        <div class="flex items-center justify-between">
            <div>
                <p class="text-gray-400 text-sm">Total Products</p>
                <p class="text-3xl font-bold text-white mt-1">{{ number_format($stats['total_products']) }}</p>
            </div>
            <div class="w-12 h-12 bg-purple-600/20 rounded-lg flex items-center justify-center">
                <svg class="w-6 h-6 text-purple-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                    <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                </svg>
            </div>
        </div>
    </div>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <!-- Recent Orders -->
    <div class="lg:col-span-2 bg-gray-800 rounded-xl border border-gray-700">
        <div class="px-6 py-4 border-b border-gray-700 flex items-center justify-between">
            <h3 class="text-lg font-semibold">Recent Orders</h3>
            <a href="{{ route('admin.orders.index') }}" class="text-primary-500 hover:text-primary-400 text-sm">View All</a>
        </div>
        <div class="overflow-x-auto">
            <table class="w-full">
                <thead class="bg-gray-700/50">
                    <tr>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Order #</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Customer</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Total</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Status</th>
                        <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Date</th>
                    </tr>
                </thead>
                <tbody class="divide-y divide-gray-700">
                    @forelse($recentOrders as $order)
                        <tr class="hover:bg-gray-700/50">
                            <td class="px-6 py-4 whitespace-nowrap">
                                <a href="{{ route('admin.orders.show', $order) }}" class="text-primary-500 hover:text-primary-400">#{{ $order->id }}</a>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap">{{ $order->user->name ?? 'N/A' }}</td>
                            <td class="px-6 py-4 whitespace-nowrap">AFN {{ number_format($order->total_amount) }}</td>
                            <td class="px-6 py-4 whitespace-nowrap">
                                @php
                                    $statusColors = [
                                        'pending' => 'bg-yellow-900/50 text-yellow-300 border-yellow-700',
                                        'processing' => 'bg-blue-900/50 text-blue-300 border-blue-700',
                                        'shipped' => 'bg-purple-900/50 text-purple-300 border-purple-700',
                                        'delivered' => 'bg-green-900/50 text-green-300 border-green-700',
                                        'cancelled' => 'bg-red-900/50 text-red-300 border-red-700',
                                    ];
                                @endphp
                                <span class="px-2 py-1 text-xs rounded-full border {{ $statusColors[$order->status] ?? 'bg-gray-700 text-gray-300' }}">
                                    {{ ucfirst($order->status) }}
                                </span>
                            </td>
                            <td class="px-6 py-4 whitespace-nowrap text-gray-400 text-sm">{{ $order->created_at->format('M d, Y') }}</td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="5" class="px-6 py-8 text-center text-gray-400">No orders yet</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

    <!-- Pending Shops -->
    <div class="bg-gray-800 rounded-xl border border-gray-700">
        <div class="px-6 py-4 border-b border-gray-700 flex items-center justify-between">
            <h3 class="text-lg font-semibold">Pending Shops</h3>
            @if($stats['pending_shops'] > 0)
                <span class="bg-yellow-900/50 text-yellow-300 px-2 py-1 rounded-full text-xs">{{ $stats['pending_shops'] }}</span>
            @endif
        </div>
        <div class="p-4 space-y-3">
            @forelse($pendingShops as $shop)
                <div class="bg-gray-700/50 rounded-lg p-4">
                    <div class="flex items-center justify-between mb-2">
                        <h4 class="font-medium">{{ $shop->name }}</h4>
                        <span class="text-xs text-gray-400">{{ $shop->created_at->diffForHumans() }}</span>
                    </div>
                    <p class="text-sm text-gray-400 mb-3">{{ $shop->user->name ?? 'Unknown' }}</p>
                    <div class="flex gap-2">
                        <form action="{{ route('admin.shops.approve', $shop) }}" method="POST" class="flex-1">
                            @csrf
                            <button type="submit" class="w-full px-3 py-1.5 bg-green-600 hover:bg-green-700 rounded text-sm transition-colors">
                                Approve
                            </button>
                        </form>
                        <form action="{{ route('admin.shops.reject', $shop) }}" method="POST" class="flex-1">
                            @csrf
                            <button type="submit" class="w-full px-3 py-1.5 bg-red-600 hover:bg-red-700 rounded text-sm transition-colors">
                                Reject
                            </button>
                        </form>
                    </div>
                </div>
            @empty
                <p class="text-center text-gray-400 py-4">No pending shops</p>
            @endforelse
        </div>
    </div>
</div>
@endsection
