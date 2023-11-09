import 'package:fe_flutter_ui/components/item_listtile.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:get/get.dart';

import '../../components/widgets/big_text.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

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
          text: 'Cài đặt',
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
      body: Column(
        children: [
          SizedBox(
            height: Dimensions.highSBox,
          ),
          Card(
            surfaceTintColor: AppColors.WHX,
            margin: const EdgeInsets.all(15),
            child: Column(children: const [
              ItemListTile(
                  iconData: Icons.connect_without_contact,
                  text: 'Liên kết tài khoản'),
              ItemListTile(iconData: Icons.info_outline, text: 'Về chúng tôi')
            ]),
          )
        ],
      ),
    );
  }
}
