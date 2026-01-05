import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/product_controller.dart';
import 'help_support_view.dart';
import 'wishlist_view.dart';

class ProfileView extends StatelessWidget {
  final AuthController authController = Get.find<AuthController>();
  final ProductController productController = Get.find<ProductController>();

  ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final name = authController.nameController.text.isNotEmpty
        ? authController.nameController.text
        : 'Guest User';
    final email = authController.emailController.text.isNotEmpty
        ? authController.emailController.text
        : 'guest@example.com';

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              ClipPath(
                clipper: _HeaderClipper(),
                child: Container(
                  height: 200,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlueAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 80),
              Column(
                children: [
                  Text(name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(email, style: const TextStyle(fontSize: 16, color: Colors.grey)),
                ],
              ),
              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 4,
                  child: Column(
                    children: [
                      _profileOption(
                        icon: Icons.shopping_bag_outlined,
                        title: 'My Orders',
                        onTap: () {},
                      ),
                      _profileOption(
                        icon: Icons.favorite,
                        title: 'My Favourites',
                        onTap: () {
                          Get.to(() => WishlistView());
                        },
                      ),
                      _profileOption(
                        icon: Icons.settings_outlined,
                        title: 'Settings',
                        onTap: () {},
                      ),
                      _profileOption(
                        icon: Icons.help_outline,
                        title: 'Help & Support',
                        onTap: () {
                          Get.to(() => const HelpSupportView());
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
        Positioned(
          top: 100,
          left: MediaQuery.of(context).size.width / 2 - 55,
          child: Stack(
            children: [
              CircleAvatar(
                radius: 55,
                backgroundColor: Colors.white,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.blue.shade300,
                  child: const Icon(Icons.person, size: 60, color: Colors.white),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () {},
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.edit, size: 20),
                ),
              )
            ],
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: SizedBox(
            height: 55,
            child: ElevatedButton.icon(
              icon: const Icon(Icons.logout, size: 22),
              label: const Text('Logout', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 6,
              ),
              onPressed: () {
                authController.emailController.clear();
                authController.passwordController.clear();
                authController.nameController.clear();
                Get.offAllNamed('/');
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _profileOption({required IconData icon, required String title, required VoidCallback onTap}) {
    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.blue.shade50,
            child: Icon(icon, color: Colors.blue),
          ),
          title: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
          trailing: const Icon(Icons.arrow_forward_ios, size: 18),
          onTap: onTap,
        ),
        const Divider(height: 1),
      ],
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(size.width / 2, size.height, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
