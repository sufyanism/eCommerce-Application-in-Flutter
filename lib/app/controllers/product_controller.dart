import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../models/product_model.dart';

class ProductController extends GetxController {
  var products = <Product>[].obs;
  var filteredProducts = <Product>[].obs;

  var isLoading = true.obs;
  var selectedCategory = 'All'.obs;
  var searchQuery = ''.obs;

  /// Favourite product IDs
  var favourites = <int>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      isLoading(true);

      final response =
      await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        final List data = json.decode(response.body);

        products.assignAll(
          data.map((e) => Product.fromJson(e)).toList(),
        );

        /// initial load
        applyFilters();
      } else {
        Get.snackbar('Error', 'Failed to load products');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  /* ================= FILTERS ================= */

  void filterByCategory(String category) {
    selectedCategory.value = category;
    applyFilters();
  }

  void searchProducts(String query) {
    searchQuery.value = query;
    applyFilters();
  }

  /// 🔥 SINGLE SOURCE OF TRUTH
  void applyFilters() {
    List<Product> temp = products;

    /// category filter
    if (selectedCategory.value != 'All') {
      temp = temp
          .where(
            (p) =>
        p.category.toLowerCase() ==
            selectedCategory.value.toLowerCase(),
      )
          .toList();
    }

    /// search filter
    if (searchQuery.value.isNotEmpty) {
      temp = temp
          .where(
            (p) =>
        p.title
            .toLowerCase()
            .contains(searchQuery.value.toLowerCase()) ||
            p.description
                .toLowerCase()
                .contains(searchQuery.value.toLowerCase()),
      )
          .toList();
    }

    filteredProducts.assignAll(temp);
  }

  /* ================= FAVOURITES ================= */

  bool isFavourite(int productId) => favourites.contains(productId);

  void addToFavourites(int productId) {
    if (!favourites.contains(productId)) {
      favourites.add(productId);
    }
  }

  void removeFromFavourites(int productId) {
    favourites.remove(productId);
  }

  void toggleFavourite(int productId) {
    isFavourite(productId)
        ? removeFromFavourites(productId)
        : addToFavourites(productId);
  }
}
