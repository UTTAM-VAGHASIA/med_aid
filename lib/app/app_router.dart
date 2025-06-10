import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/auth/presentation/views/login_mobile_number_screen.dart';
import 'package:med_aid/features/auth/presentation/views/otp_verification_screen.dart';
import 'package:med_aid/features/auth/presentation/views/starting_options_screen.dart';
import 'package:med_aid/features/splash/presentation/views/splash_screen.dart';
import 'package:med_aid/features/home/presentation/views/home_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';
import 'package:med_aid/core/controllers/transition_controller.dart';
import 'package:med_aid/features/location/presentation/views/city_selection_screen.dart';
import 'package:med_aid/features/equipment/presentation/views/equipment_list_screen.dart';
import 'package:med_aid/features/equipment/bindings/equipment_bindings.dart';
import 'package:med_aid/features/NGO/presentation/views/ngo_list_screen.dart';
import 'package:med_aid/features/NGO/bindings/ngo_bindings.dart';

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
  equipmentList,
  ngoList,
  mobileNumber,
  otpVerification,
  citySelection,
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
          path: '/otp-verification',
          name: AppRoute.otpVerification.name,
          builder: (context, state) => const OtpVerificationScreen(),
        ),
        GoRoute(
          path: '/city-selection',
          name: AppRoute.citySelection.name,
          builder: (context, state) => const CitySelectionScreen(),
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
          path: '/equipment',
          name: AppRoute.equipmentList.name,
          builder: (context, state) {
            // Inject the controller
            EquipmentBindings().dependencies();
            return const EquipmentListScreen();
          },
        ),
        GoRoute(
          path: '/equipment/:id',
          name: AppRoute.equipmentDetail.name,
          builder: (context, state) => const SizedBox(), // Placeholder, will be replaced
        ),
        GoRoute(
          path: '/ngo',
          name: AppRoute.ngoList.name,
          builder: (context, state) {
            // Inject the controller
            NGOBindings().dependencies();
            return const NGOListScreen();
          },
        ),
      ],
      // Global redirect logic for authentication
      redirect: (context, state) {
        // Skip auth checks for these paths to allow direct access
        if (state.matchedLocation == '/auth-test' || 
            state.matchedLocation == '/mobile-number' ||
            state.matchedLocation == '/otp-verification' ||
            state.matchedLocation == '/city-selection' ||
            state.matchedLocation == '/equipment' ||
            state.matchedLocation == '/ngo' ||
            state.matchedLocation == '/splash') {
          return null;
        }
        
              // Default redirect to starting options screen
      return '/auth-test';

        /* Comment out the old authentication logic since we're just focusing on UI flow
        final session = Supabase.instance.client.auth.currentSession;
        final bool loggedIn = session != null;
        final bool loggingIn = state.matchedLocation == '/auth-test';
        final bool isSplash = state.matchedLocation == '/splash';

        // If not logged in and trying to access protected route
        if (!loggedIn && !loggingIn && !isSplash) {
          return '/auth-test'; 
        }
        
        // If logged in and trying to access auth screen (but not splash)
        if (loggedIn && loggingIn) {
          return '/home';
        }
        */
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
      try {
        await _transitionController!.transitionBetweenPages(() {
          debugPrint("AppRouter: Navigating to $path during transition");
          router.go(path);
        });
        debugPrint("AppRouter: Navigation to $path completed with transition");
      } catch (e) {
        debugPrint("AppRouter: Error during navigation to $path: $e");
        // Fallback direct navigation
        router.go(path);
      }
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
