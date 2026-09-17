import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../data/mock/mock_repositories.dart';

class AdminCustomersScreen extends ConsumerStatefulWidget {
  const AdminCustomersScreen({super.key});

  @override
  ConsumerState<AdminCustomersScreen> createState() => _AdminCustomersScreenState();
}

class _AdminCustomersScreenState extends ConsumerState<AdminCustomersScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider);
    final query = _searchController.text.trim().toLowerCase();

    final filtered = customers.where((c) =>
        c.name.toLowerCase().contains(query) ||
        c.email.toLowerCase().contains(query) ||
        c.phone.contains(query)).toList();

    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/customers',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Registered Customer Directory', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Manage client profiles, contact data, and active account access', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    AppSearchField(
                      controller: _searchController,
                      hintText: 'Search customers by name, email, or phone...',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 20),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        headingRowColor: WidgetStateProperty.all(AppColors.background),
                        columns: const [
                          DataColumn(label: Text('Customer Name')),
                          DataColumn(label: Text('Email')),
                          DataColumn(label: Text('Phone')),
                          DataColumn(label: Text('Total Requests')),
                          DataColumn(label: Text('Joined Date')),
                          DataColumn(label: Text('Status')),
                          DataColumn(label: Text('Actions')),
                        ],
                        rows: filtered.map((c) {
                          return DataRow(
                            cells: [
                              DataCell(Text(c.name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                              DataCell(Text(c.email, style: AppTextStyles.bodySmall)),
                              DataCell(Text(c.phone, style: AppTextStyles.bodySmall)),
                              DataCell(Text('${c.requestCount}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold))),
                              DataCell(Text(DateFormat('MMM dd, yyyy').format(c.joinedDate), style: AppTextStyles.bodySmall)),
                              DataCell(
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: c.status == 'Active' ? AppColors.successLight : AppColors.errorLight,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    c.status,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: c.status == 'Active' ? AppColors.success : AppColors.error,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              DataCell(
                                OutlinedButton(
                                  onPressed: () {
                                    ref.read(customersProvider.notifier).toggleCustomerStatus(c.id);
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  ),
                                  child: Text(c.status == 'Active' ? 'Disable' : 'Activate'),
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
}
