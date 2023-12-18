import 'package:chatgpt_tqnia/Core/Managers/color_manager.dart';
import 'package:chatgpt_tqnia/Core/Managers/font_manager.dart';
import 'package:chatgpt_tqnia/Core/Managers/icons_manager.dart';
import 'package:chatgpt_tqnia/Core/Managers/size_manager.dart';
import 'package:chatgpt_tqnia/Core/Managers/text_styles.dart';
import 'package:chatgpt_tqnia/Core/extensions/context_extension.dart';
import 'package:chatgpt_tqnia/Features/dashboard/presentation/views/dashboard.dart';
import 'package:chatgpt_tqnia/Features/intro/data/model/intro_model.dart';
import 'package:flutter/material.dart';

class Intro extends StatefulWidget {
  const Intro({super.key});

  @override
  State<Intro> createState() => _IntroState();
}

class _IntroState extends State<Intro> {
  PageController pageController = PageController();
  int position = 0;

  List<IntroModel> data = [
    IntroModel(
      title: 'Examples',
      icon: IconManager.intro1,
      descriptions: [
        "“Explain quantum computing in simple terms”",
        "“Got any creative ideas for a 10 year old’s birthday?”",
        "“How do I make an HTTP request in Javascript?”"
      ],
    ),
    IntroModel(
      title: 'Capabilities',
      icon: IconManager.intro2,
      descriptions: [
        "Remembers what user said earlier in the conversation",
        "Allows user to provide follow-up corrections",
        "Trained to decline inappropriate requests"
      ],
    ),
    IntroModel(
      title: 'Limitations',
      icon: IconManager.intro3,
      descriptions: [
        "May occasionally generate incorrect information",
        "May occasionally produce harmful instructions or biased content",
        "Limited knowledge of world and events after 2021"
      ],
    )
  ];

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.screenWidth,
        height: context.screenHeight,
        child: ListView(
          shrinkWrap: true,
          children: [

            SizedBox(
              height: context.screenHeight * 0.05,
            ),

            Column(
              children: [
                Image.asset(
                  IconManager.iconSplash,
                  width: 40,
                  height: 40,
                ),
                Text(
                  'Welcome to',
                  style: TextStyleManager.textStyleBold
                      .copyWith(fontSize: SizeManager.sizeFont25,fontFamily: FontManager.ralewayFont),
                ),
                Text(
                  'ChatGPT',
                  style: TextStyleManager.textStyleBold
                      .copyWith(fontSize: SizeManager.sizeFont25,fontFamily: FontManager.ralewayFont),
                ),
                const SizedBox(
                  height: SizeManager.sizeSpacing25,
                ),
                Text(
                  'Ask anything, get your answer',
                  style: TextStyleManager.textStyleRegular
                      .copyWith(fontSize: SizeManager.sizeFont18,fontFamily: FontManager.ralewayFont),
                ),
              ],
            ),

            SizedBox(
              height: context.screenHeight * 0.05,
            ),
            SizedBox(
              width: context.screenWidth,
              height: context.screenHeight * 0.45,
              child: PageView.builder(
                itemCount: data.length,
                controller: pageController,
                allowImplicitScrolling: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  var itemIntro = data[index];
                  return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: ListView(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        Column(
                          children: [
                            Image.asset(itemIntro.icon,height: 30,width: 30,),
                            const SizedBox(
                              height: SizeManager.sizeSpacing8,
                            ),
                            Text(
                              itemIntro.title,
                              style: TextStyleManager.textStyleBold
                                  .copyWith(fontSize: 21,fontFamily: FontManager.ralewayFont),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: context.screenHeight * 0.03,
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: itemIntro.descriptions.length,
                            itemBuilder: (context, index) {
                              return Container(
                                height: context.screenHeight * 0.08,
                                margin: const EdgeInsets.symmetric(
                                    horizontal: SizeManager.sizeSpacing20,
                                    vertical: SizeManager.sizeSpacing8),
                                padding: const EdgeInsets.all(4.0),
                                decoration: BoxDecoration(
                                    color: ColorManager.white.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Center(
                                  child: Text(
                                    itemIntro.descriptions[index],
                                    textAlign: TextAlign.center,
                                    style: TextStyleManager.textStyleRegular,
                                  ),
                                ),
                              );
                            })
                      ],
                    ),
                    // child: ImageAssets(
                    //   image: introImgList[index],
                    //   width: MediaQuery.of(context).size.width,
                    //   boxFit: BoxFit.fill,
                    //   height: MediaQuery.of(context).size.height,
                    // ),
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    position = index;
                  });
                },
              ),
            ),
            SizedBox(
              height: context.screenHeight * 0.05,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  width: context.screenWidth * 0.55,
                  height: 2,
                  child: ListView.builder(
                      padding: EdgeInsets.zero,
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          width: 30,
                          height: 2,
                          margin: const EdgeInsets.symmetric(
                              horizontal: SizeManager.sizeSpacing8),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: position == index
                                ? ColorManager.green
                                : ColorManager.white.withOpacity(0.2),
                          ),
                        );
                      }),
                ),
              ],
            ),

            SizedBox(
              height: context.screenHeight * 0.02,
            ),

            InkWell(
              onTap: () async {
                if(position == data.length - 1){
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) {
                        return  DashboardPage();
                      }));
                }else {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn);
                }
              },
              child: Container(
                padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                height: context.screenHeight * 0.07,
                margin: const EdgeInsets.symmetric(
                    horizontal: SizeManager.sizeSpacing20,
                    vertical: SizeManager.sizeSpacing8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: ColorManager.green,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: position == data.length - 1
                    ?  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Let's Chat",
                            style: TextStyleManager.textStyleSemiBold,
                          ),
                          const SizedBox(
                            width: SizeManager.sizeSpacing10,
                          ),
                          const Icon(
                            Icons.arrow_forward,
                            size: 20,
                          )
                        ],
                      )
                    :  Text(
                        'Next',
                        style: TextStyleManager.textStyleSemiBold,
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
