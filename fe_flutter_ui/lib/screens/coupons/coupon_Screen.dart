// ignore_for_file: file_names

import 'package:fe_flutter_ui/models/coupons.dart';
import 'package:fe_flutter_ui/provider/news_provider.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../components/item_ticket.dart';
import '../../components/widgets/big_text.dart';

class CouponScreen extends ConsumerStatefulWidget {
  const CouponScreen({
    super.key,
    required this.isComingFromCart,
    required this.quantity,
    required this.total,
  });
  final bool isComingFromCart;
  final int quantity;
  final double total;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CouponScreenState();
}

class _CouponScreenState extends ConsumerState<CouponScreen> {
  @override
  Widget build(BuildContext context) {
    final listCoupons = ref.watch(couponsData);
    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          toolbarHeight: Dimensions.heightListtile,
          elevation: 4,
          title: BigText(
            text: 'Voucher của bạn',
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
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Container(
              margin: const EdgeInsets.fromLTRB(15, 15, 15, 0),
              child: listCoupons.when(
                  data: (data) {
                    List<Coupons> lCoupons = data.map((e) => e).toList();
                    return lCoupons.length == 1
                        ? Center(
                            child: BigText(
                              text: 'Hiện chưa có ưu đãi',
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: lCoupons.length,
                            itemBuilder: (_, index) {
                              return index != 0
                                  ? ItemTicketMaterial(
                                      coupons: lCoupons[index],
                                      isComingFromCart: widget.isComingFromCart,
                                      total: widget.total,
                                      quantity: widget.quantity,
                                    )
                                  : Container();
                            });
                  },
                  error: (error, s) => Text(error.toString()),
                  loading: () => Center(
                      child:
                          Lottie.asset('assets/images/loading-line-red.json', width: Dimensions.heighContainer3 / 2)))),
        ));
  }
}
