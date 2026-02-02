@extends('admin.layouts.app')

@section('title', 'Add Product')
@section('header', 'Add Product')

@section('content')
    <div class="mb-6">
        <a href="{{ route('admin.products.index') }}" class="text-gray-400 hover:text-white flex items-center gap-2">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 19l-7-7m0 0l7-7m-7 7h18" />
            </svg>
            Back to Products
        </a>
    </div>

    <div class="max-w-2xl">
        <div class="bg-gray-800 rounded-xl border border-gray-700 p-6">
            <form action="{{ route('admin.products.store') }}" method="POST" enctype="multipart/form-data">
                @csrf

                <div class="space-y-6">
                    <div>
                        <label for="name" class="block text-sm font-medium text-gray-300 mb-2">Name *</label>
                        <input type="text" name="name" id="name" value="{{ old('name') }}" required
                            class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white focus:ring-2 focus:ring-primary-500 @error('name') border-red-500 @enderror">
                        @error('name')<p class="mt-1 text-sm text-red-400">{{ $message }}</p>@enderror
                    </div>

                    <div>
                        <label for="description" class="block text-sm font-medium text-gray-300 mb-2">Description</label>
                        <textarea name="description" id="description" rows="4"
                            class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white focus:ring-2 focus:ring-primary-500">{{ old('description') }}</textarea>
                    </div>

                    <div class="grid grid-cols-2 gap-4">
                        <div>
                            <label for="price" class="block text-sm font-medium text-gray-300 mb-2">Price (AFN) *</label>
                            <input type="number" name="price" id="price" value="{{ old('price') }}" required step="0.01"
                                min="0"
                                class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white focus:ring-2 focus:ring-primary-500">
                            @error('price')<p class="mt-1 text-sm text-red-400">{{ $message }}</p>@enderror
                        </div>
                        <div>
                            <label for="stock" class="block text-sm font-medium text-gray-300 mb-2">Stock *</label>
                            <input type="number" name="stock" id="stock" value="{{ old('stock', 0) }}" required min="0"
                                class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white focus:ring-2 focus:ring-primary-500">
                            @error('stock')<p class="mt-1 text-sm text-red-400">{{ $message }}</p>@enderror
                        </div>
                    </div>

                    <div>
                        <label for="category_id" class="block text-sm font-medium text-gray-300 mb-2">Category *</label>
                        <select name="category_id" id="category_id" required
                            class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white focus:ring-2 focus:ring-primary-500">
                            <option value="">Select Category</option>
                            @foreach($categories as $category)
                                <option value="{{ $category->id }}" {{ old('category_id') == $category->id ? 'selected' : '' }}>
                                    {{ $category->name }}</option>
                            @endforeach
                        </select>
                        @error('category_id')<p class="mt-1 text-sm text-red-400">{{ $message }}</p>@enderror
                    </div>

                    <div>
                        <label for="image" class="block text-sm font-medium text-gray-300 mb-2">Image</label>
                        <input type="file" name="image" id="image" accept="image/*"
                            class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white file:mr-4 file:py-2 file:px-4 file:rounded file:border-0 file:bg-primary-600 file:text-white file:cursor-pointer">
                        @error('image')<p class="mt-1 text-sm text-red-400">{{ $message }}</p>@enderror
                    </div>
                </div>

                <div class="flex gap-4 mt-8">
                    <button type="submit"
                        class="bg-primary-600 hover:bg-primary-700 px-6 py-2 rounded-lg transition-colors">
                        Create Product
                    </button>
                    <a href="{{ route('admin.products.index') }}"
                        class="bg-gray-700 hover:bg-gray-600 px-6 py-2 rounded-lg transition-colors">
                        Cancel
                    </a>
                </div>
            </form>
        </div>
    </div>
@endsection