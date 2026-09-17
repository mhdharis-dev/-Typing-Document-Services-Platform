import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';

class AdminBottomNavbar extends StatelessWidget {
  final String currentPath;

  const AdminBottomNavbar({
    super.key,
    required this.currentPath,
  });

  int _getSelectedIndex() {
    if (currentPath.startsWith('/admin/dashboard')) return 0;
    if (currentPath.startsWith('/admin/requests')) return 1;
    if (currentPath.startsWith('/admin/services')) return 2;
    return 3; // More screen or other modules
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getSelectedIndex();

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border, width: 1),
        ),
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          switch (index) {
            case 0:
              context.go('/admin/dashboard');
              break;
            case 1:
              context.go('/admin/requests');
              break;
            case 2:
              context.go('/admin/services');
              break;
            case 3:
              _showAdminMoreMenu(context);
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard_rounded),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz_rounded),
            activeIcon: Icon(Icons.more_horiz_rounded),
            label: 'More',
          ),
        ],
      ),
    );
  }

  void _showAdminMoreMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Admin Modules',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 16),
              ListTile(
                leading: const Icon(Icons.category_rounded, color: AppColors.primary),
                title: const Text('Categories'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/categories');
                },
              ),
              ListTile(
                leading: const Icon(Icons.people_alt_rounded, color: AppColors.primary),
                title: const Text('Customers'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/customers');
                },
              ),
              ListTile(
                leading: const Icon(Icons.folder_shared_rounded, color: AppColors.primary),
                title: const Text('Documents'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/documents');
                },
              ),
              ListTile(
                leading: const Icon(Icons.rate_review_rounded, color: AppColors.primary),
                title: const Text('Testimonials'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/testimonials');
                },
              ),
              ListTile(
                leading: const Icon(Icons.quiz_rounded, color: AppColors.primary),
                title: const Text('FAQ Management'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/faq');
                },
              ),
              ListTile(
                leading: const Icon(Icons.article_rounded, color: AppColors.primary),
                title: const Text('Blog CMS'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/blog');
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings_rounded, color: AppColors.primary),
                title: const Text('Settings'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/settings');
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.storefront_rounded, color: AppColors.textSecondary),
                title: const Text('Switch to Customer Portal'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/home');
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
