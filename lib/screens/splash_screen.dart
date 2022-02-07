import 'package:flutter/material.dart';

class SplashInitScreen extends StatefulWidget {
  const SplashInitScreen({Key? key}) : super(key: key);

  @override
  _SplashInitScreenState createState() => _SplashInitScreenState();
}

class _SplashInitScreenState extends State<SplashInitScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/web_view_screen');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/splash.png"), fit: BoxFit.fill),
        ),
      ),
    );
  }
}
