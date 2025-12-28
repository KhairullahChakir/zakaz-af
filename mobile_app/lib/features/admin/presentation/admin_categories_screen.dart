import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import 'package:mobile_app/core/widgets/custom_cached_image.dart';
import '../data/admin_repository.dart';
import '../../products/domain/category.dart';
import '../../products/presentation/providers.dart';

class AdminCategoriesScreen extends ConsumerStatefulWidget {
  const AdminCategoriesScreen({super.key});

  @override
  ConsumerState<AdminCategoriesScreen> createState() => _AdminCategoriesScreenState();
}

class _AdminCategoriesScreenState extends ConsumerState<AdminCategoriesScreen> {
  bool _isLoading = false;

  Future<void> _deleteCategory(int categoryId, String name) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(ref.tr('delete_category')),
        content: Text(ref.tr('delete_category_confirm', args: {'name': name})),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(ref.tr('cancel')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(ref.tr('delete')),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        await ref.read(adminRepositoryProvider).deleteCategory(categoryId);
        ref.invalidate(categoriesProvider);
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(ref.tr('category_deleted')), backgroundColor: Colors.green),
        );
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
  }

  Future<void> _showCategoryDialog({Category? category}) async {
    final nameController = TextEditingController(text: category?.name ?? '');
    final typeController = TextEditingController(text: category?.type ?? '');
    File? imageFile;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(category == null ? ref.tr('add_category') : ref.tr('edit_category')),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: () async {
                    try {
                      final picker = ImagePicker();
                      final picked = await picker.pickImage(
                        source: ImageSource.gallery,
                        maxWidth: 800, // Increased quality slightly
                        imageQuality: 85,
                      );
                      
                      if (picked != null) {
                        final file = File(picked.path);
                        final sizeInBytes = await file.length();
                        final sizeInMb = sizeInBytes / (1024 * 1024);
                        
                        if (sizeInMb > 5) {
                          if (!context.mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Image is too large (Max 5MB)'),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        
                        setDialogState(() => imageFile = file);
                      }
                    } catch (e) {
                      debugPrint('Error picking image: $e');
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Failed to pick image: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: imageFile != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(imageFile!, fit: BoxFit.cover),
                          )
                        : (category?.image != null && imageFile == null)
                            ? CustomCachedImage(
                                imageUrl: category!.image!,
                                borderRadius: 8,
                                fit: BoxFit.cover,
                              )
                            : Icon(Icons.add_photo_alternate, color: Colors.grey[400]),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: ref.tr('category_name'),
                    border: const OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: typeController,
                  decoration: InputDecoration(
                    labelText: ref.tr('type_optional'),
                    border: const OutlineInputBorder(),
                    hintText: ref.tr('type_hint'),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(ref.tr('cancel')),
            ),
            FilledButton(
              onPressed: () async {
                if (nameController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(ref.tr('name_required'))),
                  );
                  return;
                }

                Navigator.pop(context);
                setState(() => _isLoading = true);

                try {
                  final adminRepo = ref.read(adminRepositoryProvider);
                  if (category == null) {
                    await adminRepo.createCategory(
                      name: nameController.text,
                      type: typeController.text.isNotEmpty ? typeController.text : null,
                      image: imageFile,
                    );
                  } else {
                    await adminRepo.updateCategory(
                      id: category.id,
                      name: nameController.text,
                      type: typeController.text.isNotEmpty ? typeController.text : null,
                      image: imageFile,
                    );
                  }
                  ref.invalidate(categoriesProvider);
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(category == null ? ref.tr('category_created') : ref.tr('category_updated')),
                      backgroundColor: Colors.green,
                    ),
                  );
                } catch (e) {
                  if (!mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${ref.tr('error')}: $e'), backgroundColor: Colors.red),
                  );
                } finally {
                  if (mounted) setState(() => _isLoading = false);
                }
              },
              child: Text(category == null ? ref.tr('add') : ref.tr('save')),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(ref.tr('manage_categories')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCategoryDialog(),
        icon: const Icon(Icons.add),
        label: Text(ref.tr('add_category')),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async => ref.invalidate(categoriesProvider),
              child: categoriesAsync.when(
                data: (categories) {
                  if (categories.isEmpty) {
                    return Center(child: Text(ref.tr('no_categories_found')));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: ListTile(
                          leading: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: category.image != null
                                ? CustomCachedImage(
                                    imageUrl: category.image!,
                                    fit: BoxFit.cover,
                                    borderRadius: 8,
                                    placeholder: const Icon(Icons.category, color: Colors.grey),
                                    errorWidget: const Icon(Icons.category, color: Colors.grey),
                                  )
                                : const Icon(Icons.category, color: Colors.grey),
                          ),
                          title: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: category.type != null ? Text(category.type!) : null,
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'edit') {
                                _showCategoryDialog(category: category);
                              } else if (value == 'delete') {
                                _deleteCategory(category.id, category.name);
                              }
                            },
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    const Icon(Icons.edit, size: 20),
                                    const SizedBox(width: 8),
                                    Text(ref.tr('edit')),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    const Icon(Icons.delete, size: 20, color: Colors.red),
                                    const SizedBox(width: 8),
                                    Text(ref.tr('delete'), style: const TextStyle(color: Colors.red)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text('Error: $e')),
              ),
            ),
    );
  }
}
