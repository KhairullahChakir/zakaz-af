import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/core/utils/responsive.dart';

import '../data/onboarding_provider.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingContent> _contents = [
    OnboardingContent(
      title: 'Shop from Local Stores',
      description: 'Discover thousands of products from local Afghan shopkeepers, delivered to your doorstep.',
      image: 'assets/images/intro_1.png',
    ),
    OnboardingContent(
      title: 'Fast Delivery',
      description: 'Get your orders delivered quickly and reliably to your home or office anywhere in the city.',
      image: 'assets/images/intro_2.png',
    ),
    OnboardingContent(
      title: 'Secure Payments',
      description: 'Pay safely with cash on delivery or integrated secure payment options.',
      image: 'assets/images/intro_3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Force Light Mode colors for Onboarding to blend with images
    const kBackgroundColor = Colors.white;
    const kTextColor = Color(0xFF1A1A1A);
    const kSubTextColor = Color(0xFF757575);
    const kPrimaryOrange = Color(0xFFFF6B00);

    final isTablet = Responsive.isTablet(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    
    // Use Row layout for Tablets in Landscape or very wide screens
    final useSideBySide = isTablet && isLandscape;

    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: useSideBySide
            ? _buildTabletLayout(kTextColor, kSubTextColor, kPrimaryOrange)
            : _buildMobileLayout(kTextColor, kSubTextColor, kPrimaryOrange),
      ),
    );
  }

  // --- Mobile / Portrait Layout (Vertical) ---
  Widget _buildMobileLayout(Color textColor, Color subTextColor, Color primaryColor) {
    return Column(
      children: [
        Expanded(
          flex: 3,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemCount: _contents.length,
            itemBuilder: (context, index) {
              final content = _contents[index];
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        alignment: Alignment.center,
                        child: Image.asset(
                          content.image,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => _errorIcon(),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      content.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      content.description,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: subTextColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        _buildBottomControls(primaryColor, isTablet: false),
      ],
    );
  }

  // --- Tablet / Landscape Layout (Horizontal Row) ---
  Widget _buildTabletLayout(Color textColor, Color subTextColor, Color primaryColor) {
    return Row(
      children: [
        // Left Side: Image
        Expanded(
          flex: 5, // 50% width
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (value) => setState(() => _currentPage = value),
            itemCount: _contents.length,
            physics: const ClampingScrollPhysics(), // Image snaps instantly
            itemBuilder: (context, index) {
              return Container(
                padding: const EdgeInsets.all(48),
                alignment: Alignment.center,
                child: Image.asset(
                  _contents[index].image,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) => _errorIcon(),
                ),
              );
            },
          ),
        ),
        // Right Side: Content & Controls
        Expanded(
          flex: 4, // 40% width
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                // Title
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _contents[_currentPage].title,
                    key: ValueKey<String>(_contents[_currentPage].title),
                    style: TextStyle(
                      fontSize: 42, // Larger font for tablet
                      fontWeight: FontWeight.bold,
                      color: textColor,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Description
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    _contents[_currentPage].description,
                    key: ValueKey<String>(_contents[_currentPage].description),
                    style: TextStyle(
                      fontSize: 20, // Larger font for tablet
                      color: subTextColor,
                      height: 1.6,
                    ),
                  ),
                ),
                const Spacer(),
                // Indicators & Button
                _buildBottomControls(primaryColor, isTablet: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomControls(Color primaryColor, {required bool isTablet}) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 0 : 24, 
        vertical: isTablet ? 0 : 32
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Wrap content
        children: [
          // Dots Indicator
          Row(
            mainAxisAlignment: isTablet ? MainAxisAlignment.start : MainAxisAlignment.center,
            children: List.generate(
              _contents.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 8),
                height: 8,
                width: _currentPage == index ? 24 : 8,
                decoration: BoxDecoration(
                  color: _currentPage == index ? primaryColor : Colors.grey[300],
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),
          SizedBox(height: isTablet ? 48 : 32),
          // Button
          SizedBox(
            width: isTablet ? 200 : double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                if (_currentPage == _contents.length - 1) {
                  _finishOnboarding();
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: Text(
                _currentPage == _contents.length - 1 ? 'Get Started' : 'Next',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          if (!isTablet) const SizedBox(height: 16), // Extra bottom padding for mobile
        ],
      ),
    );
  }

  Widget _errorIcon() {
    return Icon(
      Icons.image_not_supported,
      size: 100,
      color: Colors.grey[300],
    );
  }

  void _finishOnboarding() {
    ref.read(onboardingControllerProvider.notifier).completeOnboarding();
    context.go('/login');
  }
}

class OnboardingContent {
  final String title;
  final String description;
  final String image;

  OnboardingContent({
    required this.title,
    required this.description,
    required this.image,
  });
}
