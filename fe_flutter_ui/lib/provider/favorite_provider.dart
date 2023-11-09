import 'package:fe_flutter_ui/models/favorite.dart';
import 'package:fe_flutter_ui/repositories/favorite.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../main.dart';

final favoriteProvider = Provider<IFavorite>((ref) => FavoriteRepo());
final favoriteSelectProvider = Provider<Favorite>((ref) => Favorite());

final favoriteData = FutureProvider((ref) {
  final userId = ref.watch(collectedUser);
  return ref.watch(favoriteProvider).getFavorite(userId);
});

class FavoriteNotifier extends ChangeNotifier {
  FavoriteNotifier(this.ref) : super();
  final Ref ref;

  Future<String> onSubmitFavorite(Favorite favorite) async {
    final repon = ref.watch(favoriteProvider);
    String x = await repon.postCart(favorite);
    return x;
  }

  Future<String> onDeleteFavorite(int id) async {
    return await ref.watch(favoriteProvider).deleteFavorite(id);
  }
}

final favoriteNotifier = ChangeNotifierProvider.autoDispose<FavoriteNotifier>((ref) {
  return FavoriteNotifier(ref);
});
