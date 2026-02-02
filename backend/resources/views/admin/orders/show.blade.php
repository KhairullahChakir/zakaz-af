@extends('admin.layouts.app')

@section('title', 'Order #' . $order->id)
@section('header', 'Order Details')

@section('content')
    <div class="mb-6">
        <a href="{{ route('admin.orders.index') }}" class="text-gray-400 hover:text-white flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Orders
        </a>
    </div>

    <div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
        <!-- Order Info -->
        <div class="lg:col-span-2 space-y-6">
            <!-- Order Header -->
            <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
                <div class="flex items-center justify-between mb-4">
                    <h3 class="text-xl font-bold">Order #{{ $order->id }}</h3>
                    @php
                        $statusColors = [
                            'pending' => 'bg-yellow-900/50 text-yellow-300 border-yellow-700',
                            'processing' => 'bg-blue-900/50 text-blue-300 border-blue-700',
                            'shipped' => 'bg-purple-900/50 text-purple-300 border-purple-700',
                            'delivered' => 'bg-green-900/50 text-green-300 border-green-700',
                            'cancelled' => 'bg-red-900/50 text-red-300 border-red-700',
                        ];
                    @endphp
                    <span class="px-3 py-1 rounded-full border {{ $statusColors[$order->status] ?? 'bg-gray-700' }}">
                        {{ ucfirst($order->status) }}
                    </span>
                </div>
                <div class="grid grid-cols-2 gap-4 text-sm">
                    <div>
                        <p class="text-gray-400">Date</p>
                        <p class="font-medium">{{ $order->created_at->format('M d, Y H:i') }}</p>
                    </div>
                    <div>
                        <p class="text-gray-400">Payment Method</p>
                        <p class="font-medium">{{ ucfirst(str_replace('_', ' ', $order->payment_method ?? 'N/A')) }}</p>
                    </div>
                </div>
            </div>

            <!-- Order Items -->
            <div class="bg-gray-800 rounded-xl border border-gray-700">
                <div class="px-6 py-4 border-b border-gray-700">
                    <h3 class="text-lg font-semibold">Order Items</h3>
                </div>
                <div class="divide-y divide-gray-700">
                    @forelse($order->items ?? [] as $item)
                        <div class="flex items-center gap-4 p-4">
                            <div class="w-16 h-16 bg-gray-700 rounded-lg flex items-center justify-center flex-shrink-0">
                                @if($item->product && $item->product->image)
                                    <img src="{{ asset('storage/' . $item->product->image) }}" alt="{{ $item->product->name }}"
                                        class="w-full h-full object-cover rounded-lg">
                                @else
                                    <svg class="w-8 h-8 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                            d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                                    </svg>
                                @endif
                            </div>
                            <div class="flex-1">
                                <h4 class="font-medium">{{ $item->product->name ?? 'Unknown Product' }}</h4>
                                <p class="text-sm text-gray-400">Qty: {{ $item->quantity }}</p>
                            </div>
                            <div class="text-right">
                                <p class="font-medium">AFN {{ number_format($item->price * $item->quantity) }}</p>
                                <p class="text-sm text-gray-400">AFN {{ number_format($item->price) }} each</p>
                            </div>
                        </div>
                    @empty
                        <div class="p-6 text-center text-gray-400">No items found</div>
                    @endforelse
                </div>
                <div class="px-6 py-4 border-t border-gray-700 flex justify-between items-center">
                    <span class="font-semibold">Total</span>
                    <span class="text-2xl font-bold text-primary-500">AFN {{ number_format($order->total_amount) }}</span>
                </div>
            </div>
        </div>

        <!-- Sidebar -->
        <div class="space-y-6">
            <!-- Customer Info -->
            <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
                <h3 class="text-lg font-semibold mb-4">Customer</h3>
                @if($order->user)
                    <div class="flex items-center gap-3 mb-4">
                        <div
                            class="w-10 h-10 bg-primary-600 rounded-full flex items-center justify-center text-white font-semibold">
                            {{ substr($order->user->name, 0, 1) }}
                        </div>
                        <div>
                            <p class="font-medium">{{ $order->user->name }}</p>
                            <p class="text-sm text-gray-400">{{ $order->user->email }}</p>
                        </div>
                    </div>
                    <a href="{{ route('admin.users.show', $order->user) }}"
                        class="text-primary-500 hover:text-primary-400 text-sm">View Customer</a>
                @else
                    <p class="text-gray-400">Customer not found</p>
                @endif
            </div>

            <!-- Shipping Address -->
            @if($order->address)
                <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
                    <h3 class="text-lg font-semibold mb-4">Shipping Address</h3>
                    <p class="text-gray-300">{{ $order->address->address_line ?? '' }}</p>
                    <p class="text-gray-300">{{ $order->address->city ?? '' }}, {{ $order->address->province ?? '' }}</p>
                    <p class="text-gray-400 mt-2">{{ $order->address->phone ?? '' }}</p>
                </div>
            @endif

            <!-- Actions -->
            <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
                <h3 class="text-lg font-semibold mb-4">Update Status</h3>
                <form action="{{ route('admin.orders.update', $order) }}" method="POST">
                    @csrf
                    @method('PUT')
                    <select name="status"
                        class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white mb-4">
                        <option value="pending" {{ $order->status == 'pending' ? 'selected' : '' }}>Pending</option>
                        <option value="processing" {{ $order->status == 'processing' ? 'selected' : '' }}>Processing</option>
                        <option value="shipped" {{ $order->status == 'shipped' ? 'selected' : '' }}>Shipped</option>
                        <option value="delivered" {{ $order->status == 'delivered' ? 'selected' : '' }}>Delivered</option>
                        <option value="cancelled" {{ $order->status == 'cancelled' ? 'selected' : '' }}>Cancelled</option>
                    </select>
                    <button type="submit"
                        class="w-full bg-primary-600 hover:bg-primary-700 py-2 rounded-lg transition-colors">
                        Update Status
                    </button>
                </form>
            </div>
        </div>
    </div>
@endsection