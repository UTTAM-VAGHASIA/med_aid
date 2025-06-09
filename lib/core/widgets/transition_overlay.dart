import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/core/controllers/transition_controller.dart';
import 'package:med_aid/features/splash/presentation/widgets/animated_splash_container.dart';

class TransitionOverlay extends StatelessWidget {
  final Widget child;
  
  const TransitionOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    debugPrint('TransitionOverlay build called');
    
    TransitionController? controller;
    
    try {
      controller = Get.find<TransitionController>();
      debugPrint('TransitionOverlay: Successfully found TransitionController');
    } catch (e) {
      debugPrint('TransitionOverlay: Error finding TransitionController - $e');
      // If controller not found, just return the child to prevent white screen
      return child;
    }
    
    final screenSize = MediaQuery.of(context).size;
    debugPrint('TransitionOverlay: Screen size - $screenSize');
    
    return Stack(
      fit: StackFit.expand,
      children: [
        // Main content (screens)
        child,
        
        // Overlay layer with containers
        Obx(() {
          final isVisible = controller!.isVisible.value;
          debugPrint('TransitionOverlay: isVisible = $isVisible');
          
          if (!isVisible) {
            return const SizedBox();
          }
          
          return Stack(
            fit: StackFit.expand,
            children: [

              // Top right container
              AnimatedSplashContainer(
                position: Offset(
                  screenSize.width - 441 + controller.topRightContainerOffset.value.dx,
                  controller.topRightContainerOffset.value.dy,
                ),
                size: const Size(441, 447),
                color: const Color.fromRGBO(170, 217, 217, 1),
                breathingOffset: Offset(
                  -controller.containerBreathingValue.value * 2,
                  controller.containerBreathingValue.value * 2,
                ),
                duration: const Duration(milliseconds: 700),
              ),

              // Top left container
              AnimatedSplashContainer(
                position: controller.topLeftContainerOffset.value,
                size: const Size(407, 404),
                color: const Color.fromRGBO(62, 139, 140, 1),
                breathingOffset: Offset(
                  controller.containerBreathingValue.value * 2,
                  controller.containerBreathingValue.value * 2,
                ),
                duration: const Duration(milliseconds: 800),
              ),
              
              // Bottom left container
              AnimatedSplashContainer(
                position: controller.bottomLeftContainerOffset.value,
                size: const Size(338, 581),
                color: const Color.fromRGBO(51, 51, 51, 1),
                breathingOffset: Offset(
                  controller.containerBreathingValue.value * 2,
                  -controller.containerBreathingValue.value * 2,
                ),
                duration: const Duration(milliseconds: 600),
              ),
              
              // Bottom right container
              AnimatedSplashContainer(
                position: controller.bottomRightContainerOffset.value,
                size: const Size(426, 557),
                color: const Color.fromRGBO(84, 178, 179, 1),
                breathingOffset: Offset(
                  -controller.containerBreathingValue.value * 2,
                  -controller.containerBreathingValue.value * 2,
                ),
                duration: const Duration(milliseconds: 500),
              ),
            ],
          );
        })
      ],
    );
  }
} 