import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/features/auth/controllers/auth_controller.dart';
import 'package:med_aid/features/auth/bindings/auth_binding.dart';
import 'package:med_aid/core/services/supabase_service.dart';

class AuthTestScreen extends StatefulWidget {
  const AuthTestScreen({super.key});

  @override
  State<AuthTestScreen> createState() => _AuthTestScreenState();
}

class _AuthTestScreenState extends State<AuthTestScreen> {
  late final AuthController controller;
  final _formKey = GlobalKey<FormState>();
  final _logs = <String>[].obs;
  final _isLogExpanded = false.obs;
  final _successMessage = ''.obs;

  @override
  void initState() {
    super.initState();
    // Make sure auth binding is initialized
    AuthBinding().dependencies();
    controller = Get.find<AuthController>();

    // Clear logs when rebuilding
    _logs.clear();

    // Listen for auth state changes
    final supabaseService = Get.find<SupabaseService>();
    supabaseService.onAuthStateChange.listen((event) {
      _addLog('Auth state changed: ${event.event}');
      if (event.session != null) {
        _addLog(
          'User logged in: ${event.session?.user.email ?? event.session?.user.phone}',
        );
        _showSuccessMessage('Successfully authenticated');
      }
    });

    // Log current auth state
    final currentUser = supabaseService.getCurrentUser();
    if (currentUser != null) {
      _addLog(
        'Already logged in as: ${currentUser.email ?? currentUser.phone}',
      );
    } else {
      _addLog('Not logged in');
    }

    // Listen to OTP state changes
    ever(controller.isOtpSent, (bool sent) {
      if (sent) {
        _showSuccessMessage('OTP sent successfully. Please check your phone.');
      }
    });

    // Listen to auth mode changes
    ever(controller.authMode, (AuthMode mode) {
      if (mode == AuthMode.completeProfile) {
        _showSuccessMessage(
          'Authentication successful! Please complete your profile.',
        );
      } else if (mode == AuthMode.signIn &&
          _previousMode == AuthMode.completeProfile) {
        _showSuccessMessage('Profile updated successfully!');
      }
    });
  }

  // Track previous auth mode to detect changes
  AuthMode? _previousMode;

  @override
  void didUpdateWidget(covariant AuthTestScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    _previousMode = controller.authMode.value;
  }

  void _addLog(String log) {
    _logs.add('${DateTime.now().toString().split('.').first}: $log');
    // Keep log size reasonable
    if (_logs.length > 50) {
      _logs.removeAt(0);
    }
  }

  void _showSuccessMessage(String message) {
    _successMessage.value = message;
    // Auto-hide after 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      if (_successMessage.value == message) {
        _successMessage.value = '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Auth Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _logs.add('--- Refreshed screen ---');
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              _logs.clear();
              _addLog('Logs cleared');
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Success message banner
          Obx(
            () => _successMessage.value.isNotEmpty
                ? Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    color: Colors.green.shade700,
                    child: Row(
                      children: [
                        const Icon(Icons.check_circle, color: Colors.white),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _successMessage.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, color: Colors.white),
                          onPressed: () => _successMessage.value = '',
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                          iconSize: 18,
                        ),
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),

          // Auth Form
          Expanded(
            flex: 3,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Authentication Test',
                      style: Theme.of(context).textTheme.headlineSmall,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),

                    // Google authentication section
                    _buildGoogleAuthSection(),

                    const Divider(height: 32),

                    // Phone authentication section
                    _buildPhoneAuthSection(),

                    const Divider(height: 32),

                    // Profile completion section
                    _buildProfileCompletionSection(),

                    const Divider(height: 32),

                    // Sign out button
                    ElevatedButton.icon(
                      onPressed: () async {
                        _addLog('Attempting to sign out');
                        try {
                          await controller.signOut();
                          _addLog('Sign out function completed');
                          _showSuccessMessage('You have been signed out');
                        } catch (e) {
                          _addLog('Error during sign out: $e');
                        }
                      },
                      icon: const Icon(Icons.logout),
                      label: const Text('Sign Out'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade700,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Debug logs
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      const Text(
                        'Debug Logs',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Obx(
                        () => IconButton(
                          icon: Icon(
                            _isLogExpanded.value
                                ? Icons.compress
                                : Icons.expand,
                            color: Colors.white,
                          ),
                          onPressed: () =>
                              _isLogExpanded.value = !_isLogExpanded.value,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Obx(() {
                      return ListView.builder(
                        reverse: true,
                        itemCount: _logs.length,
                        itemBuilder: (context, index) {
                          final log = _logs[_logs.length - 1 - index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 2),
                            child: Text(
                              log,
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 12,
                                fontFamily: 'monospace',
                              ),
                            ),
                          );
                        },
                      );
                    }),
                  ),

                  // Error message display
                  Obx(
                    () => controller.errorMessage.value.isNotEmpty
                        ? Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red.shade900,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              'ERROR: ${controller.errorMessage.value}',
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGoogleAuthSection() {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Google Authentication',
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),

            // Google sign-in button
            Obx(
              () => ElevatedButton.icon(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        _addLog('Initiating Google sign-in');
                        try {
                          await controller.signInWithGoogle();
                          _addLog(
                            'Google sign-in initiated - waiting for redirect',
                          );
                        } catch (e) {
                          _addLog('Error initiating Google sign-in: $e');
                        }
                      },
                icon: Image.network(
                  "https://www.gstatic.com/marketing-cms/assets/images/d5/dc/cfe9ce8b4425b410b49b7f2dd3f3/g.webp=s96-fcrop64=1,00000000ffffffff-rw",

                  height: 24,
                  width: 24,
                ),
                label: const Text('Sign in with Google'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black87,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // Note about redirect
            const Text(
              'Note: This will open a browser window for authentication',
              style: TextStyle(
                fontSize: 12,
                fontStyle: FontStyle.italic,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPhoneAuthSection() {
    return Obx(() {
      final isOtpSent = controller.isOtpSent.value;

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                isOtpSent ? 'Enter OTP' : 'Phone Authentication',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Phone field
              TextFormField(
                controller: controller.phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                  hintText: '+1234567890',
                  helperText: 'Include country code starting with +',
                ),
                keyboardType: TextInputType.phone,
                enabled:
                    !isOtpSent ||
                    !controller.isLoading.value, // Disable when OTP sent
              ),
              const SizedBox(height: 16),

              // OTP field (shown after sending OTP)
              if (isOtpSent) ...[
                TextFormField(
                  controller: controller.otpController,
                  decoration: const InputDecoration(
                    labelText: 'OTP Code',
                    border: OutlineInputBorder(),
                    hintText: '123456',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
              ],

              // Action buttons
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: controller.isLoading.value
                          ? null
                          : () async {
                              if (!isOtpSent) {
                                _addLog(
                                  'Sending phone OTP to ${controller.phoneController.text}',
                                );
                                try {
                                  await controller.sendPhoneOtp();
                                  _addLog('OTP send function completed');
                                  // Success message handled by listener
                                } catch (e) {
                                  _addLog('Error: $e');
                                }
                              } else {
                                _addLog(
                                  'Verifying OTP for ${controller.phoneController.text}',
                                );
                                try {
                                  await controller.verifyPhoneOtp();
                                  _addLog(
                                    'OTP verification function completed',
                                  );
                                  // Success message handled by listener
                                } catch (e) {
                                  _addLog('Error: $e');
                                }
                              }
                            },
                      child: Text(isOtpSent ? 'Verify OTP' : 'Send OTP'),
                    ),
                  ),
                  if (isOtpSent) ...[
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {
                        controller.isOtpSent.value = false;
                        controller.otpController.clear();
                      },
                      child: const Text('Cancel'),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildProfileCompletionSection() {
    return Obx(() {
      // ignore: unused_local_variable
      final isProfileMode =
          controller.authMode.value == AuthMode.completeProfile;

      return Card(
        margin: const EdgeInsets.symmetric(vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Complete Profile',
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // First name field
              TextFormField(
                controller: controller.firstNameController,
                decoration: const InputDecoration(
                  labelText: 'First Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Last name field
              TextFormField(
                controller: controller.lastNameController,
                decoration: const InputDecoration(
                  labelText: 'Last Name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),

              // Birthdate field (optional)
              TextFormField(
                controller: controller.birthdateController,
                decoration: const InputDecoration(
                  labelText: 'Birthdate (YYYY-MM-DD)',
                  border: OutlineInputBorder(),
                  hintText: '2000-01-01',
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 16),

              // Submit button
              ElevatedButton(
                onPressed: controller.isLoading.value
                    ? null
                    : () async {
                        _addLog('Attempting to complete profile');
                        try {
                          await controller.completeProfile();
                          _addLog('Profile completion function completed');
                          // Success message handled by listener
                        } catch (e) {
                          _addLog('Error: $e');
                        }
                      },
                child: const Text('Save Profile'),
              ),
            ],
          ),
        ),
      );
    });
  }
}
