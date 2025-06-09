import 'package:get/get.dart';
import 'package:med_aid/core/services/supabase_service.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/core/services/deep_link_service.dart';
import 'package:med_aid/features/splash/bindings/splash_binding.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    // Register core services
    Get.putAsync(() => SupabaseService().init());
    Get.putAsync(() => DeepLinkService().init());
    
    // Register router
    Get.put(AppRouter());
    
    // Register feature bindings
    SplashBinding().dependencies();
  }
}
