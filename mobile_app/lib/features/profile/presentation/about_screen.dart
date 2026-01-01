import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class AboutScreen extends ConsumerStatefulWidget {
  const AboutScreen({super.key});

  @override
  ConsumerState<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends ConsumerState<AboutScreen> {
  String _version = '';
  String _buildNumber = '';

  @override
  void initState() {
    super.initState();
    _loadPackageInfo();
  }

  Future<void> _loadPackageInfo() async {
    try {
      final info = await PackageInfo.fromPlatform();
      setState(() {
        _version = info.version;
        _buildNumber = info.buildNumber;
      });
    } catch (e) {
      setState(() {
        _version = '1.0.0';
        _buildNumber = '1';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('about_app'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with Logo
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 48),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [kPrimaryOrange, kDarkOrange],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Image.asset(
                      'assets/images/final_logo.png',
                      width: 60,
                      height: 60,
                      errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.shopping_bag,
                        size: 60,
                        color: kPrimaryOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Zakaz-AF',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${ref.tr('version')} $_version (Build $_buildNumber)',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // About Text
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: context.shadowColor,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ref.tr('our_mission'),
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: context.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          ref.tr('about_mission_desc'),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.textSecondary,
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          ref.tr('about_experience_desc'),
                          style: TextStyle(
                            fontSize: 14,
                            color: context.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Features
                  _buildSectionTitle(context, ref.tr('why_choose_us')),
                  const SizedBox(height: 12),
                  _buildFeatureCard(context, Icons.local_shipping_outlined, ref.tr('fast_delivery'), ref.tr('fast_delivery_desc')),
                  _buildFeatureCard(context, Icons.verified_user_outlined, ref.tr('verified_sellers'), ref.tr('verified_sellers_desc')),
                  _buildFeatureCard(context, Icons.security_outlined, ref.tr('secure_payments'), ref.tr('secure_payments_desc')),
                  _buildFeatureCard(context, Icons.support_agent_outlined, ref.tr('support_24_7'), ref.tr('support_24_7_desc')),

                  const SizedBox(height: 24),

                  // Contact Info
                  _buildSectionTitle(context, ref.tr('contact_us')),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: context.shadowColor,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildContactRow(context, Icons.email_outlined, 'support@zakaz-af.com'),
                        const Divider(height: 24),
                        _buildContactRow(context, Icons.phone_outlined, '+93 70 123 4567'),
                        const Divider(height: 24),
                        _buildContactRow(context, Icons.location_on_outlined, ref.tr('kabul_afghanistan')),
                        const Divider(height: 24),
                        _buildContactRow(context, Icons.language_outlined, 'www.zakaz-af.com'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Social Links
                  _buildSectionTitle(context, ref.tr('follow_us')),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(Icons.facebook, Colors.blue),
                      _buildSocialButton(Icons.camera_alt, Colors.purple),
                      _buildSocialButton(Icons.music_note, context.isDark ? Colors.white : Colors.black),
                      _buildSocialButton(Icons.send, Colors.lightBlue),
                      _buildSocialButton(Icons.phone, Colors.green),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Legal Links
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: context.shadowColor,
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildLinkTile(context, ref.tr('terms_conditions'), () {}),
                        const Divider(height: 1),
                        _buildLinkTile(context, ref.tr('privacy_policy'), () {}),
                        const Divider(height: 1),
                        _buildLinkTile(context, ref.tr('licenses'), () => _showLicenses(context)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Copyright
                  Center(
                    child: Text(
                      '© 2024 ${ref.tr('app_name')}. ${ref.tr('all_rights_reserved')}.',
                      style: TextStyle(
                        fontSize: 12,
                        color: context.textSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: context.textPrimary,
      ),
    );
  }

  Widget _buildFeatureCard(BuildContext context, IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: kPrimaryOrange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: kPrimaryOrange),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: context.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
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
    );
  }

  Widget _buildContactRow(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kPrimaryOrange, size: 22),
        const SizedBox(width: 16),
        Text(
          text,
          style: TextStyle(fontSize: 14, color: context.textPrimary),
        ),
      ],
    );
  }

  Widget _buildSocialButton(IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 28),
    );
  }

  Widget _buildLinkTile(BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(title, style: TextStyle(fontSize: 14, color: context.textPrimary)),
      trailing: Icon(Icons.chevron_right, color: context.textSecondary),
      onTap: onTap,
    );
  }

  void _showLicenses(BuildContext context) {
    showLicensePage(
      context: context,
      applicationName: 'Zakaz-AF',
      applicationVersion: '$_version (Build $_buildNumber)',
      applicationIcon: Container(
        padding: const EdgeInsets.all(12),
        child: Image.asset(
          'assets/images/final_logo.png',
          width: 48,
          height: 48,
          errorBuilder: (context, error, stackTrace) => const Icon(
            Icons.shopping_bag,
            size: 48,
            color: kPrimaryOrange,
          ),
        ),
      ),
    );
  }
}
