import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_controller.dart';

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
  
  // Simple regex for email to decide which field to send
  bool _isEmail(String input) {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(input);
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final contact = _contactController.text.trim();
      final isEmailInput = _isEmail(contact);

      await ref.read(authControllerProvider.notifier).register(
        name: _nameController.text.trim(),
        password: _passwordController.text,
        email: isEmailInput ? contact : null,
        phone: isEmailInput ? null : contact,
      );
      
      // Check for error is handled by listening to provider state in build or here
      // But for simplicity, we can just watch the side effect or use a listener
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _contactController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Listen to auth state to navigate or show error
    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(next.error.toString())),
        );
      } else if (next.value != null) {
        // Successful registration -> Navigate Home
        context.go('/');
      }
    });

    final authState = ref.watch(authControllerProvider);
    final isLoading = authState.isLoading;

    return Scaffold(
      appBar: AppBar(title: const Text('Sign Up')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const Icon(
                  Icons.person_add_outlined,
                  size: 80,
                  color: Color(0xFFF57C00),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                     labelText: 'Full Name',
                     prefixIcon: Icon(Icons.badge_outlined),
                     border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Name is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _contactController,
                  decoration: const InputDecoration(
                     labelText: 'Email or Phone',
                     prefixIcon: Icon(Icons.contact_mail_outlined),
                     border: OutlineInputBorder(),
                  ),
                  validator: (v) => v!.isEmpty ? 'Email or Phone is required' : null,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(
                     labelText: 'Password',
                     prefixIcon: Icon(Icons.lock_outline),
                     border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                  validator: (v) => v!.length < 8 ? 'Password must be 8+ chars' : null,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: isLoading ? null : _submit,
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFF57C00),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text('Create Account'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
