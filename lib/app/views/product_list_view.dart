import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import '../controllers/cart_controller.dart';
import 'cart_view.dart';
import 'profile_view.dart';
import 'product_detail_view.dart';

class ProductListView extends StatefulWidget {
  const ProductListView({super.key});

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final ProductController productController = Get.put(ProductController());
  final CartController cartController = Get.find<CartController>();
  final AuthController authController = Get.put(AuthController());

  int _selectedIndex = 0;

  Widget _buildHomeBody() {
    return Obx(() {
      if (productController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (productController.filteredProducts.isEmpty) {
        return const Center(
          child: Text(
            'No products found',
            style: TextStyle(fontSize: 16),
          ),
        );
      }

      final products = productController.filteredProducts;

      return CustomScrollView(
        slivers: [
          /// 🔹 Categories
          SliverToBoxAdapter(
            child: SizedBox(
              height: 95,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: const [
                  _CategoryItem(Icons.category, 'All'),
                  _CategoryItem(Icons.devices, 'electronics'),
                  _CategoryItem(Icons.watch, 'jewelery'),
                  _CategoryItem(Icons.male, "men's clothing"),
                  _CategoryItem(Icons.female, "women's clothing"),
                ],
              ),
            ),
          ),

          /// 🔹 Best Deals
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(12, 14, 12, 8),
              child: Text(
                'Best Deals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 230,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: products.length > 6 ? 6 : products.length,
                itemBuilder: (_, i) =>
                    _HorizontalProductCard(product: products[i]),
              ),
            ),
          ),

          /// 🔹 All Products
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Text(
                'All Products',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate(
                    (_, i) => _GridProductCard(product: products[i]),
                childCount: products.length,
              ),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.63,
              ),
            ),
          ),
        ],
      );
    });
  }

  late final List<Widget> _pages = [
    _buildHomeBody(),
    CartView(),
    ProfileView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.lightBlueAccent],
            ),
          ),
        ),
        title: _selectedIndex == 0
            ? TextField(
          onChanged: productController.searchProducts,
          decoration: InputDecoration(
            hintText: 'Search products',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        )
            : Text(
          _selectedIndex == 1 ? 'Cart' : 'Profile',
          style: const TextStyle(color: Colors.white),
        ),
        actions: _selectedIndex == 0
            ? [
          Obx(() => Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart_outlined,
                    color: Colors.white),
                onPressed: () =>
                    setState(() => _selectedIndex = 1),
              ),
              if (cartController.cartItems.isNotEmpty)
                Positioned(
                  right: 6,
                  top: 6,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: Colors.red,
                    child: Text(
                      cartController.cartItems.length.toString(),
                      style: const TextStyle(
                          color: Colors.white, fontSize: 10),
                    ),
                  ),
                )
            ],
          )),
        ]
            : null,
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (i) => setState(() => _selectedIndex = i),
        selectedItemColor: Colors.blue,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

/* ===================== CATEGORY ===================== */
class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const _CategoryItem(this.icon, this.title);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ProductController>();

    return Obx(() {
      final selected = controller.selectedCategory.value == title;

      return InkWell(
        onTap: () => controller.filterByCategory(title),
        child: Container(
          width: 100,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.blue : Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: selected ? Colors.white : Colors.blue),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

/* ===================== HORIZONTAL CARD ===================== */
class _HorizontalProductCard extends StatelessWidget {
  final dynamic product;
  final ProductController controller = Get.find<ProductController>();

  _HorizontalProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isFav = controller.isFavourite(product.id);

      return Container(
        width: 180,
        margin: const EdgeInsets.only(right: 12),
        child: Stack(
          children: [
            GestureDetector(
              onTap: () =>
                  Get.to(() => ProductDetailView(), arguments: product),
              child: Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Expanded(
                      child: Image.network(
                        product.image,
                        fit: BoxFit.contain,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(6),
                      child: Text(
                        product.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Text(
                      '₹${product.price}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),

            /// ❤️ Favourite Toggle
            Positioned(
              top: 6,
              right: 6,
              child: InkWell(
                onTap: () => controller.toggleFavourite(product.id),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }
}

/* ===================== GRID CARD ===================== */
class _GridProductCard extends StatelessWidget {
  final dynamic product;
  final ProductController controller = Get.find<ProductController>();

  _GridProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isFav = controller.isFavourite(product.id);

      return InkWell(
        onTap: () =>
            Get.to(() => ProductDetailView(), arguments: product),
        child: Card(
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Stack(
            children: [
              Column(
                children: [
                  Expanded(
                    child: Image.network(
                      product.image,
                      fit: BoxFit.contain,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      product.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    '₹${product.price}',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
              ),

              /// ❤️ Favourite Toggle
              Positioned(
                top: 6,
                right: 6,
                child: InkWell(
                  onTap: () => controller.toggleFavourite(product.id),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(
                      isFav ? Icons.favorite : Icons.favorite_border,
                      color: Colors.red,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
