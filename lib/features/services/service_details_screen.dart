import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../data/mock/mock_repositories.dart';
import '../../data/models/service_model.dart';

class ServiceDetailsScreen extends ConsumerStatefulWidget {
  final String serviceId;

  const ServiceDetailsScreen({
    super.key,
    required this.serviceId,
  });

  @override
  ConsumerState<ServiceDetailsScreen> createState() => _ServiceDetailsScreenState();
}

class _ServiceDetailsScreenState extends ConsumerState<ServiceDetailsScreen> {
  int _pageCount = 2;
  String _selectedLanguagePair = 'English -> Arabic (MoJ Official)';
  String _selectedDeliverySpeed = 'Standard (24 Hours)';
  bool _includeMOFA = true;

  double get _calculatedFee {
    double perPage = 75.0;
    if (_selectedLanguagePair.contains('French') || _selectedLanguagePair.contains('German')) {
      perPage = 100.0;
    }
    double total = perPage * _pageCount;
    if (_selectedDeliverySpeed.contains('Express')) {
      total += 50.0;
    }
    if (_includeMOFA) {
      total += 150.0;
    }
    return total;
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);
    final service = services.cast<ServiceModel?>().firstWhere(
          (s) => s?.id == widget.serviceId,
          orElse: () => null,
        );

    if (service == null) {
      return CustomerShellLayout(
        currentPath: '/services',
        child: EmptyState(
          title: 'Service Not Found',
          description: 'The requested service could not be located.',
          actionLabel: 'Back to Services',
          onAction: () => context.go('/services'),
        ),
      );
    }

    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/services',
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Top Breadcrumb
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 12),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Row(
                    children: [
                      InkWell(onTap: () => context.go('/home'), child: Text('Home', style: AppTextStyles.caption)),
                      const Text('  /  ', style: TextStyle(color: AppColors.textMuted)),
                      InkWell(onTap: () => context.go('/services'), child: Text('Services', style: AppTextStyles.caption)),
                      const Text('  /  ', style: TextStyle(color: AppColors.textMuted)),
                      Text(service.name, style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      if (isDesktop)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(12)),
                          child: Text('MoJ & ICP Accredited Agency', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                        ),
                    ],
                  ),
                ),
              ),
            ),

            // Service Title Header Banner
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 32),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(10)),
                            child: const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 24),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(service.name, style: AppTextStyles.h1.copyWith(fontSize: 20)),
                                const SizedBox(height: 4),
                                Text(
                                  service.shortDescription,
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildHighlightBadge(Icons.verified_rounded, 'Certified Sworn Quality'),
                          _buildHighlightBadge(Icons.payments_outlined, 'Starting AED ${service.price.toStringAsFixed(0)}'),
                          _buildHighlightBadge(Icons.timer_outlined, 'Turnaround: ${service.estimatedTime}'),
                          _buildHighlightBadge(Icons.shield_outlined, '100% Govt Acceptance'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Content Area + Sticky Summary Card Layout
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 32),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Details Content Area
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Overview Section
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Service Description & Compliance', style: AppTextStyles.h3),
                                  const SizedBox(height: 12),
                                  Text(
                                    'Under UAE Federal Law, official documents submitted to government departments, Dubai Courts, immigration, or free zone authorities require legal translation certified by Ministry of Justice (MoJ) licensed sworn translators.',
                                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
                                  ),
                                  const SizedBox(height: 20),
                                  Wrap(
                                    spacing: 16,
                                    runSpacing: 16,
                                    children: const [
                                      _FeatureCheckTile(title: 'MoJ Sworn Stamp & Seal', subtitle: 'Every page bears the official Ministry of Justice stamp.'),
                                      _FeatureCheckTile(title: 'Judicial Department Compliance', subtitle: 'Fully accepted by Dubai Courts, Abu Dhabi Courts, and Notary.'),
                                      _FeatureCheckTile(title: 'Physical & Digital Copies', subtitle: 'Receive high-res signed PDF plus stamped physical hardcopy.'),
                                      _FeatureCheckTile(title: '24h Express Delivery', subtitle: 'Same-day courier dispatch across Dubai, Abu Dhabi, and Sharjah.'),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Required Documents Checklist Section
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Required Input Documents', style: AppTextStyles.h3),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                                        child: Text('${service.requirements.length} Required', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  ...service.requirements.map((req) => Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: Container(
                                      padding: const EdgeInsets.all(12),
                                      decoration: BoxDecoration(color: AppColors.successLight.withValues(alpha: 0.4), borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.success.withValues(alpha: 0.2))),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                                          const SizedBox(width: 12),
                                          Expanded(child: Text(req, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600))),
                                        ],
                                      ),
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Live Fee & Turnaround Calculator
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.primary.withValues(alpha: 0.3))),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.calculate_rounded, color: AppColors.primary, size: 22),
                                      const SizedBox(width: 10),
                                      Text('Live Fee & Turnaround Calculator', style: AppTextStyles.h3),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text('Select your official target language, page count, and delivery speed to view calculated fees.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                  const SizedBox(height: 20),

                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Language Pair', style: AppTextStyles.subtitle2),
                                            const SizedBox(height: 6),
                                            DropdownButtonFormField<String>(
                                              initialValue: _selectedLanguagePair,
                                              decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                                              items: const [
                                                DropdownMenuItem(value: 'English -> Arabic (MoJ Official)', child: Text('English -> Arabic (MoJ Official)')),
                                                DropdownMenuItem(value: 'Arabic -> English (MoJ Official)', child: Text('Arabic -> English (MoJ Official)')),
                                                DropdownMenuItem(value: 'French -> Arabic', child: Text('French -> Arabic')),
                                                DropdownMenuItem(value: 'German -> Arabic', child: Text('German -> Arabic')),
                                              ],
                                              onChanged: (val) {
                                                if (val != null) setState(() => _selectedLanguagePair = val);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Number of Pages', style: AppTextStyles.subtitle2),
                                          const SizedBox(height: 6),
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                IconButton(onPressed: _pageCount > 1 ? () => setState(() => _pageCount--) : null, icon: const Icon(Icons.remove_rounded, size: 18)),
                                                Text('$_pageCount', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                                IconButton(onPressed: () => setState(() => _pageCount++), icon: const Icon(Icons.add_rounded, size: 18)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  Text('Delivery Speed', style: AppTextStyles.subtitle2),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: ChoiceChip(
                                          label: const Center(child: Text('Standard (24 Hours)')),
                                          selected: _selectedDeliverySpeed == 'Standard (24 Hours)',
                                          selectedColor: AppColors.primaryLight,
                                          onSelected: (_) => setState(() => _selectedDeliverySpeed = 'Standard (24 Hours)'),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ChoiceChip(
                                          label: const Center(child: Text('Express (4 Hours Priority)')),
                                          selected: _selectedDeliverySpeed == 'Express (4 Hours Priority)',
                                          selectedColor: AppColors.primaryLight,
                                          onSelected: (_) => setState(() => _selectedDeliverySpeed = 'Express (4 Hours Priority)'),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),

                                  CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Include MOFA Ministry Attestation Stamp (+AED 150)', style: AppTextStyles.bodyMedium),
                                    value: _includeMOFA,
                                    activeColor: AppColors.primary,
                                    onChanged: (val) => setState(() => _includeMOFA = val ?? false),
                                    controlAffinity: ListTileControlAffinity.leading,
                                  ),
                                  const SizedBox(height: 16),

                                  Container(
                                    padding: const EdgeInsets.all(16),
                                    decoration: BoxDecoration(color: AppColors.primaryLight.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(10)),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Calculated Service Fee', style: AppTextStyles.caption),
                                            Text('AED ${_calculatedFee.toStringAsFixed(0)}', style: AppTextStyles.h2.copyWith(color: AppColors.primaryDark)),
                                          ],
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () => context.go('/request-service?serviceId=${service.id}'),
                                          icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                                          label: const Text('Initiate Request'),
                                          style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 4-Step Process Section
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('4-Step MoJ Legal Translation Process', style: AppTextStyles.h3),
                                  const SizedBox(height: 16),
                                  _buildProcessStepTile('1', 'Digital Upload & Document Review', 'Submit your original document via secure upload or WhatsApp for pre-scrutiny.'),
                                  _buildProcessStepTile('2', 'Legal Linguistic Review & Sworn Verification', 'Sworn MoJ translator performs sworn legal translation abiding by UAE judicial terminology.'),
                                  _buildProcessStepTile('3', 'Official Seal, Stamp Legislation & QR Verification', 'Certified manuscript receives official MoJ stamp, translator accreditation badge, and QR code.'),
                                  _buildProcessStepTile('4', 'Instant PDF Delivery + UAE Courier Handover', 'Receive high-res signed PDF via email + original stamped hardcopies delivered to your doorstep.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Sticky Right Sidebar Summary Box (Desktop)
                      if (isDesktop) ...[
                        const SizedBox(width: 32),
                        SizedBox(
                          width: 340,
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: AppColors.border),
                                  boxShadow: [
                                    BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4)),
                                  ],
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text('Starting From', style: AppTextStyles.caption),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                                          child: Text('Government Rate', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 6),
                                    Text('AED ${service.price.toStringAsFixed(0)}', style: AppTextStyles.h1.copyWith(fontSize: 20, color: AppColors.primaryDark)),
                                    Text('per official page / document', style: AppTextStyles.caption),
                                    const Divider(height: 24),

                                    _buildCheckBullet('Ministry of Justice Certified Stamp'),
                                    _buildCheckBullet('Accepted by all UAE Courts & Freezones'),
                                    _buildCheckBullet('Express Same-Day Courier Delivery'),
                                    _buildCheckBullet('Zero Rejection SLA Guarantee'),
                                    const SizedBox(height: 20),

                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () => context.go('/request-service?serviceId=${service.id}'),
                                        icon: const Icon(Icons.assignment_turned_in_rounded, size: 18),
                                        label: const Text('Request This Service'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primary,
                                          padding: const EdgeInsets.symmetric(vertical: 16),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),

                                    SizedBox(
                                      width: double.infinity,
                                      child: OutlinedButton.icon(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Opening WhatsApp Desk (+971 4 200 8899)...'), backgroundColor: AppColors.success),
                                          );
                                        },
                                        icon: const Icon(Icons.chat_bubble_rounded, size: 18, color: Color(0xFF25D366)),
                                        label: const Text('WhatsApp PRO Desk'),
                                        style: OutlinedButton.styleFrom(
                                          foregroundColor: AppColors.textPrimary,
                                          side: const BorderSide(color: Color(0xFF25D366)),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Direct Call Helpline Box
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.phone_in_talk_rounded, color: AppColors.primary, size: 20),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Need Instant Support?', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                                            Text('+971 4 200 8899', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w900, color: AppColors.primaryDark)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHighlightBadge(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: AppColors.primary),
          const SizedBox(width: 6),
          Text(text, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
        ],
      ),
    );
  }

  Widget _buildCheckBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(Icons.check_circle_rounded, size: 16, color: AppColors.success),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary))),
        ],
      ),
    );
  }

  Widget _buildProcessStepTile(String step, String title, String desc) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.primary,
            child: Text(step, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(desc, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: const Color(0xFF0F1B19),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: Center(
        child: Text('© 2026 SanadDocs Typing & PRO Services LLC. All Rights Reserved.', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
      ),
    );
  }
}

class _FeatureCheckTile extends StatelessWidget {
  final String title;
  final String subtitle;

  const _FeatureCheckTile({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.verified_user_rounded, color: AppColors.primary, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 11, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
