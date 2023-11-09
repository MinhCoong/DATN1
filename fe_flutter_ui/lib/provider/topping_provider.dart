import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:fe_flutter_ui/repositories/topping_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final toppingProvider = Provider<IToppingNCategory>((ref) => ToppingRepo());

final toppingCartDataProvider = FutureProvider((ref) async {
  return ref.watch(toppingProvider).getTopping();
});

final toppingDataProvider = FutureProvider((ref) async {
  return ref.watch(toppingProvider).getListTopping();
});
