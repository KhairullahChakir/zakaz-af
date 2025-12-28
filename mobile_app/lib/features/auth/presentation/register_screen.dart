import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/theme/theme_context.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController(); 
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  bool _isValidEmail(String input) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(input);
  }

  bool _isValidPhone(String input) {
    return RegExp(r'^\+?[0-9]{9,15}$').hasMatch(input);
  }

  bool _isEmail(String input) {
    return input.contains('@');
  }

  Future<void> _submit() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(ref.tr('accept_terms_msg')),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.tr('error_passwords_dont_match')),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
        return;
      }

      final contact = _contactController.text.trim();
      final isEmailInput = _isEmail(contact);

      await ref.read(authControllerProvider.notifier).register(
        name: _nameController.text.trim(),
        password: _passwordController.text,
        email: isEmailInput ? contact : null,
        phone: isEmailInput ? null : contact,
        role: 'user',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.redAccent,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        );
      } else if (next.value != null) {
        if (next.value!.isVerified == false) {
           context.push('/verify-otp', extra: _contactController.text.trim());
        } else {
           context.go('/');
        }
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new_rounded, color: context.textPrimary, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 10),
                // Header section
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.cardColor,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: context.shadowColor,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: const Icon(Icons.person_add_rounded, size: 48, color: kPrimaryOrange),
                  ),
                ),
                const SizedBox(height: 24),
                
                Text(
                  ref.tr('join_zakaz'),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.w800,
                    color: context.textPrimary,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ref.tr('register_subtitle'),
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: context.textSecondary),
                ),
                const SizedBox(height: 40),

                // Form Container
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: context.cardColor,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: context.shadowColor,
                        blurRadius: 40,
                        offset: const Offset(0, 20),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildCleanField(
                        controller: _nameController,
                        label: ref.tr('full_name'),
                        hint: ref.tr('enter_full_name'),
                        icon: Icons.person_outline_rounded,
                        validator: (v) => v!.isEmpty ? ref.tr('error_required_field') : null,
                      ),
                      const SizedBox(height: 24),
                      _buildCleanField(
                        controller: _contactController,
                        label: ref.tr('email_or_phone'),
                        hint: ref.tr('email_phone_hint'),
                        icon: Icons.contact_mail_rounded,
                        validator: (v) {
                          if (v == null || v.isEmpty) return ref.tr('error_required_field');
                          if (_isEmail(v)) {
                            if (!_isValidEmail(v)) return ref.tr('invalid_email');
                          } else {
                            if (!_isValidPhone(v)) return ref.tr('invalid_phone');
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildCleanField(
                        controller: _passwordController,
                        label: ref.tr('password'),
                        hint: ref.tr('password_hint'),
                        icon: Icons.lock_outline_rounded,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: context.textSecondary),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                        validator: (v) {
                          if (v!.length < 8) return ref.tr('min_password_length');
                          if (!RegExp(r'[0-9]').hasMatch(v)) return ref.tr('password_need_number');
                          if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) return ref.tr('password_need_special');
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      _buildCleanField(
                        controller: _confirmPasswordController,
                        label: ref.tr('confirm_password'),
                        hint: ref.tr('repeat_password'),
                        icon: Icons.security_rounded,
                        obscureText: _obscureConfirmPassword,
                        suffixIcon: IconButton(
                          icon: Icon(_obscureConfirmPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: context.textSecondary),
                          onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                        ),
                        validator: (v) {
                          if (v!.isEmpty) return ref.tr('error_required_field');
                          if (v != _passwordController.text) return ref.tr('error_passwords_dont_match');
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      _buildTermsCheckbox(),
                    ],
                  ),
                ),
                
                const SizedBox(height: 32),

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
                          ref.tr('create_account'),
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
                
                const SizedBox(height: 32),

                _buildFooter(),
                
                const SizedBox(height: 40),
              ],
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
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: context.textPrimary),
        ),
        const SizedBox(height: 10),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          style: TextStyle(fontSize: 16, color: context.textPrimary),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: context.textSecondary.withValues(alpha: 0.7), fontSize: 14),
            prefixIcon: Icon(icon, color: kPrimaryOrange, size: 22),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: context.inputFillColor,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16), 
              borderSide: BorderSide(color: context.inputBorderColor, width: 1.5),
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

  Widget _buildTermsCheckbox() {
    return InkWell(
      onTap: () => setState(() => _acceptTerms = !_acceptTerms),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Checkbox(
              value: _acceptTerms,
              onChanged: (v) => setState(() => _acceptTerms = v ?? false),
              activeColor: kPrimaryOrange,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
              side: BorderSide(color: context.inputBorderColor, width: 1.5),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(
                  text: '${ref.tr('i_agree_to')} ',
                  children: [
                    TextSpan(
                      text: ref.tr('terms_conditions'),
                      style: const TextStyle(color: kPrimaryOrange, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(text: ' ${ref.tr('and')} '),
                    TextSpan(
                      text: ref.tr('privacy_policy'),
                      style: const TextStyle(color: kPrimaryOrange, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                style: TextStyle(fontSize: 13, color: context.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(ref.tr('already_have_account'), style: TextStyle(color: context.textPrimary)),
        TextButton(
          onPressed: () => context.pop(),
          child: Text(ref.tr('sign_in'), style: const TextStyle(color: kPrimaryOrange, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}


