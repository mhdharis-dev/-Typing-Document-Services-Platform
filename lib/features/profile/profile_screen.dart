import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../data/mock/mock_repositories.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/profile',
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
                Text('User Account Profile', style: AppTextStyles.h1),
                const SizedBox(height: 24),

                // User Profile Header Card
                Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(28),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primary,
                          child: Text(
                            user.name.substring(0, 1),
                            style: AppTextStyles.h1.copyWith(color: Colors.white, fontSize: 20),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(user.name, style: AppTextStyles.h2),
                              const SizedBox(height: 4),
                              Text(user.email, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                              const SizedBox(height: 4),
                              Text(user.phone, style: AppTextStyles.bodySmall.copyWith(color: AppColors.primary, fontWeight: FontWeight.w600)),
                            ],
                          ),
                        ),
                        AppButton(
                          text: 'Edit Profile',
                          icon: Icons.edit_rounded,
                          type: AppButtonType.outline,
                          onPressed: () => context.go('/profile/edit'),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // Quick Navigation Options
                Card(
                  elevation: 0,
                  child: Column(
                    children: [
                      ListTile(
                        leading: const Icon(Icons.assignment_outlined, color: AppColors.primary),
                        title: const Text('My Service Requests'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.go('/requests'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.notifications_none_rounded, color: AppColors.primary),
                        title: const Text('Notification Preferences'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.go('/notifications'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.help_outline_rounded, color: AppColors.primary),
                        title: const Text('Help & Support'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.go('/contact'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.info_outline_rounded, color: AppColors.primary),
                        title: const Text('About Platform'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.go('/about'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.admin_panel_settings_outlined, color: AppColors.primaryDark),
                        title: const Text('Switch to Admin Portal'),
                        subtitle: const Text('Manage services, requests & documents'),
                        trailing: const Icon(Icons.chevron_right_rounded),
                        onTap: () => context.go('/admin/dashboard'),
                      ),
                      const Divider(),
                      ListTile(
                        leading: const Icon(Icons.logout_rounded, color: AppColors.error),
                        title: Text('Logout Session', style: TextStyle(color: AppColors.error)),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Mock Logout: Session ended successfully.')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
