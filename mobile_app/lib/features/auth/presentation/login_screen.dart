import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/services/biometric_service.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kLightBg = Color(0xFFFBFBFD);
const Color kCardWhite = Colors.white;

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _isBiometricAvailable = false;
  bool _isBiometricEnabled = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final biometricService = ref.read(biometricServiceProvider);
    final isSupported = await biometricService.isDeviceSupported();
    final canCheck = await biometricService.canCheckBiometrics();
    final isEnabled = await biometricService.isBiometricEnabled();
    
    if (mounted) {
      setState(() {
        _isBiometricAvailable = isSupported && canCheck;
        _isBiometricEnabled = isEnabled;
      });
      
      // Auto-trigger biometric if enabled
      if (_isBiometricAvailable && _isBiometricEnabled) {
        _biometricLogin();
      }
    }
  }

  Future<void> _biometricLogin() async {
    final biometricService = ref.read(biometricServiceProvider);
    final credentials = await biometricService.biometricLogin(
      reason: ref.tr('biometric_login_reason'),
    );
    
    if (credentials != null && mounted) {
      await ref.read(authControllerProvider.notifier).login(
        credentials['email']!,
        credentials['password']!,
      );
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      await ref.read(authControllerProvider.notifier).login(
            _loginController.text.trim(),
            _passwordController.text,
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        final errorMsg = next.error.toString().replaceAll('Exception: ', '');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.white),
                const SizedBox(width: 12),
                Expanded(child: Text(errorMsg)),
              ],
            ),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else if (next.value != null) {
        if (next.value!.isVerified == false) {
          context.push('/verify-otp', extra: _loginController.text.trim());
        } else {
          context.go('/');
        }
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: kLightBg,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Header - Professional & Clean
                  Center(
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 20,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        size: 56,
                        color: kPrimaryOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  
                  Text(
                    ref.tr('welcome_back'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF1D1D1F),
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    ref.tr('login_subtitle'),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16, 
                      color: Colors.grey.shade600,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Elegant Form Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: kCardWhite,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 40,
                          offset: const Offset(0, 20),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildCleanField(
                          controller: _loginController,
                          label: ref.tr('email_or_phone'),
                          hint: ref.tr('enter_email_phone'),
                          icon: Icons.person_outline_rounded,
                          validator: (v) => v!.isEmpty ? ref.tr('error_required_field') : null,
                        ),
                        const SizedBox(height: 24),
                        _buildCleanField(
                          controller: _passwordController,
                          label: ref.tr('password'),
                          hint: ref.tr('enter_password'),
                          icon: Icons.lock_outline_rounded,
                          obscureText: _obscurePassword,
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Colors.grey,
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) => v!.isEmpty ? ref.tr('error_required_field') : null,
                        ),
                        const SizedBox(height: 12),
                        _buildTools(),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),

                  // Premium Action Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 8,
                      shadowColor: kPrimaryOrange.withValues(alpha: 0.3),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : Text(
                            ref.tr('sign_in'),
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                  ),
                  
                  const SizedBox(height: 40),

                  // Divided social section
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          ref.tr('or_continue_with').toUpperCase(),
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            letterSpacing: 1.2,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  _buildSocialOptions(),
                  
                  const SizedBox(height: 32),

                  _buildFooter(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCleanField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1D1D1F),
          ),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: const TextStyle(fontSize: 16),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: kPrimaryOrange, size: 22),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), 
              borderSide: BorderSide(color: Colors.grey.shade100, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), 
              borderSide: const BorderSide(color: kPrimaryOrange, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), 
              borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
            ),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildTools() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Checkbox(
              value: _rememberMe,
              onChanged: (v) => setState(() => _rememberMe = v ?? false),
              activeColor: kPrimaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              side: BorderSide(color: Colors.grey.shade300, width: 1.5),
            ),
            Text(ref.tr('remember_me'), style: const TextStyle(color: Color(0xFF1D1D1F), fontSize: 14)),
          ],
        ),
        TextButton(
          onPressed: () => context.push('/forgot-password'),
          child: Text(
            ref.tr('forgot_password'),
            style: const TextStyle(color: kPrimaryOrange, fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _socialBtn(
          onTap: () => ref.read(authControllerProvider.notifier).googleLogin(),
          child: Image.network(
            'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
            height: 24,
          ),
        ),
        _socialBtn(
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('${ref.tr('facebook')} ${ref.tr('coming_soon')}')),
            );
          },
          child: const Icon(Icons.facebook_rounded, color: Color(0xFF1877F2), size: 28),
        ),
        // Biometric login button (only show if available and enabled)
        if (_isBiometricAvailable && _isBiometricEnabled)
          _socialBtn(
            onTap: _biometricLogin,
            child: const Icon(Icons.fingerprint_rounded, color: kPrimaryOrange, size: 28),
          )
        else
          _socialBtn(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${ref.tr('apple_id')} ${ref.tr('coming_soon')}')),
              );
            },
            child: const Icon(Icons.apple_rounded, color: Colors.black, size: 28),
          ),
      ],
    );
  }

  Widget _socialBtn({required Widget child, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 60,
        width: 80,
        decoration: BoxDecoration(
          color: kCardWhite,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(child: child),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(ref.tr('dont_have_account')),
        TextButton(
          onPressed: () => context.push('/register'),
          child: Text(ref.tr('sign_up'), style: const TextStyle(color: kPrimaryOrange, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}



