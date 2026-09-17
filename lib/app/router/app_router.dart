import 'package:go_router/go_router.dart';

import '../../core/widgets/empty_state.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../features/onboarding/onboarding_screen.dart';
import '../../features/home/home_screen.dart';
import '../../features/services/services_screen.dart';
import '../../features/services/service_details_screen.dart';
import '../../features/service_request/request_service_screen.dart';
import '../../features/service_request/request_confirmation_screen.dart';
import '../../features/requests/my_requests_screen.dart';
import '../../features/requests/request_details_screen.dart';
import '../../features/notifications/notifications_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/profile/edit_profile_screen.dart';
import '../../features/about/about_screen.dart';
import '../../features/contact/contact_screen.dart';

import '../../features/admin/dashboard/admin_dashboard_screen.dart';
import '../../features/admin/services/admin_services_screen.dart';
import '../../features/admin/services/admin_service_form_screen.dart';
import '../../features/admin/categories/admin_categories_screen.dart';
import '../../features/admin/customers/admin_customers_screen.dart';
import '../../features/admin/requests/admin_requests_screen.dart';
import '../../features/admin/requests/admin_request_details_screen.dart';
import '../../features/admin/documents/admin_documents_screen.dart';
import '../../features/admin/testimonials/admin_testimonials_screen.dart';
import '../../features/admin/faq/admin_faq_screen.dart';
import '../../features/admin/blog/admin_blog_screen.dart';
import '../../features/admin/settings/admin_settings_screen.dart';

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    initialLocation: '/home',
    routes: [
      GoRoute(
        path: '/',
        redirect: (context, state) => '/home',
      ),
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/services',
        builder: (context, state) {
          final cat = state.uri.queryParameters['category'];
          final q = state.uri.queryParameters['q'];
          return ServicesScreen(initialCategory: cat, initialQuery: q);
        },
      ),
      GoRoute(
        path: '/services/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ServiceDetailsScreen(serviceId: id);
        },
      ),
      GoRoute(
        path: '/request-service',
        builder: (context, state) {
          final srvId = state.uri.queryParameters['serviceId'];
          return RequestServiceScreen(preselectedServiceId: srvId);
        },
      ),
      GoRoute(
        path: '/requests/confirmation',
        builder: (context, state) {
          final reqId = state.uri.queryParameters['id'] ?? '';
          return RequestConfirmationScreen(requestId: reqId);
        },
      ),
      GoRoute(
        path: '/requests',
        builder: (context, state) => const MyRequestsScreen(),
      ),
      GoRoute(
        path: '/requests/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return RequestDetailsScreen(requestId: id);
        },
      ),
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/about',
        builder: (context, state) => const AboutScreen(),
      ),
      GoRoute(
        path: '/contact',
        builder: (context, state) => const ContactScreen(),
      ),

      // Admin Portal Routes
      GoRoute(
        path: '/admin',
        redirect: (context, state) => '/admin/dashboard',
      ),
      GoRoute(
        path: '/admin/dashboard',
        builder: (context, state) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: '/admin/services',
        builder: (context, state) => const AdminServicesScreen(),
      ),
      GoRoute(
        path: '/admin/services/create',
        builder: (context, state) => const AdminServiceFormScreen(),
      ),
      GoRoute(
        path: '/admin/services/:id/edit',
        builder: (context, state) {
          final id = state.pathParameters['id'];
          return AdminServiceFormScreen(serviceId: id);
        },
      ),
      GoRoute(
        path: '/admin/categories',
        builder: (context, state) => const AdminCategoriesScreen(),
      ),
      GoRoute(
        path: '/admin/customers',
        builder: (context, state) => const AdminCustomersScreen(),
      ),
      GoRoute(
        path: '/admin/requests',
        builder: (context, state) => const AdminRequestsScreen(),
      ),
      GoRoute(
        path: '/admin/requests/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return AdminRequestDetailsScreen(requestId: id);
        },
      ),
      GoRoute(
        path: '/admin/documents',
        builder: (context, state) => const AdminDocumentsScreen(),
      ),
      GoRoute(
        path: '/admin/testimonials',
        builder: (context, state) => const AdminTestimonialsScreen(),
      ),
      GoRoute(
        path: '/admin/faq',
        builder: (context, state) => const AdminFaqScreen(),
      ),
      GoRoute(
        path: '/admin/blog',
        builder: (context, state) => const AdminBlogScreen(),
      ),
      GoRoute(
        path: '/admin/settings',
        builder: (context, state) => const AdminSettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => CustomerShellLayout(
      currentPath: '/home',
      child: EmptyState(
        title: '404 - Page Not Found',
        description: 'The requested page "${state.uri}" does not exist or has been moved.',
        actionLabel: 'Return to Home',
        onAction: () => context.go('/home'),
      ),
    ),
  );
}
