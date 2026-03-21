import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../l10n/app_localizations.dart';
import '../features/adhkar/presentation/pages/adhkar_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/mosques/presentation/pages/mosques_page.dart';
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
        builder: (context, state) => const SplashScreen(),
      ),
      
      // Main app shell with bottom nav
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return ScaffoldWithNavBar(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/adhkar',
            name: 'adhkar',
            builder: (context, state) => const AdhkarPage(),
          ),
          GoRoute(
            path: '/rulings',
            name: 'rulings',
            builder: (context, state) => const RulingsPage(),
          ),
          GoRoute(
            path: '/mosques',
            name: 'mosques',
            builder: (context, state) => const MosquesPage(),
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
            label: l10n?.homeTab ?? 'الرئيسية',
          ),
          NavigationDestination(
            icon: const Icon(Icons.menu_book_outlined),
            selectedIcon: const Icon(Icons.menu_book, color: AppColors.primary),
            label: l10n?.adhkarTab ?? 'الأذكار',
          ),
          NavigationDestination(
            icon: const Icon(Icons.gavel_outlined),
            selectedIcon: const Icon(Icons.gavel, color: AppColors.primary),
            label: l10n?.rulingsTab ?? 'الأحكام',
          ),
          NavigationDestination(
            icon: const Icon(Icons.location_on_outlined),
            selectedIcon: const Icon(Icons.location_on, color: AppColors.primary),
            label: l10n?.mosquesTab ?? 'المساجد',
          ),
        ],
      ),
    );
  }
}
