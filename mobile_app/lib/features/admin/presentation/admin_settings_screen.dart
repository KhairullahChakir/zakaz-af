import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/network/dio_provider.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  bool _isLoading = true;
  bool _isSaving = false;
  
  // Contact Info Controllers
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _whatsappController = TextEditingController();
  final _locationController = TextEditingController();
  
  // Social Media Controllers
  final _facebookController = TextEditingController();
  final _instagramController = TextEditingController();
  final _tiktokController = TextEditingController();
  final _telegramController = TextEditingController();
  final _youtubeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _whatsappController.dispose();
    _locationController.dispose();
    _facebookController.dispose();
    _instagramController.dispose();
    _tiktokController.dispose();
    _telegramController.dispose();
    _youtubeController.dispose();
    super.dispose();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/admin/settings');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        final settings = response.data['data'] as List;
        
        for (var setting in settings) {
          final key = setting['key'] as String;
          final value = setting['value'] as String? ?? '';
          
          switch (key) {
            case 'contact_email':
              _emailController.text = value;
              break;
            case 'contact_phone':
              _phoneController.text = value;
              break;
            case 'contact_whatsapp':
              _whatsappController.text = value;
              break;
            case 'contact_location':
              _locationController.text = value;
              break;
            case 'social_facebook':
              _facebookController.text = value;
              break;
            case 'social_instagram':
              _instagramController.text = value;
              break;
            case 'social_tiktok':
              _tiktokController.text = value;
              break;
            case 'social_telegram':
              _telegramController.text = value;
              break;
            case 'social_youtube':
              _youtubeController.text = value;
              break;
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading settings: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isSaving = true);
    
    try {
      final dio = ref.read(dioProvider);
      
      final settings = [
        {'key': 'contact_email', 'value': _emailController.text},
        {'key': 'contact_phone', 'value': _phoneController.text},
        {'key': 'contact_whatsapp', 'value': _whatsappController.text},
        {'key': 'contact_location', 'value': _locationController.text},
        {'key': 'social_facebook', 'value': _facebookController.text},
        {'key': 'social_instagram', 'value': _instagramController.text},
        {'key': 'social_tiktok', 'value': _tiktokController.text},
        {'key': 'social_telegram', 'value': _telegramController.text},
        {'key': 'social_youtube', 'value': _youtubeController.text},
      ];
      
      final response = await dio.post('/admin/settings/bulk', data: {'settings': settings});
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ref.tr('settings_saved')),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error saving settings: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('app_settings'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
        actions: [
          if (!_isLoading)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _loadSettings,
              tooltip: ref.tr('refresh'),
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: kPrimaryOrange))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Contact Information Section
                  _buildSectionHeader(
                    icon: Icons.contact_mail,
                    title: ref.tr('contact_info'),
                    subtitle: ref.tr('contact_info_desc'),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCard([
                    _buildTextField(
                      controller: _emailController,
                      label: ref.tr('email'),
                      hint: 'example@email.com',
                      icon: Icons.email_outlined,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _phoneController,
                      label: ref.tr('phone'),
                      hint: '+93 70 123 4567',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _whatsappController,
                      label: 'WhatsApp',
                      hint: '+93 70 123 4567',
                      icon: Icons.chat,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 16),
                    _buildTextField(
                      controller: _locationController,
                      label: ref.tr('location'),
                      hint: 'Sheberghan, Jawzjan, Afghanistan',
                      icon: Icons.location_on_outlined,
                    ),
                  ]),
                  
                  const SizedBox(height: 32),
                  
                  // Social Media Section
                  _buildSectionHeader(
                    icon: Icons.share,
                    title: ref.tr('social_media'),
                    subtitle: ref.tr('social_media_desc'),
                  ),
                  const SizedBox(height: 16),
                  _buildSettingsCard([
                    _buildSocialField(
                      controller: _facebookController,
                      label: 'Facebook',
                      hint: 'https://facebook.com/your-page',
                      color: Colors.blue,
                      icon: Icons.facebook,
                    ),
                    const SizedBox(height: 16),
                    _buildSocialField(
                      controller: _instagramController,
                      label: 'Instagram',
                      hint: 'https://instagram.com/your-profile',
                      color: Colors.purple,
                      icon: Icons.camera_alt,
                    ),
                    const SizedBox(height: 16),
                    _buildSocialField(
                      controller: _tiktokController,
                      label: 'TikTok',
                      hint: 'https://tiktok.com/@your-account',
                      color: context.isDark ? Colors.white : Colors.black,
                      icon: Icons.music_note,
                    ),
                    const SizedBox(height: 16),
                    _buildSocialField(
                      controller: _telegramController,
                      label: 'Telegram',
                      hint: 'https://t.me/your-channel',
                      color: Colors.lightBlue,
                      icon: Icons.send,
                    ),
                    const SizedBox(height: 16),
                    _buildSocialField(
                      controller: _youtubeController,
                      label: 'YouTube',
                      hint: 'https://youtube.com/@your-channel',
                      color: Colors.red,
                      icon: Icons.play_arrow,
                    ),
                  ]),
                  
                  const SizedBox(height: 32),
                  
                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _isSaving ? null : _saveSettings,
                      style: FilledButton.styleFrom(
                        backgroundColor: kPrimaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: _isSaving
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                          : Text(
                              ref.tr('save_changes'),
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
    );
  }

  Widget _buildSectionHeader({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: kPrimaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: kPrimaryOrange, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
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
    );
  }

  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
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
      child: Column(children: children),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: context.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: context.textSecondary),
        hintText: hint,
        hintStyle: TextStyle(color: context.textSecondary.withValues(alpha: 0.5)),
        prefixIcon: Icon(icon, color: kPrimaryOrange),
        filled: true,
        fillColor: context.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: kPrimaryOrange, width: 2),
        ),
      ),
    );
  }

  Widget _buildSocialField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required Color color,
    required IconData icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.url,
      style: TextStyle(color: context.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: context.textSecondary),
        hintText: hint,
        hintStyle: TextStyle(color: context.textSecondary.withValues(alpha: 0.5)),
        prefixIcon: Container(
          margin: const EdgeInsets.all(8),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        filled: true,
        fillColor: context.inputFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 2),
        ),
        suffixIcon: controller.text.isNotEmpty
            ? IconButton(
                icon: Icon(Icons.clear, color: context.textSecondary),
                onPressed: () => setState(() => controller.clear()),
              )
            : null,
      ),
    );
  }
}
