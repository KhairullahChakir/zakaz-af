import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../network/dio_provider.dart';

part 'app_settings_service.g.dart';

/// App settings from backend
class AppSettingsData {
  final ContactInfo contact;
  final SocialLinks social;

  AppSettingsData({
    required this.contact,
    required this.social,
  });

  factory AppSettingsData.fromJson(Map<String, dynamic> json) {
    return AppSettingsData(
      contact: ContactInfo.fromJson(json['contact'] ?? {}),
      social: SocialLinks.fromJson(json['social'] ?? {}),
    );
  }

  factory AppSettingsData.empty() {
    return AppSettingsData(
      contact: ContactInfo.empty(),
      social: SocialLinks.empty(),
    );
  }
}

class ContactInfo {
  final String email;
  final String phone;
  final String whatsapp;
  final String location;

  ContactInfo({
    required this.email,
    required this.phone,
    required this.whatsapp,
    required this.location,
  });

  factory ContactInfo.fromJson(Map<String, dynamic> json) {
    return ContactInfo(
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      whatsapp: json['whatsapp'] ?? '',
      location: json['location'] ?? '',
    );
  }

  factory ContactInfo.empty() {
    return ContactInfo(
      email: 'khairullahanosh9626@gmail.com',
      phone: '+77073756623',
      whatsapp: '+77073756623',
      location: 'Sheberghan, Jawzjan, Afghanistan',
    );
  }
}

class SocialLinks {
  final String facebook;
  final String instagram;
  final String tiktok;
  final String telegram;
  final String youtube;

  SocialLinks({
    required this.facebook,
    required this.instagram,
    required this.tiktok,
    required this.telegram,
    required this.youtube,
  });

  factory SocialLinks.fromJson(Map<String, dynamic> json) {
    return SocialLinks(
      facebook: json['facebook'] ?? '',
      instagram: json['instagram'] ?? '',
      tiktok: json['tiktok'] ?? '',
      telegram: json['telegram'] ?? '',
      youtube: json['youtube'] ?? '',
    );
  }

  factory SocialLinks.empty() {
    return SocialLinks(
      facebook: '',
      instagram: '',
      tiktok: '',
      telegram: '',
      youtube: '',
    );
  }

  /// Get list of active social links
  List<SocialLinkItem> get activeLinks {
    final links = <SocialLinkItem>[];
    if (facebook.isNotEmpty) links.add(SocialLinkItem('facebook', facebook));
    if (instagram.isNotEmpty) links.add(SocialLinkItem('instagram', instagram));
    if (tiktok.isNotEmpty) links.add(SocialLinkItem('tiktok', tiktok));
    if (telegram.isNotEmpty) links.add(SocialLinkItem('telegram', telegram));
    if (youtube.isNotEmpty) links.add(SocialLinkItem('youtube', youtube));
    return links;
  }
}

class SocialLinkItem {
  final String type;
  final String url;

  SocialLinkItem(this.type, this.url);
}

@Riverpod(keepAlive: true)
class AppSettingsNotifier extends _$AppSettingsNotifier {
  @override
  Future<AppSettingsData> build() async {
    return _fetchSettings();
  }

  Future<AppSettingsData> _fetchSettings() async {
    try {
      final dio = ref.read(dioProvider);
      final response = await dio.get('/app-settings');
      
      if (response.statusCode == 200 && response.data['success'] == true) {
        return AppSettingsData.fromJson(response.data['data']);
      }
      return AppSettingsData.empty();
    } catch (e) {
      // Return default settings on error
      return AppSettingsData.empty();
    }
  }

  /// Refresh settings from server
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await _fetchSettings());
  }
}
