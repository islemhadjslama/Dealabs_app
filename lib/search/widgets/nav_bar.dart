import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../search/widgets/custom_search_bar.dart';
import 'package:newapp/services/products_services.dart';
import '../../shared/generic_list_screen.dart';

class NavBar extends StatelessWidget implements PreferredSizeWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductsService productsService = ProductsService();

    return AppBar(
      backgroundColor: Colors.white,
      elevation: 2,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios),
        color: Colors.black,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      title: CustomSearchBar(
        onSubmitted: (query) async {
          if (query.isEmpty) return;

          // Show loading dialog
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: CircularProgressIndicator()),
          );

          // Fetch products from database
          List<Product> filteredProducts =
          await productsService.searchProducts(query);

          // Close loading dialog
          Navigator.pop(context);

          // Navigate to results page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GenericListScreen(
                title: "Search results for '$query'",
                products: filteredProducts,
              ),
            ),
          );
        },
      ),
      centerTitle: true,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
