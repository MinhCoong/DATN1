// ignore_for_file: avoid_print, use_build_context_synchronously, unused_result

import 'package:fe_flutter_ui/screens/login/login_screen.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pinput/pinput.dart';

import '../../components/showdialog_notify.dart';
import '../../main.dart';
import '../../models/login.dart';
import '../../models/registrationtoken.dart';
import '../../provider/cart_provider.dart';
import '../../provider/customer_provider.dart';
import '../../provider/news_provider.dart';
import '../../utils/colors.dart';

class OtpScreen extends ConsumerWidget {
  OtpScreen({super.key, required this.phoneNumnber});
  final String phoneNumnber;
  static String verify = '';

  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final defaultPinTheme = PinTheme(
      height: Dimensions.heightAppbarSearch,
      width: Dimensions.widthContainer,
      textStyle: GoogleFonts.comfortaa(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        boxShadow: [
          BoxShadow(offset: const Offset(2, 3), color: Colors.black.withOpacity(.25), blurRadius: 5, spreadRadius: -1)
        ],
        borderRadius: BorderRadius.circular(15),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      borderRadius: BorderRadius.circular(15),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: AppColors.WH,
      ),
    );
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: SizedBox(
            height: Dimensions.screenHeight / 1.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  BigText(
                    text: 'Xác nhận mã OTP',
                    fontweight: FontWeight.w900,
                    color: Colors.black.withOpacity(.7),
                  ),
                  SizedBox(
                    height: Dimensions.heighContainer0,
                  ),
                  BigText(
                    text: 'Một mã gồm 6 số được gửi tới số điện thoại',
                    textAlign: TextAlign.center,
                    overFlow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: Dimensions.heighContainer0 / 2,
                  ),
                  BigText(
                    text: phoneNumnber,
                    size: 16,
                    overFlow: TextOverflow.visible,
                  ),
                  SizedBox(
                    height: Dimensions.heighContainer0,
                  ),
                  SizedBox(
                    height: Dimensions.heightAppbarSearch,
                  ),
                  BigText(
                    text: 'Nhấp để tiếp tục',
                    fontweight: FontWeight.w800,
                    color: Colors.black.withOpacity(.7),
                  ),
                  SizedBox(
                    height: Dimensions.heighContainer0,
                  ),
                  Pinput(
                    androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
                    length: 6,
                    defaultPinTheme: defaultPinTheme,
                    focusedPinTheme: focusedPinTheme,
                    submittedPinTheme: submittedPinTheme,
                    // errorPinTheme: errorPinTheme,
                    showCursor: true,
                    onCompleted: (pin) async {
                      try {
                        PhoneAuthCredential credential =
                            PhoneAuthProvider.credential(verificationId: LoginScreen.verify, smsCode: pin);
                        await auth.signInWithCredential(credential);
                        var userId = FirebaseAuth.instance.currentUser?.uid;
                        var customer = LoginNRegister(
                          firstName: "Mr Soai's",
                          lastName: "User",
                          authenPhoneNumberId: userId,
                          phoneNumber: phoneNumnber,
                          facebookUserId: '',
                          googleUserId: '',
                          email: '',
                          avatar: '',
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
                      } catch (e) {
                        print('Error');
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            opaque: false,
                            pageBuilder: (BuildContext context, _, __) => const NotifyShowdialog(
                              content: 'Nhập sai mã OTP rồi!!',
                            ),
                          ),
                        );
                      }
                    },
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
                        await FirebaseAuth.instance.verifyPhoneNumber(
                          phoneNumber: phoneNumnber,
                          verificationCompleted: (PhoneAuthCredential credential) {},
                          verificationFailed: (FirebaseAuthException e) {
                            if (e.code == 'invalid-phone-number') {
                              print('The provided phone number is not valid.');
                            }
                          },
                          codeSent: (String verificationId, int? resendToken) {
                            LoginScreen.verify = verificationId;
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
                          text: 'Gửi lại mã OTP',
                          color: AppColors.BURGUNDY.withOpacity(.7),
                          fontweight: FontWeight.w800,
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
