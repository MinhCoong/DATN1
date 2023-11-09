// ignore_for_file: unused_result

import 'package:fe_flutter_ui/main.dart';
import 'package:fe_flutter_ui/models/address.dart';
import 'package:fe_flutter_ui/provider/address_provider.dart';
import 'package:fe_flutter_ui/screens/oder/address/add_address.dart';
import 'package:fe_flutter_ui/screens/oder/address/edit_address.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

import '../../../components/item_listtile.dart';
import '../../../components/widgets/big_text.dart';

class SaveAddressScreen extends ConsumerStatefulWidget {
  const SaveAddressScreen({super.key, required this.isComingFromCart});
  final bool isComingFromCart;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _SaveAddressScreenState();
}

class _SaveAddressScreenState extends ConsumerState<SaveAddressScreen> {
  @override
  Widget build(BuildContext context) {
    final listAddress = ref.watch(addressData);
    return Scaffold(
      backgroundColor: AppColors.BACKGROUND_COLOR,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        toolbarHeight: Dimensions.heightListtile,
        title: BigText(
          text: 'Địa chỉ đã lưu',
          size: 15,
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
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            children: [
              SizedBox(
                height: Dimensions.highSBox,
              ),
              NeumorphicButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                          opaque: false,
                          pageBuilder: (BuildContext context, _, __) =>
                              const AddAddressScreen()),
                    );
                  },
                  style: NeumorphicStyle(
                      shape: NeumorphicShape.flat,
                      boxShape: NeumorphicBoxShape.roundRect(
                          const BorderRadius.all(Radius.circular(15))),
                      depth: 3,
                      lightSource: LightSource.topLeft,
                      color: AppColors.WH),
                  child: const ItemListTile(
                      iconData: Icons.add, text: 'Địa chỉ mới')),
              SizedBox(
                height: Dimensions.heighContainer0,
              ),
              listAddress.when(
                  skipLoadingOnReload: true,
                  skipLoadingOnRefresh: true,
                  data: (data) {
                    List<Addresses> lstAdd = data.map((e) => e).toList();
                    return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: lstAdd.length,
                        itemBuilder: (_, index) {
                          return ItemAddress(
                            addresses: lstAdd[index],
                            isComingFromCart: widget.isComingFromCart,
                          );
                        });
                  },
                  error: (error, s) => Text(error.toString()),
                  loading: () => const Center(
                        child: CircularProgressIndicator(),
                      ))
            ],
          ),
        ),
      ),
    );
  }
}

class ItemAddress extends ConsumerWidget {
  const ItemAddress({
    super.key,
    required this.addresses,
    required this.isComingFromCart,
  });

  final Addresses addresses;
  final bool isComingFromCart;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return NeumorphicButton(
      onPressed: () {
        if (isComingFromCart) {
          ref.read(addAddress.notifier).update((state) => addresses);
          Get.back();
        } else {
          Navigator.of(context).push(
            PageRouteBuilder(
                opaque: false,
                pageBuilder: (BuildContext context, _, __) =>
                    EditAddressScreen(addresses)),
          );
        }
      },
      margin: const EdgeInsets.symmetric(vertical: 5),
      style: NeumorphicStyle(
          shape: NeumorphicShape.flat,
          boxShape: NeumorphicBoxShape.roundRect(
              const BorderRadius.all(Radius.circular(15))),
          depth: 3,
          lightSource: LightSource.topLeft,
          color: AppColors.WH),
      child: Slidable(
        key: UniqueKey(),
        // ignore: prefer_const_constructors
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          // dismissible: DismissiblePane(onDismissed: () {}),
          children: [
            SlidableAction(
              borderRadius: BorderRadius.circular(10),
              onPressed: (context) {
                Navigator.of(context).push(
                  PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) =>
                          EditAddressScreen(addresses)),
                );
              },
              backgroundColor: AppColors.BURGUNDY,
              foregroundColor: AppColors.WH,
              icon: Icons.create,
              label: 'Sửa',
            ),
            SlidableAction(
              borderRadius: BorderRadius.circular(10),
              onPressed: (context) async {
                await ref.watch(addressNotifier).onDeleAddress(addresses.id!);
                ref.refresh(addressData);
              },
              backgroundColor: AppColors.BURGUNDY,
              foregroundColor: AppColors.WH,
              icon: Icons.delete,
              label: 'Xóa',
            )
          ],
        ),
        child: ListTile(
          splashColor: AppColors.WHX,
          tileColor: Colors.transparent,
          minLeadingWidth: 0,
          leading: const FaIcon(
            Icons.location_on_rounded,
            color: AppColors.BURGUNDY,
          ),
          title: BigText(
            text: addresses.nameAddress!,
            size: 15,
            fontweight: FontWeight.w800,
            color: Colors.black.withOpacity(.85),
          ),
          subtitle: BigText(
            text: addresses.addrressValue!,
            overFlow: TextOverflow.visible,
          ),
        ),
      ),
    );
  }
}
