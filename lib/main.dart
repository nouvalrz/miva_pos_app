import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:miva_pos_app/app/services/powersync_service.dart';
import 'package:miva_pos_app/app/services/supabase_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Hide status bar
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Load .env
  await dotenv.load(fileName: ".env");

  // Load powersync database
  await openDatabase();

  // Session checking from Supabase
  final bool isLoggedInStatus = isLoggedIn();

  runApp(
    GetMaterialApp(
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        FormBuilderLocalizations.delegate
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('id', 'ID'), // Indonesian
      ],
      title: "Application",
      initialRoute:
          isLoggedInStatus ? AppPages.WITH_SESSION : AppPages.WITHOUT_SESSION,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: mivaTheme(),
    ),
  );
}

//TODO : Move
ThemeData mivaTheme() {
  var baseTextTheme = GoogleFonts.interTextTheme();

  var mivaTextTheme = baseTextTheme.copyWith(
    displayLarge: baseTextTheme.displayLarge?.copyWith(letterSpacing: 0.0),
    displayMedium: baseTextTheme.displayMedium?.copyWith(letterSpacing: 0.0),
    displaySmall: baseTextTheme.displaySmall?.copyWith(letterSpacing: 0.0),
    headlineLarge: baseTextTheme.headlineLarge?.copyWith(letterSpacing: 0.0),
    headlineMedium: baseTextTheme.headlineMedium?.copyWith(letterSpacing: 0.0),
    headlineSmall: baseTextTheme.headlineSmall?.copyWith(letterSpacing: 0.0),
    titleLarge: baseTextTheme.titleLarge?.copyWith(letterSpacing: 0.0),
    titleMedium: baseTextTheme.titleMedium?.copyWith(letterSpacing: 0.0),
    titleSmall: baseTextTheme.titleSmall?.copyWith(letterSpacing: 0.0),
    bodyLarge: baseTextTheme.bodyLarge?.copyWith(letterSpacing: 0.0),
    bodyMedium: baseTextTheme.bodyMedium?.copyWith(letterSpacing: 0.0),
    bodySmall: baseTextTheme.bodySmall?.copyWith(letterSpacing: 0.0),
    labelLarge: baseTextTheme.labelLarge?.copyWith(letterSpacing: 0.0),
    labelMedium: baseTextTheme.labelMedium?.copyWith(letterSpacing: 0.0),
    labelSmall: baseTextTheme.labelSmall?.copyWith(letterSpacing: 0.0),
  );

  var mivaTheme = ThemeData(
    colorSchemeSeed: const Color(0xFF40228C),
    textTheme: mivaTextTheme,
  );

  return mivaTheme;
}
