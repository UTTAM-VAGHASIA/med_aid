import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/features/auth/controllers/auth_controller.dart';
import 'package:med_aid/features/auth/bindings/auth_binding.dart';
import 'package:pinput/pinput.dart';

class OtpVerificationScreen extends StatefulWidget {
  const OtpVerificationScreen({super.key});

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  Timer? _timer;
  int _timeLeft = 300; // 5 minutes in seconds
  bool _isResending = false;
  late final AppRouter appRouter;
  late final AuthController controller;
  final TextEditingController _pinController = TextEditingController();

  // Added for success state
  bool _showSuccessOverlay = false;

  @override
  void initState() {
    super.initState();
    // Make sure auth binding is initialized
    AuthBinding().dependencies();
    controller = Get.find<AuthController>();
    appRouter = Get.find<AppRouter>();
    
    _startTimer();

    // Listen to auth mode changes to know when to show success UI
    ever(controller.authMode, (AuthMode mode) {
      if (mode == AuthMode.completeProfile) {
        // User verified and needs to complete profile
        setState(() {
          _showSuccessOverlay = true;
        });
        
        // Navigate after showing success for 2 seconds
        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;
          appRouter.goWithTransition('/city-selection');
        });
      }
    });
  }

  @override
  void dispose() {
    _pinController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        setState(() {
          _timeLeft--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _handleSubmit() async {
    final otp = _pinController.text;
    if (otp.length == 6) {
      // Clear previous errors
      controller.errorMessage.value = '';
      
      // Set the OTP value in controller
      controller.otpController.text = otp;
      
      try {
        // Verify OTP using controller
        await controller.verifyPhoneOtp();
        
        // Success case is handled by the ever() listener on authMode
      } catch (e) {
        // Error already handled in controller
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete verification code'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _handleResend() async {
    setState(() {
      _isResending = true;
    });
    
    try {
      // Clear previous errors
      controller.errorMessage.value = '';
      
      // Resend OTP
      await controller.sendPhoneOtp();
      
      setState(() {
        _isResending = false;
        // Reset timer
        _timeLeft = 300;
        _startTimer();
      });
      
      if (controller.errorMessage.value.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Code has been sent again'),
            backgroundColor: Colors.green.shade600,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isResending = false;
      });
      // Error already handled in controller
    }
  }

  @override
  Widget build(BuildContext context) {
    // Define Pinput default settings
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w500,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        border: Border.all(color: const Color(0xFF54B2B3), width: 2),
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Colors.grey.shade100,
      ),
    );

    return Scaffold(
      body: Stack(
        children: [
          // Main content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  
                  // Back button and title row
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 30),
                        onPressed: () => appRouter.goWithTransition('/mobile-number'),
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
                  
                  const SizedBox(height: 48),
                  
                  // Verification title
                  const Center(
                    child: Text(
                      'Verification',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Instruction text
                  Center(
                    child: Text(
                      'Enter the code from the SMS\nsent to ${controller.phoneController.text}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  // Pinput OTP input field
                  Center(
                    child: Pinput(
                      controller: _pinController,
                      length: 6,
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) => _handleSubmit(),
                    ),
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Timer
                  Center(
                    child: Text(
                      _formatTime(_timeLeft),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  
                  // Error message
                  Obx(() => controller.errorMessage.value.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(top: 16.0),
                        child: Center(
                          child: Text(
                            controller.errorMessage.value,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      )
                    : const SizedBox.shrink()
                  ),
                  
                  const Spacer(),
                  
                  // Submit button
                  Obx(() => ElevatedButton(
                    onPressed: controller.isLoading.value ? null : _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF54B2B3),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      minimumSize: Size(MediaQuery.of(context).size.width, 0),
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
                          'Submit',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                  )),
                  
                  const SizedBox(height: 16),
                  
                  // Resend link
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'I didn\'t receive the code! ',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.black87,
                          ),
                        ),
                        _isResending
                          ? const SizedBox(
                              height: 14,
                              width: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Color(0xFF54B2B3),
                              ),
                            )
                          : GestureDetector(
                              onTap: _handleResend,
                              child: Text(
                                'Resend',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF54B2B3),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          
          // Success overlay
          if (_showSuccessOverlay)
            Container(
              color: Colors.black.withOpacity(0.5),
              width: double.infinity,
              height: double.infinity,
              child: Center(
                child: Container(
                  width: 300,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFAFDCDD),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Success icon
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.check_circle,
                            color: Color(0xFF8EE08B),
                            size: 60,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Title
                      const Text(
                        'Congratulations!',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      
                      const SizedBox(height: 10),
                      
                      // Message
                      const Text(
                        'You have successfully\nLogin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
} 