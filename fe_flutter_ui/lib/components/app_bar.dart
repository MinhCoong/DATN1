// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fe_flutter_ui/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import 'package:fe_flutter_ui/screens/coupons/coupon_Screen.dart';
import 'package:fe_flutter_ui/screens/notification/notification_screen.dart';

import '../models/customer.dart';
import '../provider/customer_provider.dart';
import '../screens/login/login_screen.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'widgets/big_text.dart';

class MyAppBarMS extends ConsumerStatefulWidget {
  const MyAppBarMS({
    Key? key,
    required this.txt,
  }) : super(key: key);

  final String txt;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppBarMSState();
}

class _MyAppBarMSState extends ConsumerState<MyAppBarMS> {
  Customer customerX = Customer();
  bool isChosseDate = false;
  int couponint = 0;
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
    couponint = ref.watch(indexCoupons) - 1;
    return AppBar(
      title: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: BigText(
          text: FirebaseAuth.instance.currentUser == null
              ? "Mời bạn những món ngon ><"
              : nameLast.text == ''
                  ? "${nameFirst.text} ${widget.txt}"
                  : '${nameLast.text} ${widget.txt}',
          size: 13,
          overFlow: TextOverflow.visible,
        ),
      ),
      elevation: 4,
      titleSpacing: 0,
      leading: Padding(
        padding: EdgeInsets.only(bottom: Dimensions.imageAppBar, left: Dimensions.imageAppBarLeftP),
        child: const Image(image: AssetImage('assets/images/mrsoaiIcon.png')),
      ),
      actions: [
        NeumorphicButton(
          onPressed: () => FirebaseAuth.instance.currentUser == null
              ? Get.to(() => const LoginScreen())
              : Get.to(() => const CouponScreen(
                    isComingFromCart: false,
                    quantity: 0,
                    total: 0,
                  )),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
          margin: EdgeInsets.symmetric(vertical: Dimensions.highSBox),
          style: NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(20))),
              depth: 1,
              lightSource: LightSource.topLeft,
              color: AppColors.WH),
          child: Row(children: [
            FaIcon(
              FontAwesomeIcons.ticket,
              size: Dimensions.heighContainer0 * 2,
              color: AppColors.BURGUNDY,
            ),
            SizedBox(
              width: Dimensions.imageAppBar,
            ),
            FirebaseAuth.instance.currentUser == null
                ? Container()
                : BigText(
                    text: couponint != -1 ? couponint.toString() : '',
                  ),
            // Spacer(),
          ]),
        ),
        NeumorphicButton(
          onPressed: () {
            Get.to(() => const NotificationScreen());
          },
          padding: const EdgeInsets.symmetric(horizontal: 20),
          margin: EdgeInsets.symmetric(vertical: Dimensions.highSBox),
          style: const NeumorphicStyle(
              shape: NeumorphicShape.concave,
              boxShape: NeumorphicBoxShape.circle(),
              depth: 1,
              lightSource: LightSource.topLeft,
              color: AppColors.WH),
          child: Container(
            alignment: Alignment.center,
            child: FaIcon(
              FontAwesomeIcons.bell,
              size: Dimensions.heighContainer0 * 2,
              color: AppColors.BURGUNDY,
            ),
          ),
        ),
        SizedBox(
          width: Dimensions.imageAppBarLeftP * 1.5,
        )
      ],
    );
  }
}
