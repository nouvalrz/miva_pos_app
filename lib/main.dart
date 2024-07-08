import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:get/get.dart';
import 'package:miva_pos_app/app/services/powersync_service.dart';
import 'package:miva_pos_app/app/services/supabase_service.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
      ],
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('id', 'ID'), // Indonesian
      ],
      title: "Application",
      initialRoute:
          isLoggedInStatus ? AppPages.WITH_SESSION : AppPages.WITHOUT_SESSION,
      getPages: AppPages.routes,
    ),
  );
}
