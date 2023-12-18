
import 'package:chatgpt_tqnia/Core/Managers/color_manager.dart';
import 'package:chatgpt_tqnia/Features/Splash/presentation/splash.dart';
import 'package:chatgpt_tqnia/Features/intro/presentation/views/intro.dart';
import 'package:flutter/material.dart';

import 'Features/dashboard/presentation/views/dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      builder: (context, child) {
        final MediaQueryData data = MediaQuery.of(context);
        return MediaQuery(
          data: data.copyWith(
              textScaleFactor:
              data.textScaleFactor >= 1.3 ? 1.2 : data.textScaleFactor),
          child: child!,
        );
      },
      theme: ThemeData.dark().copyWith(scaffoldBackgroundColor: const Color(0xff343541)),
      home:  const SplashScreen(),
    );
  }
}
