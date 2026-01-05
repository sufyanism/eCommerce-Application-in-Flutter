import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/controllers/auth_controller.dart';
import 'app/controllers/cart_controller.dart';
import 'app/routes/app_pages.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController(), permanent: true);
    Get.put(CartController(), permanent: true);
    Get.put(CartController(), permanent: true);

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'E-Commerce App',
      initialRoute: '/',
      getPages: AppPages.routes,
    );
  }
}
