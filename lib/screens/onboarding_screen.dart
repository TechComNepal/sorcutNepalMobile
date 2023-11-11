import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sortcutnepal/models/onbaord.dart';
import 'package:sortcutnepal/utils/size_config.dart';

import '../utils/exporter.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key}) : super(key: key);
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late PageController _controller;

  @override
  void initState() {
    _controller = PageController();
    super.initState();
  }

  int _currentPage = 0;
  List colors = const [
    Color(0xff5C75AA),
    Color(0xff5C75AA),
    Color(0xff5C75AA),
    Color(0xff5C75AA),
    // Color(0xffFFE5DE),
    // Color(0xffDCF6E6),
  ];

  AnimatedContainer _buildDots({
    int? index,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(50),
        ),
        // color: Color(0xFF000000),
        color: Color.fromARGB(255, 33, 44, 69),
      ),
      margin: const EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: _currentPage == index ? 20 : 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double width = SizeConfig.screenW!;
    double height = SizeConfig.screenH!;

    return Scaffold(
      backgroundColor: colors[_currentPage],
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor: Colors.white12, // Color of you choice
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              ClipPath(
                clipper: CustomShape(),
                child: Container(
                  height: 200,
                  color: Colors.white12,
                ),
              ),
              Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: PageView.builder(
                      physics: const BouncingScrollPhysics(),
                      controller: _controller,
                      onPageChanged: (value) =>
                          setState(() => _currentPage = value),
                      itemCount: contents.length,
                      itemBuilder: (context, i) {
                        return Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            children: [
                              Image.asset(
                                "assets/sortcut.png",
                                height: SizeConfig.blockV! * 8,
                                // 6
                              ),
                              SizedBox(
                                height: (height >= 840) ? 60 : 50,
                              ),
                              Text(
                                contents[i].title,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  // fontFamily: "Mulish",
                                  color: Colors.white60,
                                  fontWeight: FontWeight.w600,
                                  fontSize: (width <= 550) ? 28 : 35,
                                ),
                              ),
                              const SizedBox(height: 30),
                              Text(
                                contents[i].desc,
                                style: TextStyle(
                                  // fontFamily: "Mulish",
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w300,
                                  fontSize: (width <= 550) ? 14 : 25,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: (height >= 840) ? 60 : 30,
                              ),
                              Image.asset(
                                contents[i].image,
                                height: SizeConfig.blockV! * 26,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // _currentPage + 1 == contents.length
                        //     ? Padding(
                        //         padding: const EdgeInsets.symmetric(horizontal: 10),
                        //         child: ElevatedButton(
                        //           onPressed: () {},
                        //           child: Row(
                        //             children: [
                        //               Text(
                        //                 "GET STARTED",
                        //                 style: TextStyle(color: Colors.white70),
                        //               ),
                        //               Icon(
                        //                 Icons.chevron_right,
                        //                 color: Colors.white60,
                        //               )
                        //             ],
                        //           ),
                        //           style: ElevatedButton.styleFrom(
                        //             backgroundColor: Color(0xfff5C75AA),
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10),
                        //             ),
                        //             padding: (width <= 550)
                        //                 ? EdgeInsets.symmetric(vertical: 20)
                        //                 : EdgeInsets.symmetric(
                        //                     horizontal: width * 0.2, vertical: 25),
                        //             textStyle:
                        //                 TextStyle(fontSize: (width <= 550) ? 13 : 17),
                        //           ),
                        //         ),
                        //       )
                        //     :
                        // 486ccf
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              if (_currentPage + 1 != contents.length)
                                TextButton(
                                  onPressed: () {
                                    _controller.jumpToPage(3);
                                  },
                                  child: const Text(
                                    "SKIP",
                                    style: TextStyle(color: Colors.white54),
                                  ),
                                  style: TextButton.styleFrom(
                                    elevation: 0,
                                    textStyle: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: (width <= 550) ? 13 : 17,
                                    ),
                                  ),
                                ),
                              if (_currentPage + 1 != contents.length)
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: List.generate(
                                    contents.length,
                                    (int index) => _buildDots(
                                      index: index,
                                    ),
                                  ),
                                ),
                              ElevatedButton(
                                onPressed: () {
                                  if (_currentPage + 1 == contents.length) {
                                    box.write('onboard', false);
                                    Navigator.pushReplacementNamed(
                                        context, '/main-bottom-nav');
                                  } else {
                                    _controller.nextPage(
                                      duration:
                                          const Duration(milliseconds: 200),
                                      curve: Curves.easeIn,
                                    );
                                  }
                                },
                                child: _currentPage + 1 == contents.length
                                    ? Row(
                                        children: [
                                          Text(
                                            "GET STARTED",
                                            style: TextStyle(
                                                color: Colors.white70),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Colors.white60,
                                          )
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          Text(
                                            "NEXT",
                                            style: TextStyle(
                                                color: Colors.white60),
                                          ),
                                          Icon(
                                            Icons.chevron_right,
                                            color: Colors.white60,
                                          )
                                        ],
                                      ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xfff5C75AA),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  foregroundColor: const Color(0xfff5C75AA),
                                  elevation: 0,
                                  // padding: (width <= 550)
                                  //     ? const EdgeInsets.symmetric(
                                  //         horizontal: 30, vertical: 20)
                                  //     : const EdgeInsets.symmetric(
                                  //         horizontal: 30, vertical: 25),
                                  textStyle: TextStyle(
                                      fontSize: (width <= 550) ? 13 : 17),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomShape extends CustomClipper<Path> {
  @override
  getClip(Size size) {
    double height = size.height;
    double width = size.width;
    var path = Path();
    path.lineTo(0, height - 80);
    // path.lineTo(0, height);
    path.quadraticBezierTo(width / 2, height + 80, width, height - 80);
    path.lineTo(width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper oldClipper) {
    return true;
  }
}
