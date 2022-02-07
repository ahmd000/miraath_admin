import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miraath/helpers/helpers.dart';
import 'package:miraath/screens/notification_controller/fb_notifications.dart';
import 'package:miraath/widgets/text_app.dart';

class SendNotificationScreen extends StatefulWidget {
  const SendNotificationScreen({Key? key}) : super(key: key);

  @override
  _SendNotificationScreenState createState() => _SendNotificationScreenState();
}

class _SendNotificationScreenState extends State<SendNotificationScreen>
    with FbNotifications, Helpers {
  late TextEditingController _titleEditController;
  late TextEditingController _subTitleEditController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _titleEditController = TextEditingController();
    _subTitleEditController = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _titleEditController.dispose();
    _subTitleEditController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 10.sp,
        backgroundColor: const Color(0xff115972),
        centerTitle: true,
        title: TextApp(
          text: "الاشعارات",

          fontSize: 25.sp,
          fontColor: Colors.white,
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 16.sp, vertical: 16.sp),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
              child: Column(
                children: [
                  TextField(
                    controller: _titleEditController,
                    keyboardType: TextInputType.text,
                    textAlign: TextAlign.start,
                    decoration: InputDecoration(
                      hintText: "عنوان الاشعار",
                      prefixIcon: const Icon(Icons.title),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.sp),
                        borderSide: const BorderSide(
                          color: Colors.grey,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  TextField(
                    controller: _subTitleEditController,
                    keyboardType: TextInputType.multiline,
                    textAlign: TextAlign.start,
                    minLines: 3,
                    maxLines: 5,
                    decoration: InputDecoration(
                        hintText: "موضوع الاشعار",
                        prefixIcon: const Icon(Icons.subtitles),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.sp),
                            borderSide: const BorderSide(
                              color: Colors.grey,
                              width: 1,
                            ))),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  if (_titleEditController.text.isNotEmpty &&
                      _subTitleEditController.text.isNotEmpty) {
                    sendGeneralNotify(_titleEditController.text.trim(),
                        _subTitleEditController.text.trim());
                    showSnackBar(
                      context: context,
                      message: "تم ادسال الاشعار",
                      error: false,
                    );

                    clearText();
                  } else {
                    showSnackBar(
                      context: context,
                      message: "فشل ارسال الاشعار",
                      error: true,
                    );
                  }
                },

                label: TextApp(
                  text: "ارسال الاشعار",
                  fontSize: 20.sp,
                  fontColor: Colors.white,
                ),
                icon: const Icon(Icons.send),
                style: ElevatedButton.styleFrom(
                  primary: const Color(0xff115972),
                  padding: EdgeInsets.all(16.sp),
                  fixedSize: const Size(0, 60),
                  alignment: AlignmentDirectional.center,
                  elevation: 10.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void clearText() {
    setState(() {
      _subTitleEditController.clear();
      _titleEditController.clear();
    });
  }
}
