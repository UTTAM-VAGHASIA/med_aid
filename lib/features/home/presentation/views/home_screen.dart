import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/core/controllers/transition_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the AppRouter instance for navigation with transitions
    final AppRouter appRouter = Get.find<AppRouter>();
    final TransitionController transitionController = Get.find<TransitionController>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('MED AID'),
        actions: [
          // Demo button that shows transitions manually
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () async {
              // Show loading overlay
              await transitionController.show();
              
              // Simulate a loading operation
              await Future.delayed(const Duration(seconds: 2));
              
              // Hide loading overlay
              await transitionController.hide();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to MED AID',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Example navigation button
            ElevatedButton(
              onPressed: () {
                // Use the transition animation when navigating
                appRouter.goWithTransition('/auth-test');
              },
              child: const Text('Go to Auth Test'),
            ),
          ],
        ),
      ),
    );
  }
} 