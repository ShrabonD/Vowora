import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/services/supabase_service.dart';
import 'core/theme/vowora_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/birthday_provider.dart';
import 'providers/wedding_provider.dart';
import 'providers/wedding_wizard_provider.dart';
import 'providers/wedding_ecosystem_provider.dart';
import 'routes/app_routes.dart';
import 'screens/intro_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Safely initialize Supabase auth and postgres services
  await SupabaseService.initialize();

  runApp(const VoworaApp());
}


class VoworaApp extends StatelessWidget {
  const VoworaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => BirthdayProvider()),
        ChangeNotifierProvider(create: (_) => WeddingProvider()),
        ChangeNotifierProvider(create: (_) => WeddingWizardProvider()),
        ChangeNotifierProvider(create: (_) => WeddingEcosystemProvider()),
      ],
      child: MaterialApp(
        title: 'VOWORA - Smart Wedding Planner',
        debugShowCheckedModeBanner: false,
        theme: VoworaTheme.lightTheme,
        // show an enimated intro so this is used
        initialRoute: '/intro',
        routes: <String, WidgetBuilder>{
          ...AppRoutes.routes,
          '/intro': (context) => const IntroScreen(),
        },
      ),
    );
  }
}
