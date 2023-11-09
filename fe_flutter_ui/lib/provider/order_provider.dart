import 'package:fe_flutter_ui/models/order.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:fe_flutter_ui/repositories/order_repo.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

final orderProvider = Provider<IOrder>((ref) => OrderRepo());

final orderData = FutureProvider((ref) async {
  final userId = ref.watch(collectedUser);
  return ref.watch(orderProvider).getOrder(userId);
});

class OrderNotifier extends ChangeNotifier {
  OrderNotifier(this.ref) : super();
  final Ref ref;

  Future<String> onSubmitOrder(Order order) async {
    final repon = ref.read(orderProvider);
    String x = await repon.postOrder(order);

    return x;
  }
}

final cartNoitfier = ChangeNotifierProvider.autoDispose<OrderNotifier>((ref) {
  return OrderNotifier(ref);
});
