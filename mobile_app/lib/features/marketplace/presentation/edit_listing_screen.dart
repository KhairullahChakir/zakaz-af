import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/widgets/custom_cached_image.dart';
import '../../products/presentation/providers.dart';
import '../data/marketplace_repository.dart';
import '../domain/marketplace_item.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);

class EditListingScreen extends ConsumerStatefulWidget {
  final MarketplaceItem item;
  const EditListingScreen({super.key, required this.item});

  @override
  ConsumerState<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends ConsumerState<EditListingScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _phoneController;
  late TextEditingController _locationController;
  
  String _condition = 'new';
  int? _categoryId;
  bool _isLoading = false;

  // Image State
  List<String> _currentImages = [];
  final List<File> _newImages = [];
  final List<String> _deletedImages = [];

  final List<String> _conditions = ['new', 'like_new', 'used_good', 'used_fair', 'used_poor'];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item.name);
    _descriptionController = TextEditingController(text: widget.item.description);
    _priceController = TextEditingController(text: widget.item.price.toStringAsFixed(0));
    _phoneController = TextEditingController(text: widget.item.phone);
    _locationController = TextEditingController(text: widget.item.location ?? '');
    _condition = widget.item.condition;
    _categoryId = widget.item.categoryId;
    
    // Initialize current images
    if (widget.item.galleryUrls != null) {
      _currentImages = List.from(widget.item.galleryUrls!);
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _newImages.add(File(pickedFile.path)));
    }
  }

  void _removeCurrentImage(int index) {
    setState(() {
      final url = _currentImages.removeAt(index);
      _deletedImages.add(url);
    });
  }

  void _removeNewImage(int index) {
    setState(() {
      _newImages.removeAt(index);
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    // Validate at least one image remains
    if (_currentImages.isEmpty && _newImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.tr('image_required') ?? 'At least one image is required')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await ref.read(marketplaceRepositoryProvider).updateListing(
        widget.item.id,
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.parse(_priceController.text),
        condition: _condition,
        phone: _phoneController.text.trim(),
        categoryId: _categoryId,
        location: _locationController.text.isEmpty ? null : _locationController.text.trim(),
        newImages: _newImages,
        deletedImages: _deletedImages,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.tr('listing_updated')),
            backgroundColor: Colors.green,
          ),
        );
        ref.invalidate(myMarketplaceItemsProvider);
        ref.invalidate(marketplaceItemsProvider);
        ref.invalidate(marketplaceItemsCacheProvider);
        ref.invalidate(marketplaceItemDetailsProvider(widget.item.id));
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        print('Error updating: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')), 
            backgroundColor: Colors.red
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final language = ref.watch(languageProvider);
    final isRTL = language.isRTL;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        appBar: AppBar(
          title: Text(ref.tr('edit_listing')),
          backgroundColor: kPrimaryOrange,
          foregroundColor: Colors.white,
        ),
        body: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Image Management Section
              Text(
                'Images', // TODO: Add translation 'images'
                style: TextStyle(fontWeight: FontWeight.bold, color: context.textPrimary),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  // +1 for the Add Button
                  itemCount: _currentImages.length + _newImages.length + 1,
                  itemBuilder: (context, index) {
                    // 1. Add Button (at the end)
                    if (index == _currentImages.length + _newImages.length) {
                      return GestureDetector(
                        onTap: _pickImage,
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: context.softOrange,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: kPrimaryOrange),
                          ),
                          child: const Icon(Icons.add_a_photo, color: kPrimaryOrange),
                        ),
                      );
                    }

                    // 2. Existing Images
                    if (index < _currentImages.length) {
                      return Stack(
                        children: [
                          Container(
                            width: 100,
                            margin: const EdgeInsets.only(right: 8),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: CustomCachedImage(
                                imageUrl: _currentImages[index],
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            ),
                          ),
                          Positioned(
                            right: 12,
                            top: 4,
                            child: GestureDetector(
                              onTap: () => _removeCurrentImage(index),
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
                    }

                    // 3. New Images
                    final newIndex = index - _currentImages.length;
                    return Stack(
                      children: [
                        Container(
                          width: 100,
                          margin: const EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(_newImages[newIndex]),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: 4,
                          child: GestureDetector(
                            onTap: () => _removeNewImage(newIndex),
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
                  },
                ),
              ),
              const SizedBox(height: 24),

              // Name
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: ref.tr('product_name'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: context.inputFillColor,
                ),
                validator: (v) => v?.isEmpty == true ? ref.tr('required') : null,
              ),
              const SizedBox(height: 16),

              // Description
              TextFormField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: ref.tr('description'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: context.inputFillColor,
                ),
                validator: (v) => v?.isEmpty == true ? ref.tr('required') : null,
              ),
              const SizedBox(height: 16),

              // Price
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: '${ref.tr('price')} (AFN)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: context.inputFillColor,
                ),
                validator: (v) => v?.isEmpty == true ? ref.tr('required') : null,
              ),
              const SizedBox(height: 16),

              // Phone
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: ref.tr('phone'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: context.inputFillColor,
                ),
                validator: (v) => v?.isEmpty == true ? ref.tr('required') : null,
              ),
              const SizedBox(height: 16),

              // Location
              TextFormField(
                controller: _locationController,
                decoration: InputDecoration(
                  labelText: ref.tr('location'),
                  hintText: 'Kabul, Afghanistan',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: context.inputFillColor,
                ),
              ),
              const SizedBox(height: 16),

              // Condition Dropdown
              DropdownButtonFormField<String>(
                value: _condition,
                decoration: InputDecoration(
                  labelText: ref.tr('condition'),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  filled: true,
                  fillColor: context.inputFillColor,
                ),
                items: _conditions.map((c) => DropdownMenuItem(
                  value: c,
                  child: Text(ref.tr('condition_$c')),
                )).toList(),
                onChanged: (v) => setState(() => _condition = v!),
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              categoriesAsync.when(
                data: (categories) => DropdownButtonFormField<int>(
                  value: _categoryId,
                  decoration: InputDecoration(
                    labelText: ref.tr('category'),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    filled: true,
                    fillColor: context.inputFillColor,
                  ),
                  items: categories.map((c) => DropdownMenuItem(
                    value: c.id,
                    child: Text(c.name),
                  )).toList(),
                  onChanged: (v) => setState(() => _categoryId = v),
                ),
                loading: () => const LinearProgressIndicator(),
                error: (e, _) => Text('Error loading categories'),
              ),
              const SizedBox(height: 32),

              // Submit Button
              SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryOrange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          ref.tr('update_listing'),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
