import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import '../data/shop_repository.dart';
import '../../../core/localization/language_provider.dart';

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
  double? _latitude;
  double? _longitude;

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
        SnackBar(content: Text(ref.tr('max_photos_allowed'))),
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
        SnackBar(content: Text(ref.tr('add_photo_error'))),
      );
      return;
    }

    if (_businessLicense == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.tr('upload_license_error'))),
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
        latitude: _latitude,
        longitude: _longitude,
        photos: _shopPhotos,
        businessLicense: _businessLicense!,
        ownerNid: _ownerNid,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.tr('application_submitted')),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${ref.tr('error')}: $e'), backgroundColor: Colors.red),
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
        title: Text(ref.tr('become_shopkeeper_title')),
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
                    [ref.tr('step_shop_info'), ref.tr('step_location'), ref.tr('step_documents')][_currentStep],
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
                            child: Text(ref.tr('back')),
                          ),
                        ),
                      if (_currentStep > 0) const SizedBox(width: 16),
                      Expanded(
                        flex: 2,
                        child: FilledButton(
                          onPressed: _currentStep < 2 ? _nextStep : _submitApplication,
                          child: Text(_currentStep < 2 ? ref.tr('next') : ref.tr('submit')),
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
            decoration: InputDecoration(
              labelText: ref.tr('shop_name_label'),
              border: const OutlineInputBorder(),
              hintText: ref.tr('shop_name_hint'),
            ),
            validator: (v) => v?.isEmpty == true ? ref.tr('error_required_field') : null,
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _selectedType,
            decoration: InputDecoration(
              labelText: ref.tr('shop_type_label'),
              border: const OutlineInputBorder(),
            ),
            items: _shopTypes.map((type) {
              return DropdownMenuItem(
                value: type,
                child: Text(ref.tr(type)),
              );
            }).toList(),
            onChanged: (v) => setState(() => _selectedType = v!),
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _descriptionController,
            decoration: InputDecoration(
              labelText: ref.tr('description_optional'),
              border: const OutlineInputBorder(),
              hintText: ref.tr('shop_desc_hint'),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 24),
          
          Text(
            ref.tr('shop_photos_title'),
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
                        Text(ref.tr('add_photo_label'), style: TextStyle(color: Colors.grey[600], fontSize: 12)),
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
            decoration: InputDecoration(
              labelText: ref.tr('shop_address_label'),
              border: const OutlineInputBorder(),
              hintText: ref.tr('street_area_hint'),
            ),
            validator: (v) => v?.isEmpty == true ? ref.tr('error_required_field') : null,
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    labelText: ref.tr('city_label'),
                    border: const OutlineInputBorder(),
                    hintText: ref.tr('city_hint'),
                  ),
                  validator: (v) => v?.isEmpty == true ? ref.tr('error_required_field') : null,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: _provinceController,
                  decoration: InputDecoration(
                    labelText: ref.tr('province_label'),
                    border: const OutlineInputBorder(),
                    hintText: ref.tr('city_hint'),
                  ),
                  validator: (v) => v?.isEmpty == true ? ref.tr('error_required_field') : null,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _phoneController,
            decoration: InputDecoration(
              labelText: ref.tr('phone_contact_label'),
              border: const OutlineInputBorder(),
              hintText: ref.tr('phone_hint'),
              prefixIcon: const Icon(Icons.phone),
            ),
            keyboardType: TextInputType.phone,
            validator: (v) => v?.isEmpty == true ? ref.tr('error_required_field') : null,
          ),
          const SizedBox(height: 16),
          
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: ref.tr('email_optional'),
              border: const OutlineInputBorder(),
              hintText: ref.tr('email_hint'),
              prefixIcon: const Icon(Icons.email),
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 24),

          // Map Picker Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      ref.tr('gps_coordinates'),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                if (_latitude != null && _longitude != null)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Text(
                          '${_latitude!.toStringAsFixed(6)}, ${_longitude!.toStringAsFixed(6)}',
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          ref.tr('location_picked'),
                          style: const TextStyle(color: Colors.green, fontSize: 12),
                        ),
                      ],
                    ),
                  )
                else
                  Text(
                    ref.tr('coordinates_hint'),
                    style: TextStyle(color: Colors.grey[600], fontSize: 13),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      final LatLng? result = await context.push('/map-picker', 
                        extra: (_latitude != null && _longitude != null) 
                          ? LatLng(_latitude!, _longitude!) 
                          : null
                      );
                      if (result != null) {
                        setState(() {
                          _latitude = result.latitude;
                          _longitude = result.longitude;
                        });
                      }
                    },
                    icon: const Icon(Icons.map),
                    label: Text(ref.tr('select_on_map')),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ),
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
          Text(
            ref.tr('upload_docs_desc'),
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 24),
          
          // Business License
          Text(
            ref.tr('business_license_title'),
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
                        Text(ref.tr('tap_to_upload'), style: TextStyle(color: Colors.grey[600])),
                        Text(ref.tr('license_subtitle'), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),
          
          // Owner NID (Tazkira)
          Text(
            ref.tr('owner_id_title'),
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
                        Text(ref.tr('tap_to_upload'), style: TextStyle(color: Colors.grey[600])),
                        Text(ref.tr('tazkira_subtitle'), style: TextStyle(color: Colors.grey[500], fontSize: 12)),
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
                    ref.tr('application_review_notice'),
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
