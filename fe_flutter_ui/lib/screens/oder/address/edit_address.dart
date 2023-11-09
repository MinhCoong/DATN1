// ignore_for_file: unused_result

import 'package:fe_flutter_ui/models/address.dart';
import 'package:fe_flutter_ui/provider/address_provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../components/dots_.dart';
import '../../../components/widgets/big_text.dart';
import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import 'map.dart';

class EditAddressScreen extends ConsumerStatefulWidget {
  const EditAddressScreen(this.addresses, {super.key});

  final Addresses addresses;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AddAddressScreenState();
}

class _AddAddressScreenState extends ConsumerState<EditAddressScreen> {
  var textNameAddress = TextEditingController();
  var textDescription = TextEditingController();
  String address = '';

  @override
  Widget build(BuildContext context) {
    textNameAddress.text = widget.addresses.nameAddress!;
    textDescription.text = widget.addresses.description!;
    address = widget.addresses.addrressValue!;
    return GestureDetector(
      onTap: () {
        Get.back();
      },
      child: Scaffold(
          backgroundColor: Colors.black38,
          body: Container(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
            margin: EdgeInsets.only(
                top: Dimensions.heightListtile * 1.6, left: 15, right: 15),
            height: Dimensions.screenHeight / 1.8,
            decoration: const BoxDecoration(
                color: AppColors.WH,
                borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30), bottom: Radius.circular(30))),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: Dimensions.heighContainer0 * 2,
                  ),
                  SizedBox(
                    height: Dimensions.heightListtile / 2.5,
                    width: Dimensions.screenWidth,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        BigText(
                          text: "Sửa địa chỉ",
                          textAlign: TextAlign.center,
                          size: 15,
                        ),
                        Positioned(
                          left: 15,
                          child: IconButton(
                            icon: const Icon(
                              Icons.close,
                              color: Colors.black,
                            ),
                            onPressed: () {
                              Get.back();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const DottedBoderAPP(),
                  SizedBox(
                    height: Dimensions.heighContainer0,
                  ),
                  BigText(text: "Tên địa chỉ"),
                  SizedBox(
                    height: Dimensions.heighContainer0,
                  ),
                  Neumorphic(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(15))),
                        depth: -2,
                        lightSource: LightSource.topLeft,
                        color: AppColors.BACKGROUND_COLOR),
                    child: SizedBox(
                        height: Dimensions.heightAppbarSearch,
                        child: TextField(
                            controller: textNameAddress,
                            cursorColor: AppColors.BURGUNDY,
                            cursorWidth: 2,
                            cursorHeight: 35,
                            autofocus: false,
                            style: GoogleFonts.comfortaa(
                                height: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ví dụ nhà của Soái....',
                              hintStyle: GoogleFonts.comfortaa(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ))),
                  ),
                  SizedBox(
                    height: Dimensions.heighContainer0 * 2,
                  ),
                  BigText(text: "Địa chỉ*"),
                  SizedBox(
                    height: Dimensions.heighContainer0,
                  ),
                  NeumorphicButton(
                    onPressed: () {
                      Get.to(() => const MapScreen());
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(15))),
                        depth: 2,
                        lightSource: LightSource.topLeft,
                        color: AppColors.BACKGROUND_COLOR),
                    child: Container(
                        alignment: Alignment.centerLeft,
                        height: Dimensions.heightAppbarSearch * 1.5,
                        width: double.infinity,
                        child: BigText(
                          text: address,
                          overFlow: TextOverflow.visible,
                        )),
                  ),
                  SizedBox(
                    height: Dimensions.heighContainer0 * 2,
                  ),
                  BigText(text: "Thêm hướng dẫn"),
                  SizedBox(
                    height: Dimensions.heighContainer0,
                  ),
                  Neumorphic(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(15))),
                        depth: -2,
                        lightSource: LightSource.topLeft,
                        color: AppColors.BACKGROUND_COLOR),
                    child: SizedBox(
                        height: Dimensions.heightAppbarSearch,
                        child: TextField(
                            controller: textDescription,
                            cursorColor: AppColors.BURGUNDY,
                            cursorWidth: 2,
                            cursorHeight: 35,
                            autofocus: false,
                            style: GoogleFonts.comfortaa(
                                height: 2,
                                fontSize: 13,
                                fontWeight: FontWeight.w500),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Ví dụ như tên cổng....',
                              hintStyle: GoogleFonts.comfortaa(
                                  fontSize: 13, fontWeight: FontWeight.w500),
                            ))),
                  ),
                  SizedBox(
                    height: Dimensions.heighContainer0 * 3,
                  ),
                  NeumorphicButton(
                    onPressed: () async {
                      await handleEditAddress();
                      Get.back();
                    },
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    margin: EdgeInsets.symmetric(
                        horizontal: Dimensions.heighContainer2 / 3),
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        boxShape: NeumorphicBoxShape.roundRect(
                            const BorderRadius.all(Radius.circular(15))),
                        depth: 3,
                        lightSource: LightSource.topLeft,
                        color: AppColors.BURGUNDY),
                    child: SizedBox(
                        height: Dimensions.heightAppbarSearch,
                        child: Center(
                          child: BigText(
                            text: 'Lưu',
                            color: AppColors.NOODLE_COLOR,
                          ),
                        )),
                  ),
                ],
              ),
            ),
          )),
    );
  }

  Future<void> handleEditAddress() async {
    var addresses = Addresses(
        id: widget.addresses.id,
        userId: widget.addresses.userId,
        nameAddress: textNameAddress.text,
        addrressValue: address,
        description: textDescription.text,
        status: true);
    await ref
        .watch(addressNotifier)
        .onUpdateAddress(widget.addresses.id!, addresses);
    ref.refresh(addressData);
  }
}
