import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/app/app_router.dart';

class StartingOptionsScreen extends StatelessWidget {
  const StartingOptionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    // Access the router instance
    final appRouter = Get.find<AppRouter>();
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            children: [
              // Top row with logo and language selection
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Logo at top left
                  Image.asset(
                    'assets/app-logo.png',
                    height: 48,
                  ),
                  
                  // English language button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'English',
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 32),
              
              // Centered login image and text
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Login screen image
                    Image.asset(
                      'assets/login_screen_image.png',
                      width: screenSize.width * 0.8,
                    ),
                    
                    const SizedBox(height: 32),
                    
                    // App name and tagline
                    const Text(
                      'MED - AID',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '" Bridging The Gap,\nTransforming Healthcare "',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Login and Sign up buttons
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Login button
                  ElevatedButton(
                    onPressed: () {
                      appRouter.goWithTransition('/mobile-number');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF54B2B3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'LOGIN',
                      style: TextStyle(
                        color: Colors.white, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Sign up button
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to sign up screen (also using auth screen)
                      appRouter.goWithTransition('/auth-test');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey[800],
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'SIGN UP',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
