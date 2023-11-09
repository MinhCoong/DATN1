// ignore_for_file: public_member_api_docs, sort_constructors_first, unused_result
import 'package:fe_flutter_ui/models/cart.dart';
import 'package:fe_flutter_ui/models/favorite.dart';
import 'package:fe_flutter_ui/models/topping_category.dart';
import 'package:fe_flutter_ui/provider/cart_provider.dart';
import 'package:fe_flutter_ui/provider/favorite_provider.dart';
import 'package:fe_flutter_ui/provider/topping_provider.dart';
import 'package:fe_flutter_ui/utils/list_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:fe_flutter_ui/models/productmrsoai.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:fe_flutter_ui/components/widgets/small_text.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../components/widgets/imagecacheprovider.dart';
import '../../main.dart';
import '../../utils/hero_animation_asset.dart';
import '../login/login_screen.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class DetailsFoodScreen extends ConsumerStatefulWidget {
  const DetailsFoodScreen({
    Key? key,
    required this.foodData,
    required this.isFavorite,
  }) : super(key: key);
  final Products? foodData;
  final bool isFavorite;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailsFoodScreenState();
}

class _DetailsFoodScreenState extends ConsumerState<DetailsFoodScreen> with AutomaticKeepAliveClientMixin {
  String? groupValue = '';
  Color customColor = AppColors.NOODLE_COLOR;
  int indexSize = 0;
  int quantity = 1;
  int endPrice = 0;
  double priceTopping = 0.0;
  List<int> addListTopping = [];
  TextEditingController description = TextEditingController();

  @override
  void initState() {
    super.initState();
    groupValue = widget.foodData?.prices![0].size!.sizeName;
    setState(() {
      endPrice = (widget.foodData!.prices![indexSize].priceOfProduct! * quantity);
    });
  }

  Future<void> _likeOrDislike() async {
    final userId = ref.watch(collectedUser);
    var itemFavorite = Favorite(id: 0, userId: userId, productId: widget.foodData!.id, status: true);
    await ref.read(favoriteNotifier).onSubmitFavorite(itemFavorite);

    ref.refresh(favoriteData);
    ref.refresh(cartData);

    setState(() {
      widget.foodData!.isFavorite = !widget.foodData!.isFavorite;
    });
  }

  Future<void> _handleAddToCart() async {
    final userId = ref.watch(collectedUser);
    var addCart = AddToCartModel(
        userId: userId,
        productId: widget.foodData!.id,
        sizeId: indexSize + 1,
        quantity: quantity,
        description: description.text.trim(),
        priceProduct: endPrice + priceTopping,
        toppingSelect: addListTopping);
    await ref.read(cartNotifier).onSubmitCart(addCart);

    ref.refresh(cartData);
    Get.back();
  }

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Hero(
          createRectTween: HeroAnimationAsset.customTweenRect,
          tag: widget.foodData!.image.toString(),
          child: Material(
            color: Colors.transparent,
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: AppColors.WH,
              ),
              child: Stack(
                children: [
                  Stack(
                    children: [
                      Neumorphic(
                        padding: EdgeInsets.symmetric(vertical: Dimensions.heighContainer0, horizontal: Dimensions.heighContainer0 * 2),
                        style: NeumorphicStyle(
                            shape: NeumorphicShape.flat, depth: -5, lightSource: LightSource.topLeft, color: AppColors.NOODLE_COLOR.withOpacity(.8)),
                        child: Container(
                          padding: EdgeInsets.fromLTRB(
                              Dimensions.heighContainer0, Dimensions.heighContainer0 * 2, Dimensions.heighContainer0, Dimensions.heighContainer0 * 5),
                          height: Dimensions.heightImage,
                          child: ImageCachedProvider(
                            url: UrlImageProduct + widget.foodData!.image.toString(),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                            padding: EdgeInsets.only(
                              top: Dimensions.heightImage - Dimensions.heighContainer0 * 2,
                            ),
                            child: Container(
                              decoration: const BoxDecoration(
                                  color: AppColors.BACKGROUND_COLOR, borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                              child: Column(children: [
                                builderDetailsFood(),
                                builderWidgetRadio(),
                                builderCheckbox(), //gay lag
                                builderNote()
                              ]),
                            )),
                      ),
                    ],
                  ),
                  Positioned(
                    top: Dimensions.padding_MarginHome2,
                    right: Dimensions.padding_MarginHome2,
                    child: Align(
                      alignment: Alignment.topRight,
                      child: NeumorphicButton(
                        onPressed: () {
                          Get.back();
                        },
                        style: const NeumorphicStyle(
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.circle(),
                            depth: 2,
                            lightSource: LightSource.topLeft,
                            color: Colors.transparent),
                        child: const Icon(
                          Icons.close,
                          color: AppColors.BURGUNDY,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          color: AppColors.WH,
          height: Dimensions.heighContainer1,
          width: Dimensions.screenWidth,
          child: Row(
            children: [
              Expanded(
                  child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Flexible(
                    child: NeumorphicButton(
                      onPressed: () {
                        if (quantity >= 2 && quantity <= 20) {
                          setState(() {
                            priceTopping = priceTopping / quantity * --quantity;

                            var priceP = widget.foodData!.prices![indexSize].priceOfProduct ?? 1;
                            endPrice = priceP * quantity;
                          });
                        }
                      },
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: 3,
                          lightSource: LightSource.topLeft,
                          color: AppColors.NOODLE_COLOR),
                      child: const Icon(
                        Icons.remove,
                        color: AppColors.BURGUNDY,
                      ),
                    ),
                  ),
                  BigText(
                    text: quantity.toString(),
                    size: 20,
                    fontweight: FontWeight.w900,
                    color: Colors.black.withOpacity(.6),
                  ),
                  Flexible(
                    child: NeumorphicButton(
                      onPressed: () {
                        if (quantity <= 19) {
                          setState(() {
                            priceTopping = priceTopping / quantity * ++quantity;
                            var priceP = widget.foodData!.prices![indexSize].priceOfProduct ?? 1;
                            endPrice = priceP * quantity;
                          });
                        }
                      },
                      style: const NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.circle(),
                          depth: 3,
                          lightSource: LightSource.topLeft,
                          color: AppColors.NOODLE_COLOR),
                      child: const Icon(
                        Icons.add,
                        color: AppColors.BURGUNDY,
                      ),
                    ),
                  ),
                ],
              )),
              Expanded(
                  flex: 2,
                  child: NeumorphicButton(
                    onPressed: () async {
                      FirebaseAuth.instance.currentUser == null ? Get.to(() => const LoginScreen()) : await _handleAddToCart();
                    },
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.all(15),
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(20))),
                        depth: 3,
                        lightSource: LightSource.topLeft,
                        color: AppColors.NOODLE_COLOR),
                    child: Center(
                      child: BigText(
                        text: "${formatCurrency.format(endPrice + priceTopping)}đ",
                        color: AppColors.BURGUNDY.withOpacity(0.8),
                        fontweight: FontWeight.w900,
                      ),
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget builderCheckbox() {
    final lstTopping = ref.watch(toppingCartDataProvider);

    return lstTopping.when(
        data: (data) {
          List<ToppingNCategory> lstTopCate = data.map((e) => e).where((element) => element.categoryId == widget.foodData!.categoryId).toList();
          return lstTopCate.isNotEmpty
              ? Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      BigText(
                        text: 'Topping',
                        overFlow: TextOverflow.visible,
                        size: 15,
                      ),
                      SizedBox(
                        height: Dimensions.highSBox,
                      ),
                      ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: lstTopCate.length,
                          itemBuilder: (_, index) {
                            addListTopping.isEmpty ? lstTopCate[index].toppings!.selected = false : null;
                            return Column(
                              children: [
                                Row(
                                  children: [
                                    NeumorphicCheckbox(
                                      margin: const EdgeInsets.all(5),
                                      style: NeumorphicCheckboxStyle(
                                        selectedDepth: -3,
                                        unselectedDepth: 2,
                                        disabledColor: AppColors.WH,
                                        selectedColor: customColor,
                                        boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(10))),
                                        lightSource: LightSource.topLeft,
                                      ),
                                      value: lstTopCate[index].toppings!.selected,
                                      onChanged: (value) {
                                        setState(() {
                                          lstTopCate[index].toppings!.selected = value;
                                          if (!lstTopCate[index].toppings!.selected) {
                                            addListTopping.remove(lstTopCate[index].toppings?.id ?? 0);
                                            priceTopping -= lstTopCate[index].toppings!.price! * quantity;
                                          } else {
                                            addListTopping.add(lstTopCate[index].toppings?.id ?? 0);
                                            priceTopping += lstTopCate[index].toppings!.price! * quantity;
                                          }
                                        });
                                      },
                                    ),
                                    SizedBox(
                                      width: Dimensions.padding_MarginHome2,
                                    ),
                                    Expanded(
                                      flex: 3,
                                      child: BigText(
                                        text: lstTopCate[index].toppings!.toppingName.toString(),
                                      ),
                                    ),
                                    const Spacer(),
                                    Expanded(
                                      child: BigText(
                                        text: '${formatCurrency.format(lstTopCate[index].toppings!.price)}đ',
                                      ),
                                    ),
                                  ],
                                ),
                                Divider(thickness: 1, color: Colors.black.withOpacity(.1)),
                              ],
                            );
                          }),
                    ],
                  ),
                )
              : Container();
        },
        error: (error, s) => Text(error.toString()),
        loading: () => Center(child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2)));
  }

  Container builderDetailsFood() {
    return Container(
      padding: const EdgeInsets.only(bottom: 20),
      margin: const EdgeInsets.only(bottom: 5),
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(spreadRadius: 0, blurRadius: 5, color: Colors.black.withOpacity(0.1))],
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            minVerticalPadding: 20,
            title: BigText(
              text: widget.foodData!.productName.toString(),
              size: 17,
            ),
            subtitle: Padding(
              padding: EdgeInsets.only(top: Dimensions.heighContainer0 / 2),
              child: BigText(
                text: '${formatCurrency.format(widget.foodData!.prices![indexSize].priceOfProduct)}đ',
                size: 15,
                color: Colors.black.withOpacity(.7),
              ),
            ),
            trailing: GestureDetector(
              onTap: () async {
                await _likeOrDislike();
              },
              child: Icon(
                widget.foodData!.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                color: AppColors.BURGUNDY.withOpacity(0.7),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SmallText(
              text: widget.foodData!.description.toString(),
              overFlow: TextOverflow.visible,
              size: 13,
              color: Colors.black.withOpacity(.7),
            ),
          ),
        ],
      ),
    );
  }

  Container builderNote() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        BigText(
          text: 'Ghi chú',
          size: 15,
        ),
        SizedBox(
          height: Dimensions.heighContainer0,
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
                  // controller: description,
                  cursorColor: AppColors.BURGUNDY,
                  cursorWidth: 2,
                  cursorHeight: 35,
                  autofocus: false,
                  maxLines: 1,
                  onChanged: (value) {
                    setState(() {
                      description.text = value;
                    });
                  },
                  style: GoogleFonts.comfortaa(height: 2, fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Ghi chú',
                    hintStyle: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w500),
                  ))),
        ),
      ]),
    );
  }

  Container builderWidgetRadio() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      margin: const EdgeInsets.symmetric(vertical: 5),
      color: Colors.white,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                child: BigText(
                  text: 'Size',
                  size: 15,
                ),
              ),
              Flexible(
                child: BigText(
                  text: '*',
                  color: Colors.redAccent,
                ),
              )
            ],
          ),
          SizedBox(
            height: Dimensions.highSBox,
          ),
          SizedBox(
              width: Dimensions.screenWidth,
              height: Dimensions.heigthAppBarCustom / 1.3,
              child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: widget.foodData?.prices!.length,
                  itemBuilder: (_, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: NeumorphicRadio(
                        groupValue: groupValue,
                        value: widget.foodData?.prices![index].size!.sizeName,
                        style: NeumorphicRadioStyle(
                            unselectedDepth: 2,
                            shape: NeumorphicShape.concave,
                            boxShape: NeumorphicBoxShape.roundRect(BorderRadius.all(Radius.circular(Dimensions.padding_MarginHome - 5))),
                            lightSource: LightSource.topLeft,
                            unselectedColor: AppColors.WH,
                            selectedColor: AppColors.NOODLE_COLOR),
                        onChanged: (value) {
                          setState(() {
                            groupValue = widget.foodData?.prices![index].size!.sizeName;
                            indexSize = index;
                            var priceP = widget.foodData!.prices![indexSize].priceOfProduct ?? 1;
                            endPrice = priceP * quantity;
                          });
                        },
                        child: Container(
                            width: Dimensions.heighContainer0 * 8,
                            alignment: Alignment.center,
                            child: Text(
                              widget.foodData?.prices![index].size!.sizeName ?? '',
                              style: GoogleFonts.comfortaa(fontWeight: FontWeight.w900, fontSize: 20, color: AppColors.BURGUNDY.withOpacity(0.7)),
                            )),
                      ),
                    );
                  }))
        ],
      ),
    );
  }
}
