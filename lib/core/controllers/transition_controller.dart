import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransitionController extends GetxController with GetSingleTickerProviderStateMixin {
  // Animation controller
  late AnimationController animationController;
  
  // Visibility flag
  final isVisible = false.obs;
  
  // Container positions
  final topLeftContainerOffset = const Offset(-500, -500).obs;
  final topRightContainerOffset = const Offset(500, -500).obs;
  final bottomLeftContainerOffset = const Offset(-500, 500).obs;
  final bottomRightContainerOffset = const Offset(500, 500).obs;
  
  // Container breathing animation values
  final containerBreathingValue = 0.0.obs;
  
  // State flags
  final isAnimatingIn = false.obs;
  final isAnimatingOut = false.obs;

  @override
  void onInit() {
    super.onInit();
    debugPrint("TransitionController: onInit called");
    
    // Initialize animation controller
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
  }
  
  @override
  void onClose() {
    debugPrint("TransitionController: onClose called");
    animationController.dispose();
    super.onClose();
  }
  
  // Show the transition overlay (bring containers in)
  Future<void> show() async {
    debugPrint("TransitionController: show called, isVisible=${isVisible.value}, isAnimatingIn=${isAnimatingIn.value}");
    if (isAnimatingIn.value || isVisible.value) return;
    
    isAnimatingIn.value = true;
    isVisible.value = true;
    
    // First make sure all containers are positioned off-screen
    topLeftContainerOffset.value = const Offset(-500, -500);
    topRightContainerOffset.value = const Offset(500, -500);
    bottomLeftContainerOffset.value = const Offset(-500, 500);
    bottomRightContainerOffset.value = const Offset(500, 500);
    
    // Add a small delay to ensure visibility is processed
    await Future.delayed(const Duration(milliseconds: 50));
    
    // Animate containers into place in sequence
    // Top left container enters first
    topLeftContainerOffset.value = const Offset(-100, -140);
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Top right container enters
    topRightContainerOffset.value = const Offset(51, -57);
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Bottom left container enters
    bottomLeftContainerOffset.value = const Offset(-100, 314);
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Bottom right container enters
    bottomRightContainerOffset.value = const Offset(74, 354);
    
    // Start breathing animation
    _startContainerBreathingAnimation();
    
    // Wait for animations to complete
    await Future.delayed(const Duration(milliseconds: 500));
    isAnimatingIn.value = false;
    debugPrint("TransitionController: show completed");
  }
  
  // Hide the transition overlay (move containers out)
  Future<void> hide() async {
    debugPrint("TransitionController: hide called, isVisible=${isVisible.value}, isAnimatingOut=${isAnimatingOut.value}");
    if (isAnimatingOut.value || !isVisible.value) return;
    
    isAnimatingOut.value = true;
    
    // Move containers out in sequence
    
    // Bottom right container exits first
    bottomRightContainerOffset.value = const Offset(500, 500);
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Bottom left container exits
    bottomLeftContainerOffset.value = const Offset(-500, 500);
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Top right container exits
    topRightContainerOffset.value = const Offset(500, -500);
    
    await Future.delayed(const Duration(milliseconds: 100));
    
    // Top left container exits last
    topLeftContainerOffset.value = const Offset(-500, -500);
    
    // Complete animation
    await Future.delayed(const Duration(milliseconds: 300));
    isVisible.value = false;
    isAnimatingOut.value = false;
    debugPrint("TransitionController: hide completed");
  }
  
  // Creates a subtle "breathing" effect for the containers
  void _startContainerBreathingAnimation() {
    debugPrint("TransitionController: breathing animation started");
    Timer.periodic(const Duration(seconds: 3), (timer) {
      if (!isVisible.value) {
        debugPrint("TransitionController: breathing animation stopped");
        timer.cancel();
        return;
      }
      
      // Create a breathing effect by oscillating between 0 and 1
      containerBreathingValue.value = containerBreathingValue.value == 0 ? 1 : 0;
    });
  }
  
  // Show overlay during page transitions
  Future<void> transitionBetweenPages(VoidCallback navigationCallback) async {
    debugPrint("TransitionController: transitionBetweenPages started");
    await show();
    await Future.delayed(const Duration(milliseconds: 200));
    debugPrint("TransitionController: navigation callback called");
    navigationCallback();
    await Future.delayed(const Duration(milliseconds: 300));
    await hide();
    debugPrint("TransitionController: transitionBetweenPages completed");
  }
} 