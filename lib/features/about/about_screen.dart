import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/responsive_layout.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/about',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 64 : 16,
          vertical: 32,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1000),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Text('About Apex Services', style: AppTextStyles.h1),
                const SizedBox(height: 8),
                Text(
                  'Your premier partner for typing, legal translation, document attestation, and corporate PRO services in the UAE.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),

                // Introduction Banner
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Company Overview', style: AppTextStyles.h2),
                      const SizedBox(height: 12),
                      Text(
                        'Founded in Dubai, Apex Typing & Document Services provides streamlined, transparent, and court-approved government assistance services for individuals, investors, families, and corporations across the UAE. We bridge the gap between government portals and your business requirements.',
                        style: AppTextStyles.bodyLarge.copyWith(height: 1.6),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Mission & Vision Cards
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                                child: const Icon(Icons.flag_rounded, color: AppColors.primary),
                              ),
                              const SizedBox(height: 16),
                              Text('Our Mission', style: AppTextStyles.h3),
                              const SizedBox(height: 8),
                              Text(
                                'To simplify complex government procedures, legal translations, and residency paperwork through digital-first ease and error-free execution.',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                decoration: const BoxDecoration(color: AppColors.primaryLight, shape: BoxShape.circle),
                                child: const Icon(Icons.visibility_rounded, color: AppColors.primary),
                              ),
                              const SizedBox(height: 16),
                              Text('Our Vision', style: AppTextStyles.h3),
                              const SizedBox(height: 8),
                              Text(
                                'To be the most trusted and tech-enabled service business management platform in the Middle East, empowering fast-track corporate expansion.',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),

                // Service Highlights
                Text('Platform Service Highlights', style: AppTextStyles.h2),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: const [
                    _HighlightTile(title: 'Ministry Certified', subtitle: 'Approved by UAE Ministry of Justice & Foreign Affairs'),
                    _HighlightTile(title: '99.8% Success Rate', subtitle: 'Error-free typing for GDRFA, Amer & Tasheel'),
                    _HighlightTile(title: 'Express Processing', subtitle: 'Same-day legal translations & urgent visa stamps'),
                    _HighlightTile(title: 'Dedicated PRO Desk', subtitle: 'Dedicated account managers for corporate accounts'),
                  ],
                ),
                const SizedBox(height: 40),

                // CTA
                Center(
                  child: AppButton(
                    text: 'Explore All Services',
                    icon: Icons.arrow_forward_rounded,
                    onPressed: () => context.go('/services'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _HighlightTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _HighlightTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 230,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.star_rounded, color: AppColors.primary, size: 20),
          const SizedBox(height: 8),
          Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
