import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/core/services/supabase_service.dart';

class SplashController extends GetxController with GetSingleTickerProviderStateMixin {
  // Services
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final AppRouter _appRouter = Get.find<AppRouter>();
  
  // Animation controllers
  late AnimationController animationController;
  
  // Animation values
  final logoOpacity = 0.0.obs;
  final logoScale = 0.5.obs;
  final textOpacity = 0.0.obs;
  
  // Container positions
  final topLeftContainerOffset = const Offset(-500, -500).obs;
  final topRightContainerOffset = const Offset(500, -500).obs;
  final bottomLeftContainerOffset = const Offset(-500, 500).obs;
  final bottomRightContainerOffset = const Offset(500, 500).obs;
  
  // Container breathing animation values
  final containerBreathingValue = 0.0.obs;
  
  // Navigation target
  final RxString _nextRoute = ''.obs;
  
  // State flags
  final isNavigating = false.obs;
  final isAnimatingOut = false.obs;
  
  @override
  void onInit() {
    super.onInit();
    
    // Initialize animation controller
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
    
    // Start the splash animation sequence
    _startSplashAnimation();
  }
  
  @override
  void onClose() {
    animationController.dispose();
    super.onClose();
  }
  
  // Main animation sequence for splash screen
  void _startSplashAnimation() async {
    // Step 1: Fade in and flip logo
    logoOpacity.value = 1.0;
    logoScale.value = 1.0;
    
    // Step 2: After 500ms, fade in text
    await Future.delayed(const Duration(milliseconds: 500));
    textOpacity.value = 1.0;
    
    // Step 3: After 1000ms, animate containers into place
    await Future.delayed(const Duration(milliseconds: 1000));
    topLeftContainerOffset.value = const Offset(-100, -140);
    topRightContainerOffset.value = const Offset(51, -57); // Right aligned
    bottomLeftContainerOffset.value = const Offset(-100, 304);
    bottomRightContainerOffset.value = const Offset(74, 354);
    
    // Step 4: Start breathing animation for containers
    _startContainerBreathingAnimation();
    
    // Step 5: Check auth state after animations
    await Future.delayed(const Duration(seconds: 3));
    _determineNavigationTarget();
  }
  
  // Creates a subtle "breathing" effect for the containers
  void _startContainerBreathingAnimation() {
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (isAnimatingOut.value) {
        timer.cancel();
        return;
      }
      
      // Create a breathing effect by oscillating between 0 and 1
      containerBreathingValue.value = containerBreathingValue.value == 0 ? 1 : 0;
    });
  }
  
  // Check if user is authenticated and set navigation target
  void _determineNavigationTarget() {
    final currentUser = _supabaseService.getCurrentUser();
    final isLoggedIn = currentUser != null;
    
    // Set target route based on auth state
    _nextRoute.value = isLoggedIn ? '/home' : '/auth-test';
    
    // Start exit animation
    _startExitAnimation();
  }
  
  // Animate containers away before navigating
  void _startExitAnimation() async {
    isAnimatingOut.value = true;
    
    // Step 1: Move containers out in reverse order
    
    // Bottom right container exits first
    bottomRightContainerOffset.value = const Offset(500, 500);
    
    // Bottom left container exits
    bottomLeftContainerOffset.value = const Offset(-500, 500);
    
    // Top right container exits
    topRightContainerOffset.value = const Offset(500, -500);
    
    // Top left container exits last
    topLeftContainerOffset.value = const Offset(-500, -500);
    

    // Navigate after containers move away
    await Future.delayed(const Duration(milliseconds: 500));
    isNavigating.value = true;
    _appRouter.router.go(_nextRoute.value);

  }
}
