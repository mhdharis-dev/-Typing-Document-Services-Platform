import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/validators/app_validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../data/mock/mock_repositories.dart';
import '../../../data/models/faq_model.dart';

class AdminFaqScreen extends ConsumerWidget {
  const AdminFaqScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqs = ref.watch(faqProvider);
    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/faq',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('FAQ Management', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage common questions and knowledgebase articles', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                AppButton(
                  text: 'Add FAQ',
                  icon: Icons.add_rounded,
                  onPressed: () => _showFaqDialog(context, ref, null),
                ),
              ],
            ),
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
                      DataColumn(label: Text('Question')),
                      DataColumn(label: Text('Answer')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: faqs.map((f) {
                      return DataRow(
                        cells: [
                          DataCell(Text(f.question, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                          DataCell(Text(f.answer, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis)),
                          DataCell(Text(f.category, style: AppTextStyles.bodySmall)),
                          DataCell(
                            Switch(
                              value: f.isEnabled,
                              onChanged: (_) => ref.read(faqProvider.notifier).toggleFaqStatus(f.id),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 18, color: AppColors.primary),
                                  onPressed: () => _showFaqDialog(context, ref, f),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                  onPressed: () => ref.read(faqProvider.notifier).deleteFaq(f.id),
                                ),
                              ],
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

  void _showFaqDialog(BuildContext context, WidgetRef ref, FaqModel? existing) {
    final formKey = GlobalKey<FormState>();
    final qCtrl = TextEditingController(text: existing?.question ?? '');
    final aCtrl = TextEditingController(text: existing?.answer ?? '');
    final catCtrl = TextEditingController(text: existing?.category ?? 'General');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add FAQ Item' : 'Edit FAQ Item'),
        content: SizedBox(
          width: 480,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  label: 'Question',
                  controller: qCtrl,
                  validator: (val) => AppValidators.requiredValidator(val, 'Question'),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Category',
                  controller: catCtrl,
                  validator: (val) => AppValidators.requiredValidator(val, 'Category'),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Answer',
                  controller: aCtrl,
                  maxLines: 3,
                  validator: AppValidators.descriptionValidator,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final model = FaqModel(
                  id: existing?.id ?? 'faq_${DateTime.now().millisecondsSinceEpoch}',
                  question: qCtrl.text.trim(),
                  answer: aCtrl.text.trim(),
                  category: catCtrl.text.trim(),
                  isEnabled: existing?.isEnabled ?? true,
                );
                if (existing == null) {
                  ref.read(faqProvider.notifier).addFaq(model);
                } else {
                  ref.read(faqProvider.notifier).updateFaq(model);
                }
                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
