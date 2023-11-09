import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import 'widgets/big_text.dart';

class ItemNotification extends StatelessWidget {
  final String title;
  final String body;
  final String time;
  final bool status;
  const ItemNotification({
    Key? key,
    required this.title,
    required this.body,
    required this.time,
    required this.status,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: Colors.white,
      elevation: 2,
      surfaceTintColor: status ? Colors.white : AppColors.BURGUNDY.withOpacity(.7),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: BigText(
                text: title,
                size: 13,
                overFlow: TextOverflow.visible,
              ),
            ),
            SizedBox(
              height: Dimensions.highSBox * 2,
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 5,
                    child: BigText(
                      text: body,
                      size: 13,
                      overFlow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Spacer(),
                  BigText(
                    text: '${time.split('T').first} ${time.split('T').last}',
                    size: 12,
                    overFlow: TextOverflow.ellipsis,
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
