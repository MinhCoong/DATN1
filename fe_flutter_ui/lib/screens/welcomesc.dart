import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/components/widgets/logo_text.dart';
import 'package:flutter/material.dart';

class WelCome extends StatelessWidget {
  const WelCome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 100, 4, 3),
      body: SafeArea(
          child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                  gradient: RadialGradient(
                      colors: [
                    Color.fromARGB(255, 255, 4, 3),
                    Color.fromARGB(255, 211, 4, 3),
                    Color.fromARGB(255, 166, 4, 3),
                    Color.fromARGB(255, 122, 4, 3),
                    Color.fromARGB(255, 78, 4, 3),
                    // Color(0xFF4E0403),
                  ],
                      focal: Alignment.center,
                      radius: 1.1,
                      tileMode: TileMode.clamp)),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    bottom: Dimensions.imagePosi,
                    child: Image(
                      width: Dimensions.welcomeImage,
                      height: Dimensions.welcomeImage,
                      image: const AssetImage('assets/images/Micay2.png'),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    bottom: Dimensions.textWelPosi,
                    child: Column(
                      children: [
                        MrSoaiText(
                          text: 'Mr Soaái',
                          size: Dimensions.textMrSoai,
                          textFontW: FontWeight.bold,
                          letterSpacing: 1.6,
                        ),
                        SizedBox(
                          height: Dimensions.highSBox,
                        ),
                        MrSoaiText(
                          text: 'M iì Cay & Traâ Sữa',
                          size: Dimensions.textBig,
                        ),
                      ],
                    ),
                  ),
                ],
              ))),
    );
  }
}
