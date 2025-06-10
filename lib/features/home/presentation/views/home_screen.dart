import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/app/app_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appRouter = Get.find<AppRouter>();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: const Color(0xFF54B2B3),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Welcome to MED-AID',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF54B2B3),
              ),
            ),
            const SizedBox(height: 40),
            
            // Equipment button
            ElevatedButton(
              onPressed: () {
                appRouter.goWithTransition('/equipment');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54B2B3),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Go to Equipment'),
            ),
            
            const SizedBox(height: 20),
            
            // NGO button
            ElevatedButton(
              onPressed: () {
                appRouter.goWithTransition('/ngo');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54B2B3),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Go to NGO'),
            ),
            
            const SizedBox(height: 20),
            
            // City selection button
            ElevatedButton(
              onPressed: () {
                appRouter.goWithTransition('/city-selection');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF54B2B3),
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Back to City Selection'),
            ),
          ],
        ),
      ),
    );
  }
} 