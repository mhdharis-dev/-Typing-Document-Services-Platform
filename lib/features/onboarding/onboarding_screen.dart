import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_logo.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<_OnboardingPageData> _pages = const [
    _OnboardingPageData(
      title: 'Discover Professional Services',
      description:
          'Access a comprehensive suite of UAE typing, legal translation, visa processing, and business assistance services.',
      icon: Icons.search_rounded,
    ),
    _OnboardingPageData(
      title: 'Submit Your Request Online',
      description:
          'Easily request services, upload required document copies, and select your preferred communication channel.',
      icon: Icons.assignment_outlined,
    ),
    _OnboardingPageData(
      title: 'Real-Time Request Tracking',
      description:
          'Follow step-by-step progress from government portal submission to final residency or document delivery.',
      icon: Icons.track_changes_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const AppLogo(iconSize: 22),
                  if (_currentIndex < _pages.length - 1)
                    TextButton(
                      onPressed: () => context.go('/home'),
                      child: Text(
                        'Skip',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _pages.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  final page = _pages[index];
                  return Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 140,
                          height: 140,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryLight,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            page.icon,
                            size: 64,
                            color: AppColors.primary,
                          ),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: AppTextStyles.h1.copyWith(fontSize: 20),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          page.description,
                          style: AppTextStyles.bodyLarge.copyWith(
                            color: AppColors.textSecondary,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _pages.length,
                      (index) => Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: _currentIndex == index ? 24 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentIndex == index
                              ? AppColors.primary
                              : AppColors.border,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    isFullWidth: true,
                    text: _currentIndex == _pages.length - 1
                        ? 'Get Started'
                        : 'Next',
                    icon: _currentIndex == _pages.length - 1
                        ? Icons.arrow_forward_rounded
                        : null,
                    onPressed: () {
                      if (_currentIndex < _pages.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      } else {
                        context.go('/home');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OnboardingPageData {
  final String title;
  final String description;
  final IconData icon;

  const _OnboardingPageData({
    required this.title,
    required this.description,
    required this.icon,
  });
}
