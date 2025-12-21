import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../data/shop_repository.dart';

class BecomeShopkeeperScreen extends ConsumerStatefulWidget {
  const BecomeShopkeeperScreen({super.key});

  @override
  ConsumerState<BecomeShopkeeperScreen> createState() => _BecomeShopkeeperScreenState();
}

class _BecomeShopkeeperScreenState extends ConsumerState<BecomeShopkeeperScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pageController = PageController();
  int _currentStep = 0;
  bool _isLoading = false;

  // Form fields
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _provinceController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  
  String _selectedType = 'grocery';
  final List<File> _shopPhotos = [];
  File? _businessLicense;
  File? _ownerNid;

  final List<String> _shopTypes = [
    'grocery',
    'clothes',
    'electronics',
    'restaurant',
    'pharmacy',
    'hardware',
    'jewelry',
    'books',
    'other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _provinceController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _pickShopPhoto() async {
    if (_shopPhotos.length >= 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Maximum 3 photos allowed')),
      );
      return;
    }

    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024);
    if (picked != null) {
      setState(() => _shopPhotos.add(File(picked.path)));
    }
  }

  Future<void> _pickDocument(bool isLicense) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 1024);
    if (picked != null) {
      setState(() {
        if (isLicense) {
          _businessLicense = File(picked.path);
        } else {
          _ownerNid = File(picked.path);
        }
      });
    }
  }

  void _nextStep() {
    if (_currentStep < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep++);
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      setState(() => _currentStep--);
    }
  }

  Future<void> _submitApplication() async {
    if (!_formKey.currentState!.validate()) return;

    if (_shopPhotos.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one shop photo')),
      );
      return;
    }

    if (_businessLicense == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please upload your business license')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(shopRepositoryProvider).applyForShop(
        name: _nameController.text,
        type: _selectedType,
        description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
        address: _addressController.text,
        city: _cityController.text,
        province: _provinceController.text,
        phone: _phoneController.text,
        email: _emailController.text.isNotEmpty ? _emailController.text : null,
        photos: _shopPhotos,
        businessLicense: _businessLicense!,
        ownerNid: _ownerNid,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Application submitted! Awaiting admin approval.'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Become a Shopkeeper'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Progress indicator
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: List.generate(3, (index) {
                      return Expanded(
                        child: Container(
                          height: 4,
                          margin: EdgeInsets.only(right: index < 2 ? 8 : 0),
                          decoration: BoxDecoration(
                            color: index <= _currentStep
                                ? Theme.of(context).primaryColor
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      );
                    }),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    ['Shop Information', 'Location & Contact', 'Documents'][_currentStep],
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Form pages
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: PageView(
                      controller: _pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        _buildShopInfoStep(),
                        _buildLocationStep(),
                        _buildDocumentsStep(),
                      ],
                    ),
                  ),
                ),

                // Navigation buttons
                Container(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      if (_currentStep > 0)
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _previousStep,
                            child: const Text('Back'),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: _currentStep < 2 ? _nextStep : _submitApplication,
                          child: Text(_currentStep < 2 ? 'Next' : 'Submit Application'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildShopInfoStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Shop Name *',
              border: OutlineInputBorder(),
              hintText: 'e.g., Ahmad Electronics',
            ),
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: const InputDecoration(
              labelText: 'Shop Type *',
              border: OutlineInputBorder(),
            ),
            items: _shopTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(type[0].toUpperCase() + type.substring(1)),
              );
            }).toList(),
            onChanged: (v) => setState(() => _selectedType = v!),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _descriptionController,
            decoration: const InputDecoration(
              labelText: 'Description (Optional)',
              border: OutlineInputBorder(),
              hintText: 'Tell customers about your shop...',
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          
          Text(
            'Shop Photos (1-3 photos) *',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ..._shopPhotos.asMap().entries.map((entry) {
                return Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        entry.value,
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => setState(() => _shopPhotos.removeAt(entry.key)),
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.close, size: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                );
              }),
              if (_shopPhotos.length < 3)
                GestureDetector(
                  onTap: _pickShopPhoto,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[400]!),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_photo_alternate, color: Colors.grey[600]),
                        Text('Add Photo', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLocationStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextFormField(
            controller: _addressController,
            decoration: const InputDecoration(
              labelText: 'Shop Address *',
              border: OutlineInputBorder(),
              hintText: 'Street, Area, Landmark',
            ),
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(
                    labelText: 'City *',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Kabul',
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _provinceController,
                  decoration: const InputDecoration(
                    labelText: 'Province *',
                    border: OutlineInputBorder(),
                    hintText: 'e.g., Kabul',
                  ),
                  validator: (v) => v?.isEmpty == true ? 'Required' : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Contact Phone *',
              border: OutlineInputBorder(),
              hintText: '+93 70 XXX XXXX',
              prefixIcon: Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (v) => v?.isEmpty == true ? 'Required' : null,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _emailController,
            decoration: const InputDecoration(
              labelText: 'Email (Optional)',
              border: OutlineInputBorder(),
              hintText: 'shop@example.com',
              prefixIcon: Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Please upload the following documents for verification:',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Business License
          Text(
            'Business License *',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickDocument(true),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _businessLicense != null ? Colors.green : Colors.grey[400]!,
                  width: _businessLicense != null ? 2 : 1,
                ),
              ),
              child: _businessLicense != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_businessLicense!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.upload_file, size: 40, color: Colors.grey[600]),
                        const SizedBox(height: 8),
                        Text('Tap to upload', style: TextStyle(color: Colors.grey[600])),
                        Text('Business/Trade License', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Owner NID (Tazkira)
          Text(
            'Owner ID (Tazkira) - Optional',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: () => _pickDocument(false),
            child: Container(
              height: 150,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _ownerNid != null ? Colors.green : Colors.grey[400]!,
                  width: _ownerNid != null ? 2 : 1,
                ),
              ),
              child: _ownerNid != null
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(_ownerNid!, fit: BoxFit.cover),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.badge, size: 40, color: Colors.grey[600]),
                        const SizedBox(height: 8),
                        Text('Tap to upload', style: TextStyle(color: Colors.grey[600])),
                        Text('National ID Card (Tazkira)', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Terms notice
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue[700]),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Your application will be reviewed by our team. This usually takes 1-2 business days.',
                    style: TextStyle(color: Colors.blue[700], fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
