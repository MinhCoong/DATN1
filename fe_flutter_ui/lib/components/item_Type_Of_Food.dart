// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:fe_flutter_ui/components/widgets/imagecacheprovider.dart';
import 'package:fe_flutter_ui/screens/menu/menu_screen.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:fe_flutter_ui/utils/list_item.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../screens/home/home_screen.dart';
import '../utils/colors.dart';
import 'widgets/big_text.dart';

final groupRadioProvider = StateProvider<String>((ref) {
  return '';
});

class ItemTypeOfFood extends ConsumerStatefulWidget {
  final String? url;
  final text;
  final int index;
  final String? firstValue;
  const ItemTypeOfFood({
    super.key,
    required this.url,
    this.text,
    this.firstValue,
    required this.index,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ItemTypeOfFoodState();
}

class _ItemTypeOfFoodState extends ConsumerState<ItemTypeOfFood> {
  @override
  Widget build(BuildContext context) {
    var groupValue = ref.watch(groupRadioProvider);
    if (groupValue.isEmpty) {
      groupValue = widget.firstValue!;
    }
    return NeumorphicRadio(
      groupValue: groupValue,
      value: widget.text,
      style: NeumorphicRadioStyle(
          shape: NeumorphicShape.concave,
          unselectedDepth: 2,
          boxShape: NeumorphicBoxShape.roundRect(
              const BorderRadius.all(Radius.circular(15))),
          lightSource: LightSource.topLeft,
          unselectedColor: AppColors.WH,
          selectedColor: AppColors.WH),
      onChanged: (value) {
        setState(() {
          ref.read(groupRadioProvider.notifier).update((state) => widget.text);
          ref
              .read(indexCategoryProvider.notifier)
              .update((state) => widget.index);
          ref.read(indexScreenProvider.notifier).update((state) => 1);
        });
      },
      child: Container(
        width: 90,
        padding: EdgeInsets.all(Dimensions.padding_MarginHome2 / 1.5),
        decoration: BoxDecoration(
            border: Border.all(
                width: 1.5,
                color: groupValue == widget.text
                    ? AppColors.BURGUNDY.withOpacity(.6)
                    : Colors.transparent),
            borderRadius: BorderRadius.circular(15)),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              child: SizedBox(
                  height: Dimensions.heightAppbarSearch,
                  width: 50,
                  child:
                      ImageCachedProvider(url: UrlImageCategory + widget.url!)),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: BigText(
                  text: widget.text,
                  size: 11.5,
                  overFlow: TextOverflow.visible,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
