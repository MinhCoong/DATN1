import 'package:fe_flutter_ui/main.dart';
import 'package:fe_flutter_ui/models/customer.dart';
import 'package:fe_flutter_ui/models/login.dart';
import 'package:fe_flutter_ui/models/registrationtoken.dart';
import 'package:fe_flutter_ui/models/token.dart';
import 'package:fe_flutter_ui/repositories/customer_repo.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../repositories/interface.dart';

final customerProvider = Provider<ICustomerRepo>((ref) => CustomerRepo());
final tokenx = Provider<TokenRepo>((ref) => TokenRepo());
final customerDataProvider = StateProvider<Customer>((ref) {
  return Customer();
});

class CustomerNotifier extends ChangeNotifier {
  CustomerNotifier(this.ref) : super();
  final Ref ref;

  Future<TokenRepo> onSubmitCustomer(LoginNRegister customer) async {
    final repository = ref.read(customerProvider);
    TokenRepo resp = await repository.postCustomer(customer);

    return resp;
  }

  Future<Customer> getCustomer(String userId) async {
    final repon = ref.read(customerProvider);
    final cus = await repon.getCustomer(userId);
    String name = '${cus.firstName ?? ''} ${cus.lastName ?? ''}';
    ref.read(textName.notifier).update((state) => name);
    ref.read(textPhone.notifier).update((state) => cus.phoneNumber ?? 'Nhập số điện thoại');
    ref.read(customerDataProvider.notifier).update((state) => cus);
    return cus;
  }

  Future<String> updateCustomer(Customer customer) async {
    return await ref.read(customerProvider).putCompleted(customer);
  }

  Future<String> postRToken(RegistrationToken registrationToken) async {
    return await ref.read(customerProvider).postRegistrationToken(registrationToken);
  }
}

final customerMrSoai = ChangeNotifierProvider.autoDispose<CustomerNotifier>(
  (ref) {
    return CustomerNotifier(ref);
  },
);
