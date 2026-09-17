import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_search_field.dart';
import '../../core/widgets/government_partners_banner.dart';
import '../../core/widgets/interactive_card.dart';
import '../../core/widgets/quick_fee_calculator.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../data/mock/mock_repositories.dart';
import '../../data/models/service_model.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final services = ref.watch(servicesProvider);
    final testimonials = ref.watch(testimonialsProvider).where((t) => t.isEnabled).toList();
    final faqs = ref.watch(faqProvider).where((f) => f.isEnabled).toList();
    final popularServices = services.where((s) => s.isPopular && s.isActive).toList();

    return CustomerShellLayout(
      currentPath: '/home',
      child: SingleChildScrollView(
        child: Column(
          children: [
            // 1. Hero Section matching Image 4
            _buildHeroSection(context),

            // 2. Official Government Accreditation Strip
            const GovernmentPartnersBanner(),

            // 3. Search & 8 Popular Categories Grid matching Image 4
            _buildSearchAndCategoriesSection(context, categories),

            // 4. Popular Featured Services Grid
            _buildPopularServicesSection(context, popularServices),

            // 5. Interactive Cost & Fee Estimator Section
            _buildEstimatorSection(context),

            // 6. How SanadDocs Operates (3-Step Pipeline)
            _buildHowItWorksSection(context),

            // 7. Why Choose Us
            _buildWhyChooseUsSection(context),

            // 8. Testimonials
            _buildTestimonialsSection(context, testimonials),

            // 9. FAQ Accordion
            _buildFaqSection(context, faqs),

            // 10. Contact CTA Section
            _buildContactCtaSection(context),

            // Footer
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.heroGradient,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 64 : 20,
        vertical: isDesktop ? 64 : 40,
      ),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Left Content Column
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.verified_rounded, size: 16, color: AppColors.goldAccent),
                          const SizedBox(width: 8),
                          Text(
                            'ACCREDITED GOVERNMENT AGENCY - LICENSE #PRO-2026',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Professional Services,\nMade Simple.',
                      style: AppTextStyles.h1.copyWith(fontSize: 20, color: Colors.white, height: 1.2),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Access certified typing, legal translation, visa processing, Emirates ID, and corporate PRO services across Dubai & Abu Dhabi from one competent platform.',
                      style: AppTextStyles.bodyLarge.copyWith(color: Colors.white.withValues(alpha: 0.9), height: 1.5),
                    ),
                    const SizedBox(height: 28),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () => context.go('/request-service'),
                          icon: const Icon(Icons.add_task_rounded, size: 18),
                          label: const Text('Request a Service'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.goldAccent,
                            foregroundColor: AppColors.textPrimary,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            textStyle: AppTextStyles.button.copyWith(fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        OutlinedButton.icon(
                          onPressed: () => context.go('/services'),
                          icon: const Icon(Icons.explore_rounded, size: 18),
                          label: const Text('Explore All Services'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white, width: 1.5),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Opening WhatsApp Desk (+971 4 200 8899)...'), backgroundColor: AppColors.success),
                            );
                          },
                          icon: const Icon(Icons.chat_bubble_rounded, size: 18),
                          label: const Text('WhatsApp PRO'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF25D366),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 36),
                    // Stats Bar
                    Wrap(
                      spacing: 20,
                      runSpacing: 12,
                      children: [
                        _buildHeroStat('15k+ Completed', 'Zero Rejection Rate'),
                        _buildHeroStat('99.8% Approval', 'Verified Govt Lodgement'),
                        _buildHeroStat('24/7 PRO Support', 'Dedicated Case Specialist'),
                      ],
                    ),
                  ],
                ),
              ),

              // Right Live Tracker Widget Preview (Desktop matching Image 4)
              if (isDesktop) ...[
                const SizedBox(width: 48),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 24, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                              child: const Icon(Icons.badge_rounded, color: AppColors.primary, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Dubai 10-Yr Golden Visa', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                  Text('REQ-2026-8942 • In Test Review', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(12)),
                              child: Text('Under Review', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
                            ),
                          ],
                        ),
                        const Divider(height: 28),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Time Elapsed', style: AppTextStyles.caption),
                                Text('35ms', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Avg. Processing', style: AppTextStyles.caption),
                                Text('3.5 Hrs', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(12)),
                          child: Row(
                            children: [
                              const CircleAvatar(radius: 14, backgroundColor: AppColors.primaryLight, child: Icon(Icons.person_rounded, size: 16, color: AppColors.primary)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Assigned PRO Officer', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                                    Text('Rashid Al-Falasi', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeroStat(String title, String subtitle) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.check_circle_rounded, color: AppColors.goldAccent, size: 16),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppTextStyles.bodySmall.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
            Text(subtitle, style: AppTextStyles.caption.copyWith(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildSearchAndCategoriesSection(BuildContext context, List categories) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSearchField(
                hintText: 'Search typing services (e.g. Golden Visa, Ejari, Attestation, MOFA, Emirates ID)...',
                onChanged: (query) {
                  if (query.trim().isNotEmpty) context.go('/services?q=$query');
                },
              ),
              const SizedBox(height: 32),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(width: 4, height: 16, color: AppColors.primary),
                          const SizedBox(width: 8),
                          Text('GOVERNMENT SERVICE VERTICALS', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.8, color: AppColors.primaryDark)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text('Popular Service Categories', style: AppTextStyles.h2),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => context.go('/services'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('View All Categories'),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // 8 Category Cards Grid matching Image 4
              LayoutBuilder(
                builder: (context, constraints) {
                  int cols = 1;
                  if (constraints.maxWidth > 1024) {
                    cols = 4;
                  } else if (constraints.maxWidth >= 600) {
                    cols = 2;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 1.35,
                    ),
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final cat = categories[index];
                      return InteractiveCard(
                        onTap: () => context.go('/services?category=${cat.id}'),
                        padding: const EdgeInsets.all(16),
                        borderRadius: 14,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                              child: Icon(_getIconData(cat.iconName), color: AppColors.primary, size: 22),
                            ),
                            const SizedBox(height: 10),
                            Text(cat.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold), maxLines: 1, overflow: TextOverflow.ellipsis),
                            const SizedBox(height: 2),
                            Text(cat.description, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11), maxLines: 2, overflow: TextOverflow.ellipsis),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPopularServicesSection(BuildContext context, List<ServiceModel> services) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Featured Government Services', style: AppTextStyles.h2),
                      const SizedBox(height: 4),
                      Text('Transparent agency processing fees with official receipt issuance for statutory fees', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => context.go('/services'),
                    icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                    label: const Text('Browse All Services'),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              LayoutBuilder(
                builder: (context, constraints) {
                  int cols = 2; // Minimum 2 boxes per row
                  if (constraints.maxWidth > 1024) {
                    cols = 3;
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: cols,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      mainAxisExtent: 240, // Fixed height: 240px
                    ),
                    itemCount: services.length,
                    itemBuilder: (context, index) {
                      final srv = services[index];
                      return _buildServiceCard(context, srv);
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildServiceCard(BuildContext context, ServiceModel service) {
    return InteractiveCard(
      onTap: () => context.go('/services/${service.id}'),
      padding: const EdgeInsets.all(14),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(8)),
                    child: Icon(_getIconData(service.iconName), color: AppColors.primary, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(4), border: Border.all(color: AppColors.border)),
                          child: Text(service.categoryName, style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 10)),
                        ),
                        const SizedBox(height: 2),
                        Text(service.name, style: AppTextStyles.h3.copyWith(fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                service.shortDescription,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(Icons.timer_outlined, size: 12, color: AppColors.textSecondary),
                  const SizedBox(width: 4),
                  Text(service.estimatedTime, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary, fontSize: 11)),
                  const Spacer(),
                  Row(
                    children: const [
                      Icon(Icons.star_rounded, size: 14, color: AppColors.goldAccent),
                      SizedBox(width: 2),
                      Text('4.9', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: [
              const Divider(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(service.pricePrefix, style: AppTextStyles.caption.copyWith(fontSize: 9)),
                      Text('AED ${service.price.toStringAsFixed(0)}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w800, color: AppColors.primaryDark)),
                    ],
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/services/${service.id}'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: const Size(60, 30),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('Details', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEstimatorSection(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: const QuickFeeCalculator(),
        ),
      ),
    );
  }

  Widget _buildHowItWorksSection(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              Text('How SanadDocs Operates', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Streamlining in-person typing office passes into a seamless digital verification pipeline', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 36),
              Wrap(
                spacing: 24,
                runSpacing: 24,
                alignment: WrapAlignment.center,
                children: const [
                  _StepCard(number: '01', title: 'Choose Service & Upload', description: 'Select your required typing or PRO service, upload high-res digital scans of your passport, Emirates ID, or certificates.'),
                  _StepCard(number: '02', title: 'PRO Review & Lodgement', description: 'Our accredited PRO team verifies every document before official government submission through GDRFA, MoHRE, MOFA, or MoJ portals.'),
                  _StepCard(number: '03', title: 'Receive Stamped Documents', description: 'Download your approved e-visas, labor contracts, or certified translations right from your portal or via express courier delivery.'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWhyChooseUsSection(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              Text('Why Individuals & Enterprises Rely on SanadDocs', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Guaranteed compliance, speed, and privacy for all your UAE administrative workflows', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 36),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: const [
                  _FeatureCard(icon: Icons.headset_mic_rounded, title: 'Dedicated Multilingual PROs', description: 'Direct phone, email, and WhatsApp access to licensed PRO consultants fluent in Arabic, English, Urdu, Tagalog, and Russian.'),
                  _FeatureCard(icon: Icons.bolt_rounded, title: 'Guaranteed Turnarounds', description: 'Urgent 2-4 hour express options for critical visa cancellations, labor contract amendments, and legal court translation.'),
                  _FeatureCard(icon: Icons.shield_rounded, title: 'Strict Data Privacy', description: 'Client documents and personal records are protected in compliance with UAE Data Protection laws.'),
                  _FeatureCard(icon: Icons.touch_app_rounded, title: 'Zero Hidden Government Charges', description: 'Full breakdown of government portal fees vs agency processing fees prior to dispatch.'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTestimonialsSection(BuildContext context, List testimonials) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              Text('Trusted Across UAE', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Over 15,000 satisfied individuals and enterprises', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 36),
              Wrap(
                spacing: 20,
                runSpacing: 20,
                alignment: WrapAlignment.center,
                children: testimonials.map((t) => InteractiveCard(
                  padding: const EdgeInsets.all(22),
                  borderRadius: 14,
                  child: SizedBox(
                    width: 330,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: List.generate(5, (index) => const Icon(Icons.star_rounded, color: AppColors.warning, size: 18)),
                        ),
                        const SizedBox(height: 14),
                        Text('"${t.review}"', style: AppTextStyles.bodyMedium.copyWith(fontStyle: FontStyle.italic, height: 1.5)),
                        const SizedBox(height: 18),
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: AppColors.primaryLight,
                              radius: 18,
                              child: Text(t.customerName.isNotEmpty ? t.customerName[0] : 'C', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(t.customerName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                Text(t.customerRole, style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqSection(BuildContext context, List faqs) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.background,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 48),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            children: [
              Text('Frequently Asked Questions', style: AppTextStyles.h2, textAlign: TextAlign.center),
              const SizedBox(height: 8),
              Text('Everything you need to know about typing, attestation, and government fees', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary), textAlign: TextAlign.center),
              const SizedBox(height: 28),
              ...faqs.map((faq) => Container(
                margin: const EdgeInsets.only(bottom: 12),
                child: Material(
                  color: AppColors.surface,
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(color: AppColors.border),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ExpansionTile(
                    tilePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    title: Text(faq.question, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                        child: Text(faq.answer, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5)),
                      ),
                    ],
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCtaSection(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
      ),
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 56),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Column(
            children: [
              Text(
                'Need your documents typed and cleared today?',
                style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: isDesktop ? 32 : 24),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                'Speak directly with an accredited PRO consultant or request your service in less than 2 minutes.',
                style: AppTextStyles.bodyLarge.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 16,
                runSpacing: 16,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.go('/request-service'),
                    icon: const Icon(Icons.add_task_rounded),
                    label: const Text('Start Application Online'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: AppColors.primaryDark, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling Helpline: +971 4 200 8899...'), backgroundColor: AppColors.primary),
                      );
                    },
                    icon: const Icon(Icons.phone_rounded),
                    label: const Text('Call +971 4 200 8899'),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF25D366), foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Container(
      color: const Color(0xFF0F1B19),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SanadDocs', style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 6),
                        Text(
                          'Accredited UAE administrative typing, legal translation, attestation, and PRO concierge service. Enabling streamlined personal and corporate government compliance across the Emirates.',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white60, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quick Links', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('Home', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('All Services', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('Track Application', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('Submit Request', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Government Services', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('Amer (GDRFA Visa Services)', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('Tasheel (MoHRE Labor)', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('ICP Emirates ID & Residency', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('MOFA Attestation & Translation', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('© 2026 SanadDocs Administrative & PRO Services LLC. All rights reserved.', style: AppTextStyles.caption.copyWith(color: Colors.white38, fontSize: 11)),
                  Row(
                    children: [
                      Text('Privacy Policy', style: AppTextStyles.caption.copyWith(color: Colors.white38, fontSize: 11)),
                      const SizedBox(width: 16),
                      Text('Terms of Service', style: AppTextStyles.caption.copyWith(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String name) {
    switch (name) {
      case 'keyboard': return Icons.keyboard_rounded;
      case 'translate': case 'g_translate': return Icons.g_translate_rounded;
      case 'card_travel': case 'family_restroom': case 'stars': return Icons.verified_rounded;
      case 'account_balance': case 'assignment': return Icons.assignment_rounded;
      case 'business_center': case 'domain': return Icons.business_rounded;
      case 'verified': case 'verified_user': return Icons.verified_user_rounded;
      default: return Icons.category_rounded;
    }
  }
}

class _StepCard extends StatelessWidget {
  final String number;
  final String title;
  final String description;

  const _StepCard({required this.number, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      padding: const EdgeInsets.all(24),
      borderRadius: 14,
      child: SizedBox(
        width: 340,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
              child: Text(number, style: AppTextStyles.h3.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900)),
            ),
            const SizedBox(height: 16),
            Text(title, style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(description, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.4)),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({required this.icon, required this.title, required this.description});

  @override
  Widget build(BuildContext context) {
    return InteractiveCard(
      padding: const EdgeInsets.all(22),
      borderRadius: 14,
      child: SizedBox(
        width: 260,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: AppColors.primary, size: 24),
            ),
            const SizedBox(height: 14),
            Text(title, style: AppTextStyles.h3.copyWith(fontSize: 16)),
            const SizedBox(height: 6),
            Text(description, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.4)),
          ],
        ),
      ),
    );
  }
}
