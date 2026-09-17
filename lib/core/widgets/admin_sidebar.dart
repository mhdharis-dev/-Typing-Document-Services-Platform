import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import 'app_logo.dart';

class AdminSidebar extends StatelessWidget {
  final String currentPath;

  const AdminSidebar({
    super.key,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: Column(
        children: [
          Container(
            height: 65,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: const BoxDecoration(
              border: Border(
                bottom: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: AppLogo(iconSize: 22),
                  ),
                ),
                const SizedBox(width: 6),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.primaryDark,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'ADMIN',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              children: [
                _buildSidebarItem(
                  context,
                  icon: Icons.dashboard_rounded,
                  label: 'Dashboard',
                  path: '/admin/dashboard',
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('BUSINESS'),
                _buildSidebarItem(
                  context,
                  icon: Icons.grid_view_rounded,
                  label: 'Services',
                  path: '/admin/services',
                ),
                _buildSidebarItem(
                  context,
                  icon: Icons.category_rounded,
                  label: 'Categories',
                  path: '/admin/categories',
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('MANAGEMENT'),
                _buildSidebarItem(
                  context,
                  icon: Icons.people_alt_rounded,
                  label: 'Customers',
                  path: '/admin/customers',
                ),
                _buildSidebarItem(
                  context,
                  icon: Icons.assignment_turned_in_rounded,
                  label: 'Service Requests',
                  path: '/admin/requests',
                ),
                _buildSidebarItem(
                  context,
                  icon: Icons.folder_shared_rounded,
                  label: 'Documents',
                  path: '/admin/documents',
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('CONTENT & CMS'),
                _buildSidebarItem(
                  context,
                  icon: Icons.rate_review_rounded,
                  label: 'Testimonials',
                  path: '/admin/testimonials',
                ),
                _buildSidebarItem(
                  context,
                  icon: Icons.quiz_rounded,
                  label: 'FAQ Management',
                  path: '/admin/faq',
                ),
                _buildSidebarItem(
                  context,
                  icon: Icons.article_rounded,
                  label: 'Blog / Articles',
                  path: '/admin/blog',
                ),
                const SizedBox(height: 16),
                _buildSectionHeader('SYSTEM'),
                _buildSidebarItem(
                  context,
                  icon: Icons.settings_rounded,
                  label: 'Business Settings',
                  path: '/admin/settings',
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.border, width: 1),
              ),
            ),
            child: OutlinedButton.icon(
              onPressed: () => context.go('/home'),
              icon: const Icon(Icons.storefront_rounded, size: 16),
              label: const Text('Customer View'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40),
                side: const BorderSide(color: AppColors.border),
                foregroundColor: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 12, bottom: 8, top: 4),
      child: Text(
        title,
        style: AppTextStyles.label.copyWith(
          fontSize: 10,
          letterSpacing: 1.0,
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String path,
  }) {
    final isSelected = currentPath == path || currentPath.startsWith('$path/');

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: InkWell(
        onTap: () => context.go(path),
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryLight : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
              if (isSelected)
                Container(
                  width: 6,
                  height: 6,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
