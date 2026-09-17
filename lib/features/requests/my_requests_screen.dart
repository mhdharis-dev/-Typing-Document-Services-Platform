import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../core/widgets/status_chip.dart';
import '../../data/mock/mock_repositories.dart';
import '../../data/models/request_model.dart';

class MyRequestsScreen extends ConsumerStatefulWidget {
  const MyRequestsScreen({super.key});

  @override
  ConsumerState<MyRequestsScreen> createState() => _MyRequestsScreenState();
}

class _MyRequestsScreenState extends ConsumerState<MyRequestsScreen> {
  String _selectedStatusFilter = 'All';

  final List<String> _statuses = [
    'All',
    'Submitted',
    'Reviewing',
    'Documents Required',
    'Processing',
    'Completed',
    'Cancelled',
  ];

  @override
  Widget build(BuildContext context) {
    final requests = ref.watch(requestsProvider);

    final filteredRequests = _selectedStatusFilter == 'All'
        ? requests
        : requests.where((r) => r.status.toLowerCase() == _selectedStatusFilter.toLowerCase()).toList();

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('My Service Requests', style: AppTextStyles.h1),
                        const SizedBox(height: 4),
                        Text(
                          'Track progress and status of your active application submissions.',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                    AppButton(
                      text: 'New Request',
                      icon: Icons.add_rounded,
                      onPressed: () => context.go('/services'),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Status Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _statuses.map((st) {
                      final isSelected = _selectedStatusFilter == st;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: FilterChip(
                          label: Text(st),
                          selected: isSelected,
                          selectedColor: AppColors.primaryLight,
                          onSelected: (_) {
                            setState(() {
                              _selectedStatusFilter = st;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 24),

                // Requests List
                if (filteredRequests.isEmpty)
                  EmptyState(
                    title: 'No Requests Found',
                    description: _selectedStatusFilter == 'All'
                        ? 'You haven\'t submitted any service requests yet.'
                        : 'No requests match status filter "$_selectedStatusFilter".',
                    actionLabel: 'Explore Services',
                    onAction: () => context.go('/services'),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: filteredRequests.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      final req = filteredRequests[index];
                      return _buildRequestCard(context, req);
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRequestCard(BuildContext context, RequestModel request) {
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        request.id,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryDark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      request.categoryName,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
                StatusChip(status: request.status),
              ],
            ),
            const SizedBox(height: 12),
            Text(request.serviceName, style: AppTextStyles.h3),
            const SizedBox(height: 8),
            Text(
              request.message,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.access_time_rounded, size: 16, color: AppColors.textSecondary),
                    const SizedBox(width: 6),
                    Text(
                      'Submitted: ${DateFormat('MMM dd, yyyy').format(request.submittedAt)}',
                      style: AppTextStyles.bodySmall,
                    ),
                  ],
                ),
                TextButton.icon(
                  onPressed: () => context.go('/requests/${request.id}'),
                  icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                  label: const Text('View Details'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
