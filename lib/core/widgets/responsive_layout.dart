import 'package:flutter/material.dart';
import '../utils/responsive.dart';
import 'user_top_navbar.dart';
import 'user_bottom_navbar.dart';
import 'admin_sidebar.dart';
import 'admin_bottom_navbar.dart';

import 'floating_whatsapp_widget.dart';

class CustomerShellLayout extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const CustomerShellLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      appBar: isDesktop ? UserTopNavbar(currentPath: currentPath) : null,
      body: Stack(
        children: [
          child,
          const FloatingWhatsappWidget(),
        ],
      ),
      bottomNavigationBar: isDesktop ? null : UserBottomNavbar(currentPath: currentPath),
    );
  }
}

class AdminShellLayout extends StatelessWidget {
  final Widget child;
  final String currentPath;

  const AdminShellLayout({
    super.key,
    required this.child,
    required this.currentPath,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    if (isDesktop) {
      return Scaffold(
        body: Row(
          children: [
            AdminSidebar(currentPath: currentPath),
            Expanded(
              child: child,
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: AdminBottomNavbar(currentPath: currentPath),
    );
  }
}
