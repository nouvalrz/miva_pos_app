import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
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

// Init route observer
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

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
    DevicePreview(
      enabled: true,
      builder: (context) => GetMaterialApp(
        useInheritedMediaQuery: true,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        navigatorObservers: [routeObserver],
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
    ),
  );
}

//TODO : Move
ThemeData mivaTheme() {
  final ThemeData defaultTheme = ThemeData.light();

  // Buat TextTheme baru dengan letterSpacing: 0
  final TextTheme adjustedTextTheme = defaultTheme.textTheme.copyWith(
    bodyLarge: defaultTheme.textTheme.bodyLarge?.copyWith(letterSpacing: 0),
    bodyMedium: defaultTheme.textTheme.bodyMedium?.copyWith(letterSpacing: 0),
    bodySmall: defaultTheme.textTheme.bodySmall?.copyWith(letterSpacing: 0),
    titleLarge: defaultTheme.textTheme.titleLarge?.copyWith(letterSpacing: 0),
    titleMedium: defaultTheme.textTheme.titleMedium?.copyWith(letterSpacing: 0),
    titleSmall: defaultTheme.textTheme.titleSmall?.copyWith(letterSpacing: 0),
    labelLarge: defaultTheme.textTheme.labelLarge?.copyWith(letterSpacing: 0),
    labelMedium: defaultTheme.textTheme.labelMedium?.copyWith(letterSpacing: 0),
    labelSmall: defaultTheme.textTheme.labelSmall?.copyWith(letterSpacing: 0),
    headlineLarge:
        defaultTheme.textTheme.headlineLarge?.copyWith(letterSpacing: 0),
    headlineMedium:
        defaultTheme.textTheme.headlineMedium?.copyWith(letterSpacing: 0),
    headlineSmall:
        defaultTheme.textTheme.headlineSmall?.copyWith(letterSpacing: 0),
    displayLarge:
        defaultTheme.textTheme.displayLarge?.copyWith(letterSpacing: 0),
    displayMedium:
        defaultTheme.textTheme.displayMedium?.copyWith(letterSpacing: 0),
    displaySmall:
        defaultTheme.textTheme.displaySmall?.copyWith(letterSpacing: 0),
  );

  // Terapkan TextTheme yang telah dimodifikasi ke ThemeData
  return ThemeData(
    chipTheme: ChipThemeData(
      backgroundColor: Colors.white,
      disabledColor: const Color.fromARGB(255, 255, 255, 255),
      selectedColor: const Color(0xffF3F1FF),
      secondarySelectedColor: const Color(0xffF3F1FF),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      labelStyle: const TextStyle(
        color: Colors.black, // Pastikan warna teks hitam
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
      secondaryLabelStyle: const TextStyle(
        color: Colors.black, // Pastikan warna teks hitam
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
      ),
    ),

    textTheme: adjustedTextTheme,
    primaryTextTheme: adjustedTextTheme,
    fontFamily: 'Inter', // Pastikan ini sesuai dengan font yang Anda gunakan
    // Salin properti lain dari defaultTheme jika diperlukan
    colorScheme: defaultTheme.colorScheme,
    // ... properti tema lainnya
  );
}
