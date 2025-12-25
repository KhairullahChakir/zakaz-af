import 'package:flutter/material.dart';

/// Extension on BuildContext to easily access theme-aware colors
extension ThemeContextExtensions on BuildContext {
  /// Whether the current theme is dark
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
  
  /// Primary orange color (same for both themes)
  Color get primaryOrange => const Color(0xFFFF6B00);
  
  /// Background color (theme-aware)
  Color get backgroundColor => isDark 
      ? const Color(0xFF121212) 
      : const Color(0xFFFBFBFD);
  
  /// Card/Surface color (theme-aware)
  Color get cardColor => isDark 
      ? const Color(0xFF252525) 
      : Colors.white;
  
  /// Elevated card color (theme-aware)
  Color get cardColorElevated => isDark 
      ? const Color(0xFF2C2C2C) 
      : Colors.white;
  
  /// Primary text color (theme-aware)
  Color get textPrimary => isDark 
      ? const Color(0xFFF5F5F7) 
      : const Color(0xFF1D1D1F);
  
  /// Secondary text color (theme-aware)
  Color get textSecondary => isDark 
      ? const Color(0xFFAAAAAA) 
      : const Color(0xFF6E6E73);
  
  /// Divider color (theme-aware)
  Color get dividerColor => isDark 
      ? const Color(0xFF3A3A3C) 
      : const Color(0xFFE5E5EA);
  
  /// Soft orange (theme-aware)
  Color get softOrange => isDark 
      ? const Color(0xFF3D2A1C) 
      : const Color(0xFFFFF3E6);
  
  /// AppBar background (theme-aware)
  Color get appBarColor => isDark 
      ? const Color(0xFF1E1E1E) 
      : const Color(0xFFFF6B00);
  
  /// AppBar foreground (theme-aware)
  Color get appBarTextColor => isDark 
      ? const Color(0xFFF5F5F7) 
      : Colors.white;
  
  /// Shadow color for cards
  Color get shadowColor => isDark 
      ? Colors.black.withValues(alpha: 0.3)
      : Colors.black.withValues(alpha: 0.05);
  
  /// Input field fill color
  Color get inputFillColor => isDark 
      ? const Color(0xFF252525) 
      : Colors.grey.shade50;
  
  /// Input field border color
  Color get inputBorderColor => isDark 
      ? const Color(0xFF3A3A3C) 
      : Colors.grey.shade200;
}
