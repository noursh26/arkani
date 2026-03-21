import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../core/theme/app_colors.dart';
import '../core/utils/custom_transitions.dart';
import '../l10n/app_localizations.dart';
import '../features/adhkar/presentation/pages/adhkar_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/mosques/presentation/pages/mosques_page.dart';
import '../features/onboarding/presentation/pages/notification_permission_page.dart';
import '../features/rulings/presentation/pages/rulings_page.dart';
import '../features/splash/splash_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

class AppRouter {
  AppRouter._();

  static final router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    routes: [
      // Splash Screen
      GoRoute(
        path: '/splash',
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: CustomTransitions.fadeTransition,
        ),
      ),

      // Notification Permission Screen
      GoRoute(
        path: '/notification-permission',
        name: 'notification-permission',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const NotificationPermissionScreen(),
          transitionsBuilder: CustomTransitions.slideTransition,
        ),
      ),
      
      // Main app shell with bottom nav
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        pageBuilder: (context, state, child) {
          return CustomTransitionPage(
            key: state.pageKey,
            child: ScaffoldWithNavBar(child: child),
            transitionsBuilder: CustomTransitions.fadeTransition,
          );
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const HomePage(),
              transitionsBuilder: CustomTransitions.slideTransition,
            ),
          ),
          GoRoute(
            path: '/adhkar',
            name: 'adhkar',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const AdhkarPage(),
              transitionsBuilder: CustomTransitions.slideTransition,
            ),
          ),
          GoRoute(
            path: '/rulings',
            name: 'rulings',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const RulingsPage(),
              transitionsBuilder: CustomTransitions.slideTransition,
            ),
          ),
          GoRoute(
            path: '/mosques',
            name: 'mosques',
            pageBuilder: (context, state) => CustomTransitionPage(
              key: state.pageKey,
              child: const MosquesPage(),
              transitionsBuilder: CustomTransitions.slideTransition,
            ),
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithNavBar extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNavBar({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final location = GoRouterState.of(context).uri.path;

    int getCurrentIndex() {
      switch (location) {
        case '/adhkar':
          return 1;
        case '/rulings':
          return 2;
        case '/mosques':
          return 3;
        case '/':
        default:
          return 0;
      }
    }

    void onTap(int index) {
      switch (index) {
        case 0:
          context.go('/');
          break;
        case 1:
          context.go('/adhkar');
          break;
        case 2:
          context.go('/rulings');
          break;
        case 3:
          context.go('/mosques');
          break;
      }
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: getCurrentIndex(),
        onDestinationSelected: onTap,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primaryContainer,
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home, color: AppColors.primary),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book, color: AppColors.primary),
            label: l10n.adhkar,
          ),
          NavigationDestination(
            icon: const Icon(Icons.gavel_outlined),
            selectedIcon: const Icon(Icons.gavel, color: AppColors.primary),
            label: l10n.rulings,
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_on_outlined),
            selectedIcon: const Icon(Icons.location_on, color: AppColors.primary),
            label: l10n.mosques,
          ),
        ],
      ),
    );
  }
}
