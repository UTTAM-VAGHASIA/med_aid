import 'package:app_links/app_links.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:med_aid/app/app_router.dart';
import 'dart:developer' as developer;

class DeepLinkService extends GetxService {
  final AppLinks _appLinks = AppLinks();

  Future<DeepLinkService> init() async {
    _listenForLinks();
    developer.log('DeepLinkService initialized', name: 'DeepLinkService');
    return this;
  }

  void _listenForLinks() {
    _appLinks.uriLinkStream.listen((uri) async {
      developer.log('Deep link received: $uri', name: 'DeepLinkService');

      // Handle deep links
      if (uri.toString().contains('auth-callback') ||
          uri.toString().contains('login-callback')) {
        developer.log('Auth callback detected', name: 'DeepLinkService');

        // Give Supabase a moment to process the authentication
        await Future.delayed(const Duration(milliseconds: 500));

        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          developer.log(
            'Valid session found, user: ${session.user.email ?? session.user.phone}',
            name: 'DeepLinkService',
          );
          Get.offAllNamed(AppRoute.locationSelection.name);
        } else {
          developer.log(
            'No valid session found after callback',
            name: 'DeepLinkService',
          );
        }
      }
    });
  }
}
