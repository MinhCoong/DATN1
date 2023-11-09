import 'package:expandable/expandable.dart';
import 'package:fe_flutter_ui/components/item_history.dart';
import 'package:fe_flutter_ui/provider/order_provider.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

import '../../components/item_history_food.dart';
import '../../components/widgets/big_text.dart';
import '../../utils/list_item.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class HistoryScreen extends ConsumerStatefulWidget {
  const HistoryScreen({super.key});
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends ConsumerState<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    final listOrder = ref.watch(orderData);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: AppColors.WH,
          toolbarHeight: Dimensions.heightListtile,
          elevation: 4,
          title: BigText(
            text: 'Lịch sử đơn hàng',
            fontweight: FontWeight.w800,
            color: Colors.black.withOpacity(.9),
          ),
          leading: GestureDetector(
            onTap: () {
              Get.back();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
              size: 20,
            ),
          ),
        ),
        body: Stack(
          children: [
            TabBar(
              splashBorderRadius: BorderRadius.circular(15),
              indicatorColor: AppColors.BURGUNDY,
              dividerColor: Colors.transparent,
              indicatorWeight: 2,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorPadding: const EdgeInsets.only(left: 15, right: 15),
              tabs: [
                Tab(
                  child: BigText(
                    text: 'Đang làm',
                    size: 12,
                    overFlow: TextOverflow.visible,
                  ),
                ),
                Tab(
                  child: BigText(
                    text: 'Hoàn thành',
                    size: 12,
                    overFlow: TextOverflow.visible,
                  ),
                ),
                // Tab(
                //   child: BigText(
                //     text: 'Đã hủy',
                //     size: 12,
                //     overFlow: TextOverflow.visible,
                //   ),
                // ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: Dimensions.heighContainer2 / 4.5),
              child: TabBarView(children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: listOrder.when(
                      data: (data) {
                        var listOrderX = data.map((e) => e).toList();
                        return listOrderX.isEmpty
                            ? Center(
                                child: BigText(text: 'Chưa có đơn hàng nào'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: listOrderX.length,
                                itemBuilder: (_, index) {
                                  return listOrderX[index].orderStatus != 3
                                      ? ExpandableNotifier(
                                          child: ScrollOnExpand(
                                              child: ExpandablePanel(
                                            theme: const ExpandableThemeData(
                                                tapBodyToExpand: true,
                                                // tapBodyToCollapse: true,
                                                hasIcon: false),
                                            header: Container(
                                              padding: const EdgeInsets.all(5.0),
                                              child: ItemHistory(
                                                order: listOrderX[index],
                                                x: listOrderX[index].orderDetails!.length,
                                              ),
                                            ),
                                            collapsed: Container(),
                                            expanded: Container(
                                              width: Dimensions.screenWidth,
                                              padding: const EdgeInsets.fromLTRB(5, 2, 5, 20),
                                              child: Neumorphic(
                                                padding: const EdgeInsets.all(0),
                                                style: NeumorphicStyle(
                                                    border: NeumorphicBorder(width: 2, color: AppColors.BURGUNDY.withOpacity(.9)),
                                                    depth: -2,
                                                    color: AppColors.BACKGROUND_COLOR,
                                                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10))),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      color: AppColors.WH,
                                                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  child: BigText(
                                                                    text: "Tên: ${listOrderX[index].consigneeName!}",
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: BigText(
                                                                    text: "sđt: ${listOrderX[index].consigneePhoneNumber!}",
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: BigText(
                                                              text: 'Thanh toán: ${listOrderX[index].paymentMethod?.split('-').first}',
                                                              overFlow: TextOverflow.visible,
                                                            ),
                                                          ),
                                                          listOrderX[index].deliveryMethod == GiaoHang
                                                              ? Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: BigText(
                                                                    text:
                                                                        'Địa chỉ: ${listOrderX[index].consigneeAddress!.split('Ghi chú:').first.trim()}',
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                )
                                                              : Container(),
                                                          listOrderX[index].consigneeAddress!.split('Ghi chú:').last != ''
                                                              ? listOrderX[index].deliveryMethod == GiaoHang
                                                                  ? Padding(
                                                                      padding: const EdgeInsets.all(5.0),
                                                                      child: BigText(
                                                                        text:
                                                                            'Ghi chú: ${listOrderX[index].consigneeAddress!.split('Ghi chú:').last.trim()}',
                                                                        overFlow: TextOverflow.visible,
                                                                      ),
                                                                    )
                                                                  : Container()
                                                              : Container(),
                                                          listOrderX[index].deliveryMethod == GiaoHang
                                                              ? Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: BigText(
                                                                    text: 'Phí ship: ${formatCurrency.format(listOrderX[index].deliveryCharges!)}đ',
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                )
                                                              : Container(),
                                                          listOrderX[index].couponsId != 1
                                                              ? Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: BigText(
                                                                    text:
                                                                        'Khuyến mãi: ${listOrderX[index].coupons!.code}-${listOrderX[index].coupons!.discount}',
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: Dimensions.heighContainer0,
                                                    ),
                                                    Container(
                                                        color: Colors.white,
                                                        child: ListView.builder(
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: listOrderX[index].orderDetails!.length,
                                                            itemBuilder: (_, y) {
                                                              return ItemHistoryFood(
                                                                orderDetails: listOrderX[index].orderDetails![y],
                                                                listTopping: listOrderX[index].orderDetails![y].orderdetailToppingList,
                                                              );
                                                            }))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            builder: (_, collapsed, expanded) {
                                              return Expandable(
                                                collapsed: collapsed,
                                                expanded: expanded,
                                                theme: const ExpandableThemeData(),
                                              );
                                            },
                                          )),
                                        )
                                      : Container();
                                });
                      },
                      error: (error, s) => Text(error.toString()),
                      loading: () => Center(child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2))),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: listOrder.when(
                      data: (data) {
                        var listOrderX = data.map((e) => e).toList();
                        return listOrderX.isEmpty
                            ? Center(
                                child: BigText(text: 'Chưa có đơn hàng nào'),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: listOrderX.length,
                                itemBuilder: (_, index) {
                                  return listOrderX[index].orderStatus == 3
                                      ? ExpandableNotifier(
                                          child: ScrollOnExpand(
                                              child: ExpandablePanel(
                                            theme: const ExpandableThemeData(
                                                tapBodyToExpand: true,
                                                // tapBodyToCollapse: true,
                                                hasIcon: false),
                                            header: Container(
                                              padding: const EdgeInsets.all(5.0),
                                              child: ItemHistory(
                                                order: listOrderX[index],
                                                x: listOrderX[index].orderDetails!.length,
                                              ),
                                            ),
                                            collapsed: Container(),
                                            expanded: Container(
                                              width: Dimensions.screenWidth,
                                              padding: const EdgeInsets.fromLTRB(5, 2, 5, 20),
                                              child: Neumorphic(
                                                padding: const EdgeInsets.all(0),
                                                style: NeumorphicStyle(
                                                    border: NeumorphicBorder(width: 2, color: AppColors.BURGUNDY.withOpacity(.9)),
                                                    depth: -2,
                                                    color: AppColors.BACKGROUND_COLOR,
                                                    boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(10))),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Container(
                                                      color: AppColors.WH,
                                                      padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                                                      width: double.infinity,
                                                      child: Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: Row(
                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                              children: [
                                                                Expanded(
                                                                  child: BigText(
                                                                    text: "Tên: ${listOrderX[index].consigneeName!}",
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                ),
                                                                Expanded(
                                                                  child: BigText(
                                                                    text: "sđt: ${listOrderX[index].consigneePhoneNumber!}",
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding: const EdgeInsets.all(5.0),
                                                            child: BigText(
                                                              text: 'Thanh toán: ${listOrderX[index].paymentMethod}',
                                                              overFlow: TextOverflow.visible,
                                                            ),
                                                          ),
                                                          listOrderX[index].deliveryMethod == GiaoHang
                                                              ? Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: BigText(
                                                                    text:
                                                                        'Địa chỉ: ${listOrderX[index].consigneeAddress!.split('Ghi chú:').first.trim()}',
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                )
                                                              : Container(),
                                                          listOrderX[index].consigneeAddress!.split('Ghi chú:').last != ''
                                                              ? listOrderX[index].deliveryMethod == GiaoHang
                                                                  ? Padding(
                                                                      padding: const EdgeInsets.all(5.0),
                                                                      child: BigText(
                                                                        text:
                                                                            'Ghi chú: ${listOrderX[index].consigneeAddress!.split('Ghi chú:').last.trim()}',
                                                                        overFlow: TextOverflow.visible,
                                                                      ),
                                                                    )
                                                                  : Container()
                                                              : Container(),
                                                          listOrderX[index].deliveryMethod == GiaoHang
                                                              ? Padding(
                                                                  padding: const EdgeInsets.all(5.0),
                                                                  child: BigText(
                                                                    text: 'Phí ship: ${formatCurrency.format(listOrderX[index].deliveryCharges!)}đ',
                                                                    overFlow: TextOverflow.visible,
                                                                  ),
                                                                )
                                                              : Container()
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(
                                                      height: Dimensions.heighContainer0,
                                                    ),
                                                    Container(
                                                        color: Colors.white,
                                                        child: ListView.builder(
                                                            physics: const NeverScrollableScrollPhysics(),
                                                            shrinkWrap: true,
                                                            itemCount: listOrderX[index].orderDetails!.length,
                                                            itemBuilder: (_, y) {
                                                              return ItemHistoryFood(
                                                                orderDetails: listOrderX[index].orderDetails![y],
                                                                listTopping: listOrderX[index].orderDetails![y].orderdetailToppingList,
                                                              );
                                                            }))
                                                  ],
                                                ),
                                              ),
                                            ),
                                            builder: (_, collapsed, expanded) {
                                              return Expandable(
                                                collapsed: collapsed,
                                                expanded: expanded,
                                                theme: const ExpandableThemeData(),
                                              );
                                            },
                                          )),
                                        )
                                      : Container();
                                });
                      },
                      error: (error, s) => Text(error.toString()),
                      loading: () => Center(child: Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2))),
                ),
              ]),
            )
          ],
        ),
      ),
    );
  }
}
