import 'package:fe_flutter_ui/repositories/product_repo.dart';
import 'package:fe_flutter_ui/screens/menu/search_screen.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/interface.dart';

final productProvider = Provider<IProduct>((ref) {
  return ProductRepo();
});

final productData = FutureProvider((ref) async {
  final productName = ref.watch(productNameP);
  return await ref.watch(productProvider).getProduct(productName);
});
