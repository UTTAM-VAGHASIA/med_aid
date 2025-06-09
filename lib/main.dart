import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:forui/forui.dart';
import 'package:med_aid/app/app_theme.dart';
import 'package:med_aid/app/app_router.dart';
import 'package:med_aid/app/app_bindings.dart';
import 'package:med_aid/core/widgets/transition_overlay.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: ".env");

  // Initialize Supabase client
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL'] ?? '',
    anonKey: dotenv.env['SUPABASE_ANON_KEY'] ?? '',
  );

  // Initialize global bindings
  AppBindings().dependencies();
  
  // Initialize app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the router instance
    final AppRouter appRouter = Get.find<AppRouter>();

    return GetMaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'MED AID',
      theme: FThemes.zinc.light.toApproximateMaterialTheme(), // Use Zinc theme from forui
      darkTheme: FThemes.zinc.dark.toApproximateMaterialTheme(),
      themeMode: ThemeMode.system,
      routeInformationProvider: appRouter.router.routeInformationProvider,
      routeInformationParser: appRouter.router.routeInformationParser,
      routerDelegate: appRouter.router.routerDelegate,
      builder: (context, child) {
        return FTheme(
          data: Theme.of(context).brightness == Brightness.light
              ? medAidLightTheme
              : medAidDarkTheme,
          child: TransitionOverlay(child: child!),
        );
      },
    );
  }
}
