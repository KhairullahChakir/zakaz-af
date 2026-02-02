@extends('admin.layouts.app')

@section('title', 'Shops')
@section('header', 'Shops')

@section('content')
    <div class="bg-gray-800 rounded-xl border border-gray-700 p-4 mb-6">
        <form action="{{ route('admin.shops.index') }}" method="GET" class="flex gap-4">
            <input type="text" name="search" value="{{ request('search') }}" placeholder="Search shops..."
                class="flex-1 bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:ring-2 focus:ring-primary-500">
            <select name="status" class="bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white">
                <option value="">All Statuses</option>
                <option value="pending" {{ request('status') == 'pending' ? 'selected' : '' }}>Pending</option>
                <option value="approved" {{ request('status') == 'approved' ? 'selected' : '' }}>Approved</option>
                <option value="rejected" {{ request('status') == 'rejected' ? 'selected' : '' }}>Rejected</option>
            </select>
            <button type="submit"
                class="bg-primary-600 hover:bg-primary-700 px-6 py-2 rounded-lg transition-colors">Filter</button>
        </form>
    </div>

    <div class="bg-gray-800 rounded-xl border border-gray-700 overflow-hidden">
        <table class="w-full">
            <thead class="bg-gray-700/50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Shop</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Owner</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Status</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Created</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-400 uppercase">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-700">
                @forelse($shops as $shop)
                                <tr class="hover:bg-gray-700/50">
                                    <td class="px-6 py-4">
                                        <div class="flex items-center gap-3">
                                            <div
                                                class="w-10 h-10 bg-primary-600 rounded-full flex items-center justify-center text-white font-semibold">
                                                {{ substr($shop->name, 0, 1) }}
                                            </div>
                                            <div>
                                                <div class="font-medium">{{ $shop->name }}</div>
                                                <div class="text-sm text-gray-400">{{ $shop->phone ?? 'No phone' }}</div>
                                            </div>
                                        </div>
                                    </td>
                                    <td class="px-6 py-4">
                                        <div>{{ $shop->owner->name ?? 'N/A' }}</div>
                                        <div class="text-sm text-gray-400">{{ $shop->owner->email ?? '' }}</div>
                    </div>
                    </td>
                    <td class="px-6 py-4">
                        @php
                            $statusColors = [
                                'pending' => 'bg-yellow-900/50 text-yellow-300 border-yellow-700',
                                'approved' => 'bg-green-900/50 text-green-300 border-green-700',
                                'rejected' => 'bg-red-900/50 text-red-300 border-red-700',
                            ];
                        @endphp
                        <span class="px-2 py-1 text-xs rounded-full border {{ $statusColors[$shop->status] ?? 'bg-gray-700' }}">
                            {{ ucfirst($shop->status) }}
                        </span>
                    </td>
                    <td class="px-6 py-4 text-gray-400">{{ $shop->created_at->format('M d, Y') }}</td>
                    <td class="px-6 py-4 text-right">
                        <a href="{{ route('admin.shops.show', $shop) }}" class="text-primary-500 hover:text-primary-400 mr-3">View</a>
                        @if($shop->status == 'pending')
                            <form action="{{ route('admin.shops.approve', $shop) }}" method="POST" class="inline">
                                @csrf
                                <button type="submit" class="text-green-500 hover:text-green-400 mr-2">Approve</button>
                            </form>
                            <form action="{{ route('admin.shops.reject', $shop) }}" method="POST" class="inline">
                                @csrf
                                <button type="submit" class="text-red-500 hover:text-red-400">Reject</button>
                            </form>
                        @endif
                    </td>
                    </tr>
                @empty
        <tr>
            <td colspan="5" class="px-6 py-8 text-center text-gray-400">No shops found</td>
        </tr>
    @endforelse
    </tbody>
    </table>
    </div>

    @if($shops->hasPages())
        <div class="mt-6">{{ $shops->withQueryString()->links() }}</div>
    @endif
@endsection