# Progress Report - Zakaz-AF ✅

## 1. Payment Integration (Stripe) 💳
- [x] Backend `PaymentController` created.
- [x] API Route `/api/payments/create-intent` added.
- [x] `StripeService` implemented in Flutter.
- [x] Android `MainActivity` updated to `FlutterFragmentActivity`.
- [x] Android Theme updated to `AppCompat` for Stripe sheet support.
- [x] Checkout screen integrated with Stripe.

## 2. Delivery Methods 🚚
- [x] Zakaz-AF Cargo (Free, 1-3 Business days).
- [x] Shipping to other Provinces (5-7 Business days).
- [x] Express shipping (Next working day).
- [x] Database updated with `payment_method` and `delivery_method` columns.
- [x] Localized strings for English, Dari, and Pashto.

## 3. Connectivity & Fixes 🛠️
- [x] Fixed "No route to host" by updating IP to `172.20.10.13`.
- [x] Fixed Riverpod generation for `StripeService`.
- [x] Removed duplicate translation keys.
