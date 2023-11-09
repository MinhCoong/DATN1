import 'package:fe_flutter_ui/components/Item_food.dart';
import 'package:fe_flutter_ui/provider/favorite_provider.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:overscroll_pop/overscroll_pop.dart';

import '../../components/app_bar.dart';
import '../../components/widgets/big_text.dart';
import '../../components/widgets/imagecacheprovider.dart';
import '../../components/widgets/small_text.dart';
import '../../models/productmrsoai.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../utils/hero_animation_asset.dart';
import '../../utils/list_item.dart';
import '../menu/details_food_screen.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class FavoriteScreen extends ConsumerStatefulWidget {
  const FavoriteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends ConsumerState<FavoriteScreen> {
  ViewType _viewType = ViewType.grid;
  int _crossAxisCount = 2;
  double _aspectRatio = 1;

  @override
  Widget build(BuildContext context) {
    final listFavorite = ref.watch(favoriteData);
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(Dimensions.heigthAppBar),
          child: const MyAppBarMS(
            txt: 'yêu thích món này',
          )),
      body: listFavorite.when(
          data: (data) {
            List<Products> lstFavorite = data.map((e) => e).toList();
            return lstFavorite.isEmpty
                ? Center(
                    child: BigText(
                      text: "Chưa có món yêu thích nào",
                      overFlow: TextOverflow.visible,
                    ),
                  )
                : SizedBox(
                    height: Dimensions.screenHeight,
                    child: Stack(
                      children: [
                        lstFavorite.isNotEmpty
                            ? Positioned(
                                bottom: Dimensions.heighContainer2 / 1.7,
                                right: Dimensions.heighContainer0 * 1.6,
                                child: _button())
                            : Container(
                                alignment: Alignment.center,
                                child: BigText(
                                  text: "Chưa có sản phẩm yêu thích nào",
                                  size: 15,
                                ),
                              ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                          child: GridView.builder(
                              physics: const BouncingScrollPhysics(),
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: _crossAxisCount,
                                  childAspectRatio: _aspectRatio,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10),
                              itemCount: lstFavorite.length,
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                lstFavorite[index].isFavorite = true;
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
                                  tag: lstFavorite[index].image.toString(),
                                  child: GestureDetector(
                                      onTap: () => pushOverscrollRoute(
                                            barrierColor: null,
                                            context: context,
                                            scrollToPopOption: ScrollToPopOption.start,
                                            child: DetailsFoodScreen(
                                              foodData: lstFavorite[index],
                                              isFavorite: true,
                                            ),
                                          ),
                                      child: getGridItem(lstFavorite[index])),
                                );
                              }),
                        ),
                      ],
                    ),
                  );
          },
          error: (error, s) => Text(error.toString()),
          loading: () => Center(
              child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2))),
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
          ? Material(color: Colors.transparent, child: ItemFood(foodData: imageData))
          : Neumorphic(
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
    );
  }
}

enum ViewType { grid, list }
