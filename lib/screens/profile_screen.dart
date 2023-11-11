import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:get/get.dart';
import 'package:sortcutnepal/controllers/navbarController.dart';
import 'package:sortcutnepal/screens/message/loading_screen.dart';
import 'dart:developer' as developer;

import 'package:sortcutnepal/screens/message/no_internet_screen.dart';
import 'package:sortcutnepal/screens/message/unable_load_screen.dart';
import 'package:sortcutnepal/utils/constants.dart';
import 'package:sortcutnepal/widgets/alerts.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool showErrorPage = false, isLoading = true;
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  late PullToRefreshController pullToRefreshController;

  final ChromeSafariBrowser browser = new AndroidTWABrowser();
  NavBarController navBarController = Get.put(NavBarController());

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
        child: Stack(
          // fit: StackFit.expand,
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
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
                        Navigator.of(context)
                            .pushReplacementNamed('/main-bottom-nav');
                        return NavigationActionPolicy.CANCEL;
                      },
                      key: webViewKey,
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
                          isLoading = false;
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
                      },
                      initialUrlRequest: URLRequest(
                        url: Uri.parse(AppConstants.profileUrl),
                      ),
                      onScrollChanged: (controller, x, y) {
                        // print('Scrollhome $scrollY');
                        navBarController.updateScrollY(y);
                        // print('Scrollhome1 ${navBarController.scrollY.value}');
                      },
                      androidOnPermissionRequest:
                          (InAppWebViewController controller, String origin,
                              List<String> resources) async {
                        return PermissionRequestResponse(
                          resources: resources,
                          action: PermissionRequestResponseAction.GRANT,
                        );
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
            if (isLoading)
              Container(
                  height: MediaQuery.of(context).size.height,
                  child: const LoadingScreen()),
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
