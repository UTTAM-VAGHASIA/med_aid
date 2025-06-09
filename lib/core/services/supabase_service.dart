import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService extends GetxService {
  late final SupabaseClient _supabaseClient;
  
  Future<SupabaseService> init() async {
    _supabaseClient = Supabase.instance.client;
    return this;
  }
  
  // Get Supabase client
  SupabaseClient get client => _supabaseClient;
  
  // Authentication state changes stream
  Stream<AuthState> get onAuthStateChange => _supabaseClient.auth.onAuthStateChange;
  
  // Authentication methods
  Future<AuthResponse> signInWithPassword({required String email, required String password}) async {
    return await _supabaseClient.auth.signInWithPassword(email: email, password: password);
  }
  
  Future<AuthResponse> signUp({required String email, required String password, Map<String, dynamic>? data}) async {
    return await _supabaseClient.auth.signUp(email: email, password: password, data: data);
  }
  
  Future<void> signOut() async {
    await _supabaseClient.auth.signOut();
  }
  
  Future<void> sendPhoneOtp(String phone) async {
    await _supabaseClient.auth.signInWithOtp(phone: phone);
  }
  
  Future<AuthResponse> verifyPhoneOtp({required String phone, required String token}) async {
    return await _supabaseClient.auth.verifyOTP(type: OtpType.sms, phone: phone, token: token);
  }
  
  Future<void> signInWithGoogle() async {
    await _supabaseClient.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: 'io.supabase.medaid://login-callback/',
    );
  }
  
  User? getCurrentUser() {
    return _supabaseClient.auth.currentUser;
  }
  
  // Profile operations
  Future<void> updateUserProfile({required String userId, required Map<String, dynamic> data}) async {
    await _supabaseClient
        .from('profiles')
        .update(data)
        .eq('id', userId);
  }
  
  // Equipment categories operations
  Future<List<dynamic>> fetchCategories() async {
    final response = await _supabaseClient
        .from('equipment_categories')
        .select()
        .order('name', ascending: true);
    return response;
  }
  
  // Equipment items operations
  Future<List<dynamic>> fetchEquipmentItems({String? categoryId, String? location}) async {
    var query = _supabaseClient
        .from('equipment_items')
        .select('*, equipment_categories(name)')
        .eq('status', 'available');
    
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    
    if (location != null) {
      query = query.eq('location', location);
    }
    
    final response = await query;
    return response;
  }
  
  // NGO operations
  Future<List<dynamic>> fetchNGOs({required String location}) async {
    final response = await _supabaseClient
        .from('ngos')
        .select()
        .eq('location', location);
    return response;
  }
  
  Future<List<dynamic>> fetchNGOEquipment({required String ngoId, String? categoryId}) async {
    var query = _supabaseClient
        .from('equipment_items')
        .select('*, equipment_categories(name)')
        .eq('ngo_id', ngoId)
        .eq('status', 'available');
    
    if (categoryId != null) {
      query = query.eq('category_id', categoryId);
    }
    
    final response = await query;
    return response;
  }
}
