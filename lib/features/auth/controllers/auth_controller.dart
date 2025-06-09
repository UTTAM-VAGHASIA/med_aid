import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:med_aid/core/services/supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'dart:developer' as developer;

enum AuthMode {
  signIn,
  signUp,
  phoneAuth,
  resetPassword,
  emailOtp,
  completeProfile,
}

class AuthController extends GetxController {
  final SupabaseService _supabaseService = Get.find<SupabaseService>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final phoneController = TextEditingController();
  final otpController = TextEditingController();

  // User data controllers for signup
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final birthdateController = TextEditingController();

  // Observable state variables
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final isOtpSent = false.obs;
  final authMode = AuthMode.signIn.obs;
  final isPasswordVisible = false.obs;

  // Debug helpers
  void _logDebug(String message) {
    developer.log(message, name: 'AuthController');
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    phoneController.dispose();
    otpController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    birthdateController.dispose();
    super.onClose();
  }

  // Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Phone signup/signin with OTP - Step 1: Send OTP
  Future<void> sendPhoneOtp() async {
    // Validate phone number
    if (phoneController.text.isEmpty) {
      _logDebug('Phone OTP validation failed: Phone number empty');
      errorMessage.value = 'Phone number is required';
      return;
    }

    // Format validation - simple check for now
    if (!phoneController.text.startsWith('+')) {
      _logDebug('Phone format validation failed: Phone number must start with +');
      errorMessage.value = 'Phone number must include country code (starting with +)';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    _logDebug('========== SENDING PHONE OTP ==========');
    _logDebug('Request: Sending OTP to phone=${phoneController.text}');

    try {
      // Use Supabase client to send OTP
      await _supabaseService.client.auth.signInWithOtp(
        phone: phoneController.text,
      );

      _logDebug('Response: Phone OTP sent successfully');
      isOtpSent.value = true;

      // Use a safer way to notify the user instead of snackbar
      // that could fail if context is not ready
      _logDebug('OTP sent notification - Setting success message');
      // Don't use Get.snackbar here as it can fail if context is not ready
    } on AuthException catch (e) {
      _logDebug('AuthException: ${e.statusCode} - ${e.message}');
      errorMessage.value = e.message;
    } catch (e) {
      _logDebug('Error sending phone OTP: $e');
      errorMessage.value = 'Failed to send OTP: $e';
    } finally {
      isLoading.value = false;
      _logDebug('========== END SEND PHONE OTP ==========');
    }
  }

  // Phone signup/signin with OTP - Step 2: Verify OTP
  Future<void> verifyPhoneOtp() async {
    // Validate OTP
    if (otpController.text.isEmpty) {
      _logDebug('Phone OTP verification failed: OTP code empty');
      errorMessage.value = 'OTP code is required';
      return;
    }

    if (phoneController.text.isEmpty) {
      _logDebug('Phone OTP verification failed: Phone number empty');
      errorMessage.value = 'Phone number is required';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    _logDebug('========== VERIFYING PHONE OTP ==========');
    _logDebug('Request: Verifying OTP - Phone=${phoneController.text}, OTP=${otpController.text}');

    try {
      final response = await _supabaseService.client.auth.verifyOTP(
        type: OtpType.sms,
        phone: phoneController.text,
        token: otpController.text,
      );

      _logDebug('Response: Auth response received');
      _logDebug('User ID: ${response.user?.id}');
      _logDebug('User Email: ${response.user?.email}');
      _logDebug('User Phone: ${response.user?.phone}');
      _logDebug('User Created At: ${response.user?.createdAt}');
      _logDebug('Session: ${response.session != null ? "Active" : "Null"}');

      if (response.user != null) {
        // Check if this is a new user - use the timestamp to determine
        final User user = response.user!;

        // Log the raw value to help with debugging
        _logDebug('Raw createdAt value: ${user.createdAt}');

        // Use current time for comparison since determining new user status
        // is challenging due to types - if user just verified OTP, consider new
        _logDebug('Assuming this is a new user based on recent verification');
        authMode.value = AuthMode.completeProfile;

        // Use safer notification approach
        _logDebug('Account created notification - Please complete profile');
      }
    } on AuthException catch (e) {
      _logDebug('AuthException: ${e.statusCode} - ${e.message}');
      errorMessage.value = e.message;
    } catch (e) {
      _logDebug('Error verifying phone OTP: $e');
      errorMessage.value = 'Failed to verify OTP: $e';
    } finally {
      isLoading.value = false;
      _logDebug('========== END VERIFY PHONE OTP ==========');
    }
  }

  // Google Sign-in
  Future<void> signInWithGoogle() async {
    isLoading.value = true;
    errorMessage.value = '';
    
    _logDebug('========== GOOGLE SIGN IN ==========');
    _logDebug('Request: Initiating Google sign-in flow');
    
    try {
      // IMPORTANT: Configure your Google Sign-In properly in Google Cloud Console
      // 1. Create an OAuth client ID for Android (with your app's package name and SHA-1)
      // 2. Create a Web client ID (needed for cross-platform)
      // 3. Make sure the app's package name matches what's registered in Google Cloud
      const String webClientId = '623834511492-19iqtda3tu04r0qd1jr40etdjr2il7kh.apps.googleusercontent.com';
 
      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile'],
        serverClientId: webClientId, // Needed for obtaining idToken
      );
      
      // Sign out first to ensure we don't get cached credentials
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        _logDebug('Signed out previous Google session');
      }
      
      // Trigger Google sign-in flow
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      
      // If sign-in was cancelled
      if (googleUser == null) {
        _logDebug('Google sign-in was cancelled by user');
        isLoading.value = false;
        return;
      }
      
      _logDebug('Google sign-in successful for: ${googleUser.email}');
      
      // Get auth details from Google sign-in
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      
      // Get ID token and access token
      final String? idToken = googleAuth.idToken;
      final String? accessToken = googleAuth.accessToken;
      
      _logDebug('ID Token received: ${idToken != null ? 'Yes' : 'No'}');
      _logDebug('Access Token received: ${accessToken != null ? 'Yes' : 'No'}');
      
      if (idToken == null) {
        throw Exception('Could not get ID token from Google. Ensure serverClientId is correct and configured for web auth in Google Cloud Console.');
      }
      
      // Sign in to Supabase with Google tokens
      final response = await _supabaseService.client.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken, // Optional: Supabase mostly uses idToken for verification
      );
      
      _logDebug('Supabase auth successful');
      _logDebug('User ID: ${response.user?.id}');
      _logDebug('User Email: ${response.user?.email}');
      
      // Navigate or update UI based on successful login
      // You can add navigation code here if needed
      
    } on AuthException catch (e) {
      _logDebug('AuthException: ${e.statusCode} - ${e.message}');
      errorMessage.value = e.message;
    } catch (e) {
      _logDebug('Error during Google sign-in: $e');
      // Format error message for better debugging
      String errorMsg = e.toString();
      if (errorMsg.contains('ApiException: 10')) {
        errorMsg = 'Configuration error: Ensure your Google Cloud OAuth setup is correct with proper SHA-1 fingerprint and package name.';
      }
      errorMessage.value = 'Failed to sign in with Google: $errorMsg';
    } finally {
      isLoading.value = false;
      _logDebug('========== END GOOGLE SIGN IN ==========');
    }
  }

  // Complete user profile after phone authentication
  Future<void> completeProfile() async {
    // Validate user data
    if (firstNameController.text.isEmpty || lastNameController.text.isEmpty) {
      _logDebug('Profile completion validation failed: Name fields empty');
      errorMessage.value = 'Please provide your full name';
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

    _logDebug('========== COMPLETING USER PROFILE ==========');
    _logDebug('Request: Updating profile for user after phone authentication');

    try {
      // Get current user
      final currentUser = _supabaseService.getCurrentUser();

      if (currentUser == null) {
        throw Exception('No authenticated user found');
      }

      _logDebug('Current user ID: ${currentUser.id}');

      // Prepare user data
      final userData = {
        'id': currentUser.id, // Use the user ID from auth as the profile ID
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        'birth_date': birthdateController.text.isNotEmpty ? birthdateController.text : null,
        'phone_number': currentUser.phone,
        'updated_at': DateTime.now().toIso8601String(),
      };

      _logDebug('Profile data to update: $userData');

      // Update profile in database
      await _supabaseService.client
          .from('profiles')
          .upsert(userData)
          .select(); // .select() is good for returning the updated row

      _logDebug('Profile updated successfully');
      // Use safer notification approach
      _logDebug('Profile updated notification - Success');

      // Reset mode to sign in
      authMode.value = AuthMode.signIn;

      // Clear form fields
      firstNameController.clear();
      lastNameController.clear();
      birthdateController.clear();

    } on PostgrestException catch (e) {
      _logDebug('PostgrestException: ${e.code} - ${e.message}');
      errorMessage.value = 'Database error: ${e.message}';
    } catch (e) {
      _logDebug('Error updating profile: $e');
      errorMessage.value = 'Failed to update profile: $e';
    } finally {
      isLoading.value = false;
      _logDebug('========== END COMPLETING USER PROFILE ==========');
    }
  }

  // Sign out the current user
  Future<void> signOut() async {
    _logDebug('========== SIGNING OUT ==========');
    isLoading.value = true;
    
    try {
      _logDebug('Attempting to sign out current user');
      final currentUser = _supabaseService.getCurrentUser();
      _logDebug('Current user: ${currentUser?.email ?? currentUser?.phone ?? 'None'}');
      
      await _supabaseService.client.auth.signOut();
      
      // Also sign out from Google if user was signed in with Google
      final GoogleSignIn googleSignIn = GoogleSignIn();
      if (await googleSignIn.isSignedIn()) {
        await googleSignIn.signOut();
        _logDebug('Signed out from Google as well');
      }

      _logDebug('Sign out completed successfully');
      
      // Clear all form data
      emailController.clear();
      passwordController.clear();
      phoneController.clear();
      otpController.clear();
      firstNameController.clear();
      lastNameController.clear();
      birthdateController.clear();

      // Reset states
      isOtpSent.value = false;
      errorMessage.value = '';
      authMode.value = AuthMode.signIn;

      // Use safer notification approach
      _logDebug('Sign out notification - Success');

      // App router will handle redirect to auth screen

    } catch (e) {
      _logDebug('Error during sign out: $e');
      errorMessage.value = 'Failed to sign out: $e';
    } finally {
      isLoading.value = false;
      _logDebug('========== END SIGNING OUT ==========');
    }
  }

  void setAuthMode(AuthMode mode) {
    _logDebug('Setting auth mode: $mode');
    authMode.value = mode;
    errorMessage.value = '';
    isOtpSent.value = false;
  }
}