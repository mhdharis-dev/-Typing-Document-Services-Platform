import 'package:flutter/material.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

class ServicePlatformApp extends StatelessWidget {
  const ServicePlatformApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Apex Typing & Document Services',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: AppRouter.router,
    );
  }
}
