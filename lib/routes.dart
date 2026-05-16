import 'package:go_router/go_router.dart';

import 'admin/admin_home/admin_home_screen.dart';
import 'admin/admin_home/admin_home_screen_viewmodel.dart';
import 'admin/view_students/view_students_screen.dart';
import 'admin/analytics/analytics_screen.dart';

import 'api/room.dart';
import 'login.dart';
import 'main.dart';
import 'register.dart';
import 'scanner.dart';
import 'welcome.dart';

class AppRouter {
  static GoRouter router({
    required bool isLoggedIn,
    required bool isAdmin,
  }) {
    return GoRouter(
      initialLocation: '/',
      redirect: (context, state) {
        final location = state.uri.toString();

        final isAuthPage = location == '/' ||
            location == '/login' ||
            location == '/register';

        if (!isLoggedIn && !isAuthPage) {
          return '/login';
        }

        if (isLoggedIn && isAuthPage) {
          return isAdmin ? '/admin-home' : '/welcome';
        }

        // Prevent non-admin users from manually navigating to admin routes
        if (location.startsWith('/admin') && !isAdmin) {
          return '/welcome';
        }

        return null;
      },

      routes: [

        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return const MyHomePage(
              title: 'The Furnace Home Page',
            );
          },
        ),

        GoRoute(
          path: '/login',
          name: 'login',
          builder: (context, state) {
            return const LoginPage();
          },
        ),

        GoRoute(
          path: '/register',
          name: 'register',
          builder: (context, state) {
            return const Register();
          },
        ),

        GoRoute(
          path: '/welcome',
          name: 'welcome',
          builder: (context, state) {
            return WelcomePage(
              false,
              null,
              Room(
                roomId: '',
                roomName: '',
                qrRoomValue: '',
                qrCheckoutValue: '',
              ),
            );
          },
        ),

        GoRoute(
          path: '/scanner',
          name: 'scanner',
          builder: (context, state) {
            return ScanPage(
              false,
              null,
              Room(
                roomId: '',
                roomName: '',
                qrRoomValue: '',
                qrCheckoutValue: '',
              ),
            );
          },
        ),

        GoRoute(
          path: '/admin-home',
          name: 'adminHome',
          builder: (context, state) {
            return AdminHomePage(
              viewModel: AdminHomeScreenViewmodel(),
            );
          },
        ),

        GoRoute(
          path: '/admin-analytics',
          name: 'adminAnalytics',
          builder: (context, state) {
            return const AnalyticsScreen();
          },
        ),

        GoRoute(
          path: '/admin-view-students',
          name: 'adminViewStudents',
          builder: (context, state) {
            return const ViewStudentsScreen();
          },
        ),
      ],
    );
  }
}