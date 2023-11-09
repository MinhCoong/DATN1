// ignore_for_file: deprecated_member_use
import 'package:fe_flutter_ui/components/Item_food.dart';
import 'package:fe_flutter_ui/models/category.dart';
import 'package:fe_flutter_ui/provider/favorite_provider.dart';
import 'package:fe_flutter_ui/screens/menu/details_food_screen.dart';
import 'package:fe_flutter_ui/screens/menu/search_screen.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:fe_flutter_ui/components/widgets/small_text.dart';
import 'package:fe_flutter_ui/utils/list_item.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:overscroll_pop/overscroll_pop.dart';

import '../../components/item_Type_Of_Food.dart';
import '../../components/widgets/imagecacheprovider.dart';
import '../../models/productmrsoai.dart';
import '../../provider/category_provider.dart';
import '../../utils/dimensions.dart';
import '../../utils/hero_animation_asset.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

final indexCategoryProvider = StateProvider<int>((ref) {
  return 0;
});

class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  ViewType _viewType = ViewType.grid;
  int _crossAxisCount = 2;
  double _aspectRatio = 1;

  int indexCate = 0;

  @override
  Widget build(BuildContext context) {
    final listCate = ref.watch(categoryDataProvider);
    final listFavorite = ref.watch(favoriteData);
    indexCate = ref.watch(indexCategoryProvider);

    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: AppBar(
            backgroundColor: Colors.white,
            toolbarHeight: Dimensions.heigthAppBar,
            title: BigText(text: 'Menu'),
            elevation: 8,
            leading: Padding(
              padding: EdgeInsets.only(bottom: Dimensions.imageAppBar, left: Dimensions.imageAppBarLeftP),
              child: const Image(image: AssetImage('assets/images/mrsoaiIcon.png')),
            ),
            actions: [
              GestureDetector(
                onTap: () {
                  Get.to(const SearchScreen());
                },
                child: Padding(
                  padding: const EdgeInsets.only(right: 20, bottom: 5),
                  child: Neumorphic(
                    padding: EdgeInsets.all(Dimensions.imageAppBarLeftP),
                    style: const NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.circle(),
                      depth: 1,
                      color: AppColors.WH,
                      lightSource: LightSource.top,
                    ),
                    child: const Center(
                      child: FaIcon(
                        FontAwesomeIcons.search,
                        size: 23,
                        color: AppColors.BURGUNDY,
                      ),
                    ),
                  ),
                ),
              ),
            ]),
        body: listCate.when(
            data: (categoryData) {
              List<Categorys> lstCategory = categoryData.map((e) => e).toList();
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        height: Dimensions.heighContainer1 * 1.4,
                        child: ListView.builder(
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: lstCategory.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding:
                                    EdgeInsets.symmetric(horizontal: Dimensions.padding_MarginHome2 / 2, vertical: Dimensions.heighContainer0 * 1.5),
                                child: ItemTypeOfFood(
                                    index: index,
                                    url: lstCategory[index].image,
                                    firstValue: lstCategory[0].categoryName,
                                    text: lstCategory[index].categoryName),
                              );
                            }),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: Dimensions.padding_MarginHome),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              BigText(
                                text: lstCategory[indexCate].categoryName.toString(),
                                fontweight: FontWeight.bold,
                                color: AppColors.BURGUNDY,
                                size: 15,
                              ),
                              GestureDetector(
                                onTap: () {
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
                                child: NeumorphicIcon(
                                  _viewType == ViewType.list ? Icons.grid_view_sharp : Icons.view_agenda_sharp,
                                  style: const NeumorphicStyle(
                                    depth: 5,
                                    color: AppColors.BURGUNDY,
                                  ),
                                  size: 28,
                                ),
                              )
                            ],
                          ),
                          const Divider(
                            height: 15,
                            thickness: .5,
                            color: AppColors.BURGUNDY,
                          )
                        ],
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                      height: Dimensions.screenHeight * 0.8,
                      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
                      child: ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        children: [
                          GridView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: _crossAxisCount,
                                childAspectRatio: _aspectRatio,
                                mainAxisSpacing: (_viewType == ViewType.grid) ? 15 : 10,
                                crossAxisSpacing: 5,
                              ),
                              itemCount: lstCategory[indexCate].products?.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Hero(
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
                                  tag: lstCategory[indexCate].products![index].image.toString(),
                                  child: GestureDetector(
                                      onTap: () => pushOverscrollRoute(
                                            barrierColor: null,
                                            context: context,
                                            scrollToPopOption: ScrollToPopOption.start,
                                            child: DetailsFoodScreen(
                                              foodData: lstCategory[indexCate].products![index],
                                              isFavorite: false,
                                            ),
                                          ),
                                      child: listFavorite.when(
                                          data: (data) {
                                            final listF = data.map((e) => e).toList();
                                            for (var element in listF) {
                                              if (element.id == lstCategory[indexCate].products![index].id) {
                                                lstCategory[indexCate].products![index].isFavorite = true;
                                                break;
                                              } else {
                                                lstCategory[indexCate].products![index].isFavorite = false;
                                              }
                                            }
                                            return lstCategory[indexCate].products![index].status == true &&
                                                    lstCategory[indexCate].products![index].id != null
                                                ? getGridItem(lstCategory[indexCate].products![index])
                                                : Container();
                                          },
                                          error: (error, s) => Text(error.toString()),
                                          loading: () => Center(
                                              child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2)))),
                                );
                              }),
                          SizedBox(
                            height: Dimensions.heighContainer1 * 2.7,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (error, s) => Text(error.toString()),
            loading: () => Center(child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2))));
  }

  GridTile getGridItem(Products imageData) {
    return GridTile(
      child: (_viewType == ViewType.list)
          ? Material(
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: ItemFood(foodData: imageData),
              ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
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
