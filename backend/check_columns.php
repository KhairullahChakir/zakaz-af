<?php
require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

$columns = ['otp', 'otp_expires_at', 'is_verified'];
foreach ($columns as $column) {
    echo "$column: " . (Illuminate\Support\Facades\Schema::hasColumn('users', $column) ? 'Exists' : 'Missing') . "\n";
}
