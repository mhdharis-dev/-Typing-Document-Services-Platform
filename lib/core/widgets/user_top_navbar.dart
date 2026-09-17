import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_logo.dart';

class UserTopNavbar extends StatelessWidget implements PreferredSizeWidget {
  final String currentPath;

  const UserTopNavbar({
    super.key,
    required this.currentPath,
  });

  @override
  Size get preferredSize => const Size.fromHeight(65);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Row(
        children: [
          InkWell(
            onTap: () => context.go('/home'),
            child: const AppLogo(),
          ),
          const Spacer(),
          _NavItem(
            label: 'Home',
            isSelected: currentPath == '/home' || currentPath == '/',
            onTap: () => context.go('/home'),
          ),
          _NavItem(
            label: 'Services',
            isSelected: currentPath.startsWith('/services'),
            onTap: () => context.go('/services'),
          ),
          _NavItem(
            label: 'My Requests',
            isSelected: currentPath.startsWith('/requests'),
            onTap: () => context.go('/requests'),
          ),
          _NavItem(
            label: 'About',
            isSelected: currentPath == '/about',
            onTap: () => context.go('/about'),
          ),
          _NavItem(
            label: 'Contact',
            isSelected: currentPath == '/contact',
            onTap: () => context.go('/contact'),
          ),
          const SizedBox(width: 24),
          IconButton(
            icon: const Icon(Icons.notifications_none_rounded, color: AppColors.textPrimary),
            tooltip: 'Notifications',
            onPressed: () => context.go('/notifications'),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => context.go('/profile'),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: currentPath == '/profile'
                    ? AppColors.primaryLight
                    : AppColors.background,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: currentPath == '/profile'
                      ? AppColors.primary
                      : AppColors.border,
                ),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: AppColors.primary,
                    child: Icon(Icons.person, size: 14, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Profile',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          // Admin Switch Button
          OutlinedButton.icon(
            onPressed: () => context.go('/admin/dashboard'),
            icon: const Icon(Icons.admin_panel_settings_outlined, size: 16),
            label: const Text('Admin Portal'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(6),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: isSelected ? AppColors.primary : AppColors.textPrimary,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                height: 2,
                width: isSelected ? 20 : 0,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
