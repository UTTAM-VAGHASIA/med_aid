import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/splash/controllers/splash_controller.dart';
import 'package:med_aid/features/splash/presentation/widgets/animated_splash_container.dart';
import 'package:med_aid/features/splash/presentation/widgets/flip_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller instance
    final SplashController controller = Get.find<SplashController>();
    final screenSize = MediaQuery.of(context).size;
    
    return FScaffold(
      child: Stack(
        fit: StackFit.expand,
        children: [

          // Central content
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated Logo with 3D flip effect
                Obx(() => FlipLogo(
                  logoPath: 'assets/app-logo.png',
                  opacity: controller.logoOpacity.value,
                  scale: controller.logoScale.value,
                )),
                
                const SizedBox(height: 24),
                
                // App name text with animation
                Obx(() => AnimatedOpacity(
                  duration: const Duration(milliseconds: 800),
                  opacity: controller.textOpacity.value,
                  child: const Text(
                    'MED AID',
                    style: TextStyle(
                      fontFamily: 'High Tower Text',
                      fontWeight: FontWeight.w400,
                      fontSize: 40,
                      letterSpacing: -0.32,
                      color: Color(0xFF3E8B8C),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )),
              ],
            ),
          ),


          // Top right container
          Obx(() => AnimatedSplashContainer(
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
          )),

          // Top left container
          Obx(() => AnimatedSplashContainer(
            position: controller.topLeftContainerOffset.value,
            size: const Size(407, 404),
            color: const Color.fromRGBO(62, 139, 140, 1),
            breathingOffset: Offset(
              controller.containerBreathingValue.value * 2,
              controller.containerBreathingValue.value * 2,
            ),
          )),
          
          // Bottom left container
          Obx(() => AnimatedSplashContainer(
            position: controller.bottomLeftContainerOffset.value,
            size: const Size(338, 571),
            color: const Color.fromRGBO(51, 51, 51, 1),
            breathingOffset: Offset(
              controller.containerBreathingValue.value * 2,
              -controller.containerBreathingValue.value * 2,
            ),
          )),
          
          // Bottom right container
          Obx(() => AnimatedSplashContainer(
            position: controller.bottomRightContainerOffset.value,
            size: const Size(426, 557),
            color: const Color.fromRGBO(84, 178, 179, 1),
            breathingOffset: Offset(
              -controller.containerBreathingValue.value * 2,
              -controller.containerBreathingValue.value * 2,
            ),
          )),
        ],
      ),
    );
  }
}
