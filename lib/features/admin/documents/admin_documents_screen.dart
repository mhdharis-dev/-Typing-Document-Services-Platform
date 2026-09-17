import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/mock/mock_repositories.dart';

class AdminDocumentsScreen extends ConsumerWidget {
  const AdminDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(requestsProvider);

    // Aggregate all documents across all requests
    final allDocuments = <Map<String, dynamic>>[];
    for (final req in requests) {
      for (final doc in req.documents) {
        allDocuments.add({
          'doc': doc,
          'requestId': req.id,
          'customerName': req.customerName,
        });
      }
    }

    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/documents',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Document Vault & Review', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Inspect customer attached passport scans, degrees, and legal files', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(AppColors.background),
                    columns: const [
                      DataColumn(label: Text('Document File Name')),
                      DataColumn(label: Text('Customer')),
                      DataColumn(label: Text('Request ID')),
                      DataColumn(label: Text('Type / Size')),
                      DataColumn(label: Text('Upload Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: allDocuments.map((item) {
                      final doc = item['doc'];
                      return DataRow(
                        cells: [
                          DataCell(
                            Row(
                              children: [
                                const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 18),
                                const SizedBox(width: 8),
                                Text(doc.fileName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          DataCell(Text(item['customerName'], style: AppTextStyles.bodyMedium)),
                          DataCell(Text(item['requestId'], style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold))),
                          DataCell(Text('${doc.fileType} (${doc.fileSize})', style: AppTextStyles.bodySmall)),
                          DataCell(Text(DateFormat('MMM dd, yyyy').format(doc.uploadedAt), style: AppTextStyles.bodySmall)),
                          DataCell(StatusChip(status: doc.status)),
                          DataCell(
                            OutlinedButton.icon(
                              onPressed: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('Mock Inspect/Download: ${doc.fileName}')),
                                );
                              },
                              icon: const Icon(Icons.download_rounded, size: 14),
                              label: const Text('Download'),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
