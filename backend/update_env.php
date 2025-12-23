<?php
$envPath = '.env';
$content = file_get_contents($envPath);

$updates = [
    'MAIL_MAILER' => 'smtp',
    'MAIL_HOST' => 'smtp.gmail.com',
    'MAIL_PORT' => '465',
    'MAIL_USERNAME' => 'kayrullah786@gmail.com',
    'MAIL_PASSWORD' => 'gydplpplovfxvciu',
    'MAIL_ENCRYPTION' => 'ssl',
    'MAIL_FROM_ADDRESS' => '"kayrullah786@gmail.com"',
    'MAIL_FROM_NAME' => '"${APP_NAME}"',
];

foreach ($updates as $key => $value) {
    if (preg_match("/^{$key}=.*/m", $content)) {
        $content = preg_replace("/^{$key}=.*/m", "{$key}={$value}", $content);
    } else {
        $content .= "\n{$key}={$value}";
    }
}

file_put_contents($envPath, $content);
echo "Env updated successfully\n";
