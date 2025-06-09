import 'package:get/get.dart';
import 'package:med_aid/core/services/supabase_service.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/core/services/deep_link_service.dart';
import 'package:med_aid/features/splash/bindings/splash_binding.dart';
import 'package:med_aid/core/controllers/transition_controller.dart';
import 'package:med_aid/features/auth/bindings/auth_binding.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register core services
    Get.putAsync(() => SupabaseService().init());
    Get.putAsync(() => DeepLinkService().init());
    
    // Register global controllers first
    Get.put(TransitionController());
    
    // Register router (depends on TransitionController)
    Get.put(AppRouter());
    
    // Register feature bindings
    SplashBinding().dependencies();
    AuthBinding().dependencies();
  }
}
