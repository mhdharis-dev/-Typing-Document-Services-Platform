import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/app_search_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/mock/mock_repositories.dart';
import '../../../data/models/request_model.dart';

class AdminRequestsScreen extends ConsumerStatefulWidget {
  const AdminRequestsScreen({super.key});

  @override
  ConsumerState<AdminRequestsScreen> createState() => _AdminRequestsScreenState();
}

class _AdminRequestsScreenState extends ConsumerState<AdminRequestsScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<String> _filters = [
    'All',
    'Submitted',
    'Reviewing',
    'Documents Required',
    'Processing',
    'Completed',
    'Cancelled',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(requestsProvider);

    List<RequestModel> filtered = requests;

    if (_selectedFilter != 'All') {
      filtered = filtered.where((r) => r.status.toLowerCase() == _selectedFilter.toLowerCase()).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((r) =>
          r.id.toLowerCase().contains(query) ||
          r.customerName.toLowerCase().contains(query) ||
          r.serviceName.toLowerCase().contains(query) ||
          r.customerPhone.contains(query)).toList();
    }

    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/requests',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Service Request Management', style: AppTextStyles.h1),
            const SizedBox(height: 4),
            Text('Review, update status, and manage client application filings', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
            const SizedBox(height: 24),

            Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppSearchField(
                      controller: _searchController,
                      hintText: 'Search requests by ID, Customer Name, Service, or Phone...',
                      onChanged: (_) => setState(() {}),
                    ),
                    const SizedBox(height: 16),

                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _filters.map((f) {
                          final isSelected = _selectedFilter == f;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: FilterChip(
                              label: Text(f),
                              selected: isSelected,
                              selectedColor: AppColors.primaryLight,
                              onSelected: (_) => setState(() => _selectedFilter = f),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    if (isDesktop)
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: WidgetStateProperty.all(AppColors.background),
                          columns: const [
                            DataColumn(label: Text('Request ID')),
                            DataColumn(label: Text('Customer Name')),
                            DataColumn(label: Text('Service')),
                            DataColumn(label: Text('Submitted Date')),
                            DataColumn(label: Text('Status')),
                            DataColumn(label: Text('Actions')),
                          ],
                          rows: filtered.map((req) {
                            return DataRow(
                              cells: [
                                DataCell(SizedBox(width: 120, child: Text(req.id, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis))),
                                DataCell(SizedBox(width: 160, child: Text(req.customerName, style: AppTextStyles.bodyMedium, maxLines: 1, overflow: TextOverflow.ellipsis))),
                                DataCell(SizedBox(width: 180, child: Text(req.serviceName, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis))),
                                DataCell(Text(DateFormat('MMM dd, yyyy').format(req.submittedAt), style: AppTextStyles.bodySmall)),
                                DataCell(StatusChip(status: req.status)),
                                DataCell(
                                  IconButton(
                                    icon: const Icon(Icons.arrow_forward_rounded, size: 18, color: AppColors.primary),
                                    onPressed: () => context.go('/admin/requests/${req.id}'),
                                  ),
                                ),
                              ],
                            );
                          }).toList(),
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: filtered.length,
                        separatorBuilder: (context, index) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final req = filtered[index];
                          return Card(
                            elevation: 0,
                            color: AppColors.background,
                            child: ListTile(
                              title: Text('${req.id} - ${req.customerName}', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                              subtitle: Text('${req.serviceName}\nSubmitted: ${DateFormat('MMM dd').format(req.submittedAt)}'),
                              trailing: StatusChip(status: req.status),
                              onTap: () => context.go('/admin/requests/${req.id}'),
                            ),
                          );
                        },
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
