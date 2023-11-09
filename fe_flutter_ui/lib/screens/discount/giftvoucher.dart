import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../components/widgets/big_text.dart';

class GiftVoucherScreen extends StatelessWidget {
  const GiftVoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.WH,
          toolbarHeight: Dimensions.heightListtile,
          elevation: 1,
          title: BigText(
            text: 'Tặng voucher cho bạn',
            fontweight: FontWeight.w800,
            color: Colors.black.withOpacity(.9),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
          child: Column(
            children: const [],
          ),
        ));
  }
}
