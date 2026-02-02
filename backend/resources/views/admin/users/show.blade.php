@extends('admin.layouts.app')

@section('title', $user->name)
@section('header', 'User Details')

@section('content')
    <div class="mb-6">
        <a href="{{ route('admin.users.index') }}" class="text-gray-400 hover:text-white flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Users
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <div class="lg:col-span-2 space-y-6">
            <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
                <div class="flex items-center gap-4 mb-6">
                    <div
                        class="w-16 h-16 bg-primary-600 rounded-full flex items-center justify-center text-white text-2xl font-bold">
                        {{ substr($user->name, 0, 1) }}</div>
                    <div>
                        <h2 class="text-2xl font-bold">{{ $user->name }}</h2>
                        <p class="text-gray-400">{{ $user->email }}</p>
                    </div>
                </div>
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div>
                        <p class="text-gray-400">Role</p>
                        <p class="font-medium">{{ ucfirst($user->role ?? 'user') }}</p>
                    </div>
                    <div>
                        <p class="text-gray-400">Joined</p>
                        <p class="font-medium">{{ $user->created_at->format('M d, Y') }}</p>
                    </div>
                    <div>
                        <p class="text-gray-400">Phone</p>
                        <p class="font-medium">{{ $user->phone ?? 'N/A' }}</p>
                    </div>
                    <div>
                        <p class="text-gray-400">Total Orders</p>
                        <p class="font-medium">{{ $user->orders->count() }}</p>
                    </div>
                </div>
            </div>

            @if($user->orders->count() > 0)
                <div class="bg-gray-800 rounded-xl border border-gray-700">
                    <div class="px-6 py-4 border-b border-gray-700">
                        <h3 class="text-lg font-semibold">Recent Orders</h3>
                    </div>
                    <div class="divide-y divide-gray-700">
                        @foreach($user->orders as $order)
                                        <div class="flex items-center justify-between p-4">
                                            <div>
                                                <a href="{{ route('admin.orders.show', $order) }}"
                                                    class="font-medium text-primary-500 hover:text-primary-400">#{{ $order->id }}</a>
                                                <p class="text-sm text-gray-400">{{ $order->created_at->format('M d, Y') }}</p>
                                            </div>
                                            <div class="text-right">
                                                <p class="font-medium">AFN {{ number_format($order->total_amount) }}</p>
                                                @php
                                                    $statusColors = [
                                                        'pending' => 'bg-yellow-900/50 text-yellow-300',
                                                        'processing' => 'bg-blue-900/50 text-blue-300',
                                                        'shipped' => 'bg-purple-900/50 text-purple-300',
                                                        'delivered' => 'bg-green-900/50 text-green-300',
                                                        'cancelled' => 'bg-red-900/50 text-red-300',
                                                    ];
                                                @endphp
                            <span
                                                    class="px-2 py-1 text-xs rounded-full {{ $statusColors[$order->status] ?? 'bg-gray-700' }}">{{ ucfirst($order->status) }}</span>
                                            </div>
                                        </div>
                        @endforeach
                    </div>
                </div>
            @endif
        </div>

        <div class="space-y-6">
            @if($user->shop)
                <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
                    <h3 class="text-lg font-semibold mb-4">Shop</h3>
                    <div class="flex items-center gap-3 mb-3">
                        <div
                            class="w-10 h-10 bg-primary-600 rounded-full flex items-center justify-center text-white font-semibold">
                            {{ substr($user->shop->name, 0, 1) }}</div>
                        <div>
                            <p class="font-medium">{{ $user->shop->name }}</p>
                            <p class="text-sm text-gray-400">{{ ucfirst($user->shop->status) }}</p>
                        </div>
                    </div>
                    <a href="{{ route('admin.shops.show', $user->shop) }}"
                        class="text-primary-500 hover:text-primary-400 text-sm">View Shop</a>
                </div>
            @endif

            <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
                <h3 class="text-lg font-semibold mb-4">Statistics</h3>
                <div class="space-y-3">
                    <div class="flex justify-between"><span class="text-gray-400">Total Orders</span><span
                            class="font-medium">{{ $user->orders->count() }}</span></div>
                    <div class="flex justify-between"><span class="text-gray-400">Total Spent</span><span
                            class="font-medium">AFN
                            {{ number_format($user->orders->where('status', 'delivered')->sum('total_amount')) }}</span>
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection