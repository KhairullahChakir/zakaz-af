@extends('admin.layouts.app')

@section('title', $shop->name)
@section('header', 'Shop Details')

@section('content')
<div class="mb-6">
    <a href="{{ route('admin.shops.index') }}" class="text-gray-400 hover:text-white flex items-center gap-2">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18"/>
        </svg>
        Back to Shops
    </a>
</div>

<div class="grid grid-cols-1 lg:grid-cols-3 gap-6">
    <div class="lg:col-span-2 space-y-6">
        <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
            <div class="flex items-center gap-4 mb-6">
                <div class="w-16 h-16 bg-primary-600 rounded-full flex items-center justify-center text-white text-2xl font-bold">
                    {{ substr($shop->name, 0, 1) }}
                </div>
                <div>
                    <h2 class="text-2xl font-bold">{{ $shop->name }}</h2>
                    @php
                        $statusColors = [
                            'pending' => 'bg-yellow-900/50 text-yellow-300 border-yellow-700',
                            'approved' => 'bg-green-900/50 text-green-300 border-green-700',
                            'rejected' => 'bg-red-900/50 text-red-300 border-red-700',
                        ];
                    @endphp
                    <span class="px-3 py-1 text-sm rounded-full border {{ $statusColors[$shop->status] ?? 'bg-gray-700' }}">
                        {{ ucfirst($shop->status) }}
                    </span>
                </div>
            </div>
            
            <div class="grid grid-cols-2 gap-4 text-sm">
                <div><p class="text-gray-400">Phone</p><p class="font-medium">{{ $shop->phone ?? 'N/A' }}</p></div>
                <div><p class="text-gray-400">Created</p><p class="font-medium">{{ $shop->created_at->format('M d, Y') }}</p></div>
                <div class="col-span-2"><p class="text-gray-400">Description</p><p class="font-medium">{{ $shop->description ?? 'No description' }}</p></div>
            </div>
        </div>

        @if($shop->products->count() > 0)
            <div class="bg-gray-800 rounded-xl border border-gray-700">
                <div class="px-6 py-4 border-b border-gray-700">
                    <h3 class="text-lg font-semibold">Products ({{ $shop->products->count() }})</h3>
                </div>
                <div class="divide-y divide-gray-700">
                    @foreach($shop->products->take(10) as $product)
                        <div class="flex items-center gap-4 p-4">
                            <div class="w-12 h-12 bg-gray-700 rounded-lg flex items-center justify-center flex-shrink-0">
                                @if($product->image)
                                    <img src="{{ asset('storage/' . $product->image) }}" alt="{{ $product->name }}" class="w-full h-full object-cover rounded-lg">
                                @else
                                    <svg class="w-6 h-6 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/></svg>
                                @endif
                            </div>
                            <div class="flex-1"><p class="font-medium">{{ $product->name }}</p><p class="text-sm text-gray-400">AFN {{ number_format($product->price) }}</p></div>
                        </div>
                    @endforeach
                </div>
            </div>
        @endif
    </div>

    <div class="space-y-6">
        <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
            <h3 class="text-lg font-semibold mb-4">Owner</h3>
            @if($shop->user)
                <div class="flex items-center gap-3 mb-4">
                    <div class="w-10 h-10 bg-primary-600 rounded-full flex items-center justify-center text-white font-semibold">{{ substr($shop->user->name, 0, 1) }}</div>
                    <div><p class="font-medium">{{ $shop->user->name }}</p><p class="text-sm text-gray-400">{{ $shop->user->email }}</p></div>
                </div>
                <a href="{{ route('admin.users.show', $shop->user) }}" class="text-primary-500 hover:text-primary-400 text-sm">View User Profile</a>
            @endif
        </div>

        @if($shop->status == 'pending')
            <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
                <h3 class="text-lg font-semibold mb-4">Actions</h3>
                <div class="space-y-3">
                    <form action="{{ route('admin.shops.approve', $shop) }}" method="POST">@csrf<button type="submit" class="w-full bg-green-600 hover:bg-green-700 py-2 rounded-lg transition-colors">Approve Shop</button></form>
                    <form action="{{ route('admin.shops.reject', $shop) }}" method="POST">@csrf<button type="submit" class="w-full bg-red-600 hover:bg-red-700 py-2 rounded-lg transition-colors">Reject Shop</button></form>
                </div>
            </div>
        @endif
    </div>
</div>
@endsection
