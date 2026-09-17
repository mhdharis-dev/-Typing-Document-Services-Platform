import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/mock/mock_repositories.dart';

class AdminRequestDetailsScreen extends ConsumerStatefulWidget {
  final String requestId;

  const AdminRequestDetailsScreen({
    super.key,
    required this.requestId,
  });

  @override
  ConsumerState<AdminRequestDetailsScreen> createState() => _AdminRequestDetailsScreenState();
}

class _AdminRequestDetailsScreenState extends ConsumerState<AdminRequestDetailsScreen> {
  final TextEditingController _noteController = TextEditingController();

  final List<String> _statusOptions = [
    'Submitted',
    'Reviewing',
    'Documents Required',
    'Processing',
    'Completed',
    'Cancelled',
  ];

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(requestsProvider);
    final req = requests.cast<dynamic>().firstWhere(
          (r) => r.id == widget.requestId,
          orElse: () => null,
        );

    if (req == null) {
      return AdminShellLayout(
        currentPath: '/admin/requests',
        child: EmptyState(
          title: 'Request Not Found',
          description: 'Request ID ${widget.requestId} does not exist.',
          actionLabel: 'Back to Requests',
          onAction: () => context.go('/admin/requests'),
        ),
      );
    }

    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/requests',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextButton.icon(
              onPressed: () => context.go('/admin/requests'),
              icon: const Icon(Icons.arrow_back_rounded, size: 18),
              label: const Text('Back to Requests'),
            ),
            const SizedBox(height: 16),

            // Header Banner
            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(req.id, style: AppTextStyles.h1.copyWith(color: AppColors.primary, fontSize: 20)),
                              const SizedBox(width: 12),
                              StatusChip(status: req.status),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(req.serviceName, style: AppTextStyles.h2.copyWith(fontSize: 20)),
                          Text('Category: ${req.categoryName} • Submitted ${DateFormat('MMM dd, yyyy').format(req.submittedAt)}', style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),

                    // Admin Action Status Change Dropdown
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.primary),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Update Request Status', style: AppTextStyles.label.copyWith(color: AppColors.primaryDark, fontSize: 10)),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _statusOptions.contains(req.status) ? req.status : _statusOptions.first,
                              isDense: true,
                              style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                              items: _statusOptions.map((st) {
                                return DropdownMenuItem<String>(
                                  value: st,
                                  child: Text(st),
                                );
                              }).toList(),
                              onChanged: (newStatus) {
                                if (newStatus != null) {
                                  ref.read(requestsProvider.notifier).updateRequestStatus(req.id, newStatus);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Status updated to "$newStatus".')),
                                  );
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Content Grid
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      // Customer Info & Notes
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Customer Contact Details', style: AppTextStyles.h3),
                              const Divider(height: 24),
                              _buildRow('Customer Name', req.customerName),
                              _buildRow('Email', req.customerEmail),
                              _buildRow('Phone', req.customerPhone),
                              _buildRow('Preferred Contact', req.preferredContact),
                              const SizedBox(height: 16),
                              Text('Customer Message / Request Note:', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 4),
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(8)),
                                child: Text(req.message, style: AppTextStyles.bodyMedium),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Document Attachments
                      Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Submitted Documents (${req.documents.length})', style: AppTextStyles.h3),
                              const SizedBox(height: 12),
                              if (req.documents.isEmpty)
                                Text('No documents uploaded.', style: AppTextStyles.bodySmall)
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
                                                Text('${doc.fileType} • ${doc.fileSize} • Uploaded ${DateFormat('MMM dd').format(doc.uploadedAt)}', style: AppTextStyles.bodySmall),
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
                const SizedBox(width: 24),

                // Internal Notes Log Card
                Expanded(
                  flex: 2,
                  child: Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Internal Officer Notes', style: AppTextStyles.h3),
                          const SizedBox(height: 4),
                          Text('Private log visible only to admin team', style: AppTextStyles.bodySmall),
                          const Divider(height: 24),

                          AppTextField(
                            label: 'Add Internal Note',
                            hint: 'Type officer note or reference tracking...',
                            controller: _noteController,
                            maxLines: 2,
                          ),
                          const SizedBox(height: 10),
                          AppButton(
                            text: 'Add Note',
                            type: AppButtonType.secondary,
                            onPressed: () {
                              final text = _noteController.text.trim();
                              if (text.isNotEmpty) {
                                ref.read(requestsProvider.notifier).addInternalNote(req.id, 'Admin Officer', text);
                                _noteController.clear();
                              }
                            },
                          ),
                          const SizedBox(height: 20),

                          if (req.internalNotes.isEmpty)
                            Text('No internal notes recorded yet.', style: AppTextStyles.bodySmall)
                          else
                            ...req.internalNotes.map((note) => Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryLight.withAlpha(60),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.primary.withAlpha(50)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(note.author, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                                          Text(DateFormat('MMM dd, hh:mm a').format(note.createdAt), style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                                        ],
                                      ),
                                      const SizedBox(height: 4),
                                      Text(note.note, style: AppTextStyles.bodySmall),
                                    ],
                                  ),
                                )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall),
          Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
