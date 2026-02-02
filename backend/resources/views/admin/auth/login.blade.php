<!DOCTYPE html>
<html lang="en" class="dark">

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Zakaz-AF Admin</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script>
        tailwind.config = {
            darkMode: 'class',
            theme: {
                extend: {
                    colors: {
                        primary: {
                            500: '#f97316',
                            600: '#ea580c',
                            700: '#c2410c',
                        }
                    }
                }
            }
        }
    </script>
</head>

<body class="bg-gray-900 min-h-screen flex items-center justify-center p-4">
    <div class="w-full max-w-md">
        <div class="text-center mb-8">
            <h1 class="text-3xl font-bold text-primary-500">Zakaz-AF</h1>
            <p class="text-gray-400 mt-2">Admin Panel</p>
        </div>

        <div class="bg-gray-800 rounded-xl border border-gray-700 p-8">
            <h2 class="text-xl font-semibold text-white mb-6">Sign in to your account</h2>

            @if($errors->any())
                <div class="mb-4 p-4 bg-red-900/50 border border-red-700 rounded-lg text-red-300">
                    {{ $errors->first() }}
                </div>
            @endif

            <form action="{{ route('admin.authenticate') }}" method="POST">
                @csrf
                <div class="space-y-4">
                    <div>
                        <label for="email" class="block text-sm font-medium text-gray-300 mb-2">Email</label>
                        <input type="email" name="email" id="email" value="{{ old('email') }}" required autofocus
                            class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                            placeholder="admin@zakaz.af">
                    </div>

                    <div>
                        <label for="password" class="block text-sm font-medium text-gray-300 mb-2">Password</label>
                        <input type="password" name="password" id="password" required
                            class="w-full bg-gray-700 border border-gray-600 rounded-lg px-4 py-3 text-white placeholder-gray-400 focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                            placeholder="••••••••">
                    </div>

                    <div class="flex items-center">
                        <input type="checkbox" name="remember" id="remember"
                            class="w-4 h-4 rounded border-gray-600 bg-gray-700 text-primary-500 focus:ring-primary-500">
                        <label for="remember" class="ml-2 text-sm text-gray-300">Remember me</label>
                    </div>

                    <button type="submit"
                        class="w-full bg-primary-600 hover:bg-primary-700 text-white py-3 rounded-lg font-medium transition-colors">
                        Sign in
                    </button>
                </div>
            </form>
        </div>

        <p class="text-center text-gray-500 text-sm mt-6">
            Zakaz-AF E-commerce Platform
        </p>
    </div>
</body>

</html>