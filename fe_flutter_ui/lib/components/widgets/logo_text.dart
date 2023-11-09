// ignore_for_file: public_member_api_docs, sort_constructors_first, must_be_immutable
import 'package:flutter/material.dart';

class MrSoaiText extends StatelessWidget {
  final String text;
  double size;
  FontWeight textFontW;
  double letterSpacing;
  MrSoaiText({
    Key? key,
    required this.text,
    required this.size,
    this.textFontW = FontWeight.normal,
    this.letterSpacing = 1.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
          letterSpacing: letterSpacing,
          fontFamily: 'mrSoai',
          fontWeight: textFontW,
          color: Colors.white,
          fontSize: size),
    );
  }
}
