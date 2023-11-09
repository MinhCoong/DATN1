// ignore_for_file: file_names, avoid_print

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';

import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';

import '../screens/home/home_screen.dart';
import '../service/auth_service.dart';

class ItemLogoutPodup extends ConsumerStatefulWidget {
  const ItemLogoutPodup({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputCustomerState();
}

class _InputCustomerState extends ConsumerState<ItemLogoutPodup> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Scaffold(
          backgroundColor: Colors.black26,
          body: Padding(
            padding: EdgeInsets.only(top: Dimensions.heighContainer3),
            child: Column(
              children: [
                Container(
                    // height: Dimensions.heighContainer2 / 2,
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(15),
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: AppColors.WH,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: Dimensions.heighContainer0 / 2,
                        ),
                        Center(
                          child: BigText(
                            text: 'Đăng xuất khỏi tài khoản hiện tại?',
                            size: 15,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            NeumorphicButton(
                              onPressed: () {
                                Get.back();
                              },
                              style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                              ),
                              child: BigText(text: 'Hủy'),
                            ),
                            SizedBox(
                              width: Dimensions.padding_MarginHome,
                            ),
                            NeumorphicButton(
                              onPressed: () {
                                Navigator.pushNamedAndRemoveUntil(context, 'Login', (route) => false);
                                signOut().then((value) => print('Đăng xuất thành công')).catchError((error) {
                                  print('Đăng xuất thất bại: $error');
                                });
                                ref.read(indexScreenProvider.notifier).update((state) => 0);
                              },
                              style: NeumorphicStyle(
                                boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                              ),
                              child: BigText(
                                text: 'Có',
                                fontweight: FontWeight.w900,
                                color: AppColors.BURGUNDY.withOpacity(.8),
                              ),
                            )
                          ],
                        )
                      ],
                    )),
                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
