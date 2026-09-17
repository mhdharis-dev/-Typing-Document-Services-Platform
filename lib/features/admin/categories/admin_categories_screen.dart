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
import '../../../data/models/category_model.dart';

class AdminCategoriesScreen extends ConsumerWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/categories',
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
                    Text('Service Categories CMS', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage main service grouping taxons', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                AppButton(
                  text: 'Add Category',
                  icon: Icons.add_rounded,
                  onPressed: () => _showCategoryDialog(context, ref, null),
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
                      DataColumn(label: Text('Category Name')),
                      DataColumn(label: Text('Description')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: categories.map((cat) {
                      return DataRow(
                        cells: [
                          DataCell(Text(cat.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                          DataCell(Text(cat.description, style: AppTextStyles.bodySmall)),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: cat.status == 'Active' ? AppColors.successLight : AppColors.borderLight,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                cat.status,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: cat.status == 'Active' ? AppColors.success : AppColors.textSecondary,
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
                                  onPressed: () => _showCategoryDialog(context, ref, cat),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                  onPressed: () {
                                    ref.read(categoriesProvider.notifier).deleteCategory(cat.id);
                                  },
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

  void _showCategoryDialog(BuildContext context, WidgetRef ref, CategoryModel? existing) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final descCtrl = TextEditingController(text: existing?.description ?? '');
    String status = existing?.status ?? 'Active';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Category' : 'Edit Category'),
        content: SizedBox(
          width: 450,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  label: 'Category Name',
                  controller: nameCtrl,
                  validator: (val) => AppValidators.requiredValidator(val, 'Category Name'),
                ),
                const SizedBox(height: 16),
                AppTextField(
                  label: 'Description',
                  controller: descCtrl,
                  maxLines: 2,
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
                final category = CategoryModel(
                  id: existing?.id ?? 'cat_${DateTime.now().millisecondsSinceEpoch}',
                  name: nameCtrl.text.trim(),
                  description: descCtrl.text.trim(),
                  status: status,
                );
                if (existing == null) {
                  ref.read(categoriesProvider.notifier).addCategory(category);
                } else {
                  ref.read(categoriesProvider.notifier).updateCategory(category);
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
