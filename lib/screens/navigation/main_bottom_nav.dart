import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sortcutnepal/controllers/navbarController.dart';
import 'package:sortcutnepal/screens/add_post_screen.dart';
import 'package:sortcutnepal/screens/category_screen.dart';
import 'package:sortcutnepal/screens/home_screen.dart';
import 'package:sortcutnepal/screens/message/no_internet_screen.dart';
import 'package:sortcutnepal/screens/profile_screen.dart';
import 'package:sortcutnepal/screens/wishlist_screen.dart';
import 'package:sortcutnepal/utils/colors.dart';
import 'package:sortcutnepal/utils/exporter.dart';
import 'dart:developer' as developer;

class MainBottomNavScreen extends StatefulWidget {
  const MainBottomNavScreen({super.key});

  @override
  State<MainBottomNavScreen> createState() => _MainBottomNavScreenState();
}

class _MainBottomNavScreenState extends State<MainBottomNavScreen> {
  int currentTab = 0;
  NavBarController navBarController = Get.put(NavBarController());

  var _scrollController = ScrollController();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

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
    initConnectivity();

    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _scrollController.addListener(() {
      print("scrollListener / pixel =>${_scrollController.position.pixels}");
    });
  }

// Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Couldn\'t check connectivity status', error: e);
      return;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return Future.value(null);
    }

    return _updateConnectionStatus(result);
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    setState(() {
      _connectionStatus = result;
    });
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }

  // This is what you're looking for!
  void _scrollDown() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(seconds: 2),
      curve: Curves.fastOutSlowIn,
    );
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
          child: _connectionStatus == ConnectivityResult.none
              ? const NoInternetScreen()
              : NotificationListener<ScrollNotification>(
                  onNotification: (scrollNotification) {
                    if (scrollNotification is ScrollStartNotification) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        print(
                            "ScrollStartNotification / pixel => ${scrollNotification.metrics.pixels}");
                        if (scrollNotification.metrics.pixels == 0) {
                          visibility = true;
                        } else if (scrollNotification.metrics.pixels > 200) {
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
                  child: screens[currentTab]
                  // ListView(
                  //   physics: const ClampingScrollPhysics(),
                  //   controller: _scrollController,
                  //   children: [
                  //     ConstrainedBox(
                  //         constraints: BoxConstraints(
                  //             maxHeight:
                  //                 // _scrollController.position.maxScrollExtent
                  //                 MediaQuery.of(context).size.height * 8),
                  //         child: screens[currentTab]),
                  //   ],
                  // ),
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
            color: AppColors.whiteColor,
          ),
        ),
      ),
      bottomNavigationBar: GetBuilder<NavBarController>(builder: (controller) {
        // if (controller.scrollY.value > 0) {

        // }

        // if (controller.scrollY.value == 0) {
        //   visibility = true;
        // } else {
        //   visibility = false;
        // }
        return Obx(() => controller.scrollY.value >= 0
            ? Visibility(
                visible: visibility =
                    controller.scrollY.value <= 10 ? false : true,
                child: Theme(
                  data: Theme.of(context)
                      .copyWith(canvasColor: Colors.transparent),
                  child: BottomAppBar(
                    color: AppColors.mainColor,
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
                          color: AppColors.mainColor,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentTab = 0;
                                });
                              },
                              child: currentTab == 0
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.home,
                                          color: AppColors.whiteColor,
                                        ),
                                        Text(
                                          "Home",
                                          style: TextStyle(
                                              color: AppColors.whiteColor),
                                        ),
                                        //const Padding(padding: EdgeInsets.all(10))
                                      ],
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.home,
                                          color: AppColors.blackColor,
                                        ),
                                        Text(
                                          "Home",
                                          style: TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                        //const Padding(padding: EdgeInsets.all(10))
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        Material(
                          color: AppColors.mainColor,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentTab = 1;
                                });
                              },
                              child: currentTab == 1
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.group,
                                          color: AppColors.whiteColor,
                                        ),
                                        Text(
                                          "Category",
                                          style: TextStyle(
                                              color: AppColors.whiteColor),
                                        ),
                                        //const Padding(padding: EdgeInsets.all(10))
                                      ],
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.group,
                                          color: AppColors.blackColor,
                                        ),
                                        Text(
                                          "Category",
                                          style: TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                        //const Padding(padding: EdgeInsets.all(10))
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(), //to make space for the floating button
                        Material(
                          color: AppColors.mainColor,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentTab = 2;
                                });
                              },
                              child: currentTab == 2
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: AppColors.whiteColor,
                                        ),
                                        Text(
                                          "Wishlist",
                                          style: TextStyle(
                                              color: AppColors.whiteColor),
                                        ),
                                        //const Padding(padding: EdgeInsets.all(10))
                                      ],
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.favorite,
                                          color: AppColors.blackColor,
                                        ),
                                        Text(
                                          "Wishlist",
                                          style: TextStyle(
                                              color: AppColors.blackColor),
                                        ),
                                        //const Padding(padding: EdgeInsets.all(10))
                                      ],
                                    ),
                            ),
                          ),
                        ),
                        Material(
                          color: AppColors.mainColor,
                          child: Center(
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  currentTab = 3;
                                });
                              },
                              child: currentTab == 3
                                  ? const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: AppColors.whiteColor,
                                        ),
                                        Text(
                                          "Profile",
                                          style: TextStyle(
                                              color: AppColors.whiteColor),
                                        ),
                                        //const Padding(padding: EdgeInsets.all(10))
                                      ],
                                    )
                                  : const Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.person,
                                          color: AppColors.blackColor,
                                        ),
                                        Text(
                                          "Profile",
                                          style: TextStyle(
                                              color: AppColors.blackColor),
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
              )
            : Container());
        // return
        // }
        // return Container();
      }),
    );
  }
}
