import 'package:chatgpt_tqnia/Core/Managers/font_manager.dart';
import 'package:flutter/material.dart';

class FaqPage extends StatelessWidget {
  const FaqPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  SafeArea(child: Scaffold(

      body: Column(
        children: [
          Container(
            height: 60,
            padding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                    )),
                const SizedBox(
                  width: 8,
                ),
                Text("FAQ",style: TextStyle(fontFamily: FontManager.ralewayFont),),
                const Expanded(
                    child: SizedBox(
                      width: 10,
                    )),
                Image.asset(
                  "assets/chatgpt_icon.png",
                  height: 36,
                  width: 36,
                )
              ],
            ),
          ),
          Expanded(child: Container())

        ],
      ),
    ));
  }
}
