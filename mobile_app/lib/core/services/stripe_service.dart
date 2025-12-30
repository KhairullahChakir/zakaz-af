import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/dio_provider.dart';
import '../../features/cart/domain/cart_item.dart';

part 'stripe_service.g.dart';

@riverpod
StripeService stripeService(Ref ref) {
  return StripeService(ref);
}

class StripeService {
  final Ref _ref;

  StripeService(this._ref);

  Future<bool> processPayment(List<CartItem> items, String currency) async {
    try {
      // 1. Create Payment Intent on backend
      final response = await _ref.read(dioProvider).post('/payments/create-intent', data: {
        'items': items.map((item) => {
          'product_id': item.product.id,
          'quantity': item.quantity,
        }).toList(),
        'currency': currency,
      });

      final clientSecret = response.data['clientSecret'];

      // 2. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: clientSecret,
          merchantDisplayName: 'Zakaz AF',
          style: ThemeMode.light, // You can make this dynamic
        ),
      );

      // 3. Display Payment Sheet
      await Stripe.instance.presentPaymentSheet();

      return true;
    } catch (e) {
      if (e is StripeException) {
        throw Exception('Stripe error: ${e.error.localizedMessage}');
      } else {
        throw Exception('Payment failed: $e');
      }
    }
  }
}
