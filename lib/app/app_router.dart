import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/auth/presentation/views/login_mobile_number_screen.dart';
import 'package:med_aid/features/auth/presentation/views/starting_options_screen.dart';
import 'package:med_aid/features/splash/presentation/views/splash_screen.dart';
import 'package:med_aid/features/home/presentation/views/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:med_aid/core/controllers/transition_controller.dart';
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
  ngoList,
  mobileNumber
}

class AppRouter {
  // Expose the GoRouter instance
  late final GoRouter router;
  TransitionController? _transitionController;
  
  AppRouter() {
    debugPrint("AppRouter: Initializing");
    
    try {
      _transitionController = Get.find<TransitionController>();
      debugPrint("AppRouter: Found TransitionController");
    } catch (e) {
      debugPrint("AppRouter: TransitionController not available - $e");
      // Will proceed without transition controller
    }
    
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
          builder: (context, state) => const StartingOptionsScreen(),
        ),
        GoRoute(
          path: '/mobile-number',
          name: AppRoute.mobileNumber.name,
          builder: (context, state) => const LoginMobileNumberScreen(),
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
        // Skip auth checks for auth-test screen and authentication-related screens
        if (state.matchedLocation == '/auth-test' || 
            state.matchedLocation == '/mobile-number' ||
            state.matchedLocation == '/splash') {
          return null;
        }
        
        final session = Supabase.instance.client.auth.currentSession;
        final bool loggedIn = session != null;
        final bool loggingIn = state.matchedLocation == '/auth';

        // If not logged in and trying to access protected route
        if (!loggedIn && !loggingIn) {
          return '/auth'; 
        }
        
        // If logged in and trying to access auth screen
        if (loggedIn && loggingIn) {
          return '/home';
        }
        
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
    
    debugPrint("AppRouter: Initialized successfully");
  }
  
  // Navigate with transition animation
  Future<void> goWithTransition(String path) async {
    debugPrint("AppRouter: goWithTransition called for path $path");
    
    if (_transitionController != null) {
      await _transitionController!.transitionBetweenPages(() {
        router.go(path);
      });
    } else {
      debugPrint("AppRouter: No transition controller, using direct navigation");
      router.go(path);
    }
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
