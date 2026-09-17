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
import '../../../data/models/testimonial_model.dart';

class AdminTestimonialsScreen extends ConsumerWidget {
  const AdminTestimonialsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final testimonials = ref.watch(testimonialsProvider);
    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/testimonials',
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
                    Text('Testimonials Management', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Moderate customer reviews and feedback displayed on website', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                AppButton(
                  text: 'Add Testimonial',
                  icon: Icons.add_rounded,
                  onPressed: () => _showTestimonialDialog(context, ref, null),
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
                      DataColumn(label: Text('Customer Name')),
                      DataColumn(label: Text('Role / Title')),
                      DataColumn(label: Text('Review Text')),
                      DataColumn(label: Text('Rating')),
                      DataColumn(label: Text('Status')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: testimonials.map((t) {
                      return DataRow(
                        cells: [
                          DataCell(Text(t.customerName, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                          DataCell(Text(t.customerRole, style: AppTextStyles.bodySmall)),
                          DataCell(Text(t.review, style: AppTextStyles.bodySmall, maxLines: 2, overflow: TextOverflow.ellipsis)),
                          DataCell(Row(children: [const Icon(Icons.star_rounded, color: AppColors.warning, size: 16), Text(' ${t.rating}')])),
                          DataCell(
                            Switch(
                              value: t.isEnabled,
                              onChanged: (_) => ref.read(testimonialsProvider.notifier).toggleTestimonialStatus(t.id),
                            ),
                          ),
                          DataCell(
                            Row(
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 18, color: AppColors.primary),
                                  onPressed: () => _showTestimonialDialog(context, ref, t),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                  onPressed: () => ref.read(testimonialsProvider.notifier).deleteTestimonial(t.id),
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

  void _showTestimonialDialog(BuildContext context, WidgetRef ref, TestimonialModel? existing) {
    final formKey = GlobalKey<FormState>();
    final nameCtrl = TextEditingController(text: existing?.customerName ?? '');
    final roleCtrl = TextEditingController(text: existing?.customerRole ?? '');
    final reviewCtrl = TextEditingController(text: existing?.review ?? '');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(existing == null ? 'Add Testimonial' : 'Edit Testimonial'),
        content: SizedBox(
          width: 480,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(
                  label: 'Customer Name',
                  controller: nameCtrl,
                  validator: (val) => AppValidators.nameValidator(val, 'Customer Name'),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Role / Designation',
                  controller: roleCtrl,
                  validator: (val) => AppValidators.requiredValidator(val, 'Role'),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Review Text',
                  controller: reviewCtrl,
                  maxLines: 3,
                  validator: (val) => AppValidators.messageValidator(val, minLength: 10),
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
                final model = TestimonialModel(
                  id: existing?.id ?? 't_${DateTime.now().millisecondsSinceEpoch}',
                  customerName: nameCtrl.text.trim(),
                  customerRole: roleCtrl.text.trim(),
                  review: reviewCtrl.text.trim(),
                  rating: 5.0,
                  isEnabled: existing?.isEnabled ?? true,
                );
                if (existing == null) {
                  ref.read(testimonialsProvider.notifier).addTestimonial(model);
                } else {
                  ref.read(testimonialsProvider.notifier).updateTestimonial(model);
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
