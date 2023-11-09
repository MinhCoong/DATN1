import 'package:fe_flutter_ui/main.dart';
import 'package:fe_flutter_ui/models/address.dart';
import 'package:fe_flutter_ui/repositories/address_repo.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final addressProvider = Provider<IAddress>((ref) => AddressRepo());
final addressData = FutureProvider(
  (ref) {
    final userId = ref.watch(collectedUser);
    return ref.watch(addressProvider).getAddress(userId);
  },
);

class AddressNotifierX extends ChangeNotifier {
  AddressNotifierX(this.ref) : super();
  final Ref ref;

  Future<String> onSubmitAddres(Addresses addresses) async {
    final repon = ref.read(addressProvider);
    String x = await repon.postAddress(addresses);

    return x;
  }

  Future<String> onDeleAddress(int id) async {
    return await ref.watch(addressProvider).deleteAddress(id);
  }

  Future<String> onUpdateAddress(int id, Addresses address) async {
    return await ref.watch(addressProvider).updateAddress(id, address);
  }
}

final addressNotifier =
    ChangeNotifierProvider.autoDispose<AddressNotifierX>((ref) {
  return AddressNotifierX(ref);
});
