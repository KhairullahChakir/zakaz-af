@extends('admin.layouts.app')

@section('title', 'Edit Order #' . $order->id)
@section('header', 'Edit Order')

@section('content')
    <div class="mb-6">
        <a href="{{ route('admin.orders.show', $order) }}" class="text-gray-400 hover:text-white flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Order
        </a>
    </div>

    <div class="max-w-2xl">
        <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
            <h3 class="text-lg font-semibold mb-6">Update Order #{{ $order->id }}</h3>

            <form action="{{ route('admin.orders.update', $order) }}" method="POST">
                @csrf
                @method('PUT')

                <div class="mb-6">
                    <label for="status" class="block text-sm font-medium text-gray-300 mb-2">Status</label>
                    <select name="status" id="status"
                        class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white focus:ring-2 focus:ring-primary-500">
                        <option value="pending" {{ $order->status == 'pending' ? 'selected' : '' }}>Pending</option>
                        <option value="processing" {{ $order->status == 'processing' ? 'selected' : '' }}>Processing</option>
                        <option value="shipped" {{ $order->status == 'shipped' ? 'selected' : '' }}>Shipped</option>
                        <option value="delivered" {{ $order->status == 'delivered' ? 'selected' : '' }}>Delivered</option>
                        <option value="cancelled" {{ $order->status == 'cancelled' ? 'selected' : '' }}>Cancelled</option>
                    </select>
                </div>

                <div class="flex gap-4">
                    <button type="submit"
                        class="bg-primary-600 hover:bg-primary-700 px-6 py-2 rounded-lg transition-colors">
                        Update Order
                    </button>
                    <a href="{{ route('admin.orders.show', $order) }}"
                        class="bg-gray-700 hover:bg-gray-600 px-6 py-2 rounded-lg transition-colors">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
@endsection