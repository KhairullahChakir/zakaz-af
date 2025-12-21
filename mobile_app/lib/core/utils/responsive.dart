import 'package:flutter/material.dart';

/// Responsive utility class for adaptive layouts
class Responsive {
  static double screenWidth(BuildContext context) => MediaQuery.of(context).size.width;
  static double screenHeight(BuildContext context) => MediaQuery.of(context).size.height;
  
  /// Check device type
  static bool isMobile(BuildContext context) => screenWidth(context) < 600;
  static bool isTablet(BuildContext context) => screenWidth(context) >= 600 && screenWidth(context) < 900;
  static bool isDesktop(BuildContext context) => screenWidth(context) >= 900;
  
  /// Get responsive value based on screen size
  static T value<T>(BuildContext context, {
    required T mobile,
    T? tablet,
    T? desktop,
  }) {
    if (isDesktop(context)) return desktop ?? tablet ?? mobile;
    if (isTablet(context)) return tablet ?? mobile;
    return mobile;
  }
  
  /// Get responsive grid columns
  static int gridColumns(BuildContext context) {
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }
  
  /// Get responsive padding
  static EdgeInsets padding(BuildContext context) {
    return EdgeInsets.all(value(context, mobile: 16.0, tablet: 24.0, desktop: 32.0));
  }
  
  /// Get responsive horizontal padding
  static EdgeInsets horizontalPadding(BuildContext context) {
    return EdgeInsets.symmetric(
      horizontal: value(context, mobile: 16.0, tablet: 24.0, desktop: 48.0),
    );
  }
  
  /// Get responsive font size multiplier
  static double fontScale(BuildContext context) {
    return value(context, mobile: 1.0, tablet: 1.1, desktop: 1.2);
  }
  
  /// Get responsive card aspect ratio
  static double productCardRatio(BuildContext context) {
    return value(context, mobile: 0.7, tablet: 0.75, desktop: 0.8);
  }
  
  /// Get responsive banner height
  static double bannerHeight(BuildContext context) {
    return value(context, mobile: 160.0, tablet: 200.0, desktop: 250.0);
  }
  
  /// Get responsive featured product card width
  static double featuredCardWidth(BuildContext context) {
    return value(context, mobile: 150.0, tablet: 180.0, desktop: 220.0);
  }
  
  /// Get responsive category card size
  static double categoryCardSize(BuildContext context) {
    return value(context, mobile: 75.0, tablet: 90.0, desktop: 100.0);
  }
  
  /// Get max content width for large screens
  static double maxContentWidth(BuildContext context) {
    final width = screenWidth(context);
    if (width > 1200) return 1200;
    return width;
  }
  
  /// Wrap content with max width constraint
  static Widget constrainedContent(BuildContext context, {required Widget child}) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxContentWidth(context)),
        child: child,
      ),
    );
  }
}

/// Extension for responsive text styles
extension ResponsiveTextStyle on TextStyle {
  TextStyle responsive(BuildContext context) {
    final scale = Responsive.fontScale(context);
    return copyWith(fontSize: (fontSize ?? 14) * scale);
  }
}
