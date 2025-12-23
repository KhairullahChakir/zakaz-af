import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class AboutScreen extends StatefulWidget {
  const AboutScreen({super.key});

  @override
  State<AboutScreen> createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('About', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
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
                      'assets/images/logo.png',
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
                    'Version $_version (Build $_buildNumber)',
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
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Our Mission',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Zakaz-AF is a leading e-commerce platform in Afghanistan, connecting local sellers with buyers across the country. We are committed to empowering local businesses and providing customers with access to quality products at competitive prices.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Our platform offers a seamless shopping experience with secure payments, reliable delivery, and excellent customer support.',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Features
                  _buildSectionTitle('Why Choose Us'),
                  const SizedBox(height: 12),
                  _buildFeatureCard(Icons.local_shipping_outlined, 'Fast Delivery', 'Reliable and quick shipping across Afghanistan'),
                  _buildFeatureCard(Icons.verified_user_outlined, 'Verified Sellers', 'All sellers are verified for quality assurance'),
                  _buildFeatureCard(Icons.security_outlined, 'Secure Payments', 'Your transactions are protected with advanced security'),
                  _buildFeatureCard(Icons.support_agent_outlined, '24/7 Support', 'Our customer support team is always here to help'),

                  const SizedBox(height: 24),

                  // Contact Info
                  _buildSectionTitle('Contact Us'),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildContactRow(Icons.email_outlined, 'support@zakaz-af.com'),
                        const Divider(height: 24),
                        _buildContactRow(Icons.phone_outlined, '+93 70 123 4567'),
                        const Divider(height: 24),
                        _buildContactRow(Icons.location_on_outlined, 'Kabul, Afghanistan'),
                        const Divider(height: 24),
                        _buildContactRow(Icons.language_outlined, 'www.zakaz-af.com'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Social Links
                  _buildSectionTitle('Follow Us'),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(Icons.facebook, Colors.blue),
                      _buildSocialButton(Icons.telegram, Colors.lightBlue),
                      _buildSocialButton(Icons.camera_alt_outlined, Colors.pink),
                      _buildSocialButton(Icons.video_library_outlined, Colors.red),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Legal Links
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildLinkTile('Terms of Service', () {}),
                        const Divider(height: 1),
                        _buildLinkTile('Privacy Policy', () {}),
                        const Divider(height: 1),
                        _buildLinkTile('Licenses', () => _showLicenses(context)),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Copyright
                  Center(
                    child: Text(
                      '© 2024 Zakaz-AF. All rights reserved.',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
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

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: kPrimaryOrange, size: 22),
        const SizedBox(width: 16),
        Text(
          text,
          style: const TextStyle(fontSize: 14, color: Colors.black87),
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

  Widget _buildLinkTile(String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(title, style: const TextStyle(fontSize: 14)),
      trailing: Icon(Icons.chevron_right, color: Colors.grey[400]),
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
          'assets/images/logo.png',
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
