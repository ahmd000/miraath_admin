import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class TextApp extends StatelessWidget {
  final String text;
  final FontWeight fontWeight;
  final double fontSize;
  final TextAlign textAlign;
  final double height;
  final Color fontColor;

  TextApp(
      {required this.text,
        this.fontWeight = FontWeight.normal,
        required this.fontSize,
        this.textAlign = TextAlign.center,
        this.height = 1,
        required this.fontColor});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      softWrap: true,
      textAlign: textAlign,
      style: GoogleFonts.amiri(
        fontWeight: fontWeight,
        fontSize: 20.sp,
        color: fontColor,
      ),

    );
  }
}