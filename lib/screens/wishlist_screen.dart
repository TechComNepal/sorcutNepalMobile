import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'dart:developer' as developer;

import 'package:sortcutnepal/screens/message/no_internet_screen.dart';
import 'package:sortcutnepal/screens/message/unable_load_screen.dart';
import 'package:sortcutnepal/utils/constants.dart';
import 'package:sortcutnepal/widgets/alerts.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  bool showErrorPage = false, isLoading = true;
  InAppWebViewController? webViewController;
  final GlobalKey webViewKey = GlobalKey();

  ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;

  late PullToRefreshController pullToRefreshController;

  final ChromeSafariBrowser browser = new AndroidTWABrowser();

  @override
  void initState() {
    super.initState();
    initConnectivity();
    isLoading = true;
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    // browser.open(
    //     url: Uri.parse("https://www.sortcutnepal.com"),
    //     options: ChromeSafariBrowserClassOptions(
    //         android: AndroidChromeCustomTabsOptions(
    //           isTrustedWebActivity: true,
    //           enableUrlBarHiding: true,
    //           showTitle: false,
    //           instantAppsEnabled: false,
    //         ),
    //         ios: IOSSafariOptions(
    //           barCollapsingEnabled: true,
    //         )));

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
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Alerts().exitApp(context, webViewController!),
      child: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xff486CCE),
                  ))
                : const SizedBox(),
            Container(
              child: isLoading == false &&
                      _connectionStatus == ConnectivityResult.none
                  ? const NoInternetScreen()
                  : Stack(
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
                                (InAppWebViewController controller,
                                    String origin,
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
                                  action:
                                      ServerTrustAuthResponseAction.PROCEED);
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
                              url: Uri.parse(AppConstants.wishlistUrl),
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
                            onWebViewCreated:
                                (InAppWebViewController controller) {
                              webViewController = controller;
                            },
                            onLoadError: (webViewController, url, i, s) async {
                              showError();
                            },
                            onLoadHttpError: (webViewController, url, int i,
                                String s) async {
                              // showError();
                            },
                          ),
                        if (showErrorPage) const UnableToLoadScreen()
                      ],
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
