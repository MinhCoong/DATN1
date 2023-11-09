import 'package:fe_flutter_ui/screens/login/login_screen.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'widgets/big_text.dart';

class LoginCard extends ConsumerStatefulWidget {
  const LoginCard({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoyaltyCardState();
}

class _LoyaltyCardState extends ConsumerState<LoginCard> {
  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      margin: EdgeInsets.all(
        Dimensions.padding_MarginHome / 2,
      ),
      style: NeumorphicStyle(
          shape: NeumorphicShape.concave,
          boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(20))),
          depth: 5,
          lightSource: LightSource.top,
          color: AppColors.BURGUNDY),
      child: Container(
        height: Dimensions.heighContainer1 * 2,
        padding: EdgeInsets.all(Dimensions.heighContainer0 * 2),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/backgroupcard.png',
                ),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            BigText(
              text: "Bạn ơi, tham gia thành viên ngay nào",
              overFlow: TextOverflow.visible,
              color: AppColors.NOODLE_COLOR,
              size: 15,
            ),
            BigText(
              text: "Đăng nhập để nhận nhiều ưu đãi hấp dẫn và tích điểm thành viên nha.",
              overFlow: TextOverflow.visible,
              color: AppColors.NOODLE_COLOR,
            ),
            NeumorphicButton(
              style: NeumorphicStyle(depth: 2, boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(15))),
              onPressed: () {
                Get.to(() => const LoginScreen());
              },
              child: BigText(text: 'Đăng nhập'),
            )
          ],
        ),
      ),
    );
  }
}
