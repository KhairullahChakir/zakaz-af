import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'version_service.g.dart';

/// App version information
class AppVersion {
  final String currentVersion;
  final String currentBuildNumber;
  final String? latestVersion;
  final bool updateRequired;
  final bool updateAvailable;
  final String? updateUrl;

  AppVersion({
    required this.currentVersion,
    required this.currentBuildNumber,
    this.latestVersion,
    this.updateRequired = false,
    this.updateAvailable = false,
    this.updateUrl,
  });
}

/// Version check service
@Riverpod(keepAlive: true)
class VersionNotifier extends _$VersionNotifier {
  @override
  Future<AppVersion> build() async {
    final info = await PackageInfo.fromPlatform();
    
    // For now, return current version info
    // In production, you would fetch latest version from your API
    return AppVersion(
      currentVersion: info.version,
      currentBuildNumber: info.buildNumber,
      latestVersion: info.version, // Would come from API
      updateRequired: false,
      updateAvailable: false,
    );
  }

  /// Check for updates from your API
  Future<void> checkForUpdates() async {
    state = const AsyncValue.loading();
    
    try {
      final info = await PackageInfo.fromPlatform();
      
      // TODO: Replace with actual API call to check version
      // final response = await dio.get('/app/version');
      // final latestVersion = response.data['version'];
      // final minVersion = response.data['min_version'];
      
      state = AsyncValue.data(AppVersion(
        currentVersion: info.version,
        currentBuildNumber: info.buildNumber,
        latestVersion: info.version,
        updateRequired: false,
        updateAvailable: false,
      ));
    } catch (e, st) {
      // On error, just use current version
      final info = await PackageInfo.fromPlatform();
      state = AsyncValue.data(AppVersion(
        currentVersion: info.version,
        currentBuildNumber: info.buildNumber,
      ));
    }
  }

  /// Open app store for update
  Future<void> openStore() async {
    // Android Play Store URL
    const playStoreUrl = 'https://play.google.com/store/apps/details?id=com.zakaz.af';
    // iOS App Store URL (if applicable)
    const appStoreUrl = 'https://apps.apple.com/app/zakaz-af/id1234567890';
    
    final uri = Uri.parse(playStoreUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

/// Dialog to show update available
class UpdateDialog extends StatelessWidget {
  final String currentVersion;
  final String latestVersion;
  final bool forceUpdate;
  final VoidCallback onUpdate;
  final VoidCallback? onLater;

  const UpdateDialog({
    super.key,
    required this.currentVersion,
    required this.latestVersion,
    required this.forceUpdate,
    required this.onUpdate,
    this.onLater,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.system_update, color: Color(0xFFFF6B00)),
          ),
          const SizedBox(width: 12),
          Text(forceUpdate ? 'Update Required' : 'Update Available'),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('A new version ($latestVersion) is available.'),
          const SizedBox(height: 8),
          Text('Current version: $currentVersion',
              style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          if (forceUpdate) ...[
            const SizedBox(height: 12),
            Text(
              'Please update to continue using the app.',
              style: TextStyle(color: Colors.red[600], fontWeight: FontWeight.w500),
            ),
          ],
        ],
      ),
      actions: [
        if (!forceUpdate && onLater != null)
          TextButton(
            onPressed: onLater,
            child: const Text('Later'),
          ),
        ElevatedButton(
          onPressed: onUpdate,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF6B00),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          child: const Text('Update Now'),
        ),
      ],
    );
  }
}
