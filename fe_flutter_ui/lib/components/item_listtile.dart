import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'widgets/big_text.dart';

class ItemListTile extends StatelessWidget {
  final IconData iconData;
  final String text;
  const ItemListTile({
    Key? key,
    required this.iconData,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      splashColor: AppColors.WHX,
      tileColor: Colors.transparent,
      minLeadingWidth: 0,
      leading: FaIcon(
        iconData,
        color: Colors.black.withOpacity(.7),
        size: 20,
      ),
      title: BigText(
        text: text,
        size: 13,
      ),
      trailing: Icon(
        Icons.arrow_forward_ios,
        color: Colors.black.withOpacity(.7),
        size: 15,
      ),
    );
  }
}
