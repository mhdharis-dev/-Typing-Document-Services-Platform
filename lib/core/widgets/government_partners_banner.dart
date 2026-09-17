import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class GovernmentPartnersBanner extends StatelessWidget {
  const GovernmentPartnersBanner({super.key});

  final List<Map<String, String>> _partners = const [
    {'name': 'Amer Centre', 'subtitle': 'Visa & Residency Processing', 'icon': 'verified_user'},
    {'name': 'Tasheel', 'subtitle': 'Labour & Employment Typing', 'icon': 'work_outline'},
    {'name': 'GDRFA Dubai', 'subtitle': 'Immigration Services', 'icon': 'badge'},
    {'name': 'MOFA UAE', 'subtitle': 'Ministry Attestation', 'icon': 'gavel'},
    {'name': 'DED Licensing', 'subtitle': 'Economic Department', 'icon': 'domain'},
    {'name': 'Dubai Courts', 'subtitle': 'Legal Translation Typing', 'icon': 'description'},
  ];

  IconData _getPartnerIcon(String name) {
    switch (name) {
      case 'verified_user':
        return Icons.verified_user_rounded;
      case 'work_outline':
        return Icons.work_history_rounded;
      case 'badge':
        return Icons.card_membership_rounded;
      case 'gavel':
        return Icons.gavel_rounded;
      case 'domain':
        return Icons.business_rounded;
      default:
        return Icons.description_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 2,
                    width: 36,
                    color: AppColors.goldAccent,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'OFFICIAL UAE GOVERNMENT SERVICE PROVIDER & TYPING AGENT',
                    style: AppTextStyles.caption.copyWith(
                      letterSpacing: 1.5,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(width: 12),
                  Container(
                    height: 2,
                    width: 36,
                    color: AppColors.goldAccent,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 16,
                runSpacing: 16,
                children: _partners.map((p) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(_getPartnerIcon(p['icon']!), size: 22, color: AppColors.primary),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p['name']!,
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              p['subtitle']!,
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
