// ignore_for_file: public_member_api_docs, sort_constructors_first, avoid_print
// ignore_for_file: deprecated_member_use

import 'package:fe_flutter_ui/components/item_listtile.dart';
import 'package:fe_flutter_ui/components/item_logout_popup.dart';
import 'package:fe_flutter_ui/screens/oder/history_screen.dart';
import 'package:fe_flutter_ui/screens/oder/address/saved_address.dart';
import 'package:fe_flutter_ui/screens/oder/settings_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:fe_flutter_ui/components/item_discount.dart';
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:get/get.dart';

import '../../components/app_bar.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../login/login_screen.dart';
import 'account_screen.dart';

class OrderScreen extends ConsumerStatefulWidget {
  const OrderScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _OrderScreenState();
}

class _OrderScreenState extends ConsumerState<OrderScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: PreferredSize(
            preferredSize: Size.fromHeight(Dimensions.heigthAppBar), child: const MyAppBarMS(txt: 'muốn tìm gì')),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
            width: Dimensions.screenWidth,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: BigText(
                  text: 'Tiện ích',
                  fontweight: FontWeight.w800,
                ),
              ),
              GestureDetector(
                onTap: () {
                  FirebaseAuth.instance.currentUser == null
                      ? Get.to(() => const LoginScreen())
                      : Get.to(() => const HistoryScreen());
                },
                child: SizedBox(
                  height: Dimensions.heighContainer1,
                  width: Dimensions.screenWidth,
                  child: const ItemDiscount(text: 'Lịch sử đơn hàng', iconData: Icons.history_toggle_off_outlined),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                child: Column(
                  children: [
                    BigText(
                      text: 'Tài khoản',
                      fontweight: FontWeight.w800,
                    ),
                  ],
                ),
              ),
              Card(
                color: AppColors.WHX,
                surfaceTintColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(Dimensions.padding_MarginHome2),
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.currentUser == null
                            ? Get.to(() => const LoginScreen())
                            : Get.to(() => const AccountScreen());
                      },
                      child: const ItemListTile(iconData: FontAwesomeIcons.person, text: 'Thông tin cá nhân'),
                    ),
                    Divider(
                      thickness: .5,
                      indent: Dimensions.padding_MarginHome,
                      endIndent: Dimensions.padding_MarginHome,
                      color: Colors.black.withOpacity(.3),
                    ),
                    GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.currentUser == null
                            ? Get.to(() => const LoginScreen())
                            : Get.to(() => const SaveAddressScreen(
                                  isComingFromCart: false,
                                ));
                      },
                      child: const ItemListTile(iconData: FontAwesomeIcons.save, text: 'Địa chỉ đã lưu'),
                    ),
                    Divider(
                      thickness: .5,
                      indent: Dimensions.padding_MarginHome,
                      endIndent: Dimensions.padding_MarginHome,
                      color: Colors.black.withOpacity(.3),
                    ),
                    GestureDetector(
                        onTap: () {
                          Get.to(() => const SettingsScreen());
                        },
                        child: const ItemListTile(iconData: Icons.settings, text: 'Cài đặt')),
                    Divider(
                      thickness: .5,
                      indent: Dimensions.padding_MarginHome,
                      endIndent: Dimensions.padding_MarginHome,
                      color: Colors.black.withOpacity(.3),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          PageRouteBuilder(
                              opaque: false, pageBuilder: (BuildContext context, _, __) => const ItemLogoutPodup()),
                        );
                      },
                      child: const ItemListTile(iconData: FontAwesomeIcons.signOut, text: 'Đăng xuất'),
                    )
                  ],
                ),
              )
            ]),
          ),
        ));
  }
}
