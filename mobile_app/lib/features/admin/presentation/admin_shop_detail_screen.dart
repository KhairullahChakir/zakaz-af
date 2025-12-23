import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../data/admin_shop_repository.dart';
import '../../shop/domain/shop.dart';

const String _baseStorageUrl = 'http://172.20.10.2:8000/storage/';

class AdminShopDetailScreen extends ConsumerStatefulWidget {
  final Shop shop;

  const AdminShopDetailScreen({super.key, required this.shop});

  @override
  ConsumerState<AdminShopDetailScreen> createState() => _AdminShopDetailScreenState();
}

class _AdminShopDetailScreenState extends ConsumerState<AdminShopDetailScreen> {
  late Shop _shop;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _shop = widget.shop;
  }

  Future<void> _approveShop() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Approve Shop'),
        content: Text('Are you sure you want to approve "${_shop.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Approve'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        final updatedShop = await ref.read(adminShopRepositoryProvider).approveShop(_shop.id);
        setState(() => _shop = updatedShop);
        ref.invalidate(allShopsProvider);
        ref.invalidate(pendingShopsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shop approved!'), backgroundColor: Colors.green),
          );
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
  }

  Future<void> _rejectShop() async {
    final reasonController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reject Shop'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Why are you rejecting "${_shop.name}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason *',
                border: OutlineInputBorder(),
                hintText: 'e.g., Invalid business license',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please provide a reason')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Reject'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        final updatedShop = await ref.read(adminShopRepositoryProvider)
            .rejectShop(_shop.id, reasonController.text);
        setState(() => _shop = updatedShop);
        ref.invalidate(allShopsProvider);
        ref.invalidate(pendingShopsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shop rejected'), backgroundColor: Colors.orange),
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
  }

  Future<void> _suspendShop() async {
    final reasonController = TextEditingController();
    
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend Shop'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Why are you suspending "${_shop.name}"?'),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason *',
                border: OutlineInputBorder(),
                hintText: 'e.g., Policy violation',
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please provide a reason')),
                );
                return;
              }
              Navigator.pop(context, true);
            },
            style: FilledButton.styleFrom(backgroundColor: Colors.grey),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() => _isLoading = true);
      try {
        final updatedShop = await ref.read(adminShopRepositoryProvider)
            .suspendShop(_shop.id, reasonController.text);
        setState(() => _shop = updatedShop);
        ref.invalidate(allShopsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Shop suspended'), backgroundColor: Colors.grey),
          );
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
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat.yMMMd();

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldPop = await _showExitConfirmation();
        if (shouldPop == true && context.mounted) {
          context.pop();
        }
      },
      child: Scaffold(
      appBar: AppBar(
        title: Text(_shop.name),
        actions: [
          if (_shop.isApproved)
            IconButton(
              icon: const Icon(Icons.block, color: Colors.grey),
              tooltip: 'Suspend',
              onPressed: _suspendShop,
            ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Status Banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _getStatusColor(_shop.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: _getStatusColor(_shop.status).withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        Icon(_getStatusIcon(_shop.status), color: _getStatusColor(_shop.status)),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Status: ${_shop.status.toUpperCase()}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: _getStatusColor(_shop.status),
                                ),
                              ),
                              if (_shop.approvedAt != null)
                                Text(
                                  'Approved: ${dateFormat.format(_shop.approvedAt!)}',
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Shop Photos
                  Text('Shop Photos', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 140,
                    child: _buildShopPhotos(),
                  ),
                  const SizedBox(height: 24),

                  // Shop Details
                  Text('Shop Details', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  _buildDetailRow(Icons.store, 'Name', _shop.name),
                  _buildDetailRow(Icons.category, 'Type', _shop.type),
                  if (_shop.description != null)
                    _buildDetailRow(Icons.description, 'Description', _shop.description!),
                  _buildDetailRow(Icons.location_on, 'Address', _shop.address),
                  _buildDetailRow(Icons.location_city, 'Location', '${_shop.city}, ${_shop.province}'),
                  _buildDetailRow(Icons.phone, 'Phone', _shop.phone),
                  if (_shop.email != null) _buildDetailRow(Icons.email, 'Email', _shop.email!),
                  const SizedBox(height: 24),

                  // Documents
                  Text('Documents', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildDocumentCard(
                          'Business License',
                          _shop.businessLicenseUrl,
                          Icons.description,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildDocumentCard(
                          'Owner NID',
                          null, // NID URL would go here
                          Icons.badge,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  // Action Buttons (for pending shops)
                  if (_shop.isPending) ...[
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _rejectShop,
                            icon: const Icon(Icons.close, color: Colors.red),
                            label: const Text('Reject', style: TextStyle(color: Colors.red)),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: Colors.red),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: FilledButton.icon(
                            onPressed: _approveShop,
                            icon: const Icon(Icons.check),
                            label: const Text('Approve'),
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: Colors.green,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],

                  // Rejection reason (if rejected)
                  if (_shop.isRejected && _shop.rejectionReason != null) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.info, color: Colors.red[700]),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Rejection Reason:',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[700]),
                                ),
                                Text(_shop.rejectionReason!, style: TextStyle(color: Colors.red[700])),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
      ),
    );
  }

  Future<bool?> _showExitConfirmation() {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Icon(Icons.exit_to_app, color: Colors.orange),
            SizedBox(width: 12),
            Text('Leave Review?'),
          ],
        ),
        content: const Text(
          'Are you sure you want to go back? Any unsaved changes will be lost.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Stay'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            style: FilledButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Leave'),
          ),
        ],
      ),
    );
  }

  Widget _buildShopPhotos() {
    // Collect all available photos
    List<String> photoUrls = [];
    
    // Add primary photo URL if available
    if (_shop.primaryPhotoUrl != null && _shop.primaryPhotoUrl!.isNotEmpty) {
      photoUrls.add(_shop.primaryPhotoUrl!);
    }
    
    // Add photos from the photos list (converting relative paths to full URLs)
    if (_shop.photos != null && _shop.photos!.isNotEmpty) {
      for (var photo in _shop.photos!) {
        String fullUrl = photo.startsWith('http') ? photo : '$_baseStorageUrl$photo';
        if (!photoUrls.contains(fullUrl)) {
          photoUrls.add(fullUrl);
        }
      }
    }
    
    if (photoUrls.isEmpty) {
      return Container(
        width: 140,
        height: 140,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.store, size: 48, color: Colors.grey[400]),
            const SizedBox(height: 8),
            Text('No photos', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ],
        ),
      );
    }
    
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: photoUrls.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _showPhotoDialog(photoUrls[index], index + 1, photoUrls.length),
          child: Container(
            width: 140,
            margin: const EdgeInsets.only(right: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: photoUrls[index],
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  color: Colors.grey[200],
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
                errorWidget: (_, __, ___) => Container(
                  color: Colors.grey[200],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.broken_image, color: Colors.grey[400]),
                      const SizedBox(height: 4),
                      Text('Failed', style: TextStyle(color: Colors.grey[500], fontSize: 10)),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _showPhotoDialog(String url, int current, int total) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                'Photo $current of $total',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.contain,
                placeholder: (_, __) => const CircularProgressIndicator(color: Colors.white),
                errorWidget: (_, __, ___) => Container(
                  padding: const EdgeInsets.all(32),
                  color: Colors.grey[800],
                  child: const Icon(Icons.broken_image, color: Colors.white, size: 64),
                ),
              ),
            ),
            const SizedBox(height: 12),
            IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.grey),
          const SizedBox(width: 12),
          SizedBox(
            width: 80,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentCard(String title, String? url, IconData icon) {
    return GestureDetector(
      onTap: url != null ? () => _showDocumentDialog(title, url) : null,
      child: Container(
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: url != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(url, fit: BoxFit.cover),
                    Container(
                      alignment: Alignment.bottomCenter,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                      child: Text(
                        title,
                        style: const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.grey),
                  const SizedBox(height: 4),
                  Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  Text('Not provided', style: TextStyle(color: Colors.grey[400], fontSize: 10)),
                ],
              ),
      ),
    );
  }

  void _showDocumentDialog(String title, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              title: Text(title),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Image.network(url),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'suspended':
        return Colors.grey;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case 'pending':
        return Icons.hourglass_empty;
      case 'approved':
        return Icons.check_circle;
      case 'rejected':
        return Icons.cancel;
      case 'suspended':
        return Icons.block;
      default:
        return Icons.help_outline;
    }
  }
}
