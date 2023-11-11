import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:sortcutnepal/screens/message/loading_screen.dart';
import 'dart:developer' as developer;

import 'package:sortcutnepal/screens/message/no_internet_screen.dart';
import 'package:sortcutnepal/screens/message/unable_load_screen.dart';
import 'package:sortcutnepal/utils/constants.dart';
import 'package:sortcutnepal/widgets/alerts.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({Key? key}) : super(key: key);

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  bool showErrorPage = false, isLoading = true;
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  late PullToRefreshController pullToRefreshController;

  final ChromeSafariBrowser browser = new AndroidTWABrowser();

  @override
  void initState() {
    super.initState();

    pullToRefreshController = PullToRefreshController(
      options: PullToRefreshOptions(
        color: Colors.blue,
      ),
      onRefresh: () async {
        if (Platform.isAndroid) {
          webViewController?.reload();
        } else if (Platform.isIOS) {
          webViewController?.loadUrl(
              urlRequest: URLRequest(url: await webViewController?.getUrl()));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Alerts().exitApp(context, webViewController!),
      child: SafeArea(
        child: Column(
          // fit: StackFit.expand,
          children: [
            // isLoading
            //     ? const Center(
            //         child: CircularProgressIndicator(
            //         color: Color(0xff486CCE),
            //       ))
            //     : const SizedBox(),
            if (isLoading)
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: const LoadingScreen()),
            Container(
              height: MediaQuery.of(context).size.height * 10,
              child: NotificationListener<ScrollNotification>(
                onNotification: (scrollNotification) {
                  if (scrollNotification is ScrollStartNotification) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      print(
                          "ScrollStartNotification / pixel => ${scrollNotification.metrics.pixels}");
                    });
                  } else if (scrollNotification is ScrollEndNotification) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {
                        print(
                            "ScrollEndNotification / pixel =>${scrollNotification.metrics.pixels}");
                      });
                    });
                  }

                  return true;
                },
                child: Stack(
                  children: <Widget>[
                    if (!showErrorPage)
                      InAppWebView(
                        shouldOverrideUrlLoading:
                            (controller, navigationAction) async {
                          final uri = navigationAction.request.url!;
                          if (uri.toString() != AppConstants.homeUrl) {
                            return NavigationActionPolicy.ALLOW;
                          }
                          // setState(() {});
                          Navigator.of(context)
                              .pushReplacementNamed('/main-bottom-nav');
                          return NavigationActionPolicy.CANCEL;
                        },
                        key: webViewKey,
                        // androidOnFormResubmission: (controller, url) {

                        // },
                        androidOnPermissionRequest:
                            (InAppWebViewController controller, String origin,
                                List<String> resources) async {
                          return PermissionRequestResponse(
                            resources: resources,
                            action: PermissionRequestResponseAction.GRANT,
                          );
                        },

                        initialOptions: InAppWebViewGroupOptions(
                          crossPlatform: InAppWebViewOptions(
                            javaScriptCanOpenWindowsAutomatically: true,
                            useShouldOverrideUrlLoading: true,
                            mediaPlaybackRequiresUserGesture: true,
                            useOnDownloadStart: true,
                            allowFileAccessFromFileURLs: true,
                            useOnLoadResource: true,
                            supportZoom: false,
                            userAgent: 'random',
                            // incognito: true,
                          ),
                          android: AndroidInAppWebViewOptions(
                            // on Android you need to set supportMultipleWindows to true,
                            // otherwise the onCreateWindow event won't be called
                            supportMultipleWindows: true,
                            useHybridComposition: true,
                            useShouldInterceptRequest: true,
                            useOnRenderProcessGone: true,
                            mixedContentMode: AndroidMixedContentMode
                                .MIXED_CONTENT_ALWAYS_ALLOW,
                            builtInZoomControls: false,
                            allowFileAccess: true,
                            domStorageEnabled: true,
                            databaseEnabled: true,
                          ),
                        ),
                        pullToRefreshController: pullToRefreshController,
                        onReceivedServerTrustAuthRequest:
                            (controller, challenge) async {
                          return ServerTrustAuthResponse(
                              action: ServerTrustAuthResponseAction.PROCEED);
                        },
                        onLoadStop: (controller, url) {
                          setState(() {
                            isLoading = true;
                          });
                          String footerHome = ''' 
                                    document.getElementsByClassName('footer-part')[0].style.display = 'none';
                                      
                                    ''';
                          String footerRental =
                              " document.getElementById('footer').style.display = 'none';";
                          String mobileNav =
                              " document.getElementsByClassName('mobile-nav')[0].style.display = 'none';";
                          // alert('JS Running')
                          controller
                              .evaluateJavascript(source: footerHome)
                              .then((result) {});
                          controller
                              .evaluateJavascript(source: footerRental)
                              .then((result) {});
                          controller
                              .evaluateJavascript(source: mobileNav)
                              .then((result) {
                            print(result);
                            debugPrint(result);
                          });
                          setState(() {
                            isLoading = false;
                          });
                        },
                        initialUrlRequest: URLRequest(
                          url: Uri.parse(AppConstants.categoryUrl),
                        ),
                        // androidOnPermissionRequest:
                        //     (InAppWebViewController controller,
                        //         String origin,
                        //         List<String> resources) async {
                        //   return PermissionRequestResponse(
                        //     resources: resources,
                        //     action:
                        //         PermissionRequestResponseAction.GRANT,
                        //   );
                        // },
                        onScrollChanged: (controller, x, y) {
                          // setState(() {
                          //   // scrollY = y;
                          // });
                        },
                        onWebViewCreated: (InAppWebViewController controller) {
                          webViewController = controller;
                        },
                        onLoadError: (webViewController, url, i, s) async {
                          showError();
                        },
                        onLoadHttpError:
                            (webViewController, url, int i, String s) async {
                          // showError();
                        },
                      ),
                    if (showErrorPage) const UnableToLoadScreen()
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showError() {
    setState(() {
      showErrorPage = true;
    });
  }

  void hideError() {
    setState(() {
      showErrorPage = false;
    });
  }
}

class MyInAppBrowser extends InAppBrowser {
  @override
  Future onBrowserCreated() async {
    print("Browser Created!");
  }

  @override
  Future onLoadStart(url) async {
    print("Started $url");
  }

  @override
  Future onLoadStop(url) async {
    print("Stopped $url");
  }

  @override
  void onLoadError(url, code, message) {
    print("Can't load $url.. Error: $message");
  }

  @override
  void onProgressChanged(progress) {
    print("Progress: $progress");
  }

  @override
  void onExit() {
    print("Browser closed!");
  }
}

class AndroidTWABrowser extends ChromeSafariBrowser {
  @override
  void onOpened() {
    print("Android TWA browser opened");
  }

  @override
  void onCompletedInitialLoad() {
    print("Android TWA browser initial load completed");
  }

  @override
  void onClosed() {
    print("Android TWA browser closed");
  }
}
