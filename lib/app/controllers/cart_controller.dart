import 'package:get/get.dart';
import '../models/product_model.dart';

class CartController extends GetxController {
  // Product => quantity
  var cartItems = <Product, int>{}.obs;

  void addToCartWithQuantity(Product product, int quantity) {
    if (cartItems.containsKey(product)) {
      cartItems[product] = cartItems[product]! + quantity;
    } else {
      cartItems[product] = quantity;
    }
  }

  void removeFromCart(Product product) {
    cartItems.remove(product);
  }

  double get totalPrice =>
      cartItems.entries.fold(0, (sum, entry) => sum + entry.key.price * entry.value);
}
