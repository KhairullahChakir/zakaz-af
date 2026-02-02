@extends('admin.layouts.app')

@section('title', 'Orders')
@section('header', 'Orders')

@section('content')
<!-- Filters -->
<div class="bg-gray-800 rounded-xl border border-gray-700 p-4 mb-6">
    <form action="{{ route('admin.orders.index') }}" method="GET" class="flex flex-wrap gap-4">
        <div class="flex-1 min-w-[200px]">
            <input type="text" name="search" value="{{ request('search') }}" 
                   placeholder="Search by order # or customer..."
                   class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:ring-2 focus:ring-primary-500 focus:border-transparent">
        </div>
        <div>
            <select name="status" class="bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white focus:ring-2 focus:ring-primary-500">
                <option value="">All Statuses</option>
                <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                <option value="processing" {{ request('status') == 'processing' ? 'selected' : '' }}>Processing</option>
                <option value="shipped" {{ request('status') == 'shipped' ? 'selected' : '' }}>Shipped</option>
                <option value="delivered" {{ request('status') == 'delivered' ? 'selected' : '' }}>Delivered</option>
                <option value="cancelled" {{ request('status') == 'cancelled' ? 'selected' : '' }}>Cancelled</option>
            </select>
        </div>
        <button type="submit" class="bg-primary-600 hover:bg-primary-700 px-6 py-2 rounded-lg transition-colors">
            Filter
        </button>
        @if(request()->hasAny(['search', 'status']))
            <a href="{{ route('admin.orders.index') }}" class="bg-gray-700 hover:bg-gray-600 px-6 py-2 rounded-lg transition-colors">
                Reset
            </a>
        @endif
    </form>
</div>

<!-- Orders Table -->
<div class="bg-gray-800 rounded-xl border border-gray-700 overflow-hidden">
    <table class="w-full">
        <thead class="bg-gray-700/50">
            <tr>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Order #</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Customer</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Total</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Status</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Payment</th>
                <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Date</th>
                <th class="px-6 py-3 text-right text-xs font-medium text-gray-400 uppercase">Actions</th>
            </tr>
        </thead>
        <tbody class="divide-y divide-gray-700">
            @forelse($orders as $order)
                <tr class="hover:bg-gray-700/50">
                    <td class="px-6 py-4 whitespace-nowrap font-medium">#{{ $order->id }}</td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <div>
                            <div class="font-medium">{{ $order->user->name ?? 'N/A' }}</div>
                            <div class="text-sm text-gray-400">{{ $order->user->email ?? '' }}</div>
                        </div>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap font-medium">AFN {{ number_format($order->total_amount) }}</td>
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
                        <span class="px-2 py-1 text-xs rounded-full border {{ $statusColors[$order->status] ?? 'bg-gray-700' }}">
                            {{ ucfirst($order->status) }}
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap">
                        <span class="px-2 py-1 text-xs rounded-full bg-gray-700 text-gray-300">
                            {{ str_replace('_', ' ', ucfirst($order->payment_method ?? 'N/A')) }}
                        </span>
                    </td>
                    <td class="px-6 py-4 whitespace-nowrap text-gray-400">{{ $order->created_at->format('M d, Y H:i') }}</td>
                    <td class="px-6 py-4 whitespace-nowrap text-right">
                        <a href="{{ route('admin.orders.show', $order) }}" class="text-primary-500 hover:text-primary-400 mr-3">View</a>
                        <a href="{{ route('admin.orders.edit', $order) }}" class="text-blue-500 hover:text-blue-400">Edit</a>
                    </td>
                </tr>
            @empty
                <tr>
                    <td colspan="7" class="px-6 py-8 text-center text-gray-400">No orders found</td>
                </tr>
            @endforelse
        </tbody>
    </table>
</div>

<!-- Pagination -->
@if($orders->hasPages())
    <div class="mt-6">
        {{ $orders->withQueryString()->links() }}
    </div>
@endif
@endsection
