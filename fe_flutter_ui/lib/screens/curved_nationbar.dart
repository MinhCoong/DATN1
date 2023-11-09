// ignore_for_file: unused_field

import 'package:fe_flutter_ui/provider/cart_provider.dart';
import 'package:fe_flutter_ui/screens/cart/cart_screen.dart';
import 'package:fe_flutter_ui/screens/discount/discount_screen.dart';
import 'package:fe_flutter_ui/screens/favorite/favorite_screen.dart';
import 'package:fe_flutter_ui/screens/home/home_screen.dart';
import 'package:fe_flutter_ui/screens/menu/menu_screen.dart';
import 'package:fe_flutter_ui/screens/oder/oder_screen.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fe_flutter_ui/utils/list_item.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:overscroll_pop/overscroll_pop.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

import '../models/cart.dart';
import '../provider/favorite_provider.dart';
import '../utils/hero_animation_asset.dart';
import '../components/widgets/bottom_naviga_item.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

final quantityCartProvider = StateProvider<int>((ref) {
  return 0;
});

class BottomNavigaBar extends ConsumerStatefulWidget {
  const BottomNavigaBar({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _BottomNavigaBarState();
}

class _BottomNavigaBarState extends ConsumerState<BottomNavigaBar> {
  int index = 0;

  double sWidth = Dimensions.screenWidth - Dimensions.padding_MarginHome;
  double sHeight = Dimensions.heightListtile;
  double borderRadius = 10;
  double paddingNeumorphic = Dimensions.heighContainer0;
  double paddingNeumorphic2 = Dimensions.heighContainer0 / 2;
  double marginContainer = Dimensions.heighContainer0;

  void _expandBox() {
    setState(() {
      sWidth = Dimensions.screenWidth - Dimensions.padding_MarginHome * 5;
      sHeight = Dimensions.heightListtile - Dimensions.heighContainer0 * 2.5;
      marginContainer = Dimensions.padding_MarginHome;
      borderRadius = 60;
      paddingNeumorphic = Dimensions.heighContainer0 * 0.2;
      paddingNeumorphic2 = 0;
    });
  }

  void _startBox() {
    setState(() {
      sWidth = Dimensions.screenWidth - Dimensions.padding_MarginHome;
      sHeight = Dimensions.heightListtile;
      marginContainer = Dimensions.padding_MarginHome / 2;
      borderRadius = 10;
      paddingNeumorphic = Dimensions.heighContainer0;
      paddingNeumorphic2 = Dimensions.heighContainer0 / 2;
    });
  }

  void _onhandlePushCart(BuildContext context) {
    ref.read(quantityCartProvider.notifier).update((state) => quantity);
    pushOverscrollRoute(
      barrierColor: null,
      context: context,
      scrollToPopOption: ScrollToPopOption.start,
      child: const CartScreen(),
    );
  }

  void _updateLocation(PointerEvent details) {
    if (details.delta.dy > 5) {
      // Vuốt xuống
      _startBox();
    } else if (details.delta.dy < -5) {
      // Vuốt lên
      _expandBox();
    }
  }

  int totalPrice = 0;
  int quantity = 0;

  @override
  Widget build(BuildContext context) {
    index = ref.watch(indexScreenProvider);
    final methodDelivery = ref.watch(methodDeliveryProvider);

    return Listener(
      onPointerMove: _updateLocation,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // bottomNavigationBar:
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                width: double.infinity,
                height: double.infinity,
                alignment: Alignment.center,
                child: getSelectedWidget(index: index)),
            if (index == 1 || index == 2)
              Positioned(
                  bottom: Dimensions.heightListtile + Dimensions.heighContainer0 * 1.5,
                  child: AnimatedContainer(
                    alignment: Alignment.center,
                    transformAlignment: Alignment.bottomCenter,
                    duration: const Duration(milliseconds: 500),
                    width: sWidth,
                    height: sHeight,
                    margin: EdgeInsets.fromLTRB(marginContainer, marginContainer, marginContainer, 10),
                    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(borderRadius))),
                    child: Neumorphic(
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat,
                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(borderRadius))),
                            depth: 5,
                            lightSource: LightSource.topLeft,
                            color: AppColors.WH),
                        child: Container(
                            height: double.infinity,
                            width: double.infinity,
                            padding: EdgeInsets.all(paddingNeumorphic),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      sHeight >= Dimensions.heightListtile
                                          ? Expanded(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(right: Dimensions.heighContainer0 / 2),
                                                    child: Image(
                                                        width: Dimensions.heighContainer0 * 2,
                                                        height: Dimensions.heighContainer0 * 2,
                                                        image: const AssetImage('assets/images/delivery.png')),
                                                  ),
                                                  Expanded(
                                                    child: BigText(
                                                      text: methodDelivery,
                                                      size: 11,
                                                      color: Colors.black.withOpacity(0.8),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          : Container(),
                                      Expanded(
                                        child: Row(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            sHeight < Dimensions.heightListtile
                                                ? Padding(
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: Dimensions.heighContainer0 / 2),
                                                    child: WidgetAnimator(
                                                      incomingEffect: WidgetTransitionEffects.incomingSlideInFromLeft(
                                                          opacity: 0, duration: const Duration(milliseconds: 500)),
                                                      child: Image(
                                                          width: Dimensions.heighContainer0 * 2,
                                                          height: Dimensions.heighContainer0 * 2,
                                                          image: const AssetImage('assets/images/delivery.png')),
                                                    ),
                                                  )
                                                : Container(),
                                            Expanded(
                                              child: BigText(
                                                text: methodDelivery == Denlay
                                                    ? '1/2 Lê Văn Thọ, Phường 8, Tp Bảo Lộc, Lâm Đồng'
                                                    : '1122 Quang Trung, Gò Vấp, P11, HCM',
                                                size: 12,
                                                color: Colors.black.withOpacity(0.8),
                                                overFlow: TextOverflow.ellipsis,
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                ref.watch(cartData).when(
                                    skipLoadingOnReload: true,
                                    data: (data) {
                                      totalPrice = 0;
                                      quantity = 0;
                                      List<Cart> listItem = data.map((e) => e).toList();
                                      for (var element in listItem) {
                                        totalPrice += element.priceProduct!;
                                        quantity += element.quantity!;
                                      }

                                      return listItem.isNotEmpty
                                          ? Hero(
                                              createRectTween: HeroAnimationAsset.customTweenRect,
                                              flightShuttleBuilder: (
                                                BuildContext flightContext,
                                                Animation<double> animation,
                                                HeroFlightDirection flightDirection,
                                                BuildContext fromHeroContext,
                                                BuildContext toHeroContext,
                                              ) {
                                                final Hero toHero = toHeroContext.widget as Hero;
                                                return SizeTransition(
                                                  sizeFactor: animation,
                                                  child: toHero.child,
                                                );
                                              },
                                              tag: 'CardScreen',
                                              child: NeumorphicButton(
                                                onPressed: () {
                                                  _onhandlePushCart(context);
                                                },
                                                padding: EdgeInsets.symmetric(
                                                    vertical: paddingNeumorphic,
                                                    horizontal: Dimensions.heighContainer0),
                                                style: NeumorphicStyle(
                                                    shape: NeumorphicShape.flat,
                                                    boxShape: NeumorphicBoxShape.roundRect(
                                                        BorderRadius.all(Radius.circular(borderRadius))),
                                                    depth: 3,
                                                    lightSource: LightSource.topLeft,
                                                    color: AppColors.NOODLE_COLOR),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Neumorphic(
                                                      padding: EdgeInsets.all(paddingNeumorphic2),
                                                      style: const NeumorphicStyle(
                                                          shape: NeumorphicShape.convex,
                                                          boxShape: NeumorphicBoxShape.circle(),
                                                          depth: -3,
                                                          lightSource: LightSource.topLeft,
                                                          color: AppColors.BACKGROUND_COLOR),
                                                      child: Container(
                                                        alignment: Alignment.center,
                                                        height: 50,
                                                        width: 20,
                                                        child: BigText(
                                                          text: quantity.toString(),
                                                          size: 12,
                                                          overFlow: TextOverflow.visible,
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      width: Dimensions.padding_MarginHome2 / 2,
                                                    ),
                                                    BigText(
                                                      text: '${formatCurrency.format(totalPrice)}đ',
                                                      overFlow: TextOverflow.visible,
                                                    )
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Container();
                                    },
                                    error: (error, s) => Text(error.toString()),
                                    loading: () => Container()),
                              ],
                            ))),
                  ))
            else
              Container(),
            Align(
              alignment: Alignment.bottomCenter,
              child: CurvedNavigationBar(
                items: [
                  BottomNatigaItem(
                    icons: FontAwesomeIcons.house,
                    lable: index == 0 ? '' : 'Trang chủ',
                  ),
                  BottomNatigaItem(
                    icons: FontAwesomeIcons.mugHot,
                    lable: index == 1 ? '' : 'Đặt hàng',
                  ),
                  BottomNatigaItem(
                    icons: FontAwesomeIcons.solidHeart,
                    lable: index == 2 ? '' : 'Yêu thích',
                  ),
                  BottomNatigaItem(
                    icons: FontAwesomeIcons.ticketSimple,
                    lable: index == 3 ? '' : 'Ưu đãi',
                  ),
                  BottomNatigaItem(
                    icons: FontAwesomeIcons.bars,
                    lable: index == 4 ? '' : 'Khác',
                  ),
                ],
                index: index,
                onTap: (selctedIndex) {
                  setState(() {
                    ref.read(indexScreenProvider.notifier).update((state) => selctedIndex);
                    if (selctedIndex == 2) {
                      // ignore: unused_result
                      ref.refresh(favoriteData);
                    }
                  });
                },
                height: Dimensions.heightListtile * 0.9,
                backgroundColor: Colors.transparent,
                animationDuration: const Duration(milliseconds: 300),
                color: AppColors.BURGUNDY,
                buttonBackgroundColor: AppColors.NOODLE_COLOR,
                animationCurve: Curves.easeInOut,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getSelectedWidget({required int index}) {
    Widget widget;
    switch (index) {
      case 0:
        widget = const HomeScreen();
        break;
      case 1:
        widget = const MenuScreen();
        break;
      case 2:
        widget = const FavoriteScreen();
        break;
      case 3:
        widget = const DiscountScreen();
        break;
      default:
        widget = const OrderScreen();
        break;
    }
    return widget;
  }
}
