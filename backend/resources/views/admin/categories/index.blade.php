@extends('admin.layouts.app')

@section('title', 'Categories')
@section('header', 'Categories')

@section('content')
    <div class="flex justify-end mb-6">
        <a href="{{ route('admin.categories.create') }}"
            class="bg-primary-600 hover:bg-primary-700 px-4 py-2 rounded-lg transition-colors flex items-center gap-2">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
            </svg>
            Add Category
        </a>
    </div>

    <div class="bg-gray-800 rounded-xl border border-gray-700 overflow-hidden">
        <table class="w-full">
            <thead class="bg-gray-700/50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Category</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Products</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-400 uppercase">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-700">
                @forelse($categories as $category)
                    <tr class="hover:bg-gray-700/50">
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-3">
                                <div class="w-10 h-10 bg-gray-700 rounded-lg flex items-center justify-center flex-shrink-0">
                                    @if($category->image)
                                        <img src="{{ asset('storage/' . $category->image) }}" alt="{{ $category->name }}"
                                            class="w-full h-full object-cover rounded-lg">
                                    @else
                                        <svg class="w-5 h-5 text-gray-500" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2"
                                                d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A2 2 0 013 12V7a4 4 0 014-4z" />
                                        </svg>
                                    @endif
                                </div>
                                <div>
                                    <div class="font-medium">{{ $category->name }}</div>
                                    <div class="text-sm text-gray-400">{{ Str::limit($category->description, 50) }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                            <span class="px-2 py-1 text-xs rounded-full bg-gray-700">{{ $category->products_count }}
                                products</span>
                        </td>
                        <td class="px-6 py-4 text-right">
                            <a href="{{ route('admin.categories.edit', $category) }}"
                                class="text-blue-500 hover:text-blue-400 mr-3">Edit</a>
                            <form action="{{ route('admin.categories.destroy', $category) }}" method="POST" class="inline"
                                onsubmit="return confirm('Are you sure?')">
                                @csrf
                                @method('DELETE')
                                <button type="submit" class="text-red-500 hover:text-red-400">Delete</button>
                            </form>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="3" class="px-6 py-8 text-center text-gray-400">No categories found</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    @if($categories->hasPages())
        <div class="mt-6">{{ $categories->links() }}</div>
    @endif
@endsection