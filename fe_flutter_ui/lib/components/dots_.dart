import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class DottedBoderAPP extends StatelessWidget {
  const DottedBoderAPP({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      strokeCap: StrokeCap.butt,
      strokeWidth: 0.5,
      dashPattern: const [5, 5],
      customPath: (size) {
        return Path()
          ..moveTo(0, 20)
          ..lineTo(size.width, 20);
      },
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Container(),
      ),
    );
  }
}