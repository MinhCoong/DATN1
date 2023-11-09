import 'dart:async';

import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:widget_and_text_animator/widget_and_text_animator.dart';

class NotifyShowdialog extends StatefulWidget {
  const NotifyShowdialog({super.key, required this.content});
  final String content;
  @override
  State<NotifyShowdialog> createState() => _NotifyShowdialogState();
}

class _NotifyShowdialogState extends State<NotifyShowdialog> {
  late Timer time;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    time = Timer(const Duration(seconds: 2), () {
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    double screensWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(.3),
      body: WidgetAnimator(
        incomingEffect: WidgetTransitionEffects.incomingScaleUp(),
        child: Center(
          child: Container(
            width: screensWidth * 2 / 3,
            height: screensWidth / 3,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
                shape: BoxShape.rectangle,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black38,
                      offset: Offset(0, 4),
                      blurRadius: 5)
                ],
                color: AppColors.WHX,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Lottie.asset(
                    'assets/images/errorLittie.json',
                    fit: BoxFit.cover,
                  ),
                ),
                Expanded(child: Text(widget.content)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
