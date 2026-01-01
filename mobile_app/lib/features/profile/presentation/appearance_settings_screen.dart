import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/theme_provider.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/localization/language_provider.dart';
import '../../../core/services/haptic_service.dart';

class AppearanceSettingsScreen extends ConsumerWidget {
  const AppearanceSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themePreferenceProvider);
    final hapticEnabled = ref.watch(hapticEnabledProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      appBar: AppBar(
        title: Text(
          ref.tr('appearance'),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkText : Colors.white,
          ),
        ),
        backgroundColor: isDark ? AppColors.darkSurface : AppColors.primaryOrange,
        foregroundColor: isDark ? AppColors.darkText : Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Selection Section
            _buildSectionTitle(ref.tr('theme'), isDark),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                children: AppThemeMode.values.map((mode) {
                  final isSelected = currentTheme == mode;
                  return _buildThemeOption(
                    context: context,
                    ref: ref,
                    mode: mode,
                    isSelected: isSelected,
                    isDark: isDark,
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Preview Section
            _buildSectionTitle(ref.tr('preview'), isDark),
            const SizedBox(height: 12),
            
            _buildPreviewCard(context, ref, isDark),
            
            const SizedBox(height: 32),
            
            // Haptic Feedback Section
            _buildSectionTitle(ref.tr('haptic_feedback'), isDark),
            const SizedBox(height: 12),
            
            Container(
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: SwitchListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                title: Text(
                  ref.tr('haptic_feedback'),
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: isDark ? AppColors.darkText : AppColors.lightText,
                  ),
                ),
                subtitle: Text(
                  ref.tr('haptic_feedback_desc'),
                  style: TextStyle(
                    fontSize: 13,
                    color: isDark ? AppColors.darkTextSecondary : Colors.grey[600],
                  ),
                ),
                secondary: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: hapticEnabled
                        ? AppColors.primaryOrange.withValues(alpha: 0.15)
                        : isDark
                            ? AppColors.darkCardElevated
                            : Colors.grey[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.vibration,
                    color: hapticEnabled ? AppColors.primaryOrange : Colors.grey,
                  ),
                ),
                value: hapticEnabled,
                activeColor: AppColors.primaryOrange,
                onChanged: (value) async {
                  await ref.read(hapticEnabledProvider.notifier).toggle();
                  if (value) {
                    HapticService.mediumTap();
                  }
                },
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.softOrange.withValues(alpha: isDark ? 0.2 : 1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primaryOrange.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.info_outline_rounded, 
                    color: AppColors.primaryOrange,
                    size: 24,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      ref.tr('theme_info'),
                      style: TextStyle(
                        fontSize: 13,
                        color: isDark ? AppColors.darkTextSecondary : Colors.grey[700],
                      ),
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
  
  Widget _buildSectionTitle(String title, bool isDark) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: isDark ? AppColors.darkText : AppColors.lightText,
        ),
      ),
    );
  }
  
  Widget _buildThemeOption({
    required BuildContext context,
    required WidgetRef ref,
    required AppThemeMode mode,
    required bool isSelected,
    required bool isDark,
  }) {
    return InkWell(
      onTap: () => ref.read(themePreferenceProvider.notifier).setTheme(mode),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: mode != AppThemeMode.values.last
                ? BorderSide(
                    color: isDark ? AppColors.darkDivider : AppColors.lightDivider,
                    width: 0.5,
                  )
                : BorderSide.none,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryOrange.withValues(alpha: 0.15)
                    : isDark
                        ? AppColors.darkCardElevated
                        : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                mode.icon,
                color: isSelected 
                    ? AppColors.primaryOrange 
                    : isDark 
                        ? AppColors.darkTextSecondary 
                        : Colors.grey,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _getThemeName(ref, mode),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? AppColors.darkText : AppColors.lightText,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _getThemeDescription(ref, mode),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? AppColors.darkTextSecondary : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 16,
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  String _getThemeName(WidgetRef ref, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return ref.tr('theme_system');
      case AppThemeMode.light:
        return ref.tr('theme_light');
      case AppThemeMode.dark:
        return ref.tr('theme_dark');
    }
  }
  
  String _getThemeDescription(WidgetRef ref, AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.system:
        return ref.tr('theme_system_desc');
      case AppThemeMode.light:
        return ref.tr('theme_light_desc');
      case AppThemeMode.dark:
        return ref.tr('theme_dark_desc');
    }
  }
  
  Widget _buildPreviewCard(BuildContext context, WidgetRef ref, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkCard : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.primaryOrange.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.shopping_bag_rounded,
                  color: AppColors.primaryOrange,
                  size: 28,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ref.tr('sample_product'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.darkText : AppColors.lightText,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '450 ${ref.tr('afn')}',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryOrange,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: Colors.red,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryOrange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(ref.tr('add_to_cart')),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
