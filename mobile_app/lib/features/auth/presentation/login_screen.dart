import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kSoftOrange = Color(0xFFFFF3E6);

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
        // Clean up error message (remove "Exception: " prefix)
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Logo/Header
                  Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: kSoftOrange,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: kPrimaryOrange.withValues(alpha: 0.1),
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.shopping_bag_rounded,
                        size: 70,
                        color: kPrimaryOrange,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sign in to your account',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 48),

                  // Login Field
                  _buildTextField(
                    controller: _loginController,
                    label: 'Email or Phone',
                    hint: 'Enter your email or phone',
                    icon: Icons.person_outline,
                    validator: (v) => v!.isEmpty ? 'Please enter your login' : null,
                  ),
                  const SizedBox(height: 20),

                  // Password Field
                  _buildTextField(
                    controller: _passwordController,
                    label: 'Password',
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                    obscureText: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                    validator: (v) => v!.isEmpty ? 'Please enter your password' : null,
                  ),

                  // Remember Me & Forgot Password
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: _rememberMe,
                              onChanged: (v) => setState(() => _rememberMe = v ?? false),
                              activeColor: kPrimaryOrange,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text('Remember me', style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      TextButton(
                        onPressed: () => context.push('/forgot-password'),
                        child: const Text(
                          'Forgot Password?',
                          style: TextStyle(color: kPrimaryOrange, fontWeight: FontWeight.bold, fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Login Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryOrange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      elevation: 4,
                      shadowColor: kPrimaryOrange.withValues(alpha: 0.4),
                    ),
                    child: isLoading
                        ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                          )
                        : const Text('Sign In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 32),

                  // Social Login Divider
                  Row(
                    children: [
                      const Expanded(child: Divider()),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'OR CONTINUE WITH',
                          style: TextStyle(color: Colors.grey.shade400, letterSpacing: 1.2, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const Expanded(child: Divider()),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Social Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSocialButton(
                        onTap: () => ref.read(authControllerProvider.notifier).googleLogin(),
                        child: Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Google_%22G%22_logo.svg/1200px-Google_%22G%22_logo.svg.png',
                          height: 24,
                        ),
                      ),
                      _buildSocialButton(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Facebook login Coming Soon!')),
                          );
                        },
                        child: Icon(Icons.facebook_rounded, color: Colors.blue.shade800, size: 28),
                      ),
                      _buildSocialButton(
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Apple ID login Coming Soon!')),
                          );
                        },
                        child: const Icon(Icons.apple_rounded, color: Colors.black, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Footer
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account? '),
                      TextButton(
                        onPressed: () => context.push('/register'),
                        child: const Text('Sign Up', style: TextStyle(color: kPrimaryOrange, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
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
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black54)),
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
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide(color: Colors.grey.shade200, width: 1.5)),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: kPrimaryOrange, width: 1.5)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Colors.redAccent, width: 1.5)),
          ),
          validator: validator,
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required Widget child,
    required VoidCallback onTap,
    Color? borderColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: borderColor ?? Colors.grey.shade200),
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SizedBox(
          height: 30,
          width: 30,
          child: Center(child: child),
        ),
      ),
    );
  }
}

