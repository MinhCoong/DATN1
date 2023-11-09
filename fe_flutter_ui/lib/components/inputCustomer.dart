// ignore_for_file: file_names

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';

import '../main.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class InputCustomer extends ConsumerStatefulWidget {
  const InputCustomer({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputCustomerState();
}

class _InputCustomerState extends ConsumerState<InputCustomer> {
  var name = TextEditingController();
  var phone = TextEditingController();
  @override
  Widget build(BuildContext context) {
    name.text = ref.watch(textName) == 'null' ? '' : ref.watch(textName);
    phone.text = ref.watch(textPhone) == 'Nhập số điện thoại' ? '' : ref.watch(textPhone);
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Scaffold(
          backgroundColor: Colors.black26,
          body: Padding(
            padding: EdgeInsets.only(top: Dimensions.heighContainer3 / 2),
            child: Container(
                height: Dimensions.heighContainer2,
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
                    BigText(
                      text: 'Tên người nhận',
                      size: 15,
                    ),
                    Neumorphic(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                          depth: -2,
                          lightSource: LightSource.topLeft,
                          color: AppColors.BACKGROUND_COLOR),
                      child: SizedBox(
                          height: Dimensions.heightAppbarSearch,
                          child: TextField(
                              controller: name,
                              cursorColor: AppColors.BURGUNDY,
                              cursorWidth: 2,
                              cursorHeight: 35,
                              autofocus: false,
                              style: GoogleFonts.comfortaa(height: 2, fontSize: 15, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Tên người nhận',
                                hintStyle: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w500),
                              ))),
                    ),
                    SizedBox(
                      height: Dimensions.heighContainer0,
                    ),
                    BigText(
                      text: 'Số điện thoại',
                      size: 15,
                    ),
                    Neumorphic(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      style: NeumorphicStyle(
                          shape: NeumorphicShape.flat,
                          boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                          depth: -2,
                          lightSource: LightSource.topLeft,
                          color: AppColors.BACKGROUND_COLOR),
                      child: SizedBox(
                          height: Dimensions.heightAppbarSearch,
                          child: TextField(
                              controller: phone,
                              cursorColor: AppColors.BURGUNDY,
                              cursorWidth: 2,
                              cursorHeight: 35,
                              autofocus: false,
                              keyboardType: TextInputType.number,
                              style: GoogleFonts.comfortaa(height: 2, fontSize: 15, fontWeight: FontWeight.w500),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Số điện thoại',
                                hintStyle: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w500),
                              ))),
                    ),
                    SizedBox(
                      height: Dimensions.heighContainer0 * 1.5,
                    ),
                    Flexible(
                      child: Center(
                        child: NeumorphicButton(
                          style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                            lightSource: LightSource.topLeft,
                            color: AppColors.BURGUNDY,
                          ),
                          onPressed: () {
                            if (name.text != '') {
                              ref.watch(textName.notifier).update((state) => name.text.trim());
                            }
                            if (phone.text != '' &&
                                (phone.text.trim().length == 10 || phone.text.trim().length == 12)) {
                              ref.watch(textPhone.notifier).update((state) => phone.text.trim());
                            }
                            Get.back();
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: Dimensions.heightAppbarSearch / 1.5,
                              width: Dimensions.screenWidth / 3,
                              child: BigText(
                                text: 'Xác nhận',
                                color: AppColors.NOODLE_COLOR,
                                fontweight: FontWeight.w800,
                              )),
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
