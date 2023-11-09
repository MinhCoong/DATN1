import 'package:fe_flutter_ui/models/productmrsoai.dart';
import 'package:fe_flutter_ui/provider/product_provider.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:overscroll_pop/overscroll_pop.dart';

import '../../components/Item_food.dart';
import '../../components/widgets/imagecacheprovider.dart';
import '../../components/widgets/small_text.dart';
import '../../provider/favorite_provider.dart';
import '../../utils/hero_animation_asset.dart';
import '../../utils/list_item.dart';
import 'details_food_screen.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");
final productNameP = StateProvider<String>((ref) => '');

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  ViewType _viewType = ViewType.grid;
  int _crossAxisCount = 2;
  double _aspectRatio = 1;

  @override
  Widget build(BuildContext context) {
    var listProduct = ref.watch(productData);
    final listFavorite = ref.watch(favoriteData);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
        elevation: 4,
        automaticallyImplyLeading: false,
        toolbarHeight: Dimensions.heigthAppBar2,
        title: Container(
            height: Dimensions.heightAppbarSearch,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: const BoxDecoration(color: AppColors.BACKGROUND_COLOR, borderRadius: BorderRadius.all(Radius.circular(15))),
            child: Row(
              children: [
                const Icon(
                  Icons.search,
                  size: 30,
                  color: AppColors.BURGUNDY,
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                    child: TextField(
                  cursorColor: AppColors.BURGUNDY,
                  cursorWidth: 2,
                  cursorHeight: 35,
                  autofocus: true,
                  style: GoogleFonts.comfortaa(height: 2, fontSize: 15, fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tìm kiếm',
                    hintStyle: GoogleFonts.comfortaa(fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  onChanged: (value) {
                    ref.read(productNameP.notifier).update((state) => value);
                  },
                ))
              ],
            )),
        actions: [
          GestureDetector(
            onTap: () {
              Get.back();
            },
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(right: 20),
              child: BigText(
                text: "Hủy",
              ),
            )),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: listProduct.when(
            data: (data) {
              List<Products> lstProduct = data.map((e) => e).toList();
              return SizedBox(
                height: Dimensions.screenHeight,
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: _crossAxisCount,
                              childAspectRatio: _aspectRatio,
                              mainAxisSpacing: (_viewType == ViewType.grid) ? 5 : 0,
                              crossAxisSpacing: 5),
                          itemCount: lstProduct.length,
                          shrinkWrap: true,
                          itemBuilder: (context, index) {
                            return lstProduct[index].id != null || lstProduct[index].status == true
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
                                    tag: lstProduct[index].image.toString(),
                                    child: GestureDetector(
                                        onTap: () => pushOverscrollRoute(
                                              barrierColor: null,
                                              context: context,
                                              scrollToPopOption: ScrollToPopOption.start,
                                              child: DetailsFoodScreen(
                                                foodData: lstProduct[index],
                                                isFavorite: false,
                                              ),
                                            ),
                                        child: listFavorite.when(
                                            data: (data) {
                                              final listF = data.map((e) => e).toList();
                                              for (var element in listF) {
                                                if (element.id == lstProduct[index].id) {
                                                  lstProduct[index].isFavorite = true;
                                                  break;
                                                } else {
                                                  lstProduct[index].isFavorite = false;
                                                }
                                              }
                                              return getGridItem(lstProduct[index]);
                                            },
                                            error: (error, s) => Text(error.toString()),
                                            loading: () =>
                                                Center(child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.screenWidth)))),
                                  )
                                : Container();
                          }),
                    ),
                    lstProduct.isNotEmpty
                        ? Positioned(bottom: Dimensions.heighContainer2, right: Dimensions.heighContainer0 * 1.6, child: _button())
                        : Container(
                            alignment: Alignment.center,
                            child: BigText(
                              text: "Không tìm thấy sản  phẩm nào",
                              size: 15,
                            ),
                          ),
                  ],
                ),
              );
            },
            error: (error, s) => Text(error.toString()),
            loading: () => Center(child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2))),
      ),
    );
  }

  NeumorphicButton _button() {
    return NeumorphicButton(
      onPressed: () {
        if (_viewType == ViewType.list) {
          _crossAxisCount = 2;
          _aspectRatio = 1.1;
          _viewType = ViewType.grid;
        } else {
          _crossAxisCount = 1;
          _aspectRatio = 3.4;
          _viewType = ViewType.list;
        }
        setState(() {});
      },
      padding: const EdgeInsets.all(8),
      style: const NeumorphicStyle(depth: 3),
      child: Icon(
        _viewType == ViewType.list ? Icons.grid_view_sharp : Icons.view_agenda_sharp,
        color: AppColors.BURGUNDY.withOpacity(.9),
        size: 27,
      ),
    );
  }

  GridTile getGridItem(Products imageData) {
    return GridTile(
      child: (_viewType == ViewType.list)
          ? Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: ItemFood(foodData: imageData),
              ))
          : Padding(
              padding: const EdgeInsets.all(5.0),
              child: Neumorphic(
                padding: EdgeInsets.all(Dimensions.heighContainer0),
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    depth: 2,
                    lightSource: LightSource.top,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                    color: AppColors.WHX),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 12,
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 5),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: ImageCachedProvider(
                                url: UrlImageProduct + imageData.image.toString(),
                              )),
                        )),
                    Expanded(
                      flex: 5,
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          width: double.infinity,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: BigText(
                                    text: imageData.productName.toString(),
                                    size: 15,
                                    overFlow: TextOverflow.visible,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: SmallText(
                                  text: '${formatCurrency.format(imageData.prices![0].priceOfProduct)}đ',
                                  size: 13,
                                ),
                              )
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

enum ViewType { grid, list }
