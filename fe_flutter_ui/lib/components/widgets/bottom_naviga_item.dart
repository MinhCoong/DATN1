// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/components/widgets/small_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

class BottomNatigaItem extends StatelessWidget {
  final IconData icons;
  final String lable;
  const BottomNatigaItem({
    Key? key,
    required this.icons,
    required this.lable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        NeumorphicIcon(
          style: NeumorphicStyle(
            shape: NeumorphicShape.concave,
            boxShape: const NeumorphicBoxShape.circle(),
            depth: lable.isNotEmpty ? 0 : 5,
            lightSource: LightSource.topLeft,
            color: lable.isNotEmpty ? AppColors.ICON_COLOR : AppColors.BURGUNDY,
          ),
          icons,
          size: lable.isNotEmpty ? 18 : 22,
          // ),
        ),
        lable.isNotEmpty
            ? SizedBox(
                height: Dimensions.highSBox,
              )
            : Container(),
        lable.isNotEmpty
            ? SmallText(
                text: lable,
                size: 8,
                color: AppColors.ICON_COLOR,
              )
            : Container()
      ],
    );
  }
}
