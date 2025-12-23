<?php
require 'vendor/autoload.php';
$app = require_once 'bootstrap/app.php';
$app->make(Illuminate\Contracts\Console\Kernel::class)->bootstrap();

use Illuminate\Support\Facades\Mail;

echo "DEBUG: Username=" . config('mail.mailers.smtp.username') . "\n";
echo "DEBUG: Host=" . config('mail.mailers.smtp.host') . "\n";
echo "DEBUG: Port=" . config('mail.mailers.smtp.port') . "\n";
echo "DEBUG: Encryption=" . config('mail.mailers.smtp.encryption') . "\n";

try {
    Mail::raw('This is a test email to verify SMTP settings.', function($message) {
        $message->to('khairullahchakir786@gmail.com')->subject('Zakaz-AF SMTP Test');
    });
    echo "SUCCESS: Email sent!\n";
} catch (\Exception $e) {
    echo "ERROR: " . $e->getMessage() . "\n";
}
