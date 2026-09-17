import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';

class UserBottomNavbar extends StatelessWidget {
  final String currentPath;

  const UserBottomNavbar({
    super.key,
    required this.currentPath,
  });

  int _getSelectedIndex() {
    if (currentPath == '/home' || currentPath == '/') return 0;
    if (currentPath.startsWith('/services')) return 1;
    if (currentPath.startsWith('/requests')) return 2;
    if (currentPath.startsWith('/notifications')) return 3;
    if (currentPath.startsWith('/profile')) return 4;
    return 0;
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
              context.go('/home');
              break;
            case 1:
              context.go('/services');
              break;
            case 2:
              context.go('/requests');
              break;
            case 3:
              context.go('/notifications');
              break;
            case 4:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_outlined),
            activeIcon: Icon(Icons.grid_view_rounded),
            label: 'Services',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment_rounded),
            label: 'Requests',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none_rounded),
            activeIcon: Icon(Icons.notifications_rounded),
            label: 'Alerts',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
