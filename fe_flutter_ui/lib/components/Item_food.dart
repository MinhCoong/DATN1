// ignore_for_file: file_names, deprecated_member_use, must_be_immutable, unused_result

import 'package:fe_flutter_ui/components/widgets/imagecacheprovider.dart';
import 'package:fe_flutter_ui/models/productmrsoai.dart';
import 'package:fe_flutter_ui/utils/list_item.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../main.dart';
import '../models/favorite.dart';
import '../provider/cart_provider.dart';
import '../provider/favorite_provider.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'widgets/big_text.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class ItemFood extends ConsumerStatefulWidget {
  ItemFood({super.key, required this.foodData});
  Products? foodData;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemFoodState();
}

class _ItemFoodState extends ConsumerState<ItemFood> {
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

  @override
  Widget build(BuildContext context) {
    final listFavorite = ref.watch(favoriteData);

    return Neumorphic(
      padding: EdgeInsets.all(Dimensions.padding_MarginHome2),
      style: NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
        depth: 2,
        lightSource: LightSource.topLeft,
        color: AppColors.WHX,
      ),
      child: SizedBox(
        height: Dimensions.hieghtItemFood / 1.2,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 3,
              child: Neumorphic(
                padding: EdgeInsets.all(Dimensions.heighContainer0 / 2),
                style: NeumorphicStyle(
                    shape: NeumorphicShape.concave,
                    depth: -5,
                    lightSource: LightSource.topLeft,
                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                    color: AppColors.BACKGROUND_COLOR.withOpacity(.7)),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: ImageCachedProvider(url: UrlImageProduct + widget.foodData!.image.toString())),
              ),
            ),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(left: Dimensions.padding_MarginHome2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    BigText(
                      text: widget.foodData!.productName.toString(),
                      size: 15,
                      overFlow: TextOverflow.visible,
                    ),
                    Flexible(
                      child: Padding(
                        padding: EdgeInsets.only(top: Dimensions.highSBox, right: 0),
                        child: Text(
                          widget.foodData!.description.toString(),
                          maxLines: 2,
                          style: GoogleFonts.comfortaa(
                              color: Colors.black.withOpacity(.4), fontSize: 12, fontWeight: FontWeight.w500),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: Dimensions.heighContainer0 / 2,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    flex: 3,
                    child: BigText(
                      text: '${formatCurrency.format(widget.foodData!.prices![0].priceOfProduct)}đ',
                      overFlow: TextOverflow.visible,
                      size: 15,
                      textAlign: TextAlign.end,
                    ),
                  ),
                  // const Spacer(),
                  Expanded(
                    flex: 2,
                    child: GestureDetector(
                        onTap: () async {
                          await _likeOrDislike();
                        },
                        child: listFavorite.when(
                            data: (data) {
                              final listF = data.map((e) => e).toList();
                              for (var element in listF) {
                                if (element.id == widget.foodData!.id) {
                                  widget.foodData!.isFavorite = true;
                                  break;
                                } else {
                                  widget.foodData!.isFavorite = false;
                                }
                              }
                              return Icon(
                                widget.foodData!.isFavorite ? Icons.favorite : Icons.favorite_border_rounded,
                                color: AppColors.BURGUNDY.withOpacity(0.7),
                              );
                            },
                            error: (error, s) => Text(error.toString()),
                            loading: () => Center(
                                child: Lottie.asset('assets/images/loading-line-red.json',
                                    width: Dimensions.heighContainer3 / 2)))),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
