import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:fe_flutter_ui/repositories/notification_repo.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

final notificationProvider = Provider<INotification>((ref) => NotificationRepo());

final notificationData = FutureProvider((ref) {
  final userId = ref.watch(collectedUser);
  return ref.watch(notificationProvider).getNotification(userId);
});

class NotiNotifier extends ChangeNotifier {
  NotiNotifier(this.ref) : super();
  final Ref ref;

  Future<String> onSubDelete(int id) async {
    final reponse = ref.watch(notificationProvider);
    return await reponse.deleteNotify(id);
  }

  Future<String> onUpdate(int id) async {
    final reponse = ref.watch(notificationProvider);
    return await reponse.updateStatus(id);
  }
}

final notiWithNotifier = ChangeNotifierProvider.autoDispose<NotiNotifier>((ref) {
  return NotiNotifier(ref);
});
