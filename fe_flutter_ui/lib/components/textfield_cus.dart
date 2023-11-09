import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class TextFieldCus extends StatelessWidget {
  const TextFieldCus({
    super.key,
    required this.hintText,
  });
  final String hintText;
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
              const BorderRadius.all(Radius.circular(15))),
          depth: -2,
          lightSource: LightSource.topLeft,
          color: AppColors.BACKGROUND_COLOR),
      child: SizedBox(
          height: Dimensions.heightAppbarSearch,
          child: TextField(
              cursorColor: AppColors.BURGUNDY,
              cursorWidth: 2,
              cursorHeight: 35,
              autofocus: false,
              style: GoogleFonts.comfortaa(
                  height: 2, fontSize: 15, fontWeight: FontWeight.w500),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: GoogleFonts.comfortaa(
                    fontSize: 15, fontWeight: FontWeight.w500),
              ))),
    );
  }
}
