import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../products/presentation/providers.dart';
import '../../products/domain/category.dart';
import '../../../core/utils/responsive.dart';

// Orange Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kLightOrange = Color(0xFFFF8A3D);
const Color kSoftOrange = Color(0xFFFFF3E8);

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);
    final padding = Responsive.value<double>(context, mobile: 16, tablet: 24, desktop: 32);
    final gridColumns = Responsive.gridColumns(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories'),
        centerTitle: true,
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: categoriesAsync.when(
        data: (categories) => GridView.builder(
          padding: EdgeInsets.all(padding),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: gridColumns,
            childAspectRatio: 1.0,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            final category = categories[index];
            return _buildCategoryCard(context, category);
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: kPrimaryOrange)),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Category category) {
    return GestureDetector(
      onTap: () {
        // Navigate to products filtered by this category
        context.push('/products/category/${category.id}?name=${Uri.encodeComponent(category.name)}');
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildCategoryIcon(category),
            const SizedBox(height: 12),
            Text(
              category.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryIcon(Category category) {
    // Check if category has an image from the backend
    if (category.image != null) {
      final imageUrl = category.image!.startsWith('http') 
          ? category.image! 
          : 'http://172.20.10.2:8000/storage/${category.image}';

      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: imageUrl,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          placeholder: (_, __) => Container(
            width: 60,
            height: 60,
            color: kSoftOrange,
            child: const Icon(Icons.category, color: kPrimaryOrange),
          ),
          errorWidget: (_, __, ___) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: kSoftOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.category, color: kPrimaryOrange, size: 32),
          ),
        ),
      );
    }

    // Use asset images for specific categories
    final categoryName = category.name.toLowerCase();
    String? assetPath;
    
    if (categoryName.contains('grocer')) {
      assetPath = 'assets/images/groceries.png';
    } else if (categoryName.contains('cloth')) {
      assetPath = 'assets/images/clothes.png';
    } else if (categoryName.contains('tech')) {
      assetPath = 'assets/images/tech.png';
    }

    if (assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.asset(
          assetPath,
          width: 60,
          height: 60,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: kSoftOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.category, color: kPrimaryOrange, size: 32),
          ),
        ),
      );
    }

    // Default icon
    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        color: kSoftOrange,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Icon(Icons.category, color: kPrimaryOrange, size: 32),
    );
  }
}
