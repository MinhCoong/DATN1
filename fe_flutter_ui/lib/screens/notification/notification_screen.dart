// ignore_for_file: unused_result

import 'package:fe_flutter_ui/components/item_notification.dart';
import 'package:fe_flutter_ui/models/notification.dart';
import 'package:fe_flutter_ui/provider/notification_provider.dart';
import 'package:fe_flutter_ui/utils/colors.dart';
import 'package:fe_flutter_ui/utils/dimensions.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:overscroll_pop/overscroll_pop.dart';

import '../../components/itemnotify_popup.dart';
import '../../components/widgets/big_text.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  Widget build(BuildContext context) {
    final listNotification = ref.watch(notificationData);

    return Scaffold(
        backgroundColor: AppColors.BACKGROUND_COLOR,
        appBar: AppBar(
          centerTitle: true,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          toolbarHeight: Dimensions.heightListtile,
          elevation: 4,
          title: BigText(
            text: 'Thông báo',
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
              child: listNotification.when(
                  data: (data) {
                    List<Notifications> lNotifications = data.map((e) => e).toList();
                    return lNotifications.isEmpty
                        ? Center(
                            child: BigText(
                              text: 'Chưa có thông báo!',
                            ),
                          )
                        : ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: lNotifications.length,
                            itemBuilder: (_, index) {
                              return lNotifications[index].title != null
                                  ? Padding(
                                      padding: const EdgeInsets.only(bottom: 10),
                                      child: GestureDetector(
                                        onTap: () async {
                                          if (lNotifications[index].status!) {
                                            await ref.read(notiWithNotifier).onUpdate(lNotifications[index].id!);
                                            // ignore:
                                            ref.refresh(notificationData);
                                          }
                                          // ignore: use_build_context_synchronously
                                          pushOverscrollRoute(
                                              barrierColor: null,
                                              context: context,
                                              scrollToPopOption: ScrollToPopOption.start,
                                              child: ItemNotifyPodup(
                                                noti: lNotifications[index],
                                              ));
                                        },
                                        child: Slidable(
                                          key: UniqueKey(),
                                          // ignore: prefer_const_constructors
                                          endActionPane: ActionPane(
                                            motion: const ScrollMotion(),
                                            dismissible: DismissiblePane(onDismissed: () async {
                                              await ref.read(notiWithNotifier).onSubDelete(lNotifications[index].id!);
                                              ref.refresh(notificationData);
                                            }),
                                            children: [
                                              SlidableAction(
                                                borderRadius: BorderRadius.circular(10),
                                                onPressed: (context) async {
                                                  await ref
                                                      .read(notiWithNotifier)
                                                      .onSubDelete(lNotifications[index].id!);
                                                  ref.refresh(notificationData);
                                                },
                                                backgroundColor: AppColors.BURGUNDY,
                                                foregroundColor: AppColors.NOODLE_COLOR,
                                                icon: Icons.delete,
                                                label: 'Xóa',
                                              )
                                            ],
                                          ),
                                          child: SizedBox(
                                            height: Dimensions.heighContainer1,
                                            child: ItemNotification(
                                              status: lNotifications[index].status!,
                                              title: lNotifications[index].title!,
                                              body: lNotifications[index].body!,
                                              time: lNotifications[index].createdAt!.split('.').first,
                                            ),
                                          ),
                                        ),
                                      ),
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
