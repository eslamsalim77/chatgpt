import 'package:chatgpt_tqnia/Core/Managers/text_styles.dart';
import 'package:chatgpt_tqnia/Core/extensions/context_extension.dart';
import 'package:chatgpt_tqnia/Features/intro/presentation/views/intro.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) {
        return const Intro();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/chatgpt_icon.png',
                width: context.screenWidth * 0.5,
                height: context.screenHeight * 0.3,
              ),
              const SizedBox(
                height: 10,
              ),
              Text("ChatGPT",style: TextStyleManager.textStyleBold.copyWith(fontSize: 35),
              )
            ],
          ),
        ),
      ),
    );
  }
}