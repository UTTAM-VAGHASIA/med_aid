import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/features/auth/controllers/auth_controller.dart';
import 'package:med_aid/features/auth/bindings/auth_binding.dart';

class LoginMobileNumberScreen extends StatefulWidget {
  const LoginMobileNumberScreen({super.key});

  @override
  State<LoginMobileNumberScreen> createState() => _LoginMobileNumberScreenState();
}

class _LoginMobileNumberScreenState extends State<LoginMobileNumberScreen> {
  final _formKey = GlobalKey<FormState>();
  late final AuthController controller;
  late final AppRouter appRouter;
  
  @override
  void initState() {
    super.initState();
    // Make sure auth binding is initialized
    AuthBinding().dependencies();
    controller = Get.find<AuthController>();
    appRouter = Get.find<AppRouter>();
  }
  
  @override
  void dispose() {
    super.dispose();
  }

  void _handleGetOTP() async {
    if (_formKey.currentState!.validate()) {
      // Clear any previous errors
      controller.errorMessage.value = '';

      // Format the phone number with country code
      final phoneNumber = '+91${controller.phoneController.text}';
      controller.phoneController.text = phoneNumber;
      
      try {
        // Send OTP using the controller
        await controller.sendPhoneOtp();
        
        // If no error, navigate to OTP verification screen
        if (controller.errorMessage.value.isEmpty && controller.isOtpSent.value) {
          appRouter.goWithTransition('/otp-verification');
        }
      } catch (e) {
        // Error already handled in controller
      }
    }
  }
  
  void _handleGoogleLogin() async {
    try {
      await controller.signInWithGoogle();
    } catch (e) {
      // Error already handled in controller
    }
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),

                // Back button and title row
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 30,),
                      onPressed: () => appRouter.goWithTransition('/auth-test'),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    const SizedBox(width: 16),
                    const Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                // Phone Number label
                Row(
                  children: const [
                    Text(
                      'Phone Number',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(width: 4),
                    Text(
                      '*',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // Phone Number input field with country code
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey.shade300),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      // Country selector with flag (simplified)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
                        child: Row(
                          children: [
                            // India flag 
                            Image.network(
                              'https://flagcdn.com/w20/in.png',
                              width: 24,
                              height: 16,
                              errorBuilder: (context, error, stackTrace) => const Icon(
                                Icons.flag,
                                size: 20,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Text(
                              '+91',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Divider line between country code and phone input
                      Container(
                        height: 30,
                        width: 1,
                        color: Colors.grey.shade300,
                      ),

                      // Phone number input field
                      Expanded(
                        child: TextFormField(
                          controller: controller.phoneController,
                          keyboardType: TextInputType.phone,
                          decoration: const InputDecoration(
                            hintText: '9856322147',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(horizontal: 16),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your phone number';
                            }
                            if (value.length != 10) {
                              return 'Please enter a valid 10-digit phone number';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Info text
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4),
                  child: Text(
                    'A code will be sent to your number.',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                    ),
                  ),
                ),

                // Error message
                Obx(() => controller.errorMessage.value.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Text(
                        controller.errorMessage.value,
                        style: const TextStyle(
                          color: Colors.red,
                          fontSize: 14,
                        ),
                      ),
                    )
                  : const SizedBox.shrink()
                ),

                const Spacer(),

                // Get OTP button
                Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value ? null : _handleGetOTP,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF54B2B3),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(screenSize.width, 0),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade300,
                  ),
                  child: controller.isLoading.value
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.0,
                          ),
                        )
                      : const Text(
                          'Get OTP',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                )),

                const SizedBox(height: 16),

                // Login with Google button
                Obx(() => ElevatedButton.icon(
                  onPressed: controller.isLoading.value ? null : _handleGoogleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(screenSize.width, 0),
                    elevation: 0,
                    disabledBackgroundColor: Colors.grey.shade600,
                  ),
                  icon: Image.network(
                    'https://www.gstatic.com/marketing-cms/assets/images/d5/dc/cfe9ce8b4425b410b49b7f2dd3f3/g.webp=s96-fcrop64=1,00000000ffffffff-rw',
                    width: 18,
                    height: 18,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                      Icons.g_mobiledata,
                      size: 24,
                      color: Colors.white,
                    ),
                  ),
                  label: const Text(
                    'Login with Google',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                )),

                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 