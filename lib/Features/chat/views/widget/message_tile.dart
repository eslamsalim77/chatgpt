import 'package:chatgpt_tqnia/Core/Managers/font_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../Core/Managers/icons_manager.dart';

class MessageTile extends StatefulWidget {
  final String message;
   bool? isLoading = false;
  final bool sentByMe;

   MessageTile(
      {Key? key,
        required this.message,
         this.isLoading,
        required this.sentByMe})
      : super(key: key);

  @override
  State<MessageTile> createState() => _MessageTileState();
}

class _MessageTileState extends State<MessageTile> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.only(
              top: 4,
              bottom: 4,
              left: widget.sentByMe ? 0 : 24,
              right: widget.sentByMe ? 24 : 0),
          alignment: widget.sentByMe ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            margin: widget.sentByMe
                ? const EdgeInsets.only(left: 30)
                : const EdgeInsets.only(right: 30),
            padding:
             EdgeInsets.only(top:widget.isLoading! ?0: 10, bottom: 10, left: 20, right: 20),
            decoration: BoxDecoration(
                borderRadius: widget.sentByMe
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                )
                    : const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                  bottomRight: Radius.circular(8),
                ),
                color: widget.sentByMe
                    ? const Color(0xff10A37F)
                    :  Colors.white24),
            child: Text(widget.isLoading! ? "..." : widget.message,
                textAlign: TextAlign.start,
                style:  TextStyle(fontSize:widget.isLoading! ? 30 : 16, color: Colors.white)),
          ),
        ),
        if(!widget.sentByMe && !widget.isLoading!)...[
          Container(
            padding: const EdgeInsets.only(
                top: 4,
                bottom: 4,
            ),
            alignment: Alignment.centerLeft,
            child: Container(
           //   margin: const EdgeInsets.only(right: 30),
              padding: const EdgeInsets.only(bottom: 10, left: 20, right: 20),
              child: Row(children: [
                 SvgPicture.asset(IconManager.like,color: Colors.white54,),
                const SizedBox(width: 20,),
                 SvgPicture.asset(IconManager.dislike,color: Colors.white54,),
                const SizedBox(width: 35,),

                InkWell(
                  onTap: () async{
                    await Clipboard.setData(ClipboardData(text: widget.message));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Copied to Clipboard"),
                      ),
                    );
                  },
                  child:  Row(children: [
                    SvgPicture.asset(IconManager.copy,color: Colors.white54,),
                    const SizedBox(width: 4,),
                     Text("Copy",style: TextStyle(color: Colors.white54,fontFamily: FontManager.ralewayFont),)
                  ],),
                )
              ],),
            ),
          ),
        ]
      ],
    );
  }
}