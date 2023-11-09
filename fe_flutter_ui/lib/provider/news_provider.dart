import 'package:fe_flutter_ui/main.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:fe_flutter_ui/repositories/new_repo.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final newsProvider = Provider<IShared>((ref) {
  return NewsRepo();
});

final newsData = FutureProvider((ref) async {
  return await ref.watch(newsProvider).getNew();
});

final sliderMrSoaiData = FutureProvider((ref) async {
  return await ref.watch(newsProvider).getSlider();
});

final couponsData = FutureProvider((ref) async {
  final userId = ref.watch(collectedUser);
  var x = await ref.watch(newsProvider).getListCoupons(userId);
  ref.watch(indexCoupons.notifier).update((state) => x.length);
  return x;
});
