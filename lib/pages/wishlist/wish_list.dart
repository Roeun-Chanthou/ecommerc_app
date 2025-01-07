import 'package:ecommerc_app/helpers/favorite_helper.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class WishListScreen extends StatelessWidget {
  const WishListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade100,
        centerTitle: true,
        leading: const Padding(
          padding: EdgeInsets.only(
            left: 10,
          ),
          child: Center(
            child: Text(
              "L Y",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w900,
                fontFamily: "Billa",
              ),
            ),
          ),
        ),
        title: SizedBox(
          height: 40,
          child: TextField(
            readOnly: true,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 16,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide.none,
              ),
              hintText: "Search anything you like",
              hintStyle: TextStyle(
                fontSize: 18,
                color: Colors.grey[500],
              ),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Bounceable(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  Routes.cart,
                );
              },
              child: SvgPicture.asset(
                "assets/cart 02.svg",
                height: 30,
                width: 30,
              ),
            ),
          ),
        ],
      ),
      body: Consumer<FavoritesManager>(
        builder: (context, favoritesManager, child) {
          var favoriteProducts = favoritesManager.favorites;

          if (favoriteProducts.isEmpty) {
            return Container(
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/shopping-cart-realistic_1284-6011.jpg.avif",
                    height: 200,
                    width: 200,
                  ),
                  const Center(
                    child: Text(
                      "No favorite items yet!",
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              childAspectRatio: 0.68,
            ),
            itemCount: favoriteProducts.length,
            itemBuilder: (context, index) {
              var product = favoriteProducts[index];
              return Bounceable(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    Routes.detailScreen,
                    arguments: product,
                  );
                },
                child: Card(
                  elevation: 0,
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.only(
                      left: 16,
                      top: 10,
                      right: 16,
                      bottom: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Center(
                            child: Image.network(
                              "http:${product.image}",
                              width: 180,
                              height: 180,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          product.name,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Price: ${product.priceSign}${product.price}",
                          style: const TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
