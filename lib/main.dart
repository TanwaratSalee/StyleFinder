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
      // title: appname,
      theme: ThemeData(
          scaffoldBackgroundColor: Colors.transparent,
          appBarTheme: const AppBarTheme(
              iconTheme: IconThemeData(color: fontBlack),
              elevation: 0.0,
              backgroundColor: Colors.transparent),
          fontFamily: light),
      home: const SplashScreen(),
    );
  }
}
