import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class QuickFeeCalculator extends StatefulWidget {
  const QuickFeeCalculator({super.key});

  @override
  State<QuickFeeCalculator> createState() => _QuickFeeCalculatorState();
}

class _QuickFeeCalculatorState extends State<QuickFeeCalculator> {
  String _selectedService = 'Golden Visa Assistance';
  String _processingSpeed = 'Standard (3-5 Days)';
  bool _needLegalAttestation = true;

  final Map<String, double> _basePrices = {
    'Golden Visa Assistance': 3500.0,
    'Legal Translation (Arabic/English)': 150.0,
    'Family Residency Visa': 1800.0,
    'MOFA Certificate Attestation': 350.0,
    'DED Business License Setup': 4500.0,
    'Amer & Tasheel Typing Services': 250.0,
  };

  double get _estimatedTotal {
    double base = _basePrices[_selectedService] ?? 500.0;
    if (_processingSpeed == 'Urgent Express (24 Hours)') {
      base += 300.0;
    } else if (_processingSpeed == 'VIP Same Day (6 Hours)') {
      base += 600.0;
    }
    if (_needLegalAttestation) {
      base += 150.0;
    }
    return base;
  }

  String get _estimatedTime {
    if (_processingSpeed == 'VIP Same Day (6 Hours)') return '6 Hours Express';
    if (_processingSpeed == 'Urgent Express (24 Hours)') return '24 Hours';
    return '3 - 5 Business Days';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calculate_rounded, color: AppColors.primary, size: 24),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Instant Service Cost & Time Estimator', style: AppTextStyles.h3),
                    const SizedBox(height: 2),
                    Text(
                      'Calculate estimated fees & processing duration in real-time',
                      style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Divider(color: AppColors.borderLight),
          const SizedBox(height: 16),
          Text('Select Service Type', style: AppTextStyles.subtitle2),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            initialValue: _selectedService,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
            items: _basePrices.keys.map((service) {
              return DropdownMenuItem(
                value: service,
                child: Text(service, style: AppTextStyles.bodyMedium),
              );
            }).toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedService = val);
            },
          ),
          const SizedBox(height: 16),
          Text('Processing Speed', style: AppTextStyles.subtitle2),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              'Standard (3-5 Days)',
              'Urgent Express (24 Hours)',
              'VIP Same Day (6 Hours)',
            ].map((speed) {
              final isSelected = _processingSpeed == speed;
              return ChoiceChip(
                label: Text(speed),
                selected: isSelected,
                selectedColor: AppColors.primaryLight,
                backgroundColor: AppColors.background,
                labelStyle: TextStyle(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                ),
                onSelected: (selected) {
                  if (selected) setState(() => _processingSpeed = speed);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            title: Text('Include Certified Ministry Attestation (+AED 150)', style: AppTextStyles.bodyMedium),
            value: _needLegalAttestation,
            activeColor: AppColors.primary,
            onChanged: (val) => setState(() => _needLegalAttestation = val ?? false),
            controlAffinity: ListTileControlAffinity.leading,
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryLight.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Estimated Total Fee', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    Text(
                      'AED ${_estimatedTotal.toStringAsFixed(0)}',
                      style: AppTextStyles.h2.copyWith(color: AppColors.primaryDark),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('Est. Completion', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                    Row(
                      children: [
                        const Icon(Icons.bolt_rounded, size: 16, color: AppColors.goldAccent),
                        const SizedBox(width: 4),
                        Text(_estimatedTime, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.go('/request-service'),
              icon: const Icon(Icons.arrow_forward_rounded, size: 18),
              label: const Text('Proceed & Submit Request'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 16),
                backgroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
