import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miraath/screens/notification_controller/fb_notifications.dart';
import 'package:miraath/widgets/text_app.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({Key? key}) : super(key: key);

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> with FbNotifications {
  late WebViewController controller;
  @override
  void initState() {
    super.initState();
    // Enable virtual display.
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

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
                Navigator.pushNamedAndRemoveUntil(
                    context, '/web_view_screen', (route) => false);
              },
              icon: Icon(Icons.home))
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
      body: const WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: 'https://miraath.net/application/radio.html',
        zoomEnabled: true,
      ),
    );
  }
}
