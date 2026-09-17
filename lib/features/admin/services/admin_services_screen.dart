import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../data/mock/mock_repositories.dart';
import '../../../data/models/service_model.dart';

class AdminServicesScreen extends ConsumerStatefulWidget {
  const AdminServicesScreen({super.key});

  @override
  ConsumerState<AdminServicesScreen> createState() => _AdminServicesScreenState();
}

class _AdminServicesScreenState extends ConsumerState<AdminServicesScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final services = ref.watch(servicesProvider);

    final query = _searchController.text.trim().toLowerCase();
    final filtered = services.where((s) =>
        s.name.toLowerCase().contains(query) ||
        s.categoryName.toLowerCase().contains(query)).toList();

    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/services',
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
                    Text('Service Catalog Management', style: AppTextStyles.h1),
                    const SizedBox(height: 4),
                    Text('Manage active typing, translation, visa and PRO offerings', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  ],
                ),
                AppButton(
                  text: 'Add New Service',
                  icon: Icons.add_rounded,
                  onPressed: () => context.go('/admin/services/create'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AppSearchField(
                      controller: _searchController,
                      hintText: 'Search service catalog...',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.background),
                        columns: const [
                          DataColumn(label: Text('Service Name')),
                          DataColumn(label: Text('Category')),
                          DataColumn(label: Text('Turnaround')),
                          DataColumn(label: Text('Price')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: filtered.map((srv) {
                          return DataRow(
                            cells: [
                              DataCell(Text(srv.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                              DataCell(Text(srv.categoryName, style: AppTextStyles.bodySmall)),
                              DataCell(Text(srv.estimatedTime, style: AppTextStyles.bodySmall)),
                              DataCell(Text('${srv.price.toStringAsFixed(0)} AED', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold))),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: srv.isActive ? AppColors.successLight : AppColors.borderLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    srv.isActive ? 'Active' : 'Inactive',
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: srv.isActive ? AppColors.success : AppColors.textSecondary,
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
                                      tooltip: 'Edit',
                                      onPressed: () => context.go('/admin/services/${srv.id}/edit'),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                      tooltip: 'Delete',
                                      onPressed: () => _confirmDelete(srv),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(ServiceModel service) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Service?'),
        content: Text('Are you sure you want to remove "${service.name}" from catalog?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () {
              ref.read(servicesProvider.notifier).deleteService(service.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Service deleted successfully.')),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
