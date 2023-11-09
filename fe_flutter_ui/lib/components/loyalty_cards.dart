import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/customer.dart';
import '../provider/customer_provider.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'widgets/big_text.dart';

class LoyaltyCard extends ConsumerStatefulWidget {
  const LoyaltyCard({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoyaltyCardState();
}

class _LoyaltyCardState extends ConsumerState<LoyaltyCard> {
  Customer customerX = Customer();
  bool isChosseDate = false;
  var userId = '';
  var nameFirst = TextEditingController();
  var nameLast = TextEditingController();
  var point = 0;

  void getUser() {
    customerX = ref.watch(customerDataProvider);
    nameFirst.text = customerX.firstName ?? '';
    nameLast.text = customerX.lastName ?? '';

    point = customerX.point ?? 0;
    userId = customerX.id ?? "";
  }

  @override
  Widget build(BuildContext context) {
    getUser();

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
        height: Dimensions.heighContainer1 * 3,
        padding: EdgeInsets.only(bottom: Dimensions.heighContainer0 * 2),
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage(
                  'assets/images/backgroupcard.png',
                ),
                fit: BoxFit.cover),
            borderRadius: BorderRadius.all(Radius.circular(15))),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: BigText(
                text: nameFirst.text != '' ? "${nameFirst.text} ${nameLast.text}" : nameLast.text,
                color: Colors.white,
              ),
              subtitle: BigText(
                text: 'Thành viên',
                size: 13,
                color: Colors.white,
              ),
              trailing: Neumorphic(
                padding: const EdgeInsets.all(10),
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    boxShape: NeumorphicBoxShape.roundRect(
                      const BorderRadius.all(Radius.circular(10)),
                    ),
                    depth: 1,
                    lightSource: LightSource.topLeft,
                    color: AppColors.NOODLE_COLOR.withOpacity(0)),
                child: BigText(
                  text: point.toString(),
                  color: Colors.white,
                ),
              ),
            ),
            Flexible(
              child: BarcodeWidget(
                padding: EdgeInsets.symmetric(vertical: Dimensions.padding_MarginHome, horizontal: 20),
                margin: EdgeInsets.symmetric(horizontal: Dimensions.padding_MarginHome),
                decoration: BoxDecoration(
                    border: Border.all(width: 0.1, color: AppColors.BURGUNDY),
                    color: AppColors.BACKGROUND_COLOR,
                    borderRadius: BorderRadius.all(Radius.circular(Dimensions.padding_MarginHome))),
                barcode: Barcode.gs128(),
                data: userId.split("-").last.toUpperCase(),
                width: double.infinity,
                height: Dimensions.hightCustomScrollView / 2.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
