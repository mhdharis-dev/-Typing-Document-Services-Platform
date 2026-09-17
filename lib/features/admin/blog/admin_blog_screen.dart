import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/validators/app_validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../data/mock/mock_repositories.dart';
import '../../../data/models/blog_model.dart';

class AdminBlogScreen extends ConsumerWidget {
  const AdminBlogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final blogPosts = ref.watch(blogProvider);
    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/blog',
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
                    Text('Blog & Articles CMS', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Publish regulatory updates and service guidance articles', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                AppButton(
                  text: 'New Article',
                  icon: Icons.add_rounded,
                  onPressed: () => _showArticleDialog(context, ref, null),
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
                      DataColumn(label: Text('Article Title')),
                      DataColumn(label: Text('Category')),
                      DataColumn(label: Text('Author')),
                      DataColumn(label: Text('Publish Date')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: blogPosts.map((b) {
                      return DataRow(
                        cells: [
                          DataCell(Text(b.title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                          DataCell(Text(b.category, style: AppTextStyles.bodySmall)),
                          DataCell(Text(b.author, style: AppTextStyles.bodySmall)),
                          DataCell(Text(DateFormat('MMM dd, yyyy').format(b.publishDate), style: AppTextStyles.bodySmall)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: b.status == 'Published' ? AppColors.successLight : AppColors.borderLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                b.status,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: b.status == 'Published' ? AppColors.success : AppColors.textSecondary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 18, color: AppColors.primary),
                                  onPressed: () => _showArticleDialog(context, ref, b),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.published_with_changes_rounded, size: 18, color: AppColors.info),
                                  tooltip: 'Toggle Status',
                                  onPressed: () => ref.read(blogProvider.notifier).toggleArticleStatus(b.id),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                  onPressed: () => ref.read(blogProvider.notifier).deleteArticle(b.id),
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

  void _showArticleDialog(BuildContext context, WidgetRef ref, BlogModel? existing) {
    final formKey = GlobalKey<FormState>();
    final titleCtrl = TextEditingController(text: existing?.title ?? '');
    final shortCtrl = TextEditingController(text: existing?.shortDescription ?? '');
    final contentCtrl = TextEditingController(text: existing?.content ?? '');
    final catCtrl = TextEditingController(text: existing?.category ?? 'Visa & Legal');
    final authorCtrl = TextEditingController(text: existing?.author ?? 'Admin Editorial');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Create Article' : 'Edit Article'),
        content: SizedBox(
          width: 550,
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppTextField(
                    label: 'Article Title',
                    controller: titleCtrl,
                    validator: (val) => AppValidators.requiredValidator(val, 'Title'),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          label: 'Category',
                          controller: catCtrl,
                          validator: (val) => AppValidators.requiredValidator(val, 'Category'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppTextField(
                          label: 'Author',
                          controller: authorCtrl,
                          validator: (val) => AppValidators.requiredValidator(val, 'Author'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Short Preview Summary',
                    controller: shortCtrl,
                    validator: AppValidators.descriptionValidator,
                  ),
                  const SizedBox(height: 12),
                  AppTextField(
                    label: 'Full Article Content',
                    controller: contentCtrl,
                    maxLines: 5,
                    validator: (val) => AppValidators.messageValidator(val, minLength: 20),
                  ),
                ],
              ),
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
                final article = BlogModel(
                  id: existing?.id ?? 'blog_${DateTime.now().millisecondsSinceEpoch}',
                  title: titleCtrl.text.trim(),
                  shortDescription: shortCtrl.text.trim(),
                  content: contentCtrl.text.trim(),
                  category: catCtrl.text.trim(),
                  author: authorCtrl.text.trim(),
                  publishDate: existing?.publishDate ?? DateTime.now(),
                  status: existing?.status ?? 'Published',
                );
                if (existing == null) {
                  ref.read(blogProvider.notifier).addArticle(article);
                } else {
                  ref.read(blogProvider.notifier).updateArticle(article);
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
