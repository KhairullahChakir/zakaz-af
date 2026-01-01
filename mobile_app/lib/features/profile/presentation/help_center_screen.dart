import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../core/theme/theme_context.dart';
import '../../../core/services/app_settings_service.dart';
import '../../../core/widgets/shimmer_loading.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);

class HelpCenterScreen extends ConsumerStatefulWidget {
  const HelpCenterScreen({super.key});

  @override
  ConsumerState<HelpCenterScreen> createState() => _HelpCenterScreenState();
}

class _HelpCenterScreenState extends ConsumerState<HelpCenterScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    
    // Clean up phone numbers to ensure they work with tel:
    String finalUrl = url;
    if (url.startsWith('tel:')) {
      // Keep the scheme but clean the number part
      final number = url.substring(4).replaceAll(RegExp(r'[^\d+]'), '');
      finalUrl = 'tel:$number';
    }

    final uri = Uri.parse(finalUrl);
    try {
      if (await canLaunchUrl(uri)) {
        // use platformDefault for tel/mailto for better compatibility
        await launchUrl(
          uri, 
          mode: (url.startsWith('http') || url.startsWith('https')) 
              ? LaunchMode.externalApplication 
              : LaunchMode.platformDefault,
        );
      } else {
        debugPrint('Could not launch $url');
        if (mounted) {
           ScaffoldMessenger.of(context).showSnackBar(
             SnackBar(content: Text('Could not open $url')),
           );
        }
      }
    } catch (e) {
      debugPrint('Error launching $url: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsAsync = ref.watch(appSettingsProvider);
    
    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('help_center'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
      ),
      body: settingsAsync.when(
        data: (settings) => _buildContent(context, settings),
        loading: () => ShimmerLoading(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SkeletonBox(height: 50, width: double.infinity, borderRadius: 12),
                const SizedBox(height: 24),
                const SkeletonBox(height: 20, width: 150),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: const SkeletonBox(height: 80, borderRadius: 16)),
                    const SizedBox(width: 12),
                    Expanded(child: const SkeletonBox(height: 80, borderRadius: 16)),
                    const SizedBox(width: 12),
                    Expanded(child: const SkeletonBox(height: 80, borderRadius: 16)),
                  ],
                ),
                const SizedBox(height: 24),
                const SkeletonBox(height: 20, width: 150),
                const SizedBox(height: 12),
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: const SkeletonBox(height: 70, borderRadius: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
        error: (_, __) => _buildContent(context, AppSettingsData.empty()),
      ),
    );
  }

  Widget _buildContent(BuildContext context, AppSettingsData settings) {
    // FAQ Data structure
    final List<FAQCategoryData> allCategories = [
      FAQCategoryData(
        titleKey: 'cat_orders_title',
        descKey: 'cat_orders_desc',
        icon: Icons.shopping_bag_outlined,
        items: [
          FAQItemData('q_track_order', 'a_track_order'),
          FAQItemData('q_shipping_options', 'a_shipping_options'),
        ],
      ),
      FAQCategoryData(
        titleKey: 'cat_payments_title',
        descKey: 'cat_payments_desc',
        icon: Icons.credit_card_outlined,
        items: [
          FAQItemData('q_payment_methods', 'a_payment_methods'),
          FAQItemData('q_refund_policy', 'a_refund_policy'),
        ],
      ),
      FAQCategoryData(
        titleKey: 'cat_account_title',
        descKey: 'cat_account_desc',
        icon: Icons.account_circle_outlined,
        items: [
          FAQItemData('q_account_delete', 'a_account_delete'),
        ],
      ),
      FAQCategoryData(
        titleKey: 'cat_selling_title',
        descKey: 'cat_selling_desc',
        icon: Icons.store_outlined,
        items: [
          FAQItemData('q_become_seller', 'a_become_seller'),
        ],
      ),
    ];

    // Filter categories based on search
    final filteredCategories = _searchQuery.isEmpty 
        ? allCategories 
        : allCategories.map((cat) {
            final filteredItems = cat.items.where((item) {
              final q = ref.tr(item.questionKey).toLowerCase();
              final a = ref.tr(item.answerKey).toLowerCase();
              return q.contains(_searchQuery.toLowerCase()) || a.contains(_searchQuery.toLowerCase());
            }).toList();
            
            if (filteredItems.isNotEmpty || ref.tr(cat.titleKey).toLowerCase().contains(_searchQuery.toLowerCase())) {
              return cat.copyWith(items: filteredItems);
            }
            return null;
          }).whereType<FAQCategoryData>().toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: context.cardColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: context.shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              onChanged: (val) => setState(() => _searchQuery = val),
              decoration: InputDecoration(
                hintText: ref.tr('search_help_hint'),
                hintStyle: TextStyle(color: context.textSecondary),
                prefixIcon: Icon(Icons.search, color: context.textSecondary),
                suffixIcon: _searchQuery.isNotEmpty 
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _searchQuery = '');
                        },
                      ) 
                    : null,
                border: InputBorder.none,
              ),
              style: TextStyle(color: context.textPrimary),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Direct Contacts
          _buildSectionTitle(context, ref.tr('contact_directly')),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildQuickAction(
                  context, 
                  FontAwesomeIcons.whatsapp, 
                  ref.tr('chat_on_whatsapp'), 
                  const Color(0xFF25D366),
                  () => _launchUrl('https://wa.me/${settings.contact.whatsapp.replaceAll('+', '')}'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  context, 
                  Icons.phone_outlined, 
                  ref.tr('call_us'), 
                  kPrimaryOrange,
                  () => _launchUrl('tel:${settings.contact.phone}'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildQuickAction(
                  context, 
                  Icons.email_outlined, 
                  ref.tr('email_us'), 
                  Colors.blue,
                  () => _launchUrl('mailto:${settings.contact.email}'),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 32),
          
          // FAQ Categories
          _buildSectionTitle(context, ref.tr('faq_categories')),
          const SizedBox(height: 12),
          
          if (filteredCategories.isEmpty)
             Padding(
               padding: const EdgeInsets.symmetric(vertical: 32),
               child: Center(
                 child: Text(
                   ref.tr('no_results_found'), // Need to add this key
                   style: TextStyle(color: context.textSecondary),
                 ),
               ),
             )
          else
            ...filteredCategories.map((cat) => _buildFAQCategory(context, cat)),
          
          const SizedBox(height: 32),
          
          // Contact Support Card
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPrimaryOrange, kDarkOrange],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: kPrimaryOrange.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        ref.tr('still_need_help'),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ref.tr('support_24_7_assist'),
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _launchUrl('https://wa.me/${settings.contact.whatsapp.replaceAll('+', '')}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: kPrimaryOrange,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(ref.tr('get_support'), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.support_agent,
                  size: 64,
                  color: Colors.white.withValues(alpha: 0.3),
                ),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: context.textPrimary,
      ),
    );
  }

  Widget _buildQuickAction(BuildContext context, IconData icon, String label, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: context.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: context.shadowColor,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: context.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQCategory(BuildContext context, FAQCategoryData cat) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: context.cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: context.shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ExpansionTile(
        initiallyExpanded: _searchQuery.isNotEmpty,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kPrimaryOrange.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(cat.icon, color: kPrimaryOrange),
        ),
        title: Text(ref.tr(cat.titleKey), style: TextStyle(fontWeight: FontWeight.w600, color: context.textPrimary)),
        subtitle: Text(ref.tr(cat.descKey), style: TextStyle(fontSize: 12, color: context.textSecondary)),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        children: cat.items.map((item) => _buildFAQItem(context, item)).toList(),
      ),
    );
  }

  Widget _buildFAQItem(BuildContext context, FAQItemData item) {
    return ExpansionTile(
      initiallyExpanded: _searchQuery.isNotEmpty,
      title: Text(
        ref.tr(item.questionKey),
        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: context.textPrimary),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Text(
            ref.tr(item.answerKey),
            style: TextStyle(fontSize: 13, color: context.textSecondary, height: 1.5),
          ),
        ),
      ],
    );
  }
}

class FAQCategoryData {
  final String titleKey;
  final String descKey;
  final IconData icon;
  final List<FAQItemData> items;

  FAQCategoryData({
    required this.titleKey,
    required this.descKey,
    required this.icon,
    required this.items,
  });

  FAQCategoryData copyWith({List<FAQItemData>? items}) {
    return FAQCategoryData(
      titleKey: titleKey,
      descKey: descKey,
      icon: icon,
      items: items ?? this.items,
    );
  }
}

class FAQItemData {
  final String questionKey;
  final String answerKey;
  
  FAQItemData(this.questionKey, this.answerKey);
}
