import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class Alerts {
  exitApp(
      BuildContext context, InAppWebViewController webViewController) async {
    if (await webViewController.canGoBack()) {
      // print("onwill goback");
      webViewController.goBack();
    } else {
      // Scaffold.of(context).showSnackBar(
      //   const SnackBar(content: Text("No back history item")),
      // );
      showDialog(
          // barrierColor: Color(0xff5C75AA),
          context: context,
          builder: (context) => AlertDialog(
                backgroundColor: Color(0xff5C75AA),
                title: Text(
                  'Do you want to exit?',
                  style: TextStyle(color: Colors.white60, fontSize: 16),
                ),
                actions: <Widget>[
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'No',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      SystemNavigator.pop();
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ),
                ],
              ));
      return Future.value(false);
    }
  }
}
