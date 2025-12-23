import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/notification_repository.dart';
import 'package:mobile_app/core/localization/language_provider.dart';

// Orange Theme Colors
const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kSoftOrange = Color(0xFFFFF3E8);

class AdminSendNotificationScreen extends ConsumerStatefulWidget {
  const AdminSendNotificationScreen({super.key});

  @override
  ConsumerState<AdminSendNotificationScreen> createState() => _AdminSendNotificationScreenState();
}

class _AdminSendNotificationScreenState extends ConsumerState<AdminSendNotificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  String _selectedType = 'general';
  bool _isLoading = false;

  List<Map<String, dynamic>> get _notificationTypes => [
    {'value': 'general', 'label': ref.tr('type_general'), 'icon': Icons.notifications},
    {'value': 'promotion', 'label': ref.tr('type_promotion'), 'icon': Icons.local_offer},
    {'value': 'order', 'label': ref.tr('type_order_update'), 'icon': Icons.shopping_bag},
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _sendNotification() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      await ref.read(notificationRepositoryProvider).sendNotification(
        title: _titleController.text,
        body: _bodyController.text,
        type: _selectedType,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ref.tr('notification_sent_msg')),
            backgroundColor: Colors.green,
          ),
        );
        _titleController.clear();
        _bodyController.clear();
        setState(() => _selectedType = 'general');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: Colors.red,
          ),
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
        title: Text(ref.tr('send_notification')),
        centerTitle: true,
        backgroundColor: kPrimaryOrange,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: kSoftOrange,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.campaign, color: kPrimaryOrange, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            ref.tr('broadcast_notification'),
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          Text(
                            ref.tr('broadcast_desc'),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 24),
              
              // Type Selection
              Text(
                ref.tr('notification_type'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 12,
                children: _notificationTypes.map((type) {
                  final isSelected = _selectedType == type['value'];
                  return ChoiceChip(
                    label: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          type['icon'],
                          size: 18,
                          color: isSelected ? Colors.white : kPrimaryOrange,
                        ),
                        const SizedBox(width: 6),
                        Text(type['label']),
                      ],
                    ),
                    selected: isSelected,
                    selectedColor: kPrimaryOrange,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedType = type['value']);
                    },
                  );
                }).toList(),
              ),
              
              const SizedBox(height: 24),
              
              // Title Field
              Text(
                ref.tr('notification_title'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  hintText: ref.tr('notification_title_hint'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryOrange, width: 2),
                  ),
                ),
                validator: (v) => v?.isEmpty ?? true ? ref.tr('title_required') : null,
              ),
              
              const SizedBox(height: 20),
              
              // Body Field
              Text(
                ref.tr('notification_body'),
                style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bodyController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: ref.tr('notification_body_hint'),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: kPrimaryOrange, width: 2),
                  ),
                ),
                validator: (v) => v?.isEmpty ?? true ? ref.tr('message_required') : null,
              ),
              
              const SizedBox(height: 32),
              
              // Send Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendNotification,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kPrimaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.send),
                            const SizedBox(width: 8),
                            Text(
                              ref.tr('send_notification'),
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
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
