import 'package:fe_flutter_ui/repositories/category_repo.dart';
import 'package:fe_flutter_ui/repositories/interface.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final categoryProvider = Provider<ICategoryRepo>((ref) => CategoryRepo());

final categoryDataProvider = FutureProvider((ref) async {
  return ref.watch(categoryProvider).getCategories();
});
