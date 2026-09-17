import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../data/mock/mock_repositories.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifications = ref.watch(notificationsProvider);
    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/notifications',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 64 : 16,
          vertical: 32,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Notifications Hub', style: AppTextStyles.h1),
                    if (notifications.isNotEmpty)
                      Row(
                        children: [
                          TextButton(
                            onPressed: () {
                              ref.read(notificationsProvider.notifier).markAllAsRead();
                            },
                            child: const Text('Mark All Read'),
                          ),
                          TextButton(
                            onPressed: () {
                              ref.read(notificationsProvider.notifier).clearAll();
                            },
                            child: Text('Clear All', style: TextStyle(color: AppColors.error)),
                          ),
                        ],
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                if (notifications.isEmpty)
                  EmptyState(
                    title: 'No Notifications',
                    description: 'You have no active notification alerts at this time.',
                    icon: Icons.notifications_none_rounded,
                    actionLabel: 'Back to Home',
                    onAction: () => context.go('/home'),
                  )
                else
                  ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notifications.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return Card(
                        elevation: 0,
                        color: notif.isRead ? AppColors.surface : AppColors.primaryLight.withAlpha(50),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          leading: CircleAvatar(
                            backgroundColor: notif.isRead ? AppColors.borderLight : AppColors.primaryLight,
                            child: Icon(
                              notif.type == 'request'
                                  ? Icons.assignment_rounded
                                  : Icons.notifications_rounded,
                              color: notif.isRead ? AppColors.textSecondary : AppColors.primary,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            notif.title,
                            style: AppTextStyles.h3.copyWith(
                              fontSize: 16,
                              fontWeight: notif.isRead ? FontWeight.w500 : FontWeight.bold,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(notif.message, style: AppTextStyles.bodyMedium),
                              const SizedBox(height: 6),
                              Text(
                                DateFormat('MMM dd, yyyy - hh:mm a').format(notif.timestamp),
                                style: AppTextStyles.bodySmall.copyWith(fontSize: 11),
                              ),
                            ],
                          ),
                          onTap: () {
                            ref.read(notificationsProvider.notifier).markAsRead(notif.id);
                            if (notif.relatedRequestId != null) {
                              context.go('/requests/${notif.relatedRequestId}');
                            }
                          },
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
