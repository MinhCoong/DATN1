import 'package:fe_flutter_ui/models/cart.dart';
import 'package:fe_flutter_ui/repositories/cart_repo.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

final cartProvider = Provider<IcartRepo>((ref) => CartRepo());
final cartSelectProvider = Provider<Cart>((ref) => Cart());


final cartData = FutureProvider((ref) {
  final userId = ref.watch(collectedUser);
  return ref.watch(cartProvider).getCart(userId);
});

class CartNotifier extends ChangeNotifier {
  CartNotifier(this.ref) : super();
  final Ref ref;

  Future<String> onSubmitCart(AddToCartModel cart) async {
    final reponsitory = ref.read(cartProvider);
    String x = await reponsitory.postCart(cart);

    return x;
  }

  Future<String> onDeleteCart(int? id, String userId) async {
    return await ref.watch(cartProvider).deletedCart(id, userId);
  }

  Future<List<Cart>> onGetCart(String userId) async {
    return await ref.watch(cartProvider).getCart(userId);
  }
}

final cartNotifier = ChangeNotifierProvider.autoDispose<CartNotifier>((ref) {
  return CartNotifier(ref);
});
