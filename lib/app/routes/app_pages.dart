import 'package:e_commerce_app/app/views/login_view.dart';
import 'package:e_commerce_app/app/views/product_list_view.dart';
import 'package:e_commerce_app/app/views/signup_view.dart';
import 'package:get/get.dart';
import '../views/cart_view.dart';
import '../views/product_detail_view.dart';

class AppPages {
  static const initial = '/';

  static final routes = [
    GetPage(name: '/', page: () => LoginView()),
    GetPage(name: '/signup', page: () => SignupView()),
    GetPage(name: '/detail', page: () => ProductDetailView()),
    GetPage(name: '/cart', page: () => CartView()),
    GetPage(name: '/products', page: () => ProductListView()), // <-- corrected
  ];
}
