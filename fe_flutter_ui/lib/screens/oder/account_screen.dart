// ignore_for_file: unused_result, avoid_print

import 'package:fe_flutter_ui/components/widgets/imagecacheprovider.dart';
import 'package:fe_flutter_ui/main.dart';
import 'package:fe_flutter_ui/models/customer.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/item_cardMrSoai.dart';
import '../../provider/customer_provider.dart';
import '../../utils/list_item.dart';
import '../../components/widgets/big_text.dart';

class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  String itemSex = listSex[0];
  String avatar = '';
  Customer customerX = Customer();
  bool isChosseDate = false;
  DateTime selectedDate = DateTime.now();
  var nameFirst = TextEditingController();
  var nameLast = TextEditingController();
  var email = TextEditingController();

  var phoneNumber = TextEditingController();

  void getUser() {
    if (!isChosseDate) {
      customerX = ref.watch(customerDataProvider);
      nameFirst.text = customerX.firstName ?? '';
      nameLast.text = customerX.lastName ?? '';
      email.text = customerX.email ?? '';
      avatar = customerX.avatar ?? '';
      phoneNumber.text = customerX.phoneNumber ?? '';
      if (customerX.sex == null) {
        itemSex = listSex[2];
      } else {
        for (var element in listSex) {
          if (element == customerX.sex) {
            itemSex = element;
            break;
          } else {
            itemSex = listSex[2];
          }
        }
      }

      selectedDate = customerX.dateOfBirth != '' ? DateTime.parse(customerX.dateOfBirth!) : DateTime.now();
    }
    isChosseDate = true;
  }

  @override
  Widget build(BuildContext context) {
    getUser();
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: AppColors.WH,
        toolbarHeight: Dimensions.heightListtile,
        elevation: 1,
        title: BigText(
          text: 'Thông tin tài khoản',
          fontweight: FontWeight.w800,
          color: Colors.black.withOpacity(.9),
          size: 15,
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
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            const ItemCardMrSoai(),
            Padding(
              padding: EdgeInsets.only(
                  top: Dimensions.hieghtItemFood + Dimensions.heighContainer1 - Dimensions.heighContainer0,
                  left: 5,
                  right: 5),
              child: Neumorphic(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(
                        const BorderRadius.vertical(top: Radius.circular(30), bottom: Radius.circular(30))),
                    depth: 1,
                    lightSource: LightSource.top,
                    color: AppColors.WH),
                child: SizedBox(
                  width: Dimensions.screenWidth,
                  height: Dimensions.heighContainer3 * 2.5,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Dimensions.heighContainer2 / 3.5,
                      ),
                      BigText(
                        text: "${nameFirst.text} ${nameLast.text}",
                        size: 18,
                      ),
                      SizedBox(
                        height: Dimensions.heightAppbarSearch / 1.5,
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
                                controller: nameLast,
                                cursorColor: AppColors.BURGUNDY,
                                cursorWidth: 2,
                                cursorHeight: 35,
                                autofocus: false,
                                style: GoogleFonts.comfortaa(height: 2, fontSize: 13, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Tên của bạn',
                                  hintStyle: GoogleFonts.comfortaa(fontSize: 13, fontWeight: FontWeight.w500),
                                ))),
                      ),
                      SizedBox(
                        height: Dimensions.heighContainer0 * 2,
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
                                controller: nameFirst,
                                cursorColor: AppColors.BURGUNDY,
                                cursorWidth: 2,
                                cursorHeight: 35,
                                autofocus: false,
                                style: GoogleFonts.comfortaa(height: 2, fontSize: 13, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Họ/tên lót của bạn',
                                  hintStyle: GoogleFonts.comfortaa(fontSize: 13, fontWeight: FontWeight.w500),
                                ))),
                      ),
                      SizedBox(
                        height: Dimensions.heighContainer0 * 2,
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
                                controller: email,
                                cursorColor: AppColors.BURGUNDY,
                                cursorWidth: 2,
                                cursorHeight: 35,
                                autofocus: false,
                                style: GoogleFonts.comfortaa(height: 2, fontSize: 13, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Email Của bạn',
                                  hintStyle: GoogleFonts.comfortaa(fontSize: 13, fontWeight: FontWeight.w500),
                                ))),
                      ),
                      SizedBox(
                        height: Dimensions.heighContainer0 * 2,
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
                                controller: phoneNumber,
                                cursorColor: AppColors.BURGUNDY,
                                cursorWidth: 2,
                                cursorHeight: 35,
                                autofocus: false,
                                keyboardType: TextInputType.number,
                                style: GoogleFonts.comfortaa(height: 2, fontSize: 13, fontWeight: FontWeight.w500),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Số điện thoại của bạn',
                                  hintStyle: GoogleFonts.comfortaa(fontSize: 13, fontWeight: FontWeight.w500),
                                ))),
                      ),
                      SizedBox(
                        height: Dimensions.heighContainer0 * 2,
                      ),
                      builderTimeAndSex(),
                      SizedBox(
                        height: Dimensions.heighContainer0 * 2 * 2,
                      ),
                      NeumorphicButton(
                        onPressed: () async {
                          await editUser();
                        },
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                            depth: 3,
                            lightSource: LightSource.topLeft,
                            color: AppColors.BURGUNDY),
                        child: SizedBox(
                            height: Dimensions.heightAppbarSearch,
                            child: Center(
                              child: BigText(
                                text: 'Cập nhật tài khoản',
                                color: AppColors.NOODLE_COLOR,
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            builderAvatar(),
          ],
        ),
      ),
    );
  }

  Future<void> editUser() async {
    var cus = Customer(
        id: customerX.id,
        firstName: nameFirst.text,
        lastName: nameLast.text,
        email: email.text,
        phoneNumber: phoneNumber.text,
        dateOfBirth: selectedDate.toIso8601String(),
        registerDatetime: customerX.registerDatetime,
        sex: itemSex,
        avatar: customerX.avatar,
        point: customerX.point,
        status: true);
    var userId = ref.watch(collectedUser);
    await ref.read(customerMrSoai).updateCustomer(cus);
    ref.refresh(customerDataProvider);
    await ref.refresh(customerMrSoai).getCustomer(userId);
  }

  Row builderTimeAndSex() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Neumorphic(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                depth: -2,
                lightSource: LightSource.topLeft,
                color: AppColors.WHX),
            child: GestureDetector(
              onTap: () {
                showDatePicker(
                  // locale: Locale(AutofillHints.sublocality),
                  cancelText: 'Thoát',
                  confirmText: 'Chọn',
                  helpText: 'Chọn ngày tháng năm sinh',
                  fieldLabelText: 'Nhập ngày',
                  errorFormatText: 'Lỗi định dạng',
                  errorInvalidText: 'Bạn chưa chọn ngày kìa!',
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(1950),
                  lastDate: DateTime(DateTime.now().year + 1),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData().copyWith(
                          useMaterial3: true,
                          buttonTheme: ButtonThemeData(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                          ),
                          colorScheme: ColorScheme.light(
                              primary: AppColors.BURGUNDY,
                              onPrimary: AppColors.NOODLE_COLOR,
                              surface: AppColors.NOODLE_COLOR,
                              onSurface: Colors.black.withOpacity(.5)),
                          dialogBackgroundColor: Colors.white),
                      child: child!,
                    );
                  },
                ).then((date) {
                  if (date != null) {
                    setState(() {
                      isChosseDate = true;
                      selectedDate = date;
                    });
                  }
                });
              },
              child: SizedBox(
                  height: Dimensions.heightAppbarSearch,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      BigText(
                        text: selectedDate.toString().split(' ')[0],
                        size: 13,
                      ),
                      Icon(Icons.date_range, color: AppColors.BURGUNDY.withOpacity(.8))
                    ],
                  )),
            ),
          ),
        ),
        SizedBox(
          width: Dimensions.padding_MarginHome2,
        ),
        Expanded(
          child: Neumorphic(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            style: NeumorphicStyle(
                shape: NeumorphicShape.flat,
                boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                depth: -2,
                lightSource: LightSource.topLeft,
                color: AppColors.BACKGROUND_COLOR),
            child: Container(
              alignment: Alignment.center,
              height: Dimensions.heightAppbarSearch,
              child: DropdownButtonFormField(
                borderRadius: BorderRadius.circular(15),
                value: itemSex,
                items: listSex.map((e) {
                  return DropdownMenuItem(
                    value: e,
                    child: BigText(
                      text: e,
                      size: 13,
                    ),
                  );
                }).toList(),
                onChanged: ((value) {
                  setState(() {
                    itemSex = value as String;
                  });
                }),
                icon: Icon(
                  Icons.arrow_drop_down_circle,
                  color: AppColors.BURGUNDY.withOpacity(.8),
                ),
                decoration: const InputDecoration(border: InputBorder.none),
              ),
            ),
          ),
        )
      ],
    );
  }

  Padding builderAvatar() {
    print(avatar);
    return Padding(
      padding: EdgeInsets.only(top: Dimensions.hieghtItemFood),
      child: Stack(
        alignment: Alignment.center,
        children: [
          avatar != ''
              ? Neumorphic(
                  style: const NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: 3,
                      lightSource: LightSource.topLeft,
                      color: AppColors.WH),
                  child: SizedBox(
                      width: Dimensions.dividerSlive * 0.75,
                      height: Dimensions.dividerSlive2 * 0.75,
                      child: CircleAvatar(
                          backgroundColor: Colors.white,
                          child: ImageCachedProvider(
                            url: avatar,
                            x: BoxFit.cover,
                          ))),
                )
              : Container(),
          // Positioned(
          //   bottom: 5,
          //   right: Dimensions.padding_MarginHome,
          //   child: Neumorphic(
          //       padding: const EdgeInsets.all(5),
          //       style: NeumorphicStyle(
          //           shape: NeumorphicShape.concave,
          //           boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(10))),
          //           depth: -5,
          //           lightSource: LightSource.topLeft,
          //           color: AppColors.WH),
          //       child: NeumorphicIcon(
          //         Icons.camera,
          //         size: 25,
          //         style: const NeumorphicStyle(color: Colors.black, depth: 5, shape: NeumorphicShape.concave),
          //       )),
          // ),
        ],
      ),
    );
  }
}
