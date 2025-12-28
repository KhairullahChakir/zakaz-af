import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/core/localization/language_provider.dart';
import 'package:mobile_app/core/theme/theme_context.dart';

const Color kPrimaryOrange = Color(0xFFFF6B00);
const Color kDarkOrange = Color(0xFFE55A00);
const Color kSoftOrange = Color(0xFFFFF3E6);

final notificationSettingsProvider = NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(() {
  return NotificationSettingsNotifier();
});

class NotificationSettings {
  final bool pushEnabled;
  final bool orderUpdates;
  final bool promotions;
  final bool priceDrops;
  final bool sellerMessages;
  final bool emailNotifications;

  NotificationSettings({
    this.pushEnabled = true,
    this.orderUpdates = true,
    this.promotions = true,
    this.priceDrops = true,
    this.sellerMessages = true,
    this.emailNotifications = true,
  });

  NotificationSettings copyWith({
    bool? pushEnabled,
    bool? orderUpdates,
    bool? promotions,
    bool? priceDrops,
    bool? sellerMessages,
    bool? emailNotifications,
  }) {
    return NotificationSettings(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      orderUpdates: orderUpdates ?? this.orderUpdates,
      promotions: promotions ?? this.promotions,
      priceDrops: priceDrops ?? this.priceDrops,
      sellerMessages: sellerMessages ?? this.sellerMessages,
      emailNotifications: emailNotifications ?? this.emailNotifications,
    );
  }
}

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() {
    _loadSettings();
    return NotificationSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    state = NotificationSettings(
      pushEnabled: prefs.getBool('notif_push') ?? true,
      orderUpdates: prefs.getBool('notif_orders') ?? true,
      promotions: prefs.getBool('notif_promos') ?? true,
      priceDrops: prefs.getBool('notif_price_drops') ?? true,
      sellerMessages: prefs.getBool('notif_seller_msgs') ?? true,
      emailNotifications: prefs.getBool('notif_email') ?? true,
    );
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notif_push', state.pushEnabled);
    await prefs.setBool('notif_orders', state.orderUpdates);
    await prefs.setBool('notif_promos', state.promotions);
    await prefs.setBool('notif_price_drops', state.priceDrops);
    await prefs.setBool('notif_seller_msgs', state.sellerMessages);
    await prefs.setBool('notif_email', state.emailNotifications);
  }

  void toggle(String key, bool value) {
    switch (key) {
      case 'push': state = state.copyWith(pushEnabled: value); break;
      case 'orders': state = state.copyWith(orderUpdates: value); break;
      case 'promos': state = state.copyWith(promotions: value); break;
      case 'price': state = state.copyWith(priceDrops: value); break;
      case 'seller': state = state.copyWith(sellerMessages: value); break;
      case 'email': state = state.copyWith(emailNotifications: value); break;
    }
    _saveSettings();
  }
}

class NotificationSettingsScreen extends ConsumerWidget {
  const NotificationSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(notificationSettingsProvider);
    final notifier = ref.read(notificationSettingsProvider.notifier);

    return Scaffold(
      backgroundColor: context.backgroundColor,
      appBar: AppBar(
        title: Text(ref.tr('notifications'), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: context.appBarColor,
        foregroundColor: context.appBarTextColor,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildMasterToggle(settings, notifier, ref),
          const SizedBox(height: 24),
          _buildSectionTitle(ref.tr('shopping_alerts')),
          _buildCard([
            _buildToggle(ref.tr('order_updates'), ref.tr('order_updates_desc'), Icons.local_shipping_outlined, 
              settings.orderUpdates, settings.pushEnabled ? (v) => notifier.toggle('orders', v) : null),
            _buildToggle(ref.tr('type_promotion'), ref.tr('promotions_desc'), Icons.discount_outlined,
              settings.promotions, settings.pushEnabled ? (v) => notifier.toggle('promos', v) : null),
            _buildToggle(ref.tr('price_drops'), ref.tr('price_drops_desc'), Icons.trending_down,
              settings.priceDrops, settings.pushEnabled ? (v) => notifier.toggle('price', v) : null),
            _buildToggle(ref.tr('seller_messages'), ref.tr('seller_messages_desc'), Icons.chat_bubble_outline,
              settings.sellerMessages, settings.pushEnabled ? (v) => notifier.toggle('seller', v) : null),
          ]),
          const SizedBox(height: 24),
          _buildSectionTitle(ref.tr('other_channels')),
          _buildCard([
            _buildToggle(ref.tr('email_notifications'), ref.tr('email_notifications_desc'), Icons.email_outlined,
              settings.emailNotifications, (v) => notifier.toggle('email', v)),
          ]),
        ],
      ),
    );
  }

  Widget _buildMasterToggle(NotificationSettings settings, NotificationSettingsNotifier notifier, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [kPrimaryOrange, kDarkOrange]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          const Icon(Icons.notifications_active, color: Colors.white, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ref.tr('push_notifications'), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                Text(settings.pushEnabled ? ref.tr('enabled') : ref.tr('disabled'), style: TextStyle(color: Colors.white.withValues(alpha: 0.8))),
              ],
            ),
          ),
          Switch(value: settings.pushEnabled, activeColor: Colors.white, onChanged: (v) => notifier.toggle('push', v)),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(left: 4, bottom: 12),
    child: Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: context.textPrimary)),
  );

  Widget _buildCard(List<Widget> children) => Container(
    decoration: BoxDecoration(color: context.cardColor, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: context.shadowColor, blurRadius: 10)]),
    child: Column(children: children),
  );

  Widget _buildToggle(String title, String subtitle, IconData icon, bool value, void Function(bool)? onChanged) {
    final disabled = onChanged == null;
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(color: (disabled ? Colors.grey : kPrimaryOrange).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
        child: Icon(icon, color: disabled ? Colors.grey : kPrimaryOrange),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: disabled ? Colors.grey : context.textPrimary)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 12, color: context.textSecondary)),
      trailing: Switch(value: value, activeColor: kPrimaryOrange, onChanged: onChanged),
    );
  }
}
