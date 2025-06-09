import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/splash/controllers/splash_controller.dart';
import 'package:med_aid/features/splash/presentation/widgets/flip_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get controller instance
    final SplashController controller = Get.find<SplashController>();
    
    return FScaffold(
      childPad: false,
      child: Center(
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
    );
  }
}
