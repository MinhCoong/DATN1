// ignore_for_file: file_names

import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';

import '../models/notification.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class ItemNotifyPodup extends ConsumerStatefulWidget {
  const ItemNotifyPodup({
    required this.noti,
    Key? key,
  }) : super(key: key);
  final Notifications noti;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputCustomerState();
}

class _InputCustomerState extends ConsumerState<ItemNotifyPodup> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Scaffold(
          backgroundColor: Colors.black26,
          body: Padding(
            padding: EdgeInsets.only(top: Dimensions.heighContainer3 / 4),
            child: Column(
              children: [
                Container(
                    margin: const EdgeInsets.all(20),
                    clipBehavior: Clip.hardEdge,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(
                        Radius.circular(20),
                      ),
                      color: AppColors.WH,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          color: AppColors.BURGUNDY,
                          padding: const EdgeInsets.all(5),
                          child: Column(
                            children: [
                              SizedBox(
                                height: Dimensions.heighContainer0 / 2,
                              ),
                              Center(
                                child: BigText(
                                  text: 'Thông báo',
                                  size: 15,
                                  color: AppColors.NOODLE_COLOR,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(15, 5, 15, 15),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              BigText(text: widget.noti.title!),
                              BigText(
                                text: widget.noti.body!,
                                overFlow: TextOverflow.visible,
                              ),
                              BigText(
                                  text:
                                      '${widget.noti.createdAt!.split('T').first} ${widget.noti.createdAt!.split('T').last.split('.').first}'),
                            ],
                          ),
                        )
                      ],
                    )),
                const Spacer()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
