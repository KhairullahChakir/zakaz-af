@extends('admin.layouts.app')

@section('title', 'Products')
@section('header', 'Products')

@section('content')
    <!-- Actions -->
    <div class="flex justify-between items-center mb-6">
        <form action="{{ route('admin.products.index') }}" method="GET" class="flex gap-4">
            <input type="text" name="search" value="{{ request('search') }}" placeholder="Search products..."
                class="bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:ring-2 focus:ring-primary-500">
            <select name="category" class="bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white">
                <option value="">All Categories</option>
                @foreach($categories as $category)
                    <option value="{{ $category->id }}" {{ request('category') == $category->id ? 'selected' : '' }}>
                        {{ $category->name }}</option>
                @endforeach
            </select>
            <button type="submit"
                class="bg-gray-600 hover:bg-gray-500 px-4 py-2 rounded-lg transition-colors">Search</button>
        </form>
        <a href="{{ route('admin.products.create') }}"
            class="bg-primary-600 hover:bg-primary-700 px-4 py-2 rounded-lg transition-colors flex items-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Add Product
        </a>
    </div>

    <!-- Products Table -->
    <div class="bg-gray-800 rounded-xl border border-gray-700 overflow-hidden">
        <table class="w-full">
            <thead class="bg-gray-700/50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Product</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Category</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Price</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Stock</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-400 uppercase">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-700">
                @forelse($products as $product)
                    <tr class="hover:bg-gray-700/50">
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-3">
                                <div class="w-12 h-12 bg-gray-700 rounded-lg flex items-center justify-center flex-shrink-0">
                                    @if($product->image)
                                        <img src="{{ asset('storage/' . $product->image) }}" alt="{{ $product->name }}"
                                            class="w-full h-full object-cover rounded-lg">
                                    @else
                                        <svg class="w-6 h-6 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4" />
                                        </svg>
                                    @endif
                                </div>
                                <div>
                                    <div class="font-medium">{{ $product->name }}</div>
                                    <div class="text-sm text-gray-400">{{ Str::limit($product->description, 50) }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                            <span
                                class="px-2 py-1 text-xs rounded-full bg-gray-700">{{ $product->category->name ?? 'N/A' }}</span>
                        </td>
                        <td class="px-6 py-4 font-medium">AFN {{ number_format($product->price) }}</td>
                        <td class="px-6 py-4">
                            @if($product->stock > 10)
                                <span class="text-green-400">{{ $product->stock }} in stock</span>
                            @elseif($product->stock > 0)
                                <span class="text-yellow-400">{{ $product->stock }} left</span>
                            @else
                                <span class="text-red-400">Out of stock</span>
                            @endif
                        </td>
                        <td class="px-6 py-4 text-right">
                            <a href="{{ route('admin.products.edit', $product) }}"
                                class="text-blue-500 hover:text-blue-400 mr-3">Edit</a>
                            <form action="{{ route('admin.products.destroy', $product) }}" method="POST" class="inline"
                                onsubmit="return confirm('Are you sure?')">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="text-red-500 hover:text-red-400">Delete</button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="px-6 py-8 text-center text-gray-400">No products found</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    @if($products->hasPages())
        <div class="mt-6">{{ $products->withQueryString()->links() }}</div>
    @endif
@endsection