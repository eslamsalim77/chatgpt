import 'dart:convert';

import 'package:chatgpt_tqnia/Core/Managers/font_manager.dart';
import 'package:chatgpt_tqnia/Core/Managers/icons_manager.dart';
import 'package:chatgpt_tqnia/Core/extensions/context_extension.dart';
import 'package:chatgpt_tqnia/Features/chat/views/widget/message_tile.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatGpt extends StatefulWidget {
  List<Map<String, dynamic>>? listPreviosChat = [];
  int? indexChat;
   ChatGpt({super.key, this.listPreviosChat,this.indexChat});

  @override
  State<ChatGpt> createState() => _ChatGptState();
}

class _ChatGptState extends State<ChatGpt> {
  TextEditingController controller = TextEditingController();
  bool isLoadingMsg = false;
  List<Map<String, dynamic>> listChat = [
   /*
    {"is_me":true,"msg":"why sky blue?"},
    {"is_me":false,"msg":"The sky appears "}
  */
  ];

  @override
  void initState() {
    super.initState();
    if(widget.listPreviosChat != null && widget.listPreviosChat!.isNotEmpty) {
      setState(() {
        listChat = List.from(widget.listPreviosChat!);
    });
    }
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }


 void saveData(List<Map<String, dynamic>> dataList) async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
   String jsonString = jsonEncode(dataList);
   prefs.setString('dataListKey', jsonString);
 }

  Future<List<Map<String, dynamic>>> loadData() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('dataListKey');

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Map<String, dynamic>> dataList = List<Map<String, dynamic>>.from(jsonList);

      return dataList;
    } else {
      return [];
    }
  }


  @override
  Widget build(BuildContext context) {
    print("listChatlistChat $listChat");
    return SafeArea(
      child: Scaffold(
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
                     Text("Back",style: TextStyle(fontFamily: FontManager.ralewayFont),),
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
              Container(
                color: Colors.white54,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                height: 1,
                width: context.screenWidth,
              ),
              Expanded(
                child:listChat.isEmpty? Center(child: Text("Ask anything, get your answer",style: TextStyle(color: Colors.white54,fontFamily: FontManager.ralewayFont),),) :ListView.builder(
                  reverse: true, // Reverse the order of items
                  itemCount:
                      isLoadingMsg ? listChat.length + 1 : listChat.length,
                  itemBuilder: (context, index) {
                    List<Map<String, dynamic>> listChatReverse =
                        listChat.reversed.toList();
                    return isLoadingMsg && (index == 0)
                        ? MessageTile(
                            message: "", sentByMe: false, isLoading: true)
                        : MessageTile(
                            message: listChatReverse[
                                isLoadingMsg ? index - 1 : index]['msg'],
                            sentByMe: listChatReverse[
                                isLoadingMsg ? index - 1 : index]['is_me'],
                            isLoading: false);
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              if(listChat.isNotEmpty && !listChat.last['is_me'])...[
                InkWell(
                  onTap: () {
                    setState(() {
                      listChat.removeLast();
                    });
                    sendMessageGPT(context, message: listChat.last["msg"]);
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 6),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 4,vertical: 4),
                    alignment: Alignment.center,
                    constraints: BoxConstraints(
                        maxWidth: context.screenWidth / 2),
                    height: 32,
                    decoration: BoxDecoration(
                        color: const Color(0xff202123),
                        border: Border.all(color: Colors.white24),
                        borderRadius: BorderRadius.circular(6)),
                    child:  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(IconManager.refresh,color: Colors.white,),
                        const SizedBox(
                          width: 4,
                        ),
                        FittedBox(child: Text("Regenerate response",style: TextStyle(fontFamily: FontManager.ralewayFont),))
                      ],
                    ),
                  ),
                ),
              ],
              txtFormF()
            ],
          ),
      ),
    );
  }

  Widget txtFormF() {
    return Container(
      margin: const EdgeInsets.only(
          bottom: 35 ,//+ MediaQuery.of(context).viewInsets.bottom,
          right: 12,
          left: 12),
      padding: const EdgeInsets.only(left: 12),
      height: 50,
      width: context.screenWidth - 40,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white12,
          border: Border.all(color: Colors.white38)),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
            hintText: '',
            suffixIcon: Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () async {
                  if (controller.text.trim().isNotEmpty && !isLoadingMsg) {
                    setState(() {
                      listChat = List.from(listChat)
                        ..add({"is_me": true, "msg": controller.text.trim()});
                      controller.clear();
                      // isLoadingMsg = true;
                    });
                    sendMessageGPT(context, message: controller.text.trim());
                  }
                },
                child: Container(
                  height: 40,
                  width: 30,
                  decoration: BoxDecoration(
                    color: const Color(0xff10A37F),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child:
                  Center(child: SvgPicture.asset(IconManager.send,height: 21,width: 21,color: Colors.white,))

                ),
              ),
            ),
            counterText: "",
            border: InputBorder.none),
      ),
    );
  }

  // Send Message using ChatGPT API
  Future sendMessageGPT(BuildContext context, {required String message}) async {
    try {
      setState(() => isLoadingMsg = true);

      final response = await http.post(
        Uri.parse("https://api.openai.com/v1/chat/completions"),
        headers: {
          'Authorization':
              'Bearer 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',
          "Content-Type":
              "application/json" // "application/json; charset=utf-8"
        },
        body: jsonEncode(
          {
            "model": "gpt-3.5-turbo-16k",
            // "max_tokens": 16000,
            "messages": [
              {
                "role": "user",
                "content": message,
              }
            ]
          },
        ),
      );

      Map jsonResponse = jsonDecode(response.body);
      //  print("sendMessageGPT $jsonResponse");
      setState(() {
        isLoadingMsg = false;
        listChat.add({
          "msg": jsonResponse["choices"][0]["message"]["content"],
          "is_me": false,
        });
      });

      List<Map<String, dynamic>> listAll = await loadData();
      if(widget.indexChat != null){
         listAll[widget.indexChat!] = {"name": listChat[0]["msg"],"list":listChat};
        saveData(listAll);
      }else{
        listAll.add({"name": listChat[0]["msg"],"list":listChat});
        saveData(listAll);
        widget.indexChat = listAll.length - 1;
      }

      print("get list save $listAll");
      return;
    } catch (error) {
      setState(() => isLoadingMsg = false);
      rethrow;
    }
  }
}
