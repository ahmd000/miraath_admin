import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miraath/screens/notification_controller/send_notification_screen.dart';
import 'package:miraath/screens/splash_screen.dart';
import 'package:miraath/screens/web_view_screen.dart';
import 'package:move_to_background/move_to_background.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();

  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          MoveToBackground.moveTaskToBack();
          return false;
        },
        child: ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          designSize: const Size(400, 800),
          builder: () => MediaQuery(
            data: const MediaQueryData(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              builder: (context, widget) {
                ScreenUtil.setContext(context);
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: widget!,
                );
              },
              title: 'Miraath ',
              theme: ThemeData(
                primarySwatch: Colors.indigo,
              ),
              initialRoute: '/launch_screen',
              routes: {
                '/launch_screen': (context) => const SplashInitScreen(),
                '/web_view_screen': (context) => const WebViewScreen(),
                "/send_notify": (context) => const SendNotificationScreen(),
              },
            ),
          ),
        ));
  }
}
