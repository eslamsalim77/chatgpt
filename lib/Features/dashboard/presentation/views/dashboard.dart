import 'dart:convert';

import 'package:chatgpt_tqnia/Core/Managers/font_manager.dart';
import 'package:chatgpt_tqnia/Core/Managers/icons_manager.dart';
import 'package:chatgpt_tqnia/Core/extensions/context_extension.dart';
import 'package:chatgpt_tqnia/Features/chat/views/chat_page.dart';
import 'package:chatgpt_tqnia/Features/faq/views/faq.dart';
import 'package:chatgpt_tqnia/Features/intro/presentation/views/intro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DashboardPage extends StatefulWidget {
  DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late List<Map<String, dynamic>> listPrevChats = [];
  List wList = [
    {
      "icon": IconManager.delete,
      "txt": "Clear conversations",
      "clr": Colors.white,
      "ontap": () {},
      "w": null
    },
    {
      "icon": IconManager.person,
      "txt": "Upgrade to Plus",
      "clr": Colors.white,
      "ontap": () {},
      "w": Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: const Color(0xffFBF3AD)),
        child: Center(
          child: Text(
            "New",
            style: TextStyle(
                color: const Color(0xff887B06),
                fontFamily: FontManager.ralewayFont),
          ),
        ),
      )
    },
    {
      "icon": IconManager.mode,
      "txt": "Light mode",
      "clr": Colors.white,
      "ontap": () {},
      "w": null
    },
    {
      "icon": IconManager.faq,
      "txt": "Updates & FAQ",
      "clr": Colors.white,
      "ontap": () {},
      "w": null
    },
    {
      "icon": IconManager.logout,
      "txt": "Logout",
      "clr": const Color(0xffED8C8C),
      "ontap": () {},
      "w": null
    },
  ];

  Future<List<Map<String, dynamic>>> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String? jsonString = prefs.getString('dataListKey');

    if (jsonString != null) {
      List<dynamic> jsonList = jsonDecode(jsonString);

      List<Map<String, dynamic>> dataList =
          List<Map<String, dynamic>>.from(jsonList);

      return dataList;
    } else {
      return [];
    }
  }

  deleteData() async {
    setState(() {
      listPrevChats = [];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('dataListKey');
  }

  void saveData(List<Map<String, dynamic>> dataList) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String jsonString = jsonEncode(dataList);
    prefs.setString('dataListKey', jsonString);
  }

  init() async {
    List<Map<String, dynamic>> list = await loadData();

    if (list != null) {
      setState(() {
        listPrevChats = list;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xff202123),
        body: Column(
          children: [
            SizedBox(
                height: 60,
                child: featureBtn(context,
                    onTap: () => Navigator.of(context)
                            .push(MaterialPageRoute(builder: (_) {
                          return ChatGpt(
                            listPreviosChat: const [],
                          );
                        })).then((value) => init()),
                    icon: IconManager.newChat,
                    txt: "New Chat",
                    clr: Colors.white,
                    w: const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    ))),
            Container(
              color: Colors.white54,
              height: 1,
              width: context.screenWidth - 24,
            ),
            Expanded(
                flex: 2,
                child: ListView.builder(
                    itemCount: listPrevChats.length,
                    itemBuilder: (_, i) {
                      return previousChat(context,
                          txt: listPrevChats[i]["name"],
                          prev: List<Map<String, dynamic>>.from(
                              listPrevChats[i]["list"]),
                          indexChat: i);
                    })),
            Container(
              color: Colors.white54,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ),
              height: 1,
              width: context.screenWidth,
            ),
            Container(
              constraints: BoxConstraints(
                  minHeight: 100, maxHeight: context.screenHeight / 3),
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: wList.length,
                  itemBuilder: (_, i) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: featureBtn(context,
                          icon: wList[i]["icon"],
                          txt: wList[i]["txt"],
                          clr: wList[i]["clr"],
                          w: wList[i]["w"],
                          onTap: wList[i]["ontap"]),
                    );
                  }),
            ),
            const SizedBox(
              height: 16,
            )
          ],
        ),
      ),
    );
  }

  Widget featureBtn(BuildContext context,
      {required String icon,
      required String txt,
      required Color clr,
      Widget? w,
      VoidCallback? onTap}) {
    return InkWell(
      onTap: txt == "Logout"
          ? () => Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) {
                return const Intro();
              }), (route) => false)
          : txt == "Clear conversations"
              ? () => deleteData()
              : txt == "Updates & FAQ"
                  ?  () => Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return const FaqPage();
                      }))
                  : onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
        child: Row(
          children: [
            SvgPicture.asset(
              icon,
              color: clr,
            ),

            //  Image.asset("message"),
            const SizedBox(
              width: 12,
            ),
            Text(
              txt,
              style: TextStyle(color: clr, fontFamily: FontManager.ralewayFont),
            ),
            if (w != null) ...[const Expanded(child: SizedBox()), w]
          ],
        ),
      ),
    );
  }

  Widget previousChat(context,
      {required String txt,
      required int indexChat,
      required List<Map<String, dynamic>> prev}) {
    return InkWell(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) {
        return ChatGpt(
          listPreviosChat: prev,
          indexChat: indexChat,
        );
      })).then((value) => init()),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 12),
            child: Row(
              children: [
                SvgPicture.asset(
                  IconManager.newChat,
                  color: Colors.white54,
                ),
                const SizedBox(
                  width: 12,
                ),
                Text(
                  txt,
                  style: TextStyle(
                      color: Colors.white54,
                      fontFamily: FontManager.ralewayFont),
                ),
                const Expanded(child: SizedBox()),
                Row(
                  children: [
                    PopupMenuButton(
                      offset: const Offset(0, 50),
                      //    shape: const TooltipShape(),
                      itemBuilder: (_) => <PopupMenuEntry>[
                        PopupMenuItem(
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Row(
                                  children: [
                                    SvgPicture.asset(
                                      IconManager.edit,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "Edit",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: FontManager.ralewayFont),
                                    )
                                  ],
                                ))),
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () async {
                              Navigator.pop(context);

                              setState(() {
                                listPrevChats.removeAt(indexChat);
                              });

                              List<Map<String, dynamic>> listAll =
                                  await loadData();
                              listAll.removeAt(indexChat);
                              saveData(listAll);
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset(
                                  IconManager.delete,
                                  color: const Color(0xffED8C8C),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Delete",
                                  style: TextStyle(
                                      color: const Color(0xffED8C8C),
                                      fontFamily: FontManager.ralewayFont),
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                      child: const Icon(
                        Icons.more_vert,
                        size: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                    )
                  ],
                )
              ],
            ),
          ),
          Container(
            color: Colors.white54,
            height: 1,
            width: MediaQuery.of(context).size.width - 24,
          ),
        ],
      ),
    );
  }
}
