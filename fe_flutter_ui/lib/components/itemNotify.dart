// ignore_for_file: file_names


import 'package:fe_flutter_ui/components/widgets/big_text.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import 'package:fe_flutter_ui/utils/dimensions.dart';

final formatCurrency = NumberFormat("#,##0", "en_US");

class ItemNotifier extends ConsumerStatefulWidget {
  const ItemNotifier({
    Key? key,
    required this.text,
    required this.isCorrect,
  }) : super(key: key);

  final bool isCorrect;
  final String text;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InputCustomerState();
}

class _InputCustomerState extends ConsumerState<ItemNotifier>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..addListener(() {
        setState(() {});
      });

    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController)
          ..addStatusListener((status) {
            if (status == AnimationStatus.completed) {
              Get.back();
            } else if (status == AnimationStatus.dismissed) {
              _animationController.forward(); // Khởi động lại animation
            }
          });

    _animationController.forward(); // Khởi động animation
  }

  @override
  void dispose() {
    _animationController.dispose(); // Giải phóng animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(top: Dimensions.heighContainer1 / 2),
          child: Neumorphic(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.only(right: 5),
            style: NeumorphicStyle(
                depth: 10,
                boxShape:
                    NeumorphicBoxShape.roundRect(BorderRadius.circular(15)),
                color: Colors.white),
            child: SizedBox(
                height: Dimensions.heighContainer1 / 1.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          widget.isCorrect
                              ? Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/check.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                )
                              : Expanded(
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/error.png",
                                      width: 50,
                                      height: 50,
                                    ),
                                  ),
                                ),
                          Expanded(
                            flex: 4,
                            child: BigText(
                              text: widget.text,
                              overFlow: TextOverflow.visible,
                            ),
                          )
                        ],
                      ),
                    ),
                    LinearProgressIndicator(
                      value: _animation.value,
                    )
                  ],
                )),
          ),
        ),
      ),
    );
  }
}
