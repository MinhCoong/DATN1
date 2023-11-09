// ignore_for_file: file_names

import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class ItemCardMrSoai extends StatelessWidget {
  const ItemCardMrSoai({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 30, 20, 20),
      child: Neumorphic(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        style: NeumorphicStyle(
            shape: NeumorphicShape.flat,
            boxShape: NeumorphicBoxShape.roundRect(
                const BorderRadius.all(Radius.circular(20))),
            depth: 2,
            lightSource: LightSource.topLeft,
            color: AppColors.BURGUNDY),
        child: SizedBox(
          width: double.infinity,
          height: Dimensions.heighContainer2 / 1.5,
          child: Column(
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: NeumorphicText(
                          "Mr SOAI XIN CHAO",
                          style: const NeumorphicStyle(
                              depth: 2, //customize depth here
                              color: AppColors.NOODLE_COLOR),
                          textStyle: NeumorphicTextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'mrSoai' //customize size here
                              // AND others usual text style properties (fontFamily, fontWeight, ...)
                              ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
