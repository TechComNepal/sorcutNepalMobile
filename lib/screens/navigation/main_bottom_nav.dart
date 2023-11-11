import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sortcutnepal/screens/add_post_screen.dart';
import 'package:sortcutnepal/screens/category_screen.dart';
import 'package:sortcutnepal/screens/home_screen.dart';
import 'package:sortcutnepal/screens/profile_screen.dart';
import 'package:sortcutnepal/screens/wishlist_screen.dart';
import 'package:sortcutnepal/utils/exporter.dart';

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  static const mainColor = Color(0xff5C75AA);
  static const whiteColor = Color(0xfffcfcfc);
  static const blackColor = Color(0xff0c0c0c);

  int currentTab = 0;
  var _scrollController = ScrollController();

  bool visibility = false;
  // WebviewScreen(url: AppConstants.wishlistUrl),
  // WebviewScreen(url: AppConstants.profileUrl),
  // WebviewScreen(url: AppConstants.adPostUrl),
  var screens = const <Widget>[
    HomeScreen(),
    CategoryScreen(),
    WishlistScreen(),
    ProfileScreen(),
    AddPostScreen(),
  ];

  @override
  void initState() {
    super.initState();
//scrollListener(1)
    _scrollController.addListener(() {
      print("scrollListener / pixel =>${_scrollController.position.pixels}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: const SystemUiOverlayStyle(
            statusBarColor: Color(0xffffffff), // Color of you choice
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.dark,
          ),
          child: NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification is ScrollStartNotification) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  print(
                      "ScrollStartNotification / pixel => ${scrollNotification.metrics.pixels}");
                  if (scrollNotification.metrics.pixels > 200) {
                    visibility = true;
                  }
                });
              } else if (scrollNotification is ScrollEndNotification) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    print(
                        "ScrollEndNotification / pixel =>${scrollNotification.metrics.pixels}");
                  });
                  if (scrollNotification.metrics.pixels == 0) {
                    visibility = true;
                  } else {
                    visibility = false;
                  }
                });
              }

              return true;
            },
            child: ListView(
              physics: ClampingScrollPhysics(),
              controller: _scrollController,
              children: [
                ConstrainedBox(
                    constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 10),
                    child: screens[currentTab]),
              ],
            ),
          )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: visibility,
        child: FloatingActionButton(
          onPressed: () {
            setState(() {
              currentTab = 4;
            });
          },
          backgroundColor: const Color(0xff1965bf),
          shape: const CircleBorder(),
          child: const Icon(
            Icons.add,
            color: whiteColor,
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: visibility,
        child: Theme(
          data: Theme.of(context).copyWith(canvasColor: Colors.transparent),
          child: BottomAppBar(
            color: mainColor,
            shape: const CircularNotchedRectangle(),
            notchMargin: 5,
            clipBehavior: Clip.antiAlias,
            // shadowColor: Colors.transparent,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: getDeviceType() == 'tablet'
                  ? MainAxisAlignment.spaceEvenly
                  : MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Material(
                  color: mainColor,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentTab = 0;
                        });
                      },
                      child: currentTab == 0
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home,
                                  color: whiteColor,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(color: whiteColor),
                                ),
                                //const Padding(padding: EdgeInsets.all(10))
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.home,
                                  color: blackColor,
                                ),
                                Text(
                                  "Home",
                                  style: TextStyle(color: blackColor),
                                ),
                                //const Padding(padding: EdgeInsets.all(10))
                              ],
                            ),
                    ),
                  ),
                ),
                Material(
                  color: mainColor,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentTab = 1;
                        });
                      },
                      child: currentTab == 1
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group,
                                  color: whiteColor,
                                ),
                                Text(
                                  "Category",
                                  style: TextStyle(color: whiteColor),
                                ),
                                //const Padding(padding: EdgeInsets.all(10))
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.group,
                                  color: blackColor,
                                ),
                                Text(
                                  "Category",
                                  style: TextStyle(color: blackColor),
                                ),
                                //const Padding(padding: EdgeInsets.all(10))
                              ],
                            ),
                    ),
                  ),
                ),
                const SizedBox(), //to make space for the floating button
                Material(
                  color: mainColor,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentTab = 2;
                        });
                      },
                      child: currentTab == 2
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: whiteColor,
                                ),
                                Text(
                                  "Wishlist",
                                  style: TextStyle(color: whiteColor),
                                ),
                                //const Padding(padding: EdgeInsets.all(10))
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.favorite,
                                  color: blackColor,
                                ),
                                Text(
                                  "Wishlist",
                                  style: TextStyle(color: blackColor),
                                ),
                                //const Padding(padding: EdgeInsets.all(10))
                              ],
                            ),
                    ),
                  ),
                ),
                Material(
                  color: mainColor,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          currentTab = 3;
                        });
                      },
                      child: currentTab == 3
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: whiteColor,
                                ),
                                Text(
                                  "Profile",
                                  style: TextStyle(color: whiteColor),
                                ),
                                //const Padding(padding: EdgeInsets.all(10))
                              ],
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.person,
                                  color: blackColor,
                                ),
                                Text(
                                  "Profile",
                                  style: TextStyle(color: blackColor),
                                ),
                                //const Padding(padding: EdgeInsets.all(10))
                              ],
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
