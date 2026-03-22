import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../core/theme/app_colors.dart';
import '../core/utils/custom_transitions.dart';
import '../features/adhkar/presentation/pages/adhkar_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/mosques/presentation/pages/mosques_page.dart';
import '../features/onboarding/presentation/pages/notification_permission_page.dart';
import '../features/rulings/presentation/pages/rulings_page.dart';
import '../features/splash/splash_screen.dart';
import '../l10n/app_localizations.dart';

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

    final currentIndex = getCurrentIndex();

    return Scaffold(
      body: child,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  label: l10n.home,
                  isActive: currentIndex == 0,
                  onTap: () => onTap(0),
                ),
                _NavItem(
                  icon: Icons.menu_book_outlined,
                  activeIcon: Icons.menu_book_rounded,
                  label: l10n.adhkar,
                  isActive: currentIndex == 1,
                  onTap: () => onTap(1),
                ),
                _NavItem(
                  icon: Icons.gavel_outlined,
                  activeIcon: Icons.gavel_rounded,
                  label: l10n.rulings,
                  isActive: currentIndex == 2,
                  onTap: () => onTap(2),
                ),
                _NavItem(
                  icon: Icons.location_on_outlined,
                  activeIcon: Icons.location_on_rounded,
                  label: l10n.mosques,
                  isActive: currentIndex == 3,
                  onTap: () => onTap(3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isActive ? activeIcon : icon,
              color: isActive ? AppColors.primary : AppColors.textTertiary,
              size: 22,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: TextStyle(
                color: isActive ? AppColors.primary : AppColors.textTertiary,
                fontSize: 10,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
