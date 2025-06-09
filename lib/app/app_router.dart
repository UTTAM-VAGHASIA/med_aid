import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:med_aid/features/splash/presentation/views/splash_screen.dart';
import 'package:med_aid/features/home/presentation/views/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
// import 'package:med_aid/features/auth/presentation/views/auth_screen.dart';
import 'package:med_aid/features/auth/presentation/views/auth_test_screen.dart';

// Global navigator key for GoRouter
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Enum for route names to ensure type safety
enum AppRoute {
  splash,
  auth,
  authTest,
  locationSelection,
  home,
  equipmentDetail,
  ngoList
}

class AppRouter {
  // Expose the GoRouter instance
  late final GoRouter router;
  
  AppRouter() {
    router = GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: '/splash', // Start with splash screen
      routes: [
        GoRoute(
          path: '/splash',
          name: AppRoute.splash.name,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: '/auth',
          name: AppRoute.auth.name,
          builder: (context, state) => const SizedBox(), // Placeholder until AuthScreen is implemented
        ),
        GoRoute(
          path: '/auth-test',
          name: AppRoute.authTest.name,
          builder: (context, state) => const AuthTestScreen(),
        ),
        GoRoute(
          path: '/location-selection',
          name: AppRoute.locationSelection.name,
          builder: (context, state) => const SizedBox(), // Placeholder, will be replaced
        ),
        GoRoute(
          path: '/home',
          name: AppRoute.home.name,
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/equipment/:id',
          name: AppRoute.equipmentDetail.name,
          builder: (context, state) => const SizedBox(), // Placeholder, will be replaced
        ),
        GoRoute(
          path: '/ngo-list/:category/:location',
          name: AppRoute.ngoList.name,
          builder: (context, state) => const SizedBox(), // Placeholder, will be replaced
        ),
      ],
      // Global redirect logic for authentication
      redirect: (context, state) {
        // Skip auth checks for auth-test screen
        if (state.matchedLocation == '/auth-test') {
          return null;
        }
        
        final session = Supabase.instance.client.auth.currentSession;
        final bool loggedIn = session != null;
        final bool loggingIn = state.matchedLocation == '/auth';
        final bool isSplash = state.matchedLocation == '/splash';

        // If not logged in and trying to access protected route
        if (!loggedIn && !loggingIn && !isSplash) {
          return '/auth'; 
        }
        
        // If logged in and trying to access auth screen (but not splash)
        if (loggedIn && loggingIn) {
          return '/home';
        }
        
        // Let splash screen handle its own navigation based on auth state
        
        // No redirection needed
        return null;
      },
      // Updates router when auth state changes
      refreshListenable: GoRouterRefreshStream(
        Supabase.instance.client.auth.onAuthStateChange
            .map((event) => event.session)
      ),
      debugLogDiagnostics: true,
    );
  }
}

// Helper class to convert Stream to Listenable for GoRouter
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (dynamic _) => notifyListeners(),
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
