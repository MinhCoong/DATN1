// ignore_for_file: unused_result, unnecessary_brace_in_string_interps

import 'package:fe_flutter_ui/components/itemNotify.dart';
import 'package:fe_flutter_ui/models/address.dart';
import 'package:fe_flutter_ui/models/coupons.dart';
import 'package:fe_flutter_ui/models/customer.dart';
import 'package:fe_flutter_ui/models/order.dart';
import 'package:fe_flutter_ui/provider/cart_provider.dart';
import 'package:fe_flutter_ui/provider/customer_provider.dart';
import 'package:fe_flutter_ui/provider/order_provider.dart';
import 'package:fe_flutter_ui/screens/coupons/coupon_Screen.dart';
import 'package:fe_flutter_ui/screens/curved_nationbar.dart';
import 'package:fe_flutter_ui/screens/home/home_screen.dart';
import 'package:fe_flutter_ui/screens/login/login_screen.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/components/widgets/small_text.dart';
import 'package:fe_flutter_ui/utils/list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_zalopay_sdk/flutter_zalopay_sdk.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:overscroll_pop/overscroll_pop.dart';

import '../../components/dots_.dart';
import '../../components/inputCustomer.dart';
import '../../main.dart';
import '../../models/cart.dart';
import '../../repositories/payment.dart';
import '../../utils/dimensions.dart';
import '../../utils/hero_animation_asset.dart';
import '../../components/widgets/big_text.dart';
import '../oder/address/saved_address.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class CartScreen extends ConsumerStatefulWidget {
  const CartScreen({
    Key? key,
  }) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CartScreenState();
}

class _CartScreenState extends ConsumerState<CartScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  var descriptionAddress = TextEditingController();
  var nameCustomer = TextEditingController();
  var phoneCustomer = TextEditingController();
  String address = '';
  String coupons = '';
  String mDelivery = '';
  String statusPayment = '';
  String paymentMethod = listPayment[0];
  bool payResult = false;
  bool valueSwitch = false;
  double couponsValue = 0.0;
  int totalPrice = 0;
  int priceDelivery = 0;
  int quatityProduct = 0;

  Customer cus = Customer();
  DateTime dateTime = DateTime.now().hour < 22 && DateTime.now().hour > 7
      ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour,
          DateTime.now().minute + 15)
      : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 7);

  String dataAssignment() {
    address = ref.watch(addressCuren);
    cus = ref.watch(customerDataProvider);
    nameCustomer.text = ref.watch(textName);
    phoneCustomer.text = ref.watch(textPhone);
    final methodDelivery = ref.watch(methodDeliveryProvider);
    quatityProduct = ref.watch(quantityCartProvider);

    if (methodDelivery == Denlay) {
      mDelivery = "Mang đi";
      priceDelivery = 0;
    } else {
      mDelivery = "Giao hàng";
      priceDelivery = 15000;
    }
    return methodDelivery;
  }

  Future<void> createOrderX() async {
    final userId = ref.watch(collectedUser);
    final couponsAdd = ref.watch(addCoupons);

    var addOrder = Order(
        id: 0,
        code: "MrSoai",
        userId: userId,
        consigneeName: nameCustomer.text,
        consigneePhoneNumber: phoneCustomer.text,
        couponsId: couponsAdd.id ?? 1,
        orderDate: DateTime.now().toIso8601String(),
        consigneeAddress: mDelivery == GiaoHang ? '${address.trim()} Ghi chú: ${descriptionAddress.text.trim()}' : '',
        deliveryMethod: mDelivery,
        paymentMethod: '$paymentMethod-$statusPayment',
        deliveryCharges: priceDelivery,
        deliveryTime: dateTime.toIso8601String(),
        total: couponsValue >= 1000
            ? (totalPrice + priceDelivery) - couponsValue
            : (totalPrice + priceDelivery) - ((totalPrice + priceDelivery) * couponsValue / 100),
        orderStatus: 0);
    await ref.read(cartNoitfier).onSubmitOrder(addOrder);
    ref.refresh(cartData);
    ref.refresh(orderData);
    ref.watch(addCoupons.notifier).state = Coupons(id: 1);
  }

  Future<void> _removeItemCategory(int? itemFoodId) async {
    var userId = ref.watch(collectedUser);
    await ref.read(cartNotifier).onDeleteCart(itemFoodId, userId).then((value) {
      ref.read(quantityCartProvider.notifier).update((state) => --quatityProduct);
    });
    ref.refresh(cartData);
  }

  Future<void> handlePayment(BuildContext context) async {
    if (phoneCustomer.text == 'null' || phoneCustomer.text == 'Nhập số điện thoại') {
      Navigator.of(context).push(
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) => ItemNotifier(
                  isCorrect: false,
                  text: "Vui lòng nhập số điện thoại ${nameCustomer.text} ơi",
                )),
      );
    } else if (dateTime.day == DateTime.now().day
        ? dateTime.hour == DateTime.now().hour
            ? dateTime.minute < (DateTime.now().minute + 15)
            : dateTime.hour == (DateTime.now().hour + 1)
                ? (dateTime.minute + 60 - DateTime.now().minute) < 15
                : dateTime.minute < 0
        : dateTime.minute < 0 ||
            dateTime.day < DateTime.now().day ||
            (DateTime.now().hour > 22 && dateTime.day == DateTime.now().day)) {
      Navigator.of(context).push(
        PageRouteBuilder(
            opaque: false,
            pageBuilder: (BuildContext context, _, __) => ItemNotifier(
                  isCorrect: false,
                  text: "Chọn lại thời gian giúp mình với ${nameCustomer.text} ơi",
                )),
      );
    } else {
      if (paymentMethod == zalopay) {
        var result = await createOrder(couponsValue >= 1000
            ? (totalPrice + priceDelivery) - couponsValue
            : (totalPrice + priceDelivery) - ((totalPrice + priceDelivery) * couponsValue / 100));
        if (result != null) {
          statusPayment = result.zptranstoken;
        }
        FlutterZaloPaySdk.payOrder(zpToken: statusPayment).listen((event) {
          switch (event) {
            case FlutterZaloPayStatus.cancelled:
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) => const ItemNotifier(
                        isCorrect: false,
                        text: "Thanh toán thất bại",
                      )));
              break;
            case FlutterZaloPayStatus.success:
              createOrderX().then((value) => Get.back());

              break;
            case FlutterZaloPayStatus.failed:
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) => const ItemNotifier(
                        isCorrect: false,
                        text: "Thanh toán thất bại",
                      )));
              break;
            default:
              Navigator.of(context).push(PageRouteBuilder(
                  opaque: false,
                  pageBuilder: (BuildContext context, _, __) => const ItemNotifier(
                        isCorrect: false,
                        text: "Thanh toán thất bại",
                      )));

              break;
          }
        });
      } else {
        createOrderX().then((value) => Get.back());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    String methodDelivery = dataAssignment();
    return SafeArea(
        child: Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: Hero(
          createRectTween: HeroAnimationAsset.customTweenRect,
          tag: "CardScreen",
          child: Material(
            color: Colors.transparent,
            child: Container(
                clipBehavior: Clip.hardEdge,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  color: AppColors.BACKGROUND_COLOR,
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      physics: const ClampingScrollPhysics(),
                      child: Column(
                        children: [
                          SizedBox(
                            height: Dimensions.heighContainer1,
                          ),
                          methodDelivery == Denlay ? builderDeliveryMethods() : builderDeliveryMethods2(),
                          SizedBox(
                            height: Dimensions.heighContainer0,
                          ),
                          builderChosseFood(),
                          SizedBox(
                            height: Dimensions.heighContainer0,
                          ),
                          builderTotalPrice(),
                          SizedBox(
                            height: Dimensions.heighContainer0,
                          ),
                          builderPaymemtMethods()
                        ],
                      ),
                    ),
                    builderAppCard(),
                  ],
                )),
          )),
      bottomNavigationBar: Container(
        padding:
            EdgeInsets.symmetric(horizontal: Dimensions.heighContainer0 * 1.5, vertical: Dimensions.heighContainer0),
        color: AppColors.BURGUNDY,
        height: Dimensions.heighContainer1,
        width: Dimensions.screenWidth,
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: BigText(
                      text: '$mDelivery ~ ${quatityProduct} món',
                      color: AppColors.NOODLE_COLOR,
                    ),
                  ),
                  Expanded(
                    child: Text(
                      '${formatCurrency.format(couponsValue >= 1000 ? ((totalPrice + priceDelivery) - couponsValue) : ((totalPrice + priceDelivery) - ((totalPrice + priceDelivery) * couponsValue / 100)))}đ',
                      style: GoogleFonts.comfortaa(
                          color: AppColors.NOODLE_COLOR.withOpacity(0.9),
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 3,
                child: NeumorphicButton(
                  onPressed: () async {
                    FirebaseAuth.instance.currentUser == null
                        ? Get.to(() => const LoginScreen())
                        : await handlePayment(context);
                  },
                  padding: EdgeInsets.all(Dimensions.heighContainer0),
                  margin: const EdgeInsets.all(5),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                      depth: -2,
                      lightSource: LightSource.topLeft,
                      color: AppColors.NOODLE_COLOR),
                  child: Center(
                    child: BigText(
                      text: 'ĐẶT HÀNG',
                      color: AppColors.BURGUNDY.withOpacity(0.8),
                      fontweight: FontWeight.w900,
                    ),
                  ),
                )),
          ],
        ),
      ),
    ));
  }

  Container builderDeliveryMethods2() {
    Addresses addresses = ref.watch(addAddress);
    addresses.addrressValue != null ? address = addresses.addrressValue! : null;
    addresses.description != null ? descriptionAddress.text = addresses.description! : null;
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: BigText(
                text: 'Giao hàng tận nơi',
                color: Colors.black.withOpacity(.9),
                fontweight: FontWeight.w800,
                size: 16,
              ),
            ),
            Expanded(
              flex: 3,
              child: NeumorphicButton(
                padding: const EdgeInsets.all(10),
                onPressed: () {
                  ref.read(methodDeliveryProvider.notifier).update((state) => Denlay);
                },
                style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(20))),
                    depth: 2,
                    lightSource: LightSource.topLeft,
                    color: AppColors.NOODLE_COLOR),
                child: BigText(
                  text: 'Thay đổi',
                  fontweight: FontWeight.w900,
                  color: AppColors.BURGUNDY.withOpacity(0.7),
                  size: 12,
                  overFlow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        ListTile(
          onTap: () {
            Get.to(() => const SaveAddressScreen(
                  isComingFromCart: true,
                ));
          },
          minLeadingWidth: 0,
          contentPadding: EdgeInsets.zero,
          visualDensity: const VisualDensity(vertical: 3),
          title: BigText(
            text: address.split(',')[0],
            fontweight: FontWeight.w800,
          ),
          subtitle: SmallText(text: address),
          trailing: Icon(
            Icons.arrow_forward_ios,
            color: Colors.black.withOpacity(.7),
            size: 14,
          ),
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
                  controller: descriptionAddress,
                  cursorColor: AppColors.BURGUNDY,
                  cursorWidth: 2,
                  cursorHeight: 35,
                  autofocus: false,
                  style: GoogleFonts.comfortaa(height: 2, fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Thêm hướng dẫn giao hàng',
                    hintStyle: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w500),
                  ))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 13,
              child: SizedBox(
                height: Dimensions.heighContainer1,
                width: Dimensions.screenWidth / 2 - 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                        child: ListTile(
                      onTap: () {
                        pushOverscrollRoute(
                            barrierColor: null,
                            context: context,
                            scrollToPopOption: ScrollToPopOption.start,
                            child: const InputCustomer());
                      },
                      visualDensity: const VisualDensity(vertical: 2),
                      contentPadding: EdgeInsets.zero,
                      title: BigText(
                        text: nameCustomer.text.toUpperCase().trim(),
                        overFlow: TextOverflow.visible,
                      ),
                      subtitle: SmallText(text: phoneCustomer.text),
                    )),
                    const DottedBoderAPP()
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                padding: const EdgeInsets.all(20),
                width: 2,
                height: Dimensions.heightListtile - 10,
                color: Colors.black.withOpacity(.3),
                margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              ),
            ),
            Expanded(
              flex: 13,
              child: SizedBox(
                height: Dimensions.heighContainer1,
                width: Dimensions.screenWidth / 2 - 30,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: CupertinoButton(
                        padding: EdgeInsets.only(bottom: Dimensions.heighContainer0),
                        alignment: Alignment.topCenter,
                        onPressed: () {
                          _cupertinoPopupTime();
                        },
                        child: SizedBox(
                          height: 30,
                          child: ListTile(
                            visualDensity: const VisualDensity(vertical: 2),
                            contentPadding: EdgeInsets.zero,
                            title: BigText(
                              text:
                                  '${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}/${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}',
                            ),
                            subtitle: SmallText(
                                text:
                                    '${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}'),
                          ),
                        ),
                      ),
                    ),
                    const DottedBoderAPP()
                  ],
                ),
              ),
            )
          ],
        ),
        SizedBox(
          height: Dimensions.heighContainer0,
        ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Expanded(
        //       flex: 3,
        //       child: BigText(
        //         text: 'Lưu thông tin giao hàng',
        //       ),
        //     ),
        //     Flexible(
        //       child: NeumorphicSwitch(
        //         value: valueSwitch,
        //         style: NeumorphicSwitchStyle(
        //             thumbDepth: 1,
        //             activeThumbColor: AppColors.NOODLE_COLOR,
        //             activeTrackColor: AppColors.BURGUNDY.withOpacity(1),
        //             inactiveThumbColor: AppColors.NOODLE_COLOR),
        //         onChanged: (value) {
        //           setState(() {
        //             if (value) {
        //               valueSwitch = true;
        //             } else {
        //               valueSwitch = false;
        //             }
        //           });
        //         },
        //       ),
        //     )
        //   ],
        // )
      ]),
    );
  }

  void _cupertinoPopupTime() {
    showCupertinoModalPopup(
        context: context,
        builder: (BuildContext context) => Container(
              decoration: const BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
              height: Dimensions.heighContainer2 * 1.1,
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: Dimensions.heighContainer0 * 1.8),
                    child: CupertinoDatePicker(
                      initialDateTime: DateTime.now().hour < 22
                          ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour,
                              DateTime.now().minute + 15)
                          : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 7),
                      minimumDate: DateTime.now().hour < 22
                          ? DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, DateTime.now().hour,
                              DateTime.now().minute + 15)
                          : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day + 1, 7),
                      maximumDate: DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day + 3,
                      ),
                      onDateTimeChanged: (DateTime newTime) {
                        setState(() {
                          dateTime = newTime;
                        });
                      },
                      use24hFormat: true,
                      mode: CupertinoDatePickerMode.dateAndTime,
                    ),
                  ),
                  Align(
                    alignment: Alignment.topLeft,
                    child: NeumorphicButton(
                      margin: const EdgeInsets.all(10),
                      onPressed: () {
                        Get.back();
                      },
                      style: NeumorphicStyle(
                          boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                          depth: 2,
                          lightSource: LightSource.topLeft,
                          color: AppColors.BURGUNDY),
                      child: const Icon(
                        Icons.close,
                        color: AppColors.NOODLE_COLOR,
                        size: 20,
                      ),
                    ),
                  ),
                ],
              ),
            ));
  }

  Container builderPaymemtMethods() {
    return Container(
      width: double.infinity,
      height: Dimensions.heigthAppBar2,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BigText(
          text: ' Thanh toán',
          color: Colors.black.withOpacity(.9),
          fontweight: FontWeight.w800,
          size: 16,
        ),
        Expanded(
          child: DropdownButtonFormField(
              itemHeight: Dimensions.heighContainer1,
              isExpanded: true,
              borderRadius: BorderRadius.circular(15),
              decoration: const InputDecoration(border: InputBorder.none),
              value: paymentMethod,
              items: listPayment.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: SizedBox(
                      width: Dimensions.screenWidth / 1.3,
                      child: Row(
                        children: [
                          e == zalopay
                              ? const Image(
                                  width: 40,
                                  height: 40,
                                  image: AssetImage('assets/images/zalopay.png'),
                                )
                              : const Image(
                                  width: 40,
                                  height: 40,
                                  image: AssetImage('assets/images/wallet.png'),
                                ),
                          SizedBox(
                            width: Dimensions.padding_MarginHome2,
                          ),
                          BigText(
                            text: e,
                          ),
                        ],
                      )),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  paymentMethod = value as String;
                });
              }),
        )
      ]),
    );
  }

  Container builderChosseFood() {
    final listFood = ref.watch(cartData);
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BigText(
          text: 'Món đã chọn',
          color: Colors.black.withOpacity(.9),
          fontweight: FontWeight.w800,
          size: 16,
        ),
        listFood.when(
            skipLoadingOnReload: true,
            skipLoadingOnRefresh: true,
            data: (itemF) {
              List<Cart> lstFood = itemF;
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: lstFood.length,
                itemBuilder: (_, index) {
                  var toppingSelected = '';
                  var productNamex = lstFood[index].product!.productName ?? '';
                  if (lstFood[index].cartNToppings != null) {
                    for (var element in lstFood[index].cartNToppings!) {
                      toppingSelected += '${element.toppings!.toppingName} ~ ';
                    }
                  }
                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    child: Slidable(
                      key: UniqueKey(),
                      // ignore: prefer_const_constructors
                      endActionPane: ActionPane(
                        motion: const ScrollMotion(),
                        dismissible: DismissiblePane(onDismissed: () {
                          _removeItemCategory(lstFood[index].id);
                          index == lstFood.length - 1 ? Get.back() : null;
                        }),
                        children: [
                          SlidableAction(
                            borderRadius: BorderRadius.circular(10),
                            onPressed: (context) async {
                              await _removeItemCategory(lstFood[index].id);
                              index == lstFood.length - 1 ? Get.back() : null;
                            },
                            backgroundColor: AppColors.BURGUNDY,
                            foregroundColor: AppColors.NOODLE_COLOR,
                            icon: Icons.delete,
                            label: 'Xóa',
                          )
                        ],
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            horizontalTitleGap: 5,
                            minLeadingWidth: 15,
                            contentPadding: EdgeInsets.zero,
                            leading: Icon(
                              Icons.star_border_purple500_rounded,
                              color: AppColors.BURGUNDY.withOpacity(.7),
                            ),
                            title: BigText(
                              text: '${lstFood[index].quantity}x $productNamex',
                              fontweight: FontWeight.w800,
                              overFlow: TextOverflow.visible,
                            ),
                            subtitle: SmallText(
                                text:
                                    "${lstFood[index].size!.sizeName}${toppingSelected == '' ? '' : ' ~ $toppingSelected'}${lstFood[index].desciption}"),
                            trailing: BigText(
                              text: '${formatCurrency.format(lstFood[index].priceProduct)}đ',
                            ),
                          ),
                          index != lstFood.length - 1
                              ? Divider(
                                  height: 0,
                                  thickness: 1,
                                  color: Colors.black.withOpacity(.1),
                                )
                              : Container(),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            error: (error, s) => Text(error.toString()),
            loading: () => const Center(
                  child: CircularProgressIndicator(),
                ))
      ]),
    );
  }

  Container builderTotalPrice() {
    var addCouponsX = ref.watch(addCoupons);
    addCouponsX.title != null ? coupons = addCouponsX.title! : null;
    addCouponsX.discount != null ? couponsValue = double.parse(addCouponsX.discount.toString()) : null;
    final listFood = ref.watch(cartData);
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BigText(
          text: 'Tổng cộng',
          color: Colors.black.withOpacity(.9),
          fontweight: FontWeight.w800,
          size: 16,
        ),
        SizedBox(
          height: Dimensions.heighContainer0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.heighContainer0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: BigText(
                  text: 'Thành tiền',
                ),
              ),
              listFood.when(
                  data: (data) {
                    totalPrice = 0;
                    List<Cart> listItem = data.map((e) => e).toList();
                    for (var element in listItem) {
                      totalPrice += element.priceProduct!;
                    }
                    return Flexible(
                      child: BigText(
                        text: '${formatCurrency.format(totalPrice)}đ',
                      ),
                    );
                  },
                  error: (error, s) => Text(error.toString()),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      )),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.black.withOpacity(.1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.heighContainer0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: BigText(
                  text: 'Phí giao hàng',
                ),
              ),
              Flexible(
                child: BigText(
                  text: '${formatCurrency.format(priceDelivery)}đ',
                ),
              ),
            ],
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.black.withOpacity(.1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.heighContainer0),
          child: GestureDetector(
            onTap: () {
              Get.to(() => CouponScreen(
                    isComingFromCart: true,
                    quantity: quatityProduct,
                    total: double.parse(totalPrice.toString()),
                  ));
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(
                        text: 'Chọn khuyến mãi',
                        color: AppColors.ORANGE,
                      ),
                      coupons.isNotEmpty ? BigText(text: coupons) : Container()
                    ],
                  ),
                ),
                Flexible(
                  child: couponsValue != 0
                      ? BigText(text: couponsValue > 1000 ? '-$couponsValue' : '-$couponsValue%')
                      : Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.black.withOpacity(.7),
                          size: 15,
                        ),
                ),
              ],
            ),
          ),
        ),
        Divider(
          thickness: 1,
          color: Colors.black.withOpacity(.1),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimensions.heighContainer0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: BigText(
                  text: 'Số tiền thanh toán',
                ),
              ),
              Flexible(
                child: BigText(
                  text:
                      '${formatCurrency.format(couponsValue >= 1000 ? ((totalPrice + priceDelivery) - couponsValue) : ((totalPrice + priceDelivery) - ((totalPrice + priceDelivery) * couponsValue / 100)))}đ',
                ),
              ),
            ],
          ),
        ),
      ]),
    );
  }

  Container builderDeliveryMethods() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 5),
      child: Column(children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 9,
              child: BigText(
                text: 'Đến lấy món',
                color: Colors.black.withOpacity(.9),
                fontweight: FontWeight.w800,
                size: 16,
              ),
            ),
            Expanded(
              flex: 3,
              child: NeumorphicButton(
                padding: const EdgeInsets.all(10),
                onPressed: () {
                  ref.read(methodDeliveryProvider.notifier).update((state) => Giaoden);
                },
                style: NeumorphicStyle(
                    shape: NeumorphicShape.flat,
                    boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(20))),
                    depth: 2,
                    lightSource: LightSource.topLeft,
                    color: AppColors.NOODLE_COLOR),
                child: BigText(
                  text: 'Thay đổi',
                  fontweight: FontWeight.w900,
                  color: AppColors.BURGUNDY.withOpacity(0.7),
                  size: 12,
                  overFlow: TextOverflow.visible,
                  textAlign: TextAlign.center,
                ),
              ),
            )
          ],
        ),
        ListTile(
          visualDensity: const VisualDensity(vertical: 0),
          contentPadding: EdgeInsets.zero,
          title: BigText(
            text: 'Mr Soái',
          ),
          subtitle: SmallText(text: '1/2 Lê Văn Thọ, Phường 8, Tp Bảo Lộc, Tỉnh Lâm Đồng, Việt Nam'),
        ),
        Divider(
          height: 0,
          thickness: 1,
          color: Colors.black.withOpacity(.3),
        ),
        CupertinoButton(
          padding: EdgeInsets.only(bottom: Dimensions.heighContainer0),
          alignment: Alignment.topCenter,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          minSize: 0,
          onPressed: () {
            _cupertinoPopupTime();
          },
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: BigText(
              text:
                  '${dateTime.month < 10 ? '0${dateTime.month}' : dateTime.month}/${dateTime.day < 10 ? '0${dateTime.day}' : dateTime.day}',
            ),
            subtitle: SmallText(
                text:
                    '${dateTime.hour < 10 ? '0${dateTime.hour}' : dateTime.hour}:${dateTime.minute < 10 ? '0${dateTime.minute}' : dateTime.minute}'),
            trailing: Icon(
              Icons.arrow_forward_ios,
              color: Colors.black.withOpacity(.7),
              size: 20,
            ),
          ),
        ),
      ]),
    );
  }

  Container builderAppCard() {
    return Container(
      color: Colors.white,
      height: Dimensions.heigthAppBarCustom,
      padding: const EdgeInsets.all(20),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Expanded(
          child: GestureDetector(
            onTap: () {
              _removeItemCategory(null);
              final userId = ref.watch(collectedUser);
              ref.read(cartNotifier).onGetCart(userId);
              ref.refresh(cartData);
              Get.back();
            },
            child: BigText(
              text: 'Xóa',
              fontweight: FontWeight.w800,
              color: Colors.black.withOpacity(.6),
              size: 13,
            ),
          ),
        ),
        Expanded(
          flex: 4,
          child: Center(
            child: BigText(
              text: 'Xác nhận đơn hàng',
              fontweight: FontWeight.w800,
              color: Colors.black.withOpacity(.9),
            ),
          ),
        ),
        Expanded(
          child: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: NeumorphicIcon(
                Icons.close,
                size: 20,
                style: NeumorphicStyle(color: Colors.black.withOpacity(.6), depth: 5, shape: NeumorphicShape.concave),
              ),
            ),
          ),
        )
      ]),
    );
  }
}
