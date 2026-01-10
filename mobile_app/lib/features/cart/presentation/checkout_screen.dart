import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/custom_cached_image.dart';
import 'package:mobile_app/features/addresses/presentation/address_provider.dart';
import 'package:mobile_app/features/addresses/domain/address.dart';
import 'package:mobile_app/features/orders/data/order_repository.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../domain/cart_item.dart';
import 'cart_provider.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/services/stripe_service.dart';
import 'package:url_launcher/url_launcher.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

// Payment method enum
enum PaymentMethod {
  cashOnDelivery,
  whatsapp,
  mPaisa,
  aziPay,
  hesabPay,
  atomaPay,
  card,
}

enum DeliveryMethod {
  zakazAFCargo,
  otherProvinces,
  express,
}

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  bool _isLoading = false;
  Address? _selectedAddress;
  PaymentMethod _selectedPayment = PaymentMethod.cashOnDelivery;
  DeliveryMethod _selectedDelivery = DeliveryMethod.zakazAFCargo;

  @override
  void initState() {
    super.initState();
    // Pre-select default address
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final addresses = ref.read(addressesProvider).value;
      if (addresses != null && addresses.isNotEmpty) {
        final defaultAddr = addresses.firstWhere(
          (a) => a.isDefault,
          orElse: () => addresses.first,
        );
        setState(() => _selectedAddress = defaultAddr);
      }
    });
  }

  Future<void> _placeOrder() async {
    if (_selectedAddress == null) {
      _showWarning(ref.tr('please_select_address'));
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final cartState = ref.read(cartProvider);
      final List<CartItem>? items = cartState.value;

      if (items == null || items.isEmpty) {
        _showWarning(ref.tr('cart_empty'));
        return;
      }

      // Handle different payment methods
      switch (_selectedPayment) {
        case PaymentMethod.cashOnDelivery:
          await _processWithCashOnDelivery(items);
          break;
        case PaymentMethod.whatsapp:
          await _processWithWhatsApp(items);
          break;
        case PaymentMethod.mPaisa:
          _showPaymentComingSoon('M-Paisa');
          break;
        case PaymentMethod.aziPay:
          _showPaymentComingSoon('AZi Pay');
          break;
        case PaymentMethod.hesabPay:
          await _processWithHesabPay(items);
          break;
        case PaymentMethod.atomaPay:
          _showPaymentComingSoon('ATOMA Pay');
          break;
        case PaymentMethod.card:
          await _processWithCard(items);
          break;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${ref.tr('error')}: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _processWithCashOnDelivery(List<CartItem> items) async {
    await ref.read(orderRepositoryProvider).placeOrder(
      items,
      addressId: _selectedAddress!.id,
      paymentMethod: 'cash_on_delivery',
      deliveryMethod: _getDeliveryMethodKey(),
    );
    ref.read(cartProvider.notifier).clearCart();
    if (mounted) _showOrderSuccessDialog();
  }

  Future<void> _processWithWhatsApp(List<CartItem> items) async {
    // Build professional order summary message
    final StringBuffer message = StringBuffer();
    message.writeln('*${ref.tr('wa_order_header')}*');
    message.writeln('');
    message.writeln('🛍️ *${ref.tr('order_details')}:*');
    
    double total = 0;
    for (final item in items) {
      final itemTotal = (item.product.price) * item.quantity;
      total += itemTotal;
      message.writeln('• ${item.product.name} x${item.quantity} = ${itemTotal.toInt()} AFN');
    }
    
    message.writeln('');
    message.writeln('💵 *${ref.tr('cart_total')}: ${total.toInt()} AFN*');
    message.writeln('');
    
    if (_selectedAddress != null) {
      message.writeln('📍 *${ref.tr('wa_delivery_area')}:*');
      message.writeln('👤 ${_selectedAddress!.recipientName}');
      message.writeln('🏛️ ${_selectedAddress!.province}, ${_selectedAddress!.district ?? ''}');
      message.writeln('📞 ${_selectedAddress!.phonePrimary}');
    }

    // Determine the WhatsApp target number dynamically
    String whatsappNumber = '93701234567'; // Default platform number
    
    // Check if all items belong to the same shop
    final shopIds = items.map((item) => item.product.shopId).toSet();
    if (shopIds.length == 1 && shopIds.first != null) {
      final shop = items.first.product.shop;
      final targetPhone = shop?.phone ?? shop?.owner?.phone;
      
      if (shop != null && targetPhone != null && targetPhone.isNotEmpty) {
        // Sanitize phone number (remove +, spaces, dashes)
        String cleaned = targetPhone.replaceAll(RegExp(r'[^\d]'), '');
        // Handle common Afghan number formats
        if (cleaned.startsWith('0')) {
          cleaned = '93${cleaned.substring(1)}';
        } else if (cleaned.length == 9) {
          cleaned = '93$cleaned';
        }
        
        if (cleaned.isNotEmpty) {
          whatsappNumber = cleaned;
          // Add shop info to the message
          message.writeln('');
          message.writeln('🏪 *${ref.tr('nav_my_shop')}: ${shop.name}*');
        }
      }
    }
    
    message.writeln('');
    message.writeln('${ref.tr('wa_confirm_order')}');
    message.writeln('');
    message.writeln('_ ${ref.tr('wa_sent_via')} _');

    final encodedMessage = Uri.encodeComponent(message.toString());
    final whatsappUrl = 'https://wa.me/$whatsappNumber?text=$encodedMessage';
    
    final uri = Uri.parse(whatsappUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
      
      // Place order in system with pending payment status
      await ref.read(orderRepositoryProvider).placeOrder(
        items,
        addressId: _selectedAddress!.id,
        paymentMethod: 'whatsapp',
        deliveryMethod: _getDeliveryMethodKey(),
      );
      ref.read(cartProvider.notifier).clearCart();
      if (mounted) _showWhatsAppPaymentDialog();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.tr('whatsapp_not_installed')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showWhatsAppPaymentDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.check_circle, color: Color(0xFF25D366), size: 28),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(ref.tr('order_sent'))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ref.tr('whatsapp_payment_msg')),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ref.tr('confirm_on_whatsapp'), style: const TextStyle(fontSize: 13))),
                ],
              ),
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () {
              Navigator.pop(ctx);
              context.go('/');
            },
            style: FilledButton.styleFrom(
              backgroundColor: kPrimaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: Text(ref.tr('done')),
          ),
        ],
      ),
    );
  }

  Future<void> _processWithHesabPay(List<CartItem> items) async {
    // TODO: Integrate HesabPay API
    // For now, show coming soon message
    _showPaymentComingSoon('HesabPay');
  }


  Future<void> _processWithCard(List<CartItem> items) async {
    try {
      final success = await ref.read(stripeServiceProvider).processPayment(
        items,
        'USD',
      );

      if (success && mounted) {
        await ref.read(orderRepositoryProvider).placeOrder(
          items,
          addressId: _selectedAddress!.id,
          paymentMethod: 'card',
          deliveryMethod: _getDeliveryMethodKey(),
        );
        ref.read(cartProvider.notifier).clearCart();
        if (mounted) _showOrderSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString()),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showPaymentComingSoon(String method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: kSoftOrange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.schedule, color: kPrimaryOrange, size: 28),
            ),
            const SizedBox(width: 14),
            Expanded(child: Text(ref.tr('coming_soon'))),
          ],
        ),
        content: Text(
          ref.tr('payment_coming_soon_msg', args: {'method': method}),
          style: TextStyle(fontSize: 16, color: context.textSecondary),
        ),
        actions: [
          FilledButton(
            onPressed: () => Navigator.pop(context),
            style: FilledButton.styleFrom(backgroundColor: kPrimaryOrange),
            child: Text(ref.tr('ok')),
          ),
        ],
      ),
    );
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.warning_amber_rounded, color: Colors.white),
            const SizedBox(width: 12),
            Text(message),
          ],
        ),
        backgroundColor: Colors.orange.shade700,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showOrderSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: context.isDark ? Colors.green.withValues(alpha: 0.2) : Colors.green.shade50,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle,
                  size: 64,
                  color: Colors.green.shade600,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                ref.tr('order_placed_title'),
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                ref.tr('order_success_msg'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  color: context.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.pop(context);
                    context.go('/');
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: kPrimaryOrange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(ref.tr('continue_shopping')),
                ),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  context.go('/orders');
                },
                child: Text(
                  ref.tr('view_my_orders'),
                  style: const TextStyle(color: kPrimaryOrange),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartItemsAsync = ref.watch(cartProvider);
    final addressesAsync = ref.watch(addressesProvider);
    final language = ref.watch(languageProvider);
    final isRTL = language.isRTL;

    final total = cartItemsAsync.value?.fold(
          0.0,
          (sum, item) => sum + (item.product.price * item.quantity),
        ) ??
        0.0;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          title: Text(
            ref.tr('checkout'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: context.appBarColor,
          foregroundColor: context.appBarTextColor,
          elevation: 0,
        ),
        body: _isLoading
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(color: kPrimaryOrange),
                    const SizedBox(height: 24),
                    Text(
                      ref.tr('placing_order'),
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              )
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Delivery Address Section
                    _buildSectionCard(
                      icon: Icons.location_on_outlined,
                      title: ref.tr('delivery_address'),
                      trailing: TextButton.icon(
                        onPressed: () => context.push('/addresses'),
                        icon: const Icon(Icons.edit_outlined, size: 18),
                        label: Text(ref.tr('manage')),
                        style: TextButton.styleFrom(foregroundColor: kPrimaryOrange),
                      ),
                      child: addressesAsync.when(
                        data: (addresses) {
                          if (addresses.isEmpty) {
                            return _buildEmptyAddresses();
                          }
                          return Column(
                            children: addresses.map((addr) {
                              return _buildAddressOption(addr);
                            }).toList(),
                          );
                        },
                        loading: () => const Padding(
                          padding: EdgeInsets.all(20),
                          child: Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
                        ),
                        error: (e, _) => Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('${ref.tr('error')}: $e', style: const TextStyle(color: Colors.red)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Delivery Method Section
                    _buildSectionCard(
                      icon: Icons.local_shipping_outlined,
                      title: ref.tr('delivery_method'),
                      child: _buildDeliveryMethods(),
                    ),
                    const SizedBox(height: 16),

                    // Payment Method Section - NEW!
                    _buildSectionCard(
                      icon: Icons.payment_outlined,
                      title: ref.tr('payment_method'),
                      child: _buildPaymentMethods(),
                    ),
                    const SizedBox(height: 16),

                    // Order Items Section
                    _buildSectionCard(
                      icon: Icons.shopping_bag_outlined,
                      title: ref.tr('order_summary'),
                      child: cartItemsAsync.when(
                        data: (items) => Column(
                          children: items.map((item) => _buildOrderItem(item)).toList(),
                        ),
                        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
                        error: (e, _) => Text('${ref.tr('error')}: $e'),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Payment Summary Section
                    _buildSectionCard(
                      icon: Icons.receipt_long_outlined,
                      title: ref.tr('cart_total'),
                      child: Column(
                        children: [
                          _buildSummaryRow(ref.tr('subtotal'), '${total.toInt()} ${ref.tr('afn')}'),
                          const SizedBox(height: 8),
                          _buildSummaryRow(ref.tr('delivery_fee'), ref.tr('free'), valueColor: Colors.green),
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12),
                            child: Divider(),
                          ),
                          _buildSummaryRow(
                            ref.tr('cart_total'),
                            '${total.toInt()} ${ref.tr('afn')}',
                            isBold: true,
                            valueColor: kPrimaryOrange,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 100), // Space for bottom button
                  ],
                ),
              ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: context.cardColor,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            boxShadow: [
              BoxShadow(
                color: context.shadowColor,
                offset: const Offset(0, -4),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ],
          ),
          child: SafeArea(
            child: SizedBox(
              height: 56,
              child: FilledButton(
                onPressed: _isLoading ? null : _placeOrder,
                style: FilledButton.styleFrom(
                  backgroundColor: kPrimaryOrange,
                  disabledBackgroundColor: Colors.grey.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  shadowColor: kPrimaryOrange.withValues(alpha: 0.3),
                ),
                child: _isLoading
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: Colors.white,
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(_getPaymentIcon()),
                          const SizedBox(width: 12),
                          Text(
                            _getPaymentButtonText(),
                            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  IconData _getPaymentIcon() {
    switch (_selectedPayment) {
      case PaymentMethod.cashOnDelivery:
        return Icons.local_shipping_outlined;
      case PaymentMethod.whatsapp:
        return Icons.chat;
      case PaymentMethod.mPaisa:
      case PaymentMethod.aziPay:
      case PaymentMethod.atomaPay:
        return Icons.phone_android;
      case PaymentMethod.hesabPay:
        return Icons.account_balance_wallet_outlined;
      case PaymentMethod.card:
        return Icons.credit_card_outlined;
    }
  }

  String _getPaymentButtonText() {
    switch (_selectedPayment) {
      case PaymentMethod.cashOnDelivery:
        return ref.tr('place_order');
      case PaymentMethod.whatsapp:
        return ref.tr('order_via_whatsapp');
      case PaymentMethod.mPaisa:
        return ref.tr('pay_with_mpaisa');
      case PaymentMethod.aziPay:
        return ref.tr('pay_with_azipay');
      case PaymentMethod.hesabPay:
        return ref.tr('pay_with_hesabpay');
      case PaymentMethod.atomaPay:
        return ref.tr('pay_with_atoma');
      case PaymentMethod.card:
        return ref.tr('pay_with_card');
    }
  }

  // ============== PAYMENT METHODS UI ==============

  Widget _buildPaymentMethods() {
    return Column(
      children: [
        // Cash on Delivery
        _buildPaymentOption(
          method: PaymentMethod.cashOnDelivery,
          icon: Icons.local_shipping_outlined,
          iconColor: Colors.green,
          title: ref.tr('cash_on_delivery'),
          subtitle: ref.tr('cash_on_delivery_desc'),
        ),
        const SizedBox(height: 12),
        
        // WhatsApp Payment
        _buildPaymentOption(
          method: PaymentMethod.whatsapp,
          icon: Icons.chat,
          iconColor: const Color(0xFF25D366), // WhatsApp green
          title: ref.tr('whatsapp_payment'),
          subtitle: ref.tr('whatsapp_payment_desc'),
          badge: ref.tr('popular'),
        ),
        
        const SizedBox(height: 16),
        
        // Section Header for Mobile Payments
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Row(
            children: [
              Icon(Icons.phone_android, size: 16, color: context.textSecondary),
              const SizedBox(width: 8),
              Text(
                ref.tr('mobile_payment'),
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: context.textSecondary,
                ),
              ),
            ],
          ),
        ),
        
        // M-Paisa (ام پیسه)
        _buildPaymentOption(
          method: PaymentMethod.mPaisa,
          customIcon: _buildMPaisaLogo(),
          title: 'M-Paisa',
          subtitle: ref.tr('mpaisa_desc'),
          badge: ref.tr('coming_soon'),
          isDisabled: true,
        ),
        const SizedBox(height: 12),
        
        // AZi Pay
        _buildPaymentOption(
          method: PaymentMethod.aziPay,
          customIcon: _buildAziPayLogo(),
          title: 'AZi Pay',
          subtitle: ref.tr('azipay_desc'),
          badge: ref.tr('coming_soon'),
          isDisabled: true,
        ),
        const SizedBox(height: 12),
        
        // HesabPay
        _buildPaymentOption(
          method: PaymentMethod.hesabPay,
          customIcon: _buildHesabPayLogo(),
          title: 'HesabPay',
          subtitle: ref.tr('hesabpay_desc_wallet'),
          badge: ref.tr('coming_soon'),
          isDisabled: true,
        ),
        const SizedBox(height: 12),
        
        // ATOMA Pay
        _buildPaymentOption(
          method: PaymentMethod.atomaPay,
          customIcon: _buildAtomaPayLogo(),
          title: 'ATOMA Pay',
          subtitle: ref.tr('atomapay_desc'),
          badge: ref.tr('coming_soon'),
          isDisabled: true,
        ),
        const SizedBox(height: 12),
        
        // Visa/Mastercard
        _buildPaymentOption(
          method: PaymentMethod.card,
          customIcon: _buildCardLogos(),
          title: ref.tr('visa_mastercard'),
          subtitle: ref.tr('card_payment_desc'),
          badge: ref.tr('coming_soon'),
          isDisabled: true,
        ),
      ],
    );
  }

  // Custom logo builders for Afghan payment methods
  Widget _buildMPaisaLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        'assets/images/payment/mpaisa.png',
        width: 40,
        height: 28,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAziPayLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        'assets/images/payment/azipay.png',
        width: 40,
        height: 28,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildHesabPayLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        'assets/images/payment/hesabpay.png',
        width: 40,
        height: 28,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildAtomaPayLogo() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Image.asset(
        'assets/images/payment/atomapay.png',
        width: 40,
        height: 28,
        fit: BoxFit.contain,
      ),
    );
  }

  Widget _buildCardLogos() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Visa logo
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1F71),
            borderRadius: BorderRadius.circular(4),
          ),
          child: const Text(
            'VISA',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
        const SizedBox(width: 6),
        // Mastercard logo
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                color: Color(0xFFEB001B),
                shape: BoxShape.circle,
              ),
            ),
            Transform.translate(
              offset: const Offset(-6, 0),
              child: Container(
                width: 14,
                height: 14,
                decoration: BoxDecoration(
                  color: const Color(0xFFF79E1B),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 0.5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentOption({
    required PaymentMethod method,
    IconData? icon,
    Color? iconColor,
    Widget? customIcon,
    required String title,
    required String subtitle,
    String? badge,
    bool isDisabled = false,
  }) {
    final isSelected = _selectedPayment == method;

    return InkWell(
      onTap: isDisabled ? null : () => setState(() => _selectedPayment = method),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (context.isDark ? kPrimaryOrange.withValues(alpha: 0.15) : kSoftOrange)
              : context.inputFillColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPrimaryOrange : context.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio button
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kPrimaryOrange : context.textSecondary,
                  width: 2,
                ),
                color: isSelected ? kPrimaryOrange : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            
            // Icon
            if (customIcon != null)
              customIcon
            else
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: iconColor?.withValues(alpha: 0.1) ?? context.inputFillColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor ?? context.textSecondary, size: 24),
              ),
            const SizedBox(width: 14),
            
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: context.textPrimary,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            badge,
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============== DELIVERY METHODS UI ==============

  Widget _buildDeliveryMethods() {
    return Column(
      children: [
        _buildDeliveryOption(
          method: DeliveryMethod.zakazAFCargo,
          icon: Icons.local_shipping_outlined,
          title: ref.tr('zakaz_af_cargo'),
          subtitle: ref.tr('zakaz_af_cargo_desc'),
          trailing: Text(ref.tr('free'), style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
        ),
        const SizedBox(height: 12),
        _buildDeliveryOption(
          method: DeliveryMethod.otherProvinces,
          icon: Icons.map_outlined,
          title: ref.tr('shipping_other_provinces'),
          subtitle: '5-7 Business days',
        ),
        const SizedBox(height: 12),
        _buildDeliveryOption(
          method: DeliveryMethod.express,
          icon: Icons.bolt_outlined,
          title: ref.tr('express_shipping'),
          subtitle: 'Next working day',
        ),
      ],
    );
  }

  Widget _buildDeliveryOption({
    required DeliveryMethod method,
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    final isSelected = _selectedDelivery == method;

    return InkWell(
      onTap: () => setState(() => _selectedDelivery = method),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected
              ? (context.isDark ? kPrimaryOrange.withValues(alpha: 0.15) : kSoftOrange)
              : context.inputFillColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? kPrimaryOrange : context.dividerColor,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Radio
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kPrimaryOrange : context.textSecondary,
                  width: 2,
                ),
                color: isSelected ? kPrimaryOrange : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Icon(icon, color: isSelected ? kPrimaryOrange : context.textSecondary, size: 24),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  String _getDeliveryMethodKey() {
    switch (_selectedDelivery) {
      case DeliveryMethod.zakazAFCargo:
        return 'zakaz_af_cargo';
      case DeliveryMethod.otherProvinces:
        return 'other_provinces';
      case DeliveryMethod.express:
        return 'express';
    }
  }

  // ============== OTHER WIDGETS ==============

  Widget _buildSectionCard({
    required IconData icon,
    required String title,
    Widget? trailing,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: context.isDark ? kPrimaryOrange.withValues(alpha: 0.1) : kSoftOrange,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(icon, color: kPrimaryOrange, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: context.textPrimary,
                  ),
                ),
                const Spacer(),
                if (trailing != null) trailing,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyAddresses() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.isDark ? Colors.orange.withValues(alpha: 0.1) : kSoftOrange,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: context.isDark ? Colors.orange.withValues(alpha: 0.3) : Colors.orange.shade200),
      ),
      child: Column(
        children: [
          Icon(Icons.location_off_outlined, size: 40, color: Colors.orange.shade400),
          const SizedBox(height: 12),
          Text(
            ref.tr('no_addresses_saved'),
            style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => context.push('/addresses/add'),
            icon: const Icon(Icons.add, size: 18),
            label: Text(ref.tr('add_new_address')),
            style: FilledButton.styleFrom(
              backgroundColor: kPrimaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressOption(Address addr) {
    final isSelected = _selectedAddress?.id == addr.id;
    final name = addr.recipientName ?? addr.label;
    final phone = addr.phonePrimary ?? '';

    return GestureDetector(
      onTap: () => setState(() => _selectedAddress = addr),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? (context.isDark ? kPrimaryOrange.withValues(alpha: 0.15) : kSoftOrange) 
              : context.inputFillColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? kPrimaryOrange : (context.isDark ? Colors.grey.shade800 : Colors.grey.shade200),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? kPrimaryOrange : Colors.grey.shade400,
                  width: 2,
                ),
                color: isSelected ? kPrimaryOrange : Colors.transparent,
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: context.textPrimary,
                          ),
                        ),
                      ),
                      if (addr.isDefault)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            ref.tr('default_label'),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.green.shade700,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  if (phone.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      phone,
                      style: TextStyle(fontSize: 13, color: context.textSecondary),
                    ),
                  ],
                  const SizedBox(height: 4),
                  Text(
                    '${addr.province ?? addr.city}${addr.street != null ? " - ${addr.street}" : ""}',
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(dynamic item) {
    final imageUrl = item.product.imageUrl ?? item.product.image;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 56,
              height: 56,
              color: context.isDark ? kPrimaryOrange.withValues(alpha: 0.1) : kSoftOrange,
              child: imageUrl != null
                  ? CustomCachedImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      errorWidget: const Icon(Icons.image, color: kPrimaryOrange),
                    )
                  : const Icon(Icons.image, color: kPrimaryOrange),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary),
                ),
                const SizedBox(height: 4),
                Text(
                  '${ref.tr('qty')}: ${item.quantity}',
                  style: TextStyle(fontSize: 13, color: context.textSecondary),
                ),
              ],
            ),
          ),
          Text(
            '${(item.product.price * item.quantity).toInt()} ${ref.tr('afn')}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: kPrimaryOrange,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isBold = false, Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 17 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold ? (context.isDark ? Colors.white : Colors.black) : context.textSecondary,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 20 : 15,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: valueColor ?? (isBold ? kPrimaryOrange : (context.isDark ? Colors.white : Colors.black)),
          ),
        ),
      ],
    );
  }
}
