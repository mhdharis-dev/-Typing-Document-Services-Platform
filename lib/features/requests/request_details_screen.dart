import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_repositories.dart';

class RequestDetailsScreen extends ConsumerWidget {
  final String requestId;

  const RequestDetailsScreen({
    super.key,
    required this.requestId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestsProvider);
    final req = requests.cast<dynamic>().firstWhere(
          (r) => r.id == requestId,
          orElse: () => null,
        );

    if (req == null) {
      return CustomerShellLayout(
        currentPath: '/requests',
        child: EmptyState(
          title: 'Request Not Found',
          description: 'Could not find details for Request ID: $requestId',
          actionLabel: 'Back to My Requests',
          onAction: () => context.go('/requests'),
        ),
      );
    }

    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/requests',
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
                TextButton.icon(
                  onPressed: () => context.go('/requests'),
                  icon: const Icon(Icons.arrow_back_rounded, size: 18),
                  label: const Text('Back to My Requests'),
                ),
                const SizedBox(height: 16),

                // Request Title Header
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(req.id, style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 20)),
                            StatusChip(status: req.status),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(req.serviceName, style: AppTextStyles.h2),
                        const SizedBox(height: 4),
                        Text(
                          'Category: ${req.categoryName} • Submitted on ${DateFormat('MMM dd, yyyy - hh:mm a').format(req.submittedAt)}',
                          style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Visual Timeline Progress Section
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Application Progress Timeline', style: AppTextStyles.h3),
                        const SizedBox(height: 20),
                        ...List.generate(req.timeline.length, (index) {
                          final step = req.timeline[index];
                          final isLast = index == req.timeline.length - 1;

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                children: [
                                  Container(
                                    width: 24,
                                    height: 24,
                                    decoration: BoxDecoration(
                                      color: step.isCompleted ? AppColors.primary : AppColors.borderLight,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: step.isCompleted ? AppColors.primary : AppColors.border,
                                      ),
                                    ),
                                    child: Icon(
                                      step.isCompleted ? Icons.check_rounded : Icons.circle_outlined,
                                      size: 14,
                                      color: step.isCompleted ? Colors.white : AppColors.textSecondary,
                                    ),
                                  ),
                                  if (!isLast)
                                    Container(
                                      width: 2,
                                      height: 40,
                                      color: step.isCompleted ? AppColors.primary : AppColors.border,
                                    ),
                                ],
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      step.title,
                                      style: AppTextStyles.bodyMedium.copyWith(
                                        fontWeight: step.isCompleted ? FontWeight.bold : FontWeight.w500,
                                        color: step.isCompleted ? AppColors.textPrimary : AppColors.textSecondary,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      step.description,
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                                    ),
                                    if (step.timestamp != null) ...[
                                      const SizedBox(height: 4),
                                      Text(
                                        DateFormat('MMM dd, hh:mm a').format(step.timestamp!),
                                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10, color: AppColors.primary),
                                      ),
                                    ],
                                    const SizedBox(height: 16),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Customer Information & Submission Details
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
                              Text('Customer Information', style: AppTextStyles.h3),
                              const Divider(height: 24),
                              _buildInfoItem('Customer Name', req.customerName),
                              _buildInfoItem('Email Address', req.customerEmail),
                              _buildInfoItem('Phone Number', req.customerPhone),
                              _buildInfoItem('Preferred Contact', req.preferredContact),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Documents & Notes Section
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Submitted Notes & Documents', style: AppTextStyles.h3),
                        const SizedBox(height: 12),
                        Text(
                          req.message,
                          style: AppTextStyles.bodyMedium.copyWith(height: 1.5),
                        ),
                        const Divider(height: 24),
                        Text('Attached Files (${req.documents.length})', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 12),
                        if (req.documents.isEmpty)
                          Text('No document files attached.', style: AppTextStyles.bodySmall)
                        else
                          ...req.documents.map((doc) => Container(
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: AppColors.background,
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AppColors.border),
                                ),
                                child: Row(
                                  children: [
                                    const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 24),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(doc.fileName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                          Text('${doc.fileType} • ${doc.fileSize}', style: AppTextStyles.bodySmall),
                                        ],
                                      ),
                                    ),
                                    StatusChip(status: doc.status),
                                  ],
                                ),
                              )),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
