// lib/main.dart

import 'package:flutter/material.dart';
import 'package:kmasset_aplikasi/splash_screen.dart'; // Import halaman splash screen
import 'package:flutter_localizations/flutter_localizations.dart';

final GlobalKey<ScaffoldMessengerState> rootScaffoldMessengerKey =
    GlobalKey<ScaffoldMessengerState>();

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  Locale _locale = const Locale('id');

  void setThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KMAsset',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor:
            const Color.fromARGB(255, 9, 57, 81), // Warna utama aplikasi
        visualDensity: VisualDensity.adaptivePlatformDensity,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
        primaryColor: const Color.fromARGB(255, 9, 57, 81),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      themeMode: _themeMode,
      debugShowCheckedModeBanner: false, // Untuk menyembunyikan banner "DEBUG"
      locale: _locale,
      supportedLocales: const [
        Locale('id'),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      scaffoldMessengerKey: rootScaffoldMessengerKey,
      home: const SplashScreen(),
    );
  }
}
