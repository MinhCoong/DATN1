// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BigText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  FontWeight fontweight;
  TextAlign textAlign;
  BigText(
      {super.key,
      // this.color = AppColors.PRIMARY_COLOR,
      this.color = Colors.black,
      required this.text,
      this.size = 13,
      this.textAlign = TextAlign.start,
      this.fontweight = FontWeight.w600,
      this.overFlow = TextOverflow.ellipsis});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      overflow: overFlow,
      textAlign: textAlign,
      style: GoogleFonts.comfortaa(
          color: color, fontSize: size, fontWeight: fontweight),
    );
  }
}
