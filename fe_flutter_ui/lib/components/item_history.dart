// ignore_for_file: file_names, deprecated_member_use, must_be_immutable, unused_result

import 'package:fe_flutter_ui/components/widgets/imagecacheprovider.dart';
import 'package:fe_flutter_ui/models/order.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import '../utils/list_item.dart';
import 'widgets/big_text.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class ItemHistory extends ConsumerStatefulWidget {
  const ItemHistory({
    super.key,
    required this.order,
    required this.x,
  });
  final Order order;
  final int x;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemFoodState();
}

class _ItemFoodState extends ConsumerState<ItemHistory> {
  num total = 0;
  @override
  Widget build(BuildContext context) {
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
              flex: 2,
              child: Center(
                child: Neumorphic(
                  padding: EdgeInsets.all(Dimensions.heighContainer0 / 2),
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.concave,
                      depth: -5,
                      lightSource: LightSource.topLeft,
                      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
                      color: AppColors.BACKGROUND_COLOR),
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    child: ImageCachedProvider(url: UrlImageProduct + widget.order.orderDetails![0].product!.image!),
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
                    Row(
                      children: [
                        Expanded(
                          child: BigText(
                            text: "#${widget.order.code!}",
                            size: 15,
                            overFlow: TextOverflow.visible,
                          ),
                        ),
                        Expanded(
                          child: BigText(
                            text: '${formatCurrency.format(widget.order.total!)}đ',
                            overFlow: TextOverflow.visible,
                            size: 15,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${widget.order.deliveryMethod} ${widget.x} món',
                                style: GoogleFonts.comfortaa(color: Colors.black.withOpacity(.7), fontSize: 12, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                '${widget.order.deliveryTime!.split('T').first} ${widget.order.deliveryTime!.split('T').last}',
                                style: GoogleFonts.comfortaa(color: Colors.black.withOpacity(.7), fontSize: 12, fontWeight: FontWeight.w500),
                                overflow: TextOverflow.visible,
                              ),
                            ],
                          ),
                        ),
                        BigText(
                          text: widget.order.orderStatus == 0
                              ? 'Đang chờ'
                              : widget.order.orderStatus == 1
                                  ? 'Đã duyệt'
                                  : widget.order.orderStatus == 2
                                      ? "Đang giao"
                                      : widget.order.orderStatus == 3
                                          ? 'Hoàn thành'
                                          : '',
                          overFlow: TextOverflow.visible,
                          size: 13,
                          color: widget.order.orderStatus == 0
                              ? Colors.orange
                              : widget.order.orderStatus == 1
                                  ? Colors.yellow
                                  : widget.order.orderStatus == 2
                                      ? Colors.green
                                      : widget.order.orderStatus == 3
                                          ? Colors.blue
                                          : Colors.green,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // Expanded(
            //   flex: 2,
            //   child: Column(
            //     // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //     crossAxisAlignment: CrossAxisAlignment.end,
            //     children: [
            //       Expanded(
            //         flex: 3,
            //         child: BigText(
            //           text: '${formatCurrency.format(total)}đ',
            //           overFlow: TextOverflow.visible,
            //           size: 15,
            //           textAlign: TextAlign.end,
            //         ),
            //       ),
            //       Expanded(
            //         flex: 3,
            //         child: BigText(
            //           text: widget.order.orderStatus == 0
            //               ? 'Đang chờ'
            //               : widget.order.orderStatus == 1
            //                   ? 'Đã duyệt'
            //                   : widget.order.orderStatus == 2
            //                       ? "Đang giao"
            //                       : widget.order.orderStatus == 3
            //                           ? 'Hoàn thành'
            //                           : '',
            //           overFlow: TextOverflow.visible,
            //           size: 13,
            //           color: widget.order.orderStatus == 0
            //               ? Colors.orange
            //               : widget.order.orderStatus == 1
            //                   ? Colors.yellow
            //                   : widget.order.orderStatus == 2
            //                       ? Colors.green
            //                       : widget.order.orderStatus == 3
            //                           ? Colors.blue
            //                           : Colors.green,
            //           textAlign: TextAlign.end,
            //         ),
            //       ),
            //       // const Spacer(),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
