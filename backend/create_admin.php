<?php
require __DIR__.'/vendor/autoload.php';
$app = require_once __DIR__.'/bootstrap/app.php';
$app->make('Illuminate\Contracts\Console\Kernel')->bootstrap();

use App\Models\User;
use Illuminate\Support\Facades\Hash;

$user = User::updateOrCreate(
    ['email' => 'admin@zakaz.af'],
    [
        'name' => 'Admin User',
        'password' => Hash::make('admin123'),
        'role' => 'admin',
        'email_verified_at' => now(),
    ]
);

echo "User created/updated successfully!\n";
echo "Email: admin@zakaz.af\n";
echo "Password: admin123\n";
echo "User ID: " . $user->id . "\n";
