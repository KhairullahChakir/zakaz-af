import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);

class PrivacyPolicyScreen extends ConsumerWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('privacy_policy'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Last Updated
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: kPrimaryOrange.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                ref.tr('last_updated'),
                style: const TextStyle(
                  color: kPrimaryOrange,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            _buildSection(
              context,
              'Introduction',
              'Welcome to Zakaz-AF. We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application and services.',
            ),
            
            _buildSection(
              context,
              'Information We Collect',
              'We collect information that you provide directly to us, including:\n\n'
              '• Personal Information: Name, email address, phone number, and delivery address when you create an account or place an order.\n\n'
              '• Payment Information: Payment card details and billing address when you make a purchase (processed securely through our payment partners).\n\n'
              '• Profile Information: Profile picture, preferences, and other information you choose to provide.\n\n'
              '• Device Information: Information about your mobile device, including device ID, operating system, and app usage data.',
            ),
            
            _buildSection(
              context,
              'How We Use Your Information',
              'We use the information we collect to:\n\n'
              '• Process and fulfill your orders\n'
              '• Send order confirmations and updates\n'
              '• Provide customer support\n'
              '• Personalize your shopping experience\n'
              '• Send promotional communications (with your consent)\n'
              '• Improve our services and app functionality\n'
              '• Detect and prevent fraud',
            ),
            
            _buildSection(
              context,
              'Information Sharing',
              'We may share your information with:\n\n'
              '• Sellers: To fulfill your orders, we share necessary details with the sellers whose products you purchase.\n\n'
              '• Delivery Partners: We share your delivery address and contact information with our logistics partners.\n\n'
              '• Payment Processors: Your payment information is shared securely with our payment processing partners.\n\n'
              '• Legal Requirements: We may disclose information if required by law or to protect our rights.',
            ),
            
            _buildSection(
              context,
              'Data Security',
              'We implement appropriate technical and organizational security measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. This includes:\n\n'
              '• Encryption of data in transit and at rest\n'
              '• Regular security assessments\n'
              '• Access controls and authentication\n'
              '• Secure data storage practices',
            ),
            
            _buildSection(
              context,
              'Your Rights',
              'You have the right to:\n\n'
              '• Access your personal data\n'
              '• Correct inaccurate data\n'
              '• Delete your account and data\n'
              '• Opt-out of marketing communications\n'
              '• Request a copy of your data\n\n'
              'To exercise any of these rights, please contact us at privacy@zakaz-af.com.',
            ),
            
            _buildSection(
              context,
              'Cookies and Tracking',
              'We use cookies and similar tracking technologies to enhance your experience. You can manage your cookie preferences through your device settings.',
            ),
            
            _buildSection(
              context,
              'Children\'s Privacy',
              'Our services are not intended for users under the age of 18. We do not knowingly collect personal information from children.',
            ),
            
            _buildSection(
              context,
              'Changes to This Policy',
              'We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy on this page and updating the "Last Updated" date.',
            ),
            
            _buildSection(
              context,
              'Contact Us',
              'If you have any questions about this Privacy Policy, please contact us:\n\n'
              'Email: privacy@zakaz-af.com\n'
              'Phone: +93 70 123 4567\n'
              'Address: Kabul, Afghanistan',
            ),
            
            const SizedBox(height: 32),
            
            // Accept Button
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.pop(context),
                style: FilledButton.styleFrom(
                  backgroundColor: kPrimaryOrange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  ref.tr('i_understand'),
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
            
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
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
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: context.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: context.textSecondary,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
