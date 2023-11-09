// ignore_for_file: non_constant_identifier_names

import 'package:fe_flutter_ui/models/address.dart';
import 'package:fe_flutter_ui/models/cart.dart';
import 'package:fe_flutter_ui/models/coupons.dart';
import 'package:fe_flutter_ui/models/customer.dart';
import 'package:fe_flutter_ui/models/favorite.dart';
import 'package:fe_flutter_ui/models/login.dart';
import 'package:fe_flutter_ui/models/news.dart';
import 'package:fe_flutter_ui/models/order.dart';
import 'package:fe_flutter_ui/models/productmrsoai.dart';
import 'package:fe_flutter_ui/models/token.dart';
import 'package:fe_flutter_ui/models/topping.dart';
import 'package:fe_flutter_ui/models/topping_category.dart';
import 'package:fe_flutter_ui/models/category.dart';
import 'package:fe_flutter_ui/models/registrationtoken.dart';
import 'package:fe_flutter_ui/models/notification.dart';
import 'package:fe_flutter_ui/models/slider.dart';

abstract class ICustomerRepo {
  //delete
  Future<String> deletedCustomer(String customer);
  //get
  Future<Customer> getCustomer(String userId);
  //put
  Future<String> putCompleted(Customer customer);
  //post
  Future<TokenRepo> postCustomer(LoginNRegister customer);

  Future<String> postRegistrationToken(RegistrationToken registrationToken);
}

abstract class ICategoryRepo {
  Future<List<Categorys>> getCategories();
}

abstract class IToppingNCategory {
  Future<List<ToppingNCategory>> getTopping();
  Future<List<Toppings>> getListTopping();
}

abstract class IcartRepo {
  Future<List<Cart>> getCart(String userId);
  Future<String> deletedCart(int? id, String userId);
  Future<String> postCart(AddToCartModel cart);
}

abstract class IFavorite {
  Future<List<Products>> getFavorite(String userId);
  Future<String> deleteFavorite(int id);
  Future<String> postCart(Favorite favorite);
}

abstract class IOrder {
  Future<List<Order>> getOrder(String userId);
  Future<String> postOrder(Order order);
}

abstract class IShared {
  Future<List<News>> getNew();
  Future<List<SliderMrSoai>> getSlider();
  Future<List<Coupons>> getListCoupons(String userId);
}

abstract class IAddress {
  Future<List<Addresses>> getAddress(String userId);
  Future<String> postAddress(Addresses address);
  Future<String> deleteAddress(int id);
  Future<String> updateAddress(int id, Addresses address);
}

abstract class IProduct {
  Future<List<Products>> getProduct(String? productName);
}

abstract class INotification {
  Future<List<Notifications>> getNotification(String userId);
  Future<String> updateStatus(int id);
  Future<String> deleteNotify(int id);
}
