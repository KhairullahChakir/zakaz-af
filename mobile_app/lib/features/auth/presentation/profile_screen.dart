import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'auth_controller.dart';
import 'package:mobile_app/core/localization/language_provider.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    final user = ref.read(authControllerProvider).value;
    _nameController = TextEditingController(text: user?.name);
    _emailController = TextEditingController(text: user?.email);
    _phoneController = TextEditingController(text: user?.phone);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('edit_profile')),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundImage: _imageFile != null
                          ? FileImage(_imageFile!)
                          : (ref.watch(authControllerProvider).value?.profileImageUrl != null
                              ? NetworkImage(ref.watch(authControllerProvider).value!.profileImageUrl!)
                              : null) as ImageProvider?,
                      child: _imageFile == null && ref.watch(authControllerProvider).value?.profileImageUrl == null
                          ? const Icon(Icons.person, size: 60)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        backgroundColor: Theme.of(context).primaryColor,
                        radius: 18,
                        child: IconButton(
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: _pickImage,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: ref.tr('full_name'),
                  prefixIcon: const Icon(Icons.person_outline),
                  border: const OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty ? ref.tr('please_enter_name') : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: ref.tr('email'),
                  prefixIcon: const Icon(Icons.email_outlined),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: ref.tr('phone'),
                  prefixIcon: const Icon(Icons.phone_outlined),
                  border: const OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),
              FilledButton(
                onPressed: state.isLoading ? null : _submit,
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: state.isLoading
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text(ref.tr('save_changes')),
              ),
              if (state.hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Text(
                    state.error.toString(),
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    await ref.read(authControllerProvider.notifier).updateProfile(
          name: _nameController.text,
          email: _emailController.text.isEmpty ? null : _emailController.text,
          phone: _phoneController.text.isEmpty ? null : _phoneController.text,
          imagePath: _imageFile?.path,
        );

    if (mounted && !ref.read(authControllerProvider).hasError) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.tr('profile_updated_success'))),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }
}
