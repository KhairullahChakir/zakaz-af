import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class HelpCenterScreen extends ConsumerWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('help_center'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: ref.tr('search_help_hint'),
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  prefixIcon: Icon(Icons.search, color: Colors.grey[400]),
                  border: InputBorder.none,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Quick Actions
            _buildSectionTitle(ref.tr('quick_help')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _buildQuickAction(Icons.chat_bubble_outline, ref.tr('live_chat'), Colors.blue)),
                const SizedBox(width: 12),
                Expanded(child: _buildQuickAction(Icons.email_outlined, ref.tr('email_us'), Colors.green)),
                const SizedBox(width: 12),
                Expanded(child: _buildQuickAction(Icons.phone_outlined, ref.tr('call_us'), kPrimaryOrange)),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // FAQ Categories
            _buildSectionTitle(ref.tr('faq_categories')),
            const SizedBox(height: 12),
            _buildFAQCategory(
              Icons.shopping_bag_outlined,
              'Orders & Shipping',
              'Track orders, shipping info, delivery issues',
              [
                _FAQItem('How do I track my order?', 'Once your order is shipped, you will receive a tracking number via email and SMS. You can also view your order status in the "My Orders" section of the app.'),
                _FAQItem('What are the shipping options?', 'We offer standard shipping (5-7 days) and express shipping (2-3 days). Shipping costs vary based on your location and order value.'),
                _FAQItem('What if my order is delayed?', 'If your order is delayed beyond the expected delivery date, please contact our support team. We will investigate and provide updates.'),
              ],
            ),
            _buildFAQCategory(
              Icons.credit_card_outlined,
              'Payments & Refunds',
              'Payment methods, refund process, billing',
              [
                _FAQItem('What payment methods are accepted?', 'We accept credit/debit cards, bank transfers, and cash on delivery in select areas.'),
                _FAQItem('How do I request a refund?', 'You can request a refund through the "My Orders" section within 7 days of receiving your order. Refunds are processed within 5-7 business days.'),
                _FAQItem('Is my payment information secure?', 'Yes, we use industry-standard SSL encryption to protect your payment information.'),
              ],
            ),
            _buildFAQCategory(
              Icons.account_circle_outlined,
              'Account & Profile',
              'Profile settings, password, account security',
              [
                _FAQItem('How do I change my password?', 'Go to Profile > Account Security > Change Password. You will need to enter your current password and then your new password.'),
                _FAQItem('How do I update my profile information?', 'Go to Profile > Edit Profile to update your name, email, phone number, and profile picture.'),
                _FAQItem('How do I delete my account?', 'Contact our support team to request account deletion. Please note that this action is irreversible.'),
              ],
            ),
            _buildFAQCategory(
              Icons.store_outlined,
              'Selling on Zakaz-AF',
              'Become a seller, shop management',
              [
                _FAQItem('How do I become a seller?', 'Go to Profile > Become a Seller and fill out the application form. Our team will review your application within 2-3 business days.'),
                _FAQItem('What fees does Zakaz-AF charge?', 'We charge a small commission on each sale. The exact percentage depends on your product category and seller tier.'),
                _FAQItem('How do I manage my shop?', 'Once approved, you can access your Shop Dashboard from the Profile section to manage products, orders, and earnings.'),
              ],
            ),
            
            const SizedBox(height: 32),
            
            // Contact Support
            _buildSectionTitle(ref.tr('still_need_help')),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [kPrimaryOrange, kDarkOrange],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: kPrimaryOrange.withValues(alpha: 0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.tr('contact_support'),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ref.tr('support_24_7_assist'),
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: kPrimaryOrange,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(ref.tr('get_support'), style: const TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.support_agent,
                    size: 64,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.black87,
      ),
    );
  }

  Widget _buildQuickAction(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQCategory(IconData icon, String title, String subtitle, List<_FAQItem> items) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kPrimaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: kPrimaryOrange),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: items.map((item) => _buildFAQItem(item)).toList(),
      ),
    );
  }

  Widget _buildFAQItem(_FAQItem item) {
    return ExpansionTile(
      title: Text(
        item.question,
        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            item.answer,
            style: TextStyle(fontSize: 13, color: Colors.grey[700], height: 1.5),
          ),
        ),
      ],
    );
  }
}

class _FAQItem {
  final String question;
  final String answer;
  
  _FAQItem(this.question, this.answer);
}
