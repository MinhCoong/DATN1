import 'package:fe_flutter_ui/components/itemNotify.dart';
import 'package:fe_flutter_ui/components/widgets/imagecacheprovider.dart';
import 'package:fe_flutter_ui/main.dart';
import 'package:fe_flutter_ui/models/coupons.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/utils/list_item.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';
import 'package:ticket_material/ticket_material.dart';

import '../utils/colors.dart';
import 'widgets/big_text.dart';
import 'dots_.dart';

class ItemTicketMaterial extends ConsumerStatefulWidget {
  const ItemTicketMaterial({
    super.key,
    required this.quantity,
    required this.total,
    required this.coupons,
    required this.isComingFromCart,
  });
  final Coupons coupons;
  final bool isComingFromCart;
  final int quantity;
  final double total;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemTicketMaterialState();
}

class _ItemTicketMaterialState extends ConsumerState<ItemTicketMaterial> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TicketMaterial(
          tapHandler: () {
            showModalBottomSheet(
                backgroundColor: Colors.transparent,
                isScrollControlled: true,
                context: context,
                builder: (context) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(15, 5, 15, 0),
                    height: Dimensions.screenHeight / 1.1,
                    decoration: const BoxDecoration(
                        color: AppColors.WH, borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Divider(
                            height: Dimensions.heighContainer0,
                            thickness: 5,
                            indent: Dimensions.dividerSlive - 5,
                            endIndent: Dimensions.dividerSlive - 5,
                            color: AppColors.BURGUNDY,
                          ),
                          SizedBox(
                            height: Dimensions.heighContainer0 * 2,
                          ),
                          NeumorphicText(
                            "Mr SOAI",
                            style: const NeumorphicStyle(
                              depth: 1, //customize depth here
                              color: AppColors.BURGUNDY, //customize color here
                            ),
                            textStyle: NeumorphicTextStyle(
                                fontSize: 15, fontWeight: FontWeight.w900, fontFamily: 'mrSoai' //customize size here
                                // AND others usual text style properties (fontFamily, fontWeight, ...)
                                ),
                          ),
                          SizedBox(
                            height: Dimensions.heighContainer0,
                          ),
                          BigText(
                            text: widget.coupons.title!,
                            size: 16,
                          ),
                          const DottedBoderAPP(),
                          Padding(
                            padding: EdgeInsets.all(Dimensions.heighContainer0 * 2),
                            child: PrettyQr(
                              image: const AssetImage('assets/images/mrsoaiIcon.png'),
                              typeNumber: 3,
                              size: Dimensions.heighContainer2,
                              data: widget.coupons.code!,
                              errorCorrectLevel: QrErrorCorrectLevel.M,
                              roundEdges: true,
                            ),
                          ),
                          SizedBox(
                            height: Dimensions.heighContainer0,
                          ),
                          BigText(
                            text: widget.coupons.code!,
                            fontweight: FontWeight.w900,
                            size: 15,
                            color: Colors.black.withOpacity(.6),
                          ),
                          SizedBox(
                            height: Dimensions.heighContainer0,
                          ),
                          SizedBox(
                            width: Dimensions.heighContainer2 * .75,
                            child: NeumorphicButton(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.flat,
                                boxShape: NeumorphicBoxShape.roundRect(const BorderRadius.all(Radius.circular(15))),
                                lightSource: LightSource.topLeft,
                                color: AppColors.NOODLE_COLOR,
                              ),
                              onPressed: () {
                                if (widget.isComingFromCart) {
                                  if (widget.quantity >= widget.coupons.minimumQuantity! &&
                                      widget.total >= widget.coupons.minimumTotla!) {
                                    ref.watch(addCoupons.notifier).update((state) => widget.coupons);
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (BuildContext context, _, __) => const ItemNotifier(
                                                isCorrect: true,
                                                text: "Áp mã thành công.",
                                              )),
                                    );
                                    Get.back();
                                  } else {
                                    Navigator.of(context).push(
                                      PageRouteBuilder(
                                          opaque: false,
                                          pageBuilder: (BuildContext context, _, __) => const ItemNotifier(
                                                isCorrect: false,
                                                text: "Áp mã thất bại.",
                                              )),
                                    );
                                    Get.back();
                                  }
                                } else {
                                  Get.back();
                                }
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  height: Dimensions.heightAppbarSearch,
                                  child: BigText(
                                    text: widget.isComingFromCart ? 'Áp mã' : 'Tiếp tục đặt hàng',
                                    color: AppColors.BURGUNDY.withOpacity(.7),
                                    fontweight: FontWeight.w800,
                                  )),
                            ),
                          ),
                          const DottedBoderAPP(),
                          SizedBox(
                            height: Dimensions.heighContainer0 * 2,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              BigText(
                                text: 'Ngày hết hạn:',
                              ),
                              BigText(
                                text: widget.coupons.endDate!.split('T')[0],
                              )
                            ],
                          ),
                          const DottedBoderAPP(),
                          SizedBox(
                            height: Dimensions.heighContainer0 * 2,
                          ),
                          BigText(
                            text: widget.coupons.description!,
                            overFlow: TextOverflow.visible,
                          )
                        ],
                      ),
                    ),
                  );
                });
          },
          useAnimationScaleOnTap: false,
          flexLefSize: 30,
          flexRightSize: 70,
          flexMaskSize: 4,
          shadowSize: 4,
          radiusCircle: 2,
          marginBetweenCircles: 5,
          radiusBorder: 15,
          colorShadow: Colors.black12,
          height: Dimensions.heigtTicket,
          leftChild: Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 5, 15),
              child: ImageCachedProvider(url: UrlImageCoupons + widget.coupons.image!)),
          rightChild: Padding(
            padding: const EdgeInsets.fromLTRB(5, 15, 15, 15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                BigText(
                  text: widget.coupons.title!,
                  size: 15,
                  fontweight: FontWeight.w800,
                  overFlow: TextOverflow.visible,
                ),
                BigText(
                  text: widget.coupons.description!,
                  size: 13,
                )
              ],
            ),
          ),
          colorBackground: Colors.white),
    );
  }
}
