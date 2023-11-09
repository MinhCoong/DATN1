// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SmallText extends StatelessWidget {
  Color? color;
  final String text;
  double size;
  TextOverflow overFlow;
  
  SmallText({
    Key? key,
    // this.color = AppColors.PRIMARY_COLOR,
    this.color = Colors.black,
    required this.text,
    this.size = 12,
    this.overFlow = TextOverflow.clip,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: null,
      style: GoogleFonts.comfortaa(
          color: color, fontSize: size, fontWeight: FontWeight.w500),
      overflow: overFlow,
    );
  }
}
