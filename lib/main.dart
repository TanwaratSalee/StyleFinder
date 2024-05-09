import 'package:flutter/material.dart';
import 'package:flutter_finalproject/Views/splash_screen/splash_screen.dart';
import 'package:flutter_finalproject/consts/colors.dart';
import 'package:flutter_finalproject/consts/styles.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          // Manually defined ColorScheme
          colorScheme: ColorScheme(
            brightness: Brightness.light,
            primary: thinPrimaryApp,
            onPrimary: whiteColor,
            secondary: whiteColor,
            onSecondary: blackColor,
            error: redColor,
            onError: whiteColor,
            background: whiteColor,
            onBackground: blackColor,
            surface: whiteColor,
            onSurface: blackColor,
          ),
          dialogBackgroundColor: whiteColor,
          scaffoldBackgroundColor: whiteColor,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: blackColor),
              elevation: 0.0,
              backgroundColor: Colors.transparent),
          primaryColor: primaryApp,
          fontFamily: regular),
      home: const SplashScreen(),
    );
  }
}
