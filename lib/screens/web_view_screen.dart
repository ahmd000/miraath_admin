import 'dart:async';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miraath/screens/notification_controller/fb_notifications.dart';
import 'package:miraath/widgets/text_app.dart';
import 'package:move_to_background/move_to_background.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> with FbNotifications , WidgetsBindingObserver {


  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) return;

    final isBackground = state == AppLifecycleState.paused;

    if (isBackground) {
      print("play in background ");
    }

    /* if (isBackground) {
      // service.stop();
    } else {
      // service.start();
    }*/
  }
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);

    super.dispose();
  }
  @override
  void initState() {

    WidgetsBinding.instance!.addObserver(this);

    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
    // if (Platform.isAndroid) WebView.platform = AndroidWebView();

    initializeForegroundNotificationForAndroid();
    requestNotificationPermissions();
    //subscribeGeneralTopic();
    manageNotificationAction();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {

              MoveToBackground.moveTaskToBack();
            },
            icon: const Icon(
              Icons.arrow_downward,
            ),
          ),
          IconButton(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, '/web_view_screen', (route) => false);
              },
              icon: const Icon(Icons.home))
        ],
        elevation: 10.sp,
        backgroundColor: const Color(0xff115972),
        leading: IconButton(
          icon: const Icon(Icons.notification_add),
          onPressed: () {
            Navigator.pushNamed(context, "/send_notify");
          },
        ),
        centerTitle: true,
        title: TextApp(
          text: "ميراث الانبياء",
          fontColor: Colors.white,
          fontSize: 25.sp,
        ),
      ),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://miraath.net/application/radio.html',
        onWebViewCreated: (WebViewController webViewController) {
          _controller.complete(webViewController);
        },
        zoomEnabled: true,
        initialMediaPlaybackPolicy: AutoMediaPlaybackPolicy.always_allow,
        allowsInlineMediaPlayback: true,
        debuggingEnabled: true,
        gestureNavigationEnabled: true,
      ),
    );
  }
}
