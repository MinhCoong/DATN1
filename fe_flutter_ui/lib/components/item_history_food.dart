// ignore_for_file: file_names, deprecated_member_use, must_be_immutable, unused_result

import 'dart:math';

import 'package:fe_flutter_ui/components/widgets/imagecacheprovider.dart';
import 'package:fe_flutter_ui/models/oderdetails.dart';
import 'package:fe_flutter_ui/models/orderdetail_topping.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../models/topping.dart';
import '../provider/topping_provider.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../utils/list_item.dart';
import 'widgets/big_text.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class ItemHistoryFood extends ConsumerStatefulWidget {
  const ItemHistoryFood({
    super.key,
    required this.orderDetails,
    required this.listTopping,
  });
  final OrderDetails orderDetails;
  final List<OrderdetailToppingList>? listTopping;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemFoodState();
}

Toppings? jumpSearchIterative(List<Toppings> a, int? target) {
  int blockSize = sqrt(a.length).toInt();
  int start = 0;
  int next = blockSize;

  while (start < a.length && target! > a[next - 1].id!) {
    start = next;
    next = next + blockSize;

    if (next >= a.length) {
      next = a.length;
    }
  }

  for (int i = start; i < next; i++) {
    if (target == a[i].id) {
      return a[i];
    }
  }

  return null;
}

class _ItemFoodState extends ConsumerState<ItemHistoryFood> {
  String topping = '';
  @override
  Widget build(BuildContext context) {
    final listTopping = ref.watch(toppingDataProvider);
    return Neumorphic(
      padding: EdgeInsets.all(Dimensions.padding_MarginHome2),
      style: const NeumorphicStyle(
        shape: NeumorphicShape.flat,
        boxShape: NeumorphicBoxShape.rect(),
        depth: 2,
        lightSource: LightSource.topLeft,
        color: AppColors.WH,
      ),
      child: SizedBox(
        height: Dimensions.hieghtItemFood / 1.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Neumorphic(
                  padding: EdgeInsets.all(Dimensions.heighContainer0 / 2),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      depth: 0,
                      lightSource: LightSource.topLeft,
                      boxShape: NeumorphicBoxShape.roundRect(
                          BorderRadius.circular(15)),
                      color: AppColors.WH),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: ImageCachedProvider(
                        url: UrlImageProduct +
                            widget.orderDetails.product!.image!),
                    // child: Image.asset('assets/images/wallet.png'),
                  ),
                ),
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
                      text: widget.orderDetails.product!.productName!,
                      size: 15,
                      overFlow: TextOverflow.visible,
                    ),
                    listTopping.when(
                        data: (data) {
                          var lx = data.map((e) => e).toList();
                          topping = '';
                          for (var element in widget.listTopping!) {
                            var x =
                                jumpSearchIterative(lx, element.toppingsId!);
                            topping += '~${x!.toppingName}';
                          }
                          return Flexible(
                            child: Padding(
                              padding: EdgeInsets.only(
                                  top: Dimensions.highSBox, right: 0),
                              child: Text(
                                '${widget.orderDetails.quantity}x$topping',
                                style: GoogleFonts.comfortaa(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
                                overflow: TextOverflow.visible,
                              ),
                            ),
                          );
                        },
                        error: (error, s) => Text(error.toString()),
                        loading: () => Center(
                            child: Lottie.asset(
                                'assets/images/loading-line-red.json',
                                width: Dimensions.heighContainer3 / 2))),
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
                      text:
                          '${formatCurrency.format(widget.orderDetails.subtotal)}đ',
                      overFlow: TextOverflow.visible,
                      size: 15,
                      textAlign: TextAlign.end,
                    ),
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
