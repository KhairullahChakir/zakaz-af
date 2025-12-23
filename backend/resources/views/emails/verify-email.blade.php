<x-mail::message>
# Welcome to Zakaz-AF!

Hello,

Thank you for joining our community. To complete your registration and verify your email, please use the 6-digit code below:

<x-mail::panel>
# {{ $otp }}
</x-mail::panel>

This code will expire in 10 minutes.

If you did not create an account, no further action is required.

Thanks,<br>
{{ config('app.name') }}
</x-mail::message>
