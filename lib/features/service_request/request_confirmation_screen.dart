import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_repositories.dart';

class RequestConfirmationScreen extends ConsumerWidget {
  final String requestId;

  const RequestConfirmationScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestsProvider);
    final req = requests.firstWhere(
      (r) => r.id == requestId,
      orElse: () => requests.first,
    );

    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/requests',
      child: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isDesktop ? 48 : 20),
          child: Container(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(36),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: AppColors.successLight,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle_rounded,
                        size: 56,
                        color: AppColors.success,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Request Submitted Successfully!',
                      style: AppTextStyles.h2,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Your request has been registered and is now queued for document verification.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 28),

                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Tracking Request ID', req.id, isBold: true),
                          const Divider(height: 20),
                          _buildDetailRow('Service Requested', req.serviceName),
                          const Divider(height: 20),
                          _buildDetailRow('Submitted Date', DateFormat('MMM dd, yyyy - hh:mm a').format(req.submittedAt)),
                          const Divider(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Current Status', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              StatusChip(status: req.status),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 32),

                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: [
                        AppButton(
                          text: 'View Request Details',
                          icon: Icons.visibility_rounded,
                          onPressed: () => context.go('/requests/${req.id}'),
                        ),
                        AppButton(
                          text: 'Back to Home',
                          type: AppButtonType.outline,
                          onPressed: () => context.go('/home'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            color: isBold ? AppColors.primary : AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
