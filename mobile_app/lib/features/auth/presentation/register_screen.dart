import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';
import '../../../core/localization/language_provider.dart';

// Reuse constants from HomeScreen or define them here for consistency
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _contactController = TextEditingController(); // Uses for Email or Phone
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  // Robust email validation
  bool _isValidEmail(String input) {
    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(input);
  }

  // Basic phone validation (e.g., +93 or local 9-10 digits)
  bool _isValidPhone(String input) {
    return RegExp(r'^\+?[0-9]{9,15}$').hasMatch(input);
  }

  bool _isEmail(String input) {
    return input.contains('@');
  }

  bool _acceptTerms = false;

  Future<void> _submit() async {
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.tr('accept_terms_msg'))),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.tr('error_passwords_dont_match'))),
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
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString()),
            backgroundColor: Colors.redAccent,
          ),
        );
      } else if (next.value != null) {
        // Registration successful but needs verification
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(ref.tr('create_account')),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header/Logo section
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: kSoftOrange,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.person_add_rounded,
                      size: 60,
                      color: kPrimaryOrange,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  ref.tr('join_zakaz'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  ref.tr('register_subtitle'),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),

                // Name field
                _buildTextField(
                  controller: _nameController,
                  label: ref.tr('full_name'),
                  hint: ref.tr('enter_full_name'),
                  icon: Icons.person_outline,
                  validator: (v) => v!.isEmpty ? ref.tr('error_required_field') : null,
                ),
                const SizedBox(height: 20),

                // Contact field
                _buildTextField(
                  controller: _contactController,
                  label: ref.tr('email_or_phone'),
                  hint: ref.tr('email_phone_hint'),
                  icon: Icons.contact_mail_outlined,
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
                const SizedBox(height: 20),

                // Password field
                _buildTextField(
                  controller: _passwordController,
                  label: ref.tr('password'),
                  hint: ref.tr('password_hint'),
                  icon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  ),
                  validator: (v) {
                    if (v!.length < 8) return ref.tr('min_password_length');
                    if (!RegExp(r'[0-9]').hasMatch(v)) return ref.tr('password_need_number');
                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(v)) return ref.tr('password_need_special');
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Confirm Password field
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: ref.tr('confirm_password'),
                  hint: ref.tr('repeat_password'),
                  icon: Icons.lock_reset_outlined,
                  obscureText: _obscureConfirmPassword,
                  suffixIcon: IconButton(
                    icon: Icon(_obscureConfirmPassword ? Icons.visibility_off : Icons.visibility),
                    onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  ),
                  validator: (v) {
                    if (v!.isEmpty) return ref.tr('error_required_field');
                    if (v != _passwordController.text) return ref.tr('error_passwords_dont_match');
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Terms of Service Checkbox
                Row(
                  children: [
                    Checkbox(
                      value: _acceptTerms,
                      activeColor: kPrimaryOrange,
                      onChanged: (v) => setState(() => _acceptTerms = v ?? false),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _acceptTerms = !_acceptTerms),
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
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Submit Button
                ElevatedButton(
                  onPressed: isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    shadowColor: kPrimaryOrange.withValues(alpha: 0.4),
                  ),
                  child: isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          ref.tr('create_account'),
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
                const SizedBox(height: 24),

                // Footer
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${ref.tr('already_have_account')} '),
                    TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        ref.tr('sign_in'),
                        style: const TextStyle(
                          color: kPrimaryOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }



  Widget _buildTextField({
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
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
            prefixIcon: Icon(icon, color: kPrimaryOrange, size: 20),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5),
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
}
