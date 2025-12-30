<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Product;
use Illuminate\Http\Request;
use Stripe\Stripe;
use Stripe\PaymentIntent;

class PaymentController extends Controller
{
    public function createPaymentIntent(Request $request)
    {
        $request->validate([
            'items' => 'required|array',
            'items.*.product_id' => 'required|exists:products,id',
            'items.*.quantity' => 'required|integer|min:1',
            'currency' => 'required|string|size:3',
        ]);

        // Use Stripe secret key from config/services.php
        $stripeSecret = config('services.stripe.secret');
        
        if (empty($stripeSecret)) {
            return response()->json([
                'message' => 'Stripe configuration missing',
                'error' => 'Please set STRIPE_SECRET in your .env file.'
            ], 500);
        }

        Stripe::setApiKey($stripeSecret);

        try {
            $amount = 0;
            foreach ($request->items as $item) {
                $product = Product::find($item['product_id']);
                $amount += ($product->price * $item['quantity']);
            }

            // Stripe expects amount in cents
            $amountInCents = (int)($amount * 100);

            $paymentIntent = PaymentIntent::create([
                'amount' => $amountInCents,
                'currency' => strtolower($request->currency),
                'automatic_payment_methods' => [
                    'enabled' => true,
                ],
            ]);

            return response()->json([
                'clientSecret' => $paymentIntent->client_secret,
            ]);
        } catch (\Exception $e) {
            return response()->json(['message' => 'Stripe error', 'error' => $e->getMessage()], 500);
        }
    }
}
