// ignore_for_file: avoid_print, use_build_context_synchronously, must_be_immutable, unused_result

import 'package:fe_flutter_ui/models/login.dart';
import 'package:fe_flutter_ui/models/registrationtoken.dart';
import 'package:fe_flutter_ui/provider/customer_provider.dart';
import 'package:fe_flutter_ui/screens/login/otp_screen.dart';
import 'package:fe_flutter_ui/service/auth_service.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../main.dart';
import '../../provider/cart_provider.dart';
import '../../provider/news_provider.dart';
import '../../utils/colors.dart';
import '../curved_nationbar.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  static String verify = "";

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  void initState() {
    super.initState();
    coutryCodeController.text = "+84";
  }

  TextEditingController coutryCodeController = TextEditingController();
  var phoneNumber = '';

  @override
  Widget build(BuildContext context) {
    coutryCodeController.text = "+84";
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          width: double.infinity,
          child: Stack(
            children: [
              Neumorphic(
                style: const NeumorphicStyle(
                    shape: NeumorphicShape.concave, depth: -5, lightSource: LightSource.top, color: AppColors.BURGUNDY),
                child: Container(
                    padding: EdgeInsets.symmetric(
                        vertical: Dimensions.heighContainer0 * 2, horizontal: Dimensions.heighContainer0 * 10),
                    height: Dimensions.heightImage,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        gradient: RadialGradient(colors: [
                      Color.fromARGB(255, 196, 0, 29),
                      Color.fromARGB(255, 166, 0, 29),
                      Color.fromARGB(255, 116, 0, 29),
                      Color.fromARGB(255, 76, 0, 29),
                      // Color(0xFF4E0403),
                    ], focal: Alignment.center, radius: 1.1, tileMode: TileMode.clamp)),
                    child: SizedBox(
                      height: Dimensions.heightImage / 1.3,
                      child: const Image(
                          image: AssetImage(
                        'assets/images/Micay2.png',
                      )),
                    )),
              ),
              Padding(
                padding: EdgeInsets.only(top: Dimensions.heightImage / 1.1),
                child: Neumorphic(
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.vertical(top: Radius.circular(20))),
                      depth: 3,
                      lightSource: LightSource.bottom,
                      color: AppColors.WH),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                    child: Column(
                      children: [
                        BigText(
                          text: 'Chào mừng đến với',
                          color: Colors.black.withOpacity(.7),
                        ),
                        SizedBox(
                          height: Dimensions.heighContainer0 * 2,
                        ),
                        NeumorphicText(
                          "Mr SOAI",
                          style: const NeumorphicStyle(
                            depth: 1, //customize depth here
                            color: AppColors.BURGUNDY, //customize color here
                          ),
                          textStyle: NeumorphicTextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2,
                              fontFamily: 'mrSoai' //customize size here
                              // AND others usual text style properties (fontFamily, fontWeight, ...)
                              ),
                        ),
                        SizedBox(
                          height: Dimensions.textMrSoai / 2,
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
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Padding(
                                        padding: EdgeInsets.only(top: Dimensions.heighContainer0 / 2),
                                        child: BigText(
                                          text: coutryCodeController.text,
                                          overFlow: TextOverflow.visible,
                                        ),
                                      )),
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(10, 15, 10, 15),
                                    child: Container(
                                      height: double.infinity,
                                      width: 2,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Expanded(
                                    flex: 16,
                                    child: TextField(
                                      cursorColor: Colors.grey,
                                      cursorWidth: 2,
                                      cursorHeight: 30,
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      style:
                                          GoogleFonts.comfortaa(height: 2, fontSize: 15, fontWeight: FontWeight.w500),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Nhập số điện thoại',
                                        hintStyle: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w500),
                                      ),
                                      onChanged: (value) {
                                        phoneNumber = value.trim();
                                      },
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: Dimensions.heighContainer0 * 2,
                        ),
                        NeumorphicRadio(
                          style: NeumorphicRadioStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                              lightSource: LightSource.topLeft,
                              unselectedColor: AppColors.NOODLE_COLOR,
                              selectedColor: AppColors.NOODLE_COLOR),
                          onChanged: (value) async {
                            try {
                              print(coutryCodeController.text + phoneNumber);
                              await FirebaseAuth.instance.verifyPhoneNumber(
                                phoneNumber: coutryCodeController.text + phoneNumber,
                                verificationCompleted: (PhoneAuthCredential credential) {},
                                verificationFailed: (FirebaseAuthException e) {
                                  if (e.code == 'invalid-phone-number') {
                                    print('The provided phone number is not valid.');
                                  }
                                },
                                codeSent: (String verificationId, int? resendToken) {
                                  LoginScreen.verify = verificationId;
                                  // final UserID = Provider((ref) => null)
                                  Get.to(
                                      () => OtpScreen(
                                            phoneNumnber: coutryCodeController.text + phoneNumber,
                                          ),
                                      transition: Transition.rightToLeftWithFade,
                                      duration: const Duration(seconds: 1));
                                },
                                codeAutoRetrievalTimeout: (String verificationId) {},
                              );
                            } catch (e) {
                              print('feild');
                            }
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: Dimensions.heightAppbarSearch,
                              width: double.infinity,
                              child: BigText(
                                text: 'Đăng nhập',
                                size: 15,
                                color: AppColors.BURGUNDY.withOpacity(.7),
                                fontweight: FontWeight.w800,
                              )),
                        ),
                        SizedBox(
                          height: Dimensions.heighContainer0,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(() => const BottomNavigaBar());
                            },
                            child: BigText(
                              text: 'Tiếp tục như khách ❤️',
                              color: AppColors.BURGUNDY.withOpacity(.8),
                              size: 13,
                              fontweight: FontWeight.w900,
                            )),
                        SizedBox(
                          height: Dimensions.heighContainer0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.black.withOpacity(.3),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: Dimensions.padding_MarginHome2),
                              child: BigText(text: 'Hoặc', fontweight: FontWeight.w800, color: Colors.grey),
                            ),
                            Expanded(
                              child: Divider(
                                thickness: 1,
                                color: Colors.black.withOpacity(.3),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Dimensions.heighContainer0 * 2,
                        ),
                        NeumorphicRadio(
                          style: NeumorphicRadioStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                              lightSource: LightSource.topLeft,
                              unselectedColor: Colors.blue,
                              selectedColor: AppColors.NOODLE_COLOR),
                          onChanged: (value) {
                            signInWithFacebook().then((user) async {
                              print("/nUseradditionalUserInfo: ${user.additionalUserInfo}");
                              var userNow = user.additionalUserInfo!.profile;
                              var userId = FirebaseAuth.instance.currentUser?.uid;
                              var customer = LoginNRegister(
                                firstName: userNow!['first_name'] == null ? '' : userNow['first_name'],
                                lastName: userNow['last_name'] ?? '',
                                authenPhoneNumberId: '',
                                phoneNumber: '',
                                facebookUserId: userId,
                                googleUserId: '',
                                email: '',
                                avatar: userNow['picture']['data']['url'].toString(),
                              );
                              print(userId);
                              ref.read(collectedUser.notifier).update((state) => userId!);
                              await ref.read(customerMrSoai).onSubmitCustomer(customer);
                              var registrationToken = RegistrationToken(
                                  id: 0,
                                  userId: userId,
                                  deviceToken: await FirebaseMessaging.instance.getToken(),
                                  status: true);
                              await ref.read(customerMrSoai).postRToken(registrationToken);
                              FirebaseAuth.instance.currentUser == null ? null : ref.watch(couponsData);
                              FirebaseAuth.instance.currentUser == null ? null : ref.watch(cartData);
                              FirebaseAuth.instance.currentUser == null
                                  ? null
                                  : ref.read(customerMrSoai).getCustomer(userId!);
                              ref.refresh(customerMrSoai);
                              Navigator.pushNamedAndRemoveUntil(context, 'Home', (route) => false);
                            }).catchError((error) {
                              print('Đăng nhập facebook thất bại: $error');
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: Dimensions.heightAppbarSearch,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.facebook_rounded,
                                    color: AppColors.WH,
                                  ),
                                  SizedBox(
                                    width: Dimensions.padding_MarginHome2,
                                  ),
                                  BigText(
                                    text: 'Tiếp tục bằng Facebook',
                                    color: AppColors.WH,
                                    fontweight: FontWeight.w600,
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: Dimensions.heighContainer0 * 2,
                        ),
                        NeumorphicRadio(
                          style: NeumorphicRadioStyle(
                              shape: NeumorphicShape.flat,
                              boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                              lightSource: LightSource.topLeft,
                              unselectedColor: AppColors.WH,
                              selectedColor: AppColors.NOODLE_COLOR),
                          onChanged: (value) {
                            signInWithGoogle().then((user) async {
                              var userNow = user.additionalUserInfo!.profile;
                              var userId = FirebaseAuth.instance.currentUser?.uid;
                              var customer = LoginNRegister(
                                firstName: userNow!['family_name'] == null ? '' : userNow['family_name'],
                                lastName: userNow['given_name'] ?? '',
                                authenPhoneNumberId: '',
                                phoneNumber: '',
                                facebookUserId: '',
                                googleUserId: userId,
                                email: userNow['email'],
                                avatar: userNow['picture'].toString(),
                              );
                              ref.read(collectedUser.notifier).update((state) => userId!);
                              await ref.read(customerMrSoai).onSubmitCustomer(customer);

                              var registrationToken = RegistrationToken(
                                  id: 0,
                                  userId: userId,
                                  deviceToken: await FirebaseMessaging.instance.getToken(),
                                  status: true);
                              await ref.read(customerMrSoai).postRToken(registrationToken);

                              FirebaseAuth.instance.currentUser == null ? null : ref.watch(couponsData);
                              FirebaseAuth.instance.currentUser == null ? null : ref.watch(cartData);
                              FirebaseAuth.instance.currentUser == null
                                  ? null
                                  : ref.read(customerMrSoai).getCustomer(userId!);
                              ref.refresh(customerMrSoai);

                              Navigator.pushNamedAndRemoveUntil(context, 'Home', (route) => false);
                            }).catchError((error) {
                              print('Đăng nhập Google thất bại: $error');
                            });
                          },
                          child: Container(
                              alignment: Alignment.center,
                              height: Dimensions.heightAppbarSearch,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(Dimensions.padding_MarginHome2 + 5),
                                    child: Image.network('http://pngimg.com/uploads/google/google_PNG19635.png',
                                        fit: BoxFit.cover),
                                  ),
                                  BigText(
                                    text: 'Tiếp tục bằng Google',
                                    fontweight: FontWeight.w600,
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(
                          height: Dimensions.heighContainer0,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
