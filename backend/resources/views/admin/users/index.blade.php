@extends('admin.layouts.app')

@section('title', 'Users')
@section('header', 'Users')

@section('content')
    <div class="bg-gray-800 rounded-xl border border-gray-700 p-4 mb-6">
        <form action="{{ route('admin.users.index') }}" method="GET" class="flex gap-4">
            <input type="text" name="search" value="{{ request('search') }}" placeholder="Search by name or email..."
                class="flex-1 bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white placeholder-gray-400 focus:ring-2 focus:ring-primary-500">
            <select name="role" class="bg-gray-700 border border-gray-600 rounded-lg px-4 py-2 text-white">
                <option value="">All Roles</option>
                <option value="user" {{ request('role') == 'user' ? 'selected' : '' }}>User</option>
                <option value="vendor" {{ request('role') == 'vendor' ? 'selected' : '' }}>Vendor</option>
                <option value="admin" {{ request('role') == 'admin' ? 'selected' : '' }}>Admin</option>
            </select>
            <button type="submit"
                class="bg-primary-600 hover:bg-primary-700 px-6 py-2 rounded-lg transition-colors">Filter</button>
        </form>
    </div>

    <div class="bg-gray-800 rounded-xl border border-gray-700 overflow-hidden">
        <table class="w-full">
            <thead class="bg-gray-700/50">
                <tr>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">User</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Role</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Orders</th>
                    <th class="px-6 py-3 text-left text-xs font-medium text-gray-400 uppercase">Joined</th>
                    <th class="px-6 py-3 text-right text-xs font-medium text-gray-400 uppercase">Actions</th>
                </tr>
            </thead>
            <tbody class="divide-y divide-gray-700">
                @forelse($users as $user)
                    <tr class="hover:bg-gray-700/50">
                        <td class="px-6 py-4">
                            <div class="flex items-center gap-3">
                                <div
                                    class="w-10 h-10 bg-primary-600 rounded-full flex items-center justify-center text-white font-semibold">
                                    {{ substr($user->name, 0, 1) }}
                                </div>
                                <div>
                                    <div class="font-medium">{{ $user->name }}</div>
                                    <div class="text-sm text-gray-400">{{ $user->email }}</div>
                                </div>
                            </div>
                        </td>
                        <td class="px-6 py-4">
                            @php
                                $roleColors = [
                                    'admin' => 'bg-red-900/50 text-red-300 border-red-700',
                                    'vendor' => 'bg-purple-900/50 text-purple-300 border-purple-700',
                                    'user' => 'bg-blue-900/50 text-blue-300 border-blue-700',
                                ];
                            @endphp
                            <span class="px-2 py-1 text-xs rounded-full border {{ $roleColors[$user->role] ?? 'bg-gray-700' }}">
                                {{ ucfirst($user->role ?? 'user') }}
                            </span>
                        </td>
                        <td class="px-6 py-4">{{ $user->orders_count }} orders</td>
                        <td class="px-6 py-4 text-gray-400">{{ $user->created_at->format('M d, Y') }}</td>
                        <td class="px-6 py-4 text-right">
                            <a href="{{ route('admin.users.show', $user) }}"
                                class="text-primary-500 hover:text-primary-400">View</a>
                        </td>
                    </tr>
                @empty
                    <tr>
                        <td colspan="5" class="px-6 py-8 text-center text-gray-400">No users found</td>
                    </tr>
                @endforelse
            </tbody>
        </table>
    </div>

    @if($users->hasPages())
        <div class="mt-6">{{ $users->withQueryString()->links() }}</div>
    @endif
@endsection