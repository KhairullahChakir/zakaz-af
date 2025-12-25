import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import '../data/shopkeeper_repository.dart';
import '../../../core/localization/language_provider.dart';
import '../../products/domain/product.dart';
import '../../products/domain/category.dart';
import '../../products/presentation/providers.dart';

class ShopkeeperAddEditProductScreen extends ConsumerStatefulWidget {
  final Product? product;

  const ShopkeeperAddEditProductScreen({super.key, this.product});

  @override
  ConsumerState<ShopkeeperAddEditProductScreen> createState() => _ShopkeeperAddEditProductScreenState();
}

class _ShopkeeperAddEditProductScreenState extends ConsumerState<ShopkeeperAddEditProductScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  
  Category? _selectedCategory;
  File? _imageFile;
  bool _isLoading = false;

  bool get isEditing => widget.product != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(text: widget.product?.description ?? '');
    _priceController = TextEditingController(text: widget.product?.price.toString() ?? '');
    _stockController = TextEditingController(text: widget.product?.stock.toString() ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _stockController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, maxWidth: 800);
    if (picked != null) {
      setState(() => _imageFile = File(picked.path));
    }
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null && widget.product?.categoryId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ref.tr('select_category_error'))),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      final repo = ref.read(shopkeeperRepositoryProvider);
      
      if (isEditing) {
        await repo.updateProduct(
          id: widget.product!.id,
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          categoryId: _selectedCategory?.id ?? widget.product!.categoryId,
          image: _imageFile,
        );
      } else {
        await repo.createProduct(
          name: _nameController.text,
          description: _descriptionController.text,
          price: double.parse(_priceController.text),
          stock: int.parse(_stockController.text),
          categoryId: _selectedCategory!.id,
          image: _imageFile,
        );
      }

      ref.invalidate(shopkeeperProductsProvider);
      ref.invalidate(shopkeeperDashboardProvider);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isEditing ? ref.tr('product_updated_msg') : ref.tr('product_created_msg')),
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
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? ref.tr('edit_product_title') : ref.tr('add_product_title')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Image Picker
                    GestureDetector(
                      onTap: _pickImage,
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey[300]!),
                        ),
                        child: _imageFile != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.file(_imageFile!, fit: BoxFit.cover),
                              )
                            : widget.product?.imageUrl != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(widget.product!.imageUrl!, fit: BoxFit.cover),
                                  )
                                : Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_photo_alternate, size: 50, color: Colors.grey[400]),
                                      const SizedBox(height: 8),
                                      Text(ref.tr('tap_add_image'), style: TextStyle(color: Colors.grey[600])),
                                    ],
                                  ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Name
                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        labelText: ref.tr('product_name_label'),
                        border: const OutlineInputBorder(),
                      ),
                      validator: (v) => v?.isEmpty == true ? ref.tr('error_required_field') : null,
                    ),
                    const SizedBox(height: 16),

                    // Description
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: ref.tr('description_label'),
                        border: const OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                    const SizedBox(height: 16),

                    // Price and Stock
                    Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _priceController,
                            decoration: InputDecoration(
                              labelText: ref.tr('price_afn_label'),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v?.isEmpty == true) return ref.tr('error_required_field');
                              if (double.tryParse(v!) == null) return ref.tr('error_unknown');
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextFormField(
                            controller: _stockController,
                            decoration: InputDecoration(
                              labelText: ref.tr('stock_label'),
                              border: const OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                            validator: (v) {
                              if (v?.isEmpty == true) return ref.tr('error_required_field');
                              if (int.tryParse(v!) == null) return ref.tr('error_unknown');
                              return null;
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // Category Dropdown
                    categoriesAsync.when(
                      data: (categories) {
                        if (isEditing && _selectedCategory == null) {
                          _selectedCategory = categories.firstWhere(
                            (c) => c.id == widget.product!.categoryId,
                            orElse: () => categories.first,
                          );
                        }
                        return DropdownButtonFormField<Category>(
                          value: _selectedCategory,
                          decoration: InputDecoration(
                            labelText: ref.tr('category_label'),
                            border: const OutlineInputBorder(),
                          ),
                          items: categories.map((cat) {
                            return DropdownMenuItem(
                              value: cat,
                              child: Text(ref.tr(cat.name.toLowerCase())),
                            );
                          }).toList(),
                          onChanged: (cat) => setState(() => _selectedCategory = cat),
                          validator: (v) => v == null ? ref.tr('error_required_field') : null,
                        );
                      },
                      loading: () => const LinearProgressIndicator(),
                      error: (e, _) => Text('${ref.tr('loading_categories_error')}: $e'),
                    ),
                    const SizedBox(height: 32),

                    // Submit Button
                    FilledButton(
                      onPressed: _submit,
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: Text(
                        isEditing ? ref.tr('update_product_btn') : ref.tr('create_product_btn'),
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
