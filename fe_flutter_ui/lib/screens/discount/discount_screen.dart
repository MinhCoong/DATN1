// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:fe_flutter_ui/screens/coupons/coupon_Screen.dart';
import 'package:fe_flutter_ui/screens/discount/benefit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fe_flutter_ui/components/loyalty_cards.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/app_bar.dart';
import '../../components/item_discount.dart';
import '../../components/item_login_cart.dart';
import '../../components/item_ticket.dart';
import '../../models/coupons.dart';
import '../../provider/news_provider.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../login/login_screen.dart';

class DiscountScreen extends ConsumerStatefulWidget {
  const DiscountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DiscountScreenState();
}

class _DiscountScreenState extends ConsumerState<DiscountScreen> {
  @override
  Widget build(BuildContext context) {
    final listCoupons = ref.watch(couponsData);
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Dimensions.heigthAppBar),
          child: Container(
            color: AppColors.BACKGROUND_COLOR,
            // padding: EdgeInsets.symmetric(horizontal: Dimensions.appBarPadding),
            child: const MyAppBarMS(
              txt: 'có ưu đãi',
            ),
          )),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: Dimensions.heighContainer0,
            ),
            Stack(
              alignment: Alignment.topCenter,
              children: [
                Card(
                  elevation: 4,
                  color: AppColors.WHX,
                  surfaceTintColor: AppColors.WH,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    alignment: Alignment.topCenter,
                    height: Dimensions.heighContainer2 / 1.4,
                    padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                    width: Dimensions.screenWidth - Dimensions.padding_MarginHome,
                    decoration: const BoxDecoration(
                        color: AppColors.WH, border: Border(), borderRadius: BorderRadius.all(Radius.circular(30))),
                    child: BigText(
                      text: 'Mr Soái chúc bạn một ngày học tập và làm việc tốt lành',
                      size: 13,
                      textAlign: TextAlign.center,
                      overFlow: TextOverflow.visible,
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.only(top: Dimensions.heighContainer1),
                  margin: EdgeInsets.all(
                    Dimensions.padding_MarginHome / 2,
                  ),
                  child: FirebaseAuth.instance.currentUser == null ? const LoginCard() : const LoyaltyCard(),
                )
              ],
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: GridView(
                shrinkWrap: true,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    mainAxisSpacing: Dimensions.heighContainer0, childAspectRatio: 5, crossAxisCount: 1),
                children: [
                  // GestureDetector(
                  //   onTap: () {},
                  //   child: const ItemDiscount(
                  //     text: 'Nhận ưu đãi',
                  //     iconData: Icons.card_giftcard_outlined,
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      FirebaseAuth.instance.currentUser == null
                          ? Get.to(() => const LoginScreen())
                          : Get.to(const CouponScreen(
                              isComingFromCart: false,
                              total: 0,
                              quantity: 0,
                            ));
                    },
                    child: const ItemDiscount(
                      text: 'Voucher của bạn',
                      iconData: Icons.discount_rounded,
                    ),
                  ),
                  // GestureDetector(
                  //   onTap: () {
                  //     Get.to(const GiftVoucherScreen());
                  //   },
                  //   child: const ItemDiscount(
                  //     text: 'Tặng voucher',
                  //     iconData: Icons.history_edu_outlined,
                  //   ),
                  // ),
                  GestureDetector(
                    onTap: () {
                      Get.to(const BenefitScreen());
                    },
                    child: const ItemDiscount(
                      text: 'Quyền lợi',
                      iconData: Icons.add_moderator_rounded,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.only(left: 15),
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  BigText(
                    text: 'Voucher',
                    size: 16,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Icon(
                    FontAwesomeIcons.ticketSimple,
                    size: 18,
                    color: Colors.black.withOpacity(.7),
                  )
                ],
              ),
            ),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                  margin: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                  child: listCoupons.when(
                      data: (data) {
                        List<Coupons> lCoupons = data.map((e) => e).toList();
                        return lCoupons.length == 1
                            ? Center(
                                child: BigText(
                                  text: 'Hiện chưa có ưu đãi',
                                ),
                              )
                            : ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: lCoupons.length < 3 ? lCoupons.length : 3,
                                itemBuilder: (_, index) {
                                  return index != 0
                                      ? ItemTicketMaterial(
                                          coupons: lCoupons[index],
                                          isComingFromCart: false,
                                          quantity: 0,
                                          total: 0,
                                        )
                                      : Container();
                                });
                      },
                      error: (error, s) => Text(error.toString()),
                      loading: () => Center(
                          child: Lottie.asset('assets/images/loading-line-red.json',
                              width: Dimensions.heighContainer3 / 2)))),
            ),
            SizedBox(
              height: Dimensions.heighContainer1,
            )
          ],
        ),
      ),
    );
  }
}
