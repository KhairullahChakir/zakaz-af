import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'address_provider.dart';
import '../domain/address.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/localization/language_provider.dart';

// Afghanistan provinces - simplified list with major cities
const List<String> afghanProvinces = [
  'Kabul', 'Kandahar', 'Herat', 'Mazar-i-Sharif', 'Jalalabad',
  'Kunduz', 'Balkh', 'Baghlan', 'Ghazni', 'Khost',
  'Nangarhar', 'Helmand', 'Nimroz', 'Farah', 'Badghis',
  'Ghor', 'Daykundi', 'Uruzgan', 'Zabul', 'Paktia',
  'Paktika', 'Logar', 'Wardak', 'Kapisa', 'Parwan',
  'Panjshir', 'Bamyan', 'Samangan', 'Sar-e Pol', 'Jowzjan',
  'Faryab', 'Badakhshan', 'Takhar', 'Laghman', 'Kunar', 'Nuristan',
];

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

class AddEditAddressScreen extends ConsumerStatefulWidget {
  final Address? address;
  const AddEditAddressScreen({super.key, this.address});

  @override
  ConsumerState<AddEditAddressScreen> createState() => _AddEditAddressScreenState();
}

class _AddEditAddressScreenState extends ConsumerState<AddEditAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  
  // Only essential controllers
  late TextEditingController _recipientNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressDescController;
  
  String? _selectedProvince;
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final addr = widget.address;
    
    _recipientNameController = TextEditingController(text: addr?.recipientName ?? '');
    _phoneController = TextEditingController(text: addr?.phonePrimary ?? '');
    
    // Build address description from existing fields
    String existingAddress = '';
    if (addr != null) {
      final parts = <String>[];
      if (addr.street != null && addr.street!.isNotEmpty) parts.add(addr.street!);
      if (addr.district != null && addr.district!.isNotEmpty) parts.add(addr.district!);
      if (addr.city.isNotEmpty && addr.city != addr.province) parts.add(addr.city);
      if (parts.isEmpty && addr.addressLine1.isNotEmpty && addr.addressLine1 != 'N/A') {
        existingAddress = addr.addressLine1;
      } else {
        existingAddress = parts.join(', ');
      }
    }
    _addressDescController = TextEditingController(text: existingAddress);
    
    _selectedProvince = addr?.province;
    _isDefault = addr?.isDefault ?? false;
  }

  @override
  void dispose() {
    _recipientNameController.dispose();
    _phoneController.dispose();
    _addressDescController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addressState = ref.watch(addressesProvider);
    final isLoading = addressState.isLoading;
    final isEditing = widget.address != null;
    final language = ref.watch(languageProvider);
    final isRTL = language.isRTL;

    // Listen for errors and show them
    ref.listen<AsyncValue<List<Address>>>(addressesProvider, (previous, next) {
      if (next.hasError && !next.isLoading) {
        final errorMsg = next.error?.toString() ?? 'Error occurred';
        _showError(errorMsg);
      }
    });

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: context.backgroundColor,
        appBar: AppBar(
          title: Text(
            isEditing ? ref.tr('edit_address') : ref.tr('add_address'),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: context.appBarColor,
          foregroundColor: context.appBarTextColor,
          elevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Simple form
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 1. WHO - Recipient Name
                        _buildSimpleField(
                          icon: Icons.person,
                          label: ref.tr('recipient_name'),
                          hint: ref.tr('recipient_name_simple_hint'),
                          controller: _recipientNameController,
                          isRequired: true,
                          textCapitalization: TextCapitalization.words,
                        ),
                        const SizedBox(height: 24),
                        
                        // 2. PHONE - Most important!
                        _buildSimpleField(
                          icon: Icons.phone,
                          label: ref.tr('phone_number'),
                          hint: '0700 000 000',
                          controller: _phoneController,
                          isRequired: true,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9+\-\s]')),
                          ],
                        ),
                        const SizedBox(height: 24),
                        
                        // 3. WHERE - Province Picker (Visual)
                        _buildProvincePicker(),
                        const SizedBox(height: 24),
                        
                        // 4. ADDRESS - Simple description
                        _buildSimpleField(
                          icon: Icons.location_on,
                          label: ref.tr('address_simple'),
                          hint: ref.tr('address_simple_hint'),
                          controller: _addressDescController,
                          isRequired: true,
                          maxLines: 2,
                        ),
                        const SizedBox(height: 32),
                        
                        // 5. Default toggle - simple switch
                        _buildDefaultToggle(),
                        
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
              
              // Big Save Button at bottom
              _buildSaveButton(isLoading),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSimpleField({
    required IconData icon,
    required String label,
    required String hint,
    required TextEditingController controller,
    bool isRequired = false,
    TextInputType keyboardType = TextInputType.text,
    TextCapitalization textCapitalization = TextCapitalization.none,
    List<TextInputFormatter>? inputFormatters,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label with icon
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kSoftOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: kPrimaryOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            if (isRequired)
              Text(' *', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        
        // Input field - BIG and easy to tap
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          inputFormatters: inputFormatters,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: 18, // Bigger text
            color: context.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: context.textSecondary.withOpacity(0.5),
              fontSize: 16,
            ),
            filled: true,
            fillColor: context.inputFillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: kPrimaryOrange, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.red.shade300, width: 2),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
          validator: isRequired
              ? (v) => v?.isEmpty == true ? ref.tr('required') : null
              : null,
        ),
      ],
    );
  }

  Widget _buildProvincePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kSoftOrange,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.map, color: kPrimaryOrange, size: 20),
            ),
            const SizedBox(width: 12),
            Text(
              ref.tr('province'),
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: context.textPrimary,
              ),
            ),
            Text(' *', style: TextStyle(color: Colors.red.shade400, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 12),
        
        // Province Grid - Visual selection
        Container(
          decoration: BoxDecoration(
            color: context.inputFillColor,
            borderRadius: BorderRadius.circular(16),
            border: _selectedProvince != null 
                ? Border.all(color: kPrimaryOrange, width: 2)
                : null,
          ),
          child: InkWell(
            onTap: () => _showProvinceSelector(),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      _selectedProvince ?? ref.tr('select_province'),
                      style: TextStyle(
                        fontSize: 18,
                        color: _selectedProvince != null 
                            ? context.textPrimary 
                            : context.textSecondary.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: context.textSecondary,
                    size: 28,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showProvinceSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Container(
              margin: const EdgeInsets.only(top: 12),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: context.dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            // Title
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                ref.tr('select_province'),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: context.textPrimary,
                ),
              ),
            ),
            
            // Province grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 2.5,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
                itemCount: afghanProvinces.length,
                itemBuilder: (context, index) {
                  final province = afghanProvinces[index];
                  final isSelected = _selectedProvince == province;
                  
                  return InkWell(
                    onTap: () {
                      setState(() => _selectedProvince = province);
                      Navigator.pop(context);
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? kPrimaryOrange : context.inputFillColor,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isSelected ? kPrimaryOrange : context.dividerColor,
                          width: isSelected ? 2 : 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          province,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                            color: isSelected ? Colors.white : context.textPrimary,
                          ),
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultToggle() {
    return InkWell(
      onTap: () => setState(() => _isDefault = !_isDefault),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: _isDefault ? kSoftOrange : context.inputFillColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _isDefault ? kPrimaryOrange : context.dividerColor,
            width: _isDefault ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox icon
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: _isDefault ? kPrimaryOrange : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _isDefault ? kPrimaryOrange : context.textSecondary,
                  width: 2,
                ),
              ),
              child: _isDefault
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.tr('set_as_default'),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: context.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ref.tr('default_address_simple_desc'),
                    style: TextStyle(
                      fontSize: 13,
                      color: context.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSaveButton(bool isLoading) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.cardColor,
        boxShadow: [
          BoxShadow(
            color: context.shadowColor.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: FilledButton(
          onPressed: isLoading ? null : _submit,
          style: FilledButton.styleFrom(
            backgroundColor: kPrimaryOrange,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.check_circle, size: 24),
                    const SizedBox(width: 12),
                    Text(
                      ref.tr('save_address'),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    // Simple validation
    if (_recipientNameController.text.trim().isEmpty) {
      _showError(ref.tr('enter_recipient_name'));
      return;
    }
    
    if (_phoneController.text.trim().isEmpty) {
      _showError(ref.tr('enter_phone_number'));
      return;
    }
    
    if (_selectedProvince == null) {
      _showError(ref.tr('select_province_error'));
      return;
    }
    
    if (_addressDescController.text.trim().isEmpty) {
      _showError(ref.tr('enter_address'));
      return;
    }

    final data = {
      'label': _selectedProvince!, // Use province as label for simplicity
      'recipient_name': _recipientNameController.text.trim(),
      'phone_primary': _phoneController.text.trim(),
      'country': 'Afghanistan',
      'province': _selectedProvince,
      'city': _selectedProvince, // Default city to province
      'street': _addressDescController.text.trim(),
      'is_default': _isDefault,
    };

    try {
      if (widget.address == null) {
        await ref.read(addressesProvider.notifier).addAddress(data);
      } else {
        await ref.read(addressesProvider.notifier).updateAddress(widget.address!.id, data);
      }

      // Check the state after the operation
      final state = ref.read(addressesProvider);
      
      if (!mounted) return;
      
      if (state.hasError) {
        // Show the error
        final error = state.error?.toString() ?? 'Unknown error';
        _showError(error);
      } else {
        // Success!
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Row(
              children: [
                const Icon(Icons.check_circle, color: Colors.white, size: 24),
                const SizedBox(width: 12),
                Text(
                  ref.tr('address_saved_success'),
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            duration: const Duration(seconds: 2),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        _showError(e.toString());
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.white, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(message, style: const TextStyle(fontSize: 16)),
            ),
          ],
        ),
        backgroundColor: Colors.red.shade600,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
