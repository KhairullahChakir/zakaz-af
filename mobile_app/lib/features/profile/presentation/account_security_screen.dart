import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_controller.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import '../../../core/services/biometric_service.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class AccountSecurityScreen extends ConsumerStatefulWidget {
  const AccountSecurityScreen({super.key});

  @override
  ConsumerState<AccountSecurityScreen> createState() => _AccountSecurityScreenState();
}

class _AccountSecurityScreenState extends ConsumerState<AccountSecurityScreen> {
  final _formKey = GlobalKey<FormState>();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;
  bool _isChangingPassword = false;
  
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;
  String _biometricTypeName = 'Biometric';
  bool _isTogglingBiometric = false;

  @override
  void initState() {
    super.initState();
    _checkBiometricStatus();
  }

  Future<void> _checkBiometricStatus() async {
    final biometricService = ref.read(biometricServiceProvider);
    final isSupported = await biometricService.isDeviceSupported();
    final canCheck = await biometricService.canCheckBiometrics();
    final isEnabled = await biometricService.isBiometricEnabled();
    final typeName = await biometricService.getBiometricTypeName();
    
    if (mounted) {
      setState(() {
        _isBiometricAvailable = isSupported && canCheck;
        _isBiometricEnabled = isEnabled;
        _biometricTypeName = typeName;
      });
    }
  }

  Future<void> _toggleBiometric(bool enable) async {
    if (_isTogglingBiometric) return;
    
    setState(() => _isTogglingBiometric = true);
    
    final biometricService = ref.read(biometricServiceProvider);
    final user = ref.read(authControllerProvider).value;
    
    bool success = false;
    
    if (enable) {
      // Show dialog to enter password for enabling biometric
      final password = await _showPasswordDialog();
      if (password != null && user != null && user.email != null) {
        success = await biometricService.enableBiometric(
          email: user.email!,
          password: password,
        );
        
        if (success && mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(ref.tr('biometric_enabled_success')),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } else {
      success = await biometricService.disableBiometric();
      
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.tr('biometric_disabled_success')),
            backgroundColor: Colors.grey[700],
          ),
        );
      }
    }
    
    if (mounted) {
      setState(() {
        _isBiometricEnabled = success ? enable : _isBiometricEnabled;
        _isTogglingBiometric = false;
      });
    }
  }

  Future<String?> _showPasswordDialog() async {
    final passwordController = TextEditingController();
    bool showPassword = false;
    
    return showDialog<String>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Text(ref.tr('enter_password')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                ref.tr('biometric_password_desc'),
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                obscureText: !showPassword,
                decoration: InputDecoration(
                  hintText: ref.tr('password'),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setDialogState(() => showPassword = !showPassword),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(ref.tr('cancel')),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, passwordController.text),
              style: FilledButton.styleFrom(backgroundColor: kPrimaryOrange),
              child: Text(ref.tr('confirm')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _changePassword() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _isChangingPassword = true);
    
    try {
      await ref.read(authControllerProvider.notifier).changePassword(
        currentPassword: _currentPasswordController.text,
        newPassword: _newPasswordController.text,
      );
      
      if (mounted) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.tr('password_changed_success')),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isChangingPassword = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authControllerProvider).value;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(ref.tr('account_security'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: kSoftOrange,
                    backgroundImage: user?.profileImageUrl != null ? NetworkImage(user!.profileImageUrl!) : null,
                    child: user?.profileImageUrl == null ? const Icon(Icons.person, color: kPrimaryOrange, size: 30) : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? ref.tr('user'), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        Text(user?.email ?? '', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.verified_user, color: Colors.green, size: 14),
                        const SizedBox(width: 4),
                        Text(ref.tr('verified'), style: const TextStyle(color: Colors.green, fontSize: 12, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle(ref.tr('change_password')),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildPasswordField(
                      controller: _currentPasswordController,
                      label: ref.tr('current_password'),
                      hint: ref.tr('enter_current_password'),
                      showPassword: _showCurrentPassword,
                      onToggle: () => setState(() => _showCurrentPassword = !_showCurrentPassword),
                      validator: (v) => v == null || v.isEmpty ? ref.tr('required') : null,
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      controller: _newPasswordController,
                      label: ref.tr('new_password'),
                      hint: ref.tr('enter_new_password_hint'),
                      showPassword: _showNewPassword,
                      onToggle: () => setState(() => _showNewPassword = !_showNewPassword),
                      validator: (v) {
                        if (v == null || v.isEmpty) return ref.tr('required');
                        if (v.length < 8) return ref.tr('password_min_length');
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    _buildPasswordField(
                      controller: _confirmPasswordController,
                      label: ref.tr('confirm_new_password'),
                      hint: ref.tr('reenter_new_password'),
                      showPassword: _showConfirmPassword,
                      onToggle: () => setState(() => _showConfirmPassword = !_showConfirmPassword),
                      validator: (v) {
                        if (v != _newPasswordController.text) return ref.tr('passwords_dont_match');
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _isChangingPassword ? null : _changePassword,
                        style: FilledButton.styleFrom(
                          backgroundColor: kPrimaryOrange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: _isChangingPassword
                            ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                            : Text(ref.tr('change_password'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Biometric Authentication Section
            const SizedBox(height: 24),
            _buildSectionTitle(ref.tr('biometric_login')),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: _isBiometricAvailable ? kSoftOrange : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _biometricTypeName == 'Face ID' ? Icons.face : Icons.fingerprint_rounded,
                      color: _isBiometricAvailable ? kPrimaryOrange : Colors.grey,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _isBiometricAvailable ? _biometricTypeName : ref.tr('biometric_login'),
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _isBiometricAvailable 
                              ? ref.tr('biometric_login_desc')
                              : ref.tr('biometric_not_available'),
                          style: TextStyle(color: Colors.grey[600], fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  if (_isBiometricAvailable) ...[
                    if (_isTogglingBiometric)
                      const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(strokeWidth: 2, color: kPrimaryOrange),
                      )
                    else
                      Switch.adaptive(
                        value: _isBiometricEnabled,
                        onChanged: _toggleBiometric,
                        activeColor: kPrimaryOrange,
                      ),
                  ] else
                    Icon(Icons.info_outline_rounded, color: Colors.grey[400]),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            _buildSectionTitle(ref.tr('security_tips')),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: kSoftOrange,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: kPrimaryOrange.withValues(alpha: 0.3)),
              ),
              child: Column(
                children: [
                  _buildTip(Icons.key, ref.tr('tip_strong_password')),
                  _buildTip(Icons.lock_clock, ref.tr('tip_change_regularly')),
                  _buildTip(Icons.no_accounts, ref.tr('tip_never_share')),
                  _buildTip(Icons.phonelink_lock, ref.tr('tip_logout_unused')),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 12),
    child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
  );

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required bool showPassword,
    required VoidCallback onToggle,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !showPassword,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        suffixIcon: IconButton(
          icon: Icon(showPassword ? Icons.visibility_off : Icons.visibility, color: Colors.grey),
          onPressed: onToggle,
        ),
      ),
    );
  }

  Widget _buildTip(IconData icon, String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: [
        Icon(icon, color: kPrimaryOrange, size: 20),
        const SizedBox(width: 12),
        Expanded(child: Text(text, style: TextStyle(fontSize: 13, color: Colors.grey[700]))),
      ],
    ),
  );
}
