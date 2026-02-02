<!DOCTYPE html>
<html lang="en" class="dark">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="csrf-token" content="{{ csrf_token() }}">
    <title>@yield('title', 'Admin') - Zakaz-AF</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script defer src="https://unpkg.com/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: {
                            50: '#fff7ed',
                            100: '#ffedd5',
                            200: '#fed7aa',
                            300: '#fdba74',
                            400: '#fb923c',
                            500: '#f97316',
                            600: '#ea580c',
                            700: '#c2410c',
                            800: '#9a3412',
                            900: '#7c2d12',
                        }
                    }
                }
            }
        }
    </script>
    <style>
        [x-cloak] { display: none !important; }
    </style>
</head>
<body class="bg-gray-900 text-gray-100 min-h-screen" x-data="{ sidebarOpen: true }">
    <div class="flex min-h-screen">
        <!-- Sidebar -->
        <aside class="w-64 bg-gray-800 border-r border-gray-700 flex-shrink-0" :class="{ 'hidden': !sidebarOpen }">
            <div class="p-4 border-b border-gray-700">
                <h1 class="text-xl font-bold text-primary-500">Zakaz-AF Admin</h1>
            </div>
            <nav class="p-4 space-y-2">
                <a href="{{ route('admin.dashboard') }}" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors {{ request()->routeIs('admin.dashboard') ? 'bg-primary-600 text-white' : 'hover:bg-gray-700' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M3 12l2-2m0 0l7-7 7 7M5 10v10a1 1 0 001 1h3m10-11l2 2m-2-2v10a1 1 0 01-1 1h-3m-6 0a1 1 0 001-1v-4a1 1 0 011-1h2a1 1 0 011 1v4a1 1 0 001 1m-6 0h6"/>
                    </svg>
                    Dashboard
                </a>
                
                <div class="pt-4 pb-2 px-4 text-xs font-semibold text-gray-400 uppercase">Sales</div>
                <a href="{{ route('admin.orders.index') }}" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors {{ request()->routeIs('admin.orders.*') ? 'bg-primary-600 text-white' : 'hover:bg-gray-700' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 11V7a4 4 0 00-8 0v4M5 9h14l1 12H4L5 9z"/>
                    </svg>
                    Orders
                </a>
                
                <div class="pt-4 pb-2 px-4 text-xs font-semibold text-gray-400 uppercase">Inventory</div>
                <a href="{{ route('admin.products.index') }}" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors {{ request()->routeIs('admin.products.*') ? 'bg-primary-600 text-white' : 'hover:bg-gray-700' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M20 7l-8-4-8 4m16 0l-8 4m8-4v10l-8 4m0-10L4 7m8 4v10M4 7v10l8 4"/>
                    </svg>
                    Products
                </a>
                <a href="{{ route('admin.categories.index') }}" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors {{ request()->routeIs('admin.categories.*') ? 'bg-primary-600 text-white' : 'hover:bg-gray-700' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 7h.01M7 3h5c.512 0 1.024.195 1.414.586l7 7a2 2 0 010 2.828l-7 7a2 2 0 01-2.828 0l-7-7A2 2 0 013 12V7a4 4 0 014-4z"/>
                    </svg>
                    Categories
                </a>
                
                <div class="pt-4 pb-2 px-4 text-xs font-semibold text-gray-400 uppercase">Shop Management</div>
                <a href="{{ route('admin.shops.index') }}" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors {{ request()->routeIs('admin.shops.*') ? 'bg-primary-600 text-white' : 'hover:bg-gray-700' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"/>
                    </svg>
                    Shops
                </a>
                
                <div class="pt-4 pb-2 px-4 text-xs font-semibold text-gray-400 uppercase">User Management</div>
                <a href="{{ route('admin.users.index') }}" 
                   class="flex items-center gap-3 px-4 py-2.5 rounded-lg transition-colors {{ request()->routeIs('admin.users.*') ? 'bg-primary-600 text-white' : 'hover:bg-gray-700' }}">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                        <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4.354a4 4 0 110 5.292M15 21H3v-1a6 6 0 0112 0v1zm0 0h6v-1a6 6 0 00-9-5.197M13 7a4 4 0 11-8 0 4 4 0 018 0z"/>
                    </svg>
                    Users
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <div class="flex-1 flex flex-col">
            <!-- Top Bar -->
            <header class="bg-gray-800 border-b border-gray-700 px-6 py-4 flex items-center justify-between">
                <div class="flex items-center gap-4">
                    <button @click="sidebarOpen = !sidebarOpen" class="text-gray-400 hover:text-white">
                        <svg class="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 6h16M4 12h16M4 18h16"/>
                        </svg>
                    </button>
                    <h2 class="text-lg font-semibold">@yield('header', 'Dashboard')</h2>
                </div>
                <div class="flex items-center gap-4" x-data="{ open: false }">
                    <div class="relative">
                        <button @click="open = !open" class="flex items-center gap-2 text-gray-300 hover:text-white">
                            <div class="w-8 h-8 bg-primary-600 rounded-full flex items-center justify-center text-white font-semibold">
                                {{ substr(auth()->user()->name ?? 'A', 0, 1) }}
                            </div>
                            <span>{{ auth()->user()->name ?? 'Admin' }}</span>
                            <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"/>
                            </svg>
                        </button>
                        <div x-show="open" @click.away="open = false" x-cloak
                             class="absolute right-0 mt-2 w-48 bg-gray-800 rounded-lg shadow-lg border border-gray-700 py-1 z-50">
                            <form action="{{ route('logout') }}" method="POST">
                                @csrf
                                <button type="submit" class="w-full px-4 py-2 text-left text-gray-300 hover:bg-gray-700 hover:text-white">
                                    Logout
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </header>

            <!-- Page Content -->
            <main class="flex-1 p-6 overflow-auto">
                @if(session('success'))
                    <div class="mb-4 p-4 bg-green-900/50 border border-green-700 rounded-lg text-green-300">
                        {{ session('success') }}
                    </div>
                @endif
                @if(session('error'))
                    <div class="mb-4 p-4 bg-red-900/50 border border-red-700 rounded-lg text-red-300">
                        {{ session('error') }}
                    </div>
                @endif
                @yield('content')
            </main>
        </div>
    </div>
</body>
</html>
