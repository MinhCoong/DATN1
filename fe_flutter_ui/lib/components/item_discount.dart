import 'package:flutter/material.dart';

import '../utils/dimensions.dart';
import 'widgets/big_text.dart';

class ItemDiscount extends StatelessWidget {
  final String text;
  final IconData iconData;
  const ItemDiscount({
    Key? key,
    required this.text,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 5),
      color: Colors.white,
      elevation: 2,
      surfaceTintColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Icon(
                iconData,
                size: 20,
                color: Colors.black.withOpacity(.7),
              ),
            ),
            SizedBox(
              height: Dimensions.highSBox * 2,
            ),
            Expanded(
              child: BigText(
                text: text,
                size: 13,
                overFlow: TextOverflow.visible,
              ),
            )
          ],
        ),
      ),
    );
  }
}
