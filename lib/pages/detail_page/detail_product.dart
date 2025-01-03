import 'package:ecommerc_app/models/product_model.dart';
import 'package:ecommerc_app/pages/favorite/favorite.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:ecommerc_app/services/cart_service.dart';
import 'package:ecommerc_app/widgets/space_height.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class DetailProduct extends StatefulWidget {
  const DetailProduct({super.key});

  @override
  State<DetailProduct> createState() => _DetailProductState();
}

class _DetailProductState extends State<DetailProduct> {
  late double screenWidth;
  late double screenHeight;
  String colornameProduct = "";
  int itemCount = 0;
  var isClick = false;
  List<Map<String, dynamic>> cart = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    var productDS = ModalRoute.of(context)?.settings.arguments as ProductModel;
    setState(() {
      colornameProduct = productDS.productColors.isNotEmpty
          ? productDS.productColors[0].colorName
          : "No Color ";
    });
  }

  void addToCart(ProductModel product) async {
    final cartService = CartService();
    bool isProductInCart = false;

    List<Map<String, dynamic>> cart = await cartService.getCart();

    for (var cartItem in cart) {
      var existingProduct = ProductModel.fromJson(cartItem['product']);
      if (existingProduct.name == product.name &&
          existingProduct.price == product.price &&
          existingProduct.image == product.image) {
        setState(() {
          cartItem['quantity']++;
        });
        isProductInCart = true;
        break;
      }
    }

    if (!isProductInCart) {
      setState(() {
        cart.add({
          'product': product.toJson(),
          'quantity': 1,
          'color': colornameProduct,
        });
      });
    }
    await cartService.saveCart(cart);

    setState(() {
      itemCount = cart.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;

    var productDS = ModalRoute.of(context)?.settings.arguments as ProductModel;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Detail Product"),
        actions: [
          if (productDS.productType.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, Routes.cart,
                      arguments: productDS);
                },
                child: Stack(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, Routes.cart,
                            arguments: cart);
                      },
                      icon: const Icon(Icons.shopping_cart, size: 30),
                    ),
                    Positioned(
                      right: 0,
                      child: Container(
                        height: 20,
                        width: 20,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    height: screenHeight * 0.35,
                    width: double.infinity,
                    child: Image.network(
                      "http:${productDS.image}",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SpaceHeight(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                productDS.name,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "Price: ${productDS.priceSign}${productDS.price}",
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Bounceable(
                          onTap: () {
                            final favoritesManager =
                                Provider.of<FavoritesManager>(context,
                                    listen: false);
                            favoritesManager.toggleFavorite(productDS);
                          },
                          child: Consumer<FavoritesManager>(
                            builder: (context, favoritesManager, child) {
                              bool isFavorite = favoritesManager.favorites
                                  .contains(productDS);
                              return SvgPicture.asset(
                                isFavorite
                                    ? "assets/love_solid.svg"
                                    : "assets/love.svg",
                                height: 25,
                                width: 25,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SpaceHeight(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Color: $colornameProduct',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        productDS.productColors.isNotEmpty
                            ? SizedBox(
                                height: 50,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: productDS.productColors.length,
                                  itemBuilder: (context, index) {
                                    var colorData =
                                        productDS.productColors[index];
                                    var isSelected =
                                        colornameProduct == colorData.colorName;

                                    return Bounceable(
                                      onTap: () {
                                        setState(() {
                                          colornameProduct =
                                              colorData.colorName;
                                        });
                                      },
                                      child: Container(
                                        margin: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                        ),
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Color(int.parse(colorData
                                              .hexValue
                                              .replaceFirst('#', '0xFF'))),
                                          border: Border.all(
                                            color: isSelected
                                                ? Colors.blue
                                                : Colors.transparent,
                                            width: 2,
                                          ),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : const Text(
                                "No colors available",
                                style:
                                    TextStyle(fontSize: 16, color: Colors.grey),
                              ),
                      ],
                    ),
                  ),
                  const SpaceHeight(),
                  _buildTagsSection(productDS),
                  const SpaceHeight(),
                  _buildDescriptionSection(productDS),
                  const SpaceHeight(),
                ],
              ),
            ),
          ),
          _buildFooter(productDS),
        ],
      ),
    );
  }

  Widget _buildTagsSection(ProductModel productDS) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Tags",
            style: TextStyle(fontSize: 15, color: Colors.grey[600]),
          ),
          const SizedBox(height: 12),
          productDS.tagList.isEmpty
              ? ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    foregroundColor: Colors.grey[700],
                    backgroundColor: Colors.grey[400],
                    minimumSize: Size(screenWidth, 40),
                  ),
                  onPressed: () {},
                  child: const Text("There's no tag"),
                )
              : Text(productDS.tagList.join(", ")),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ProductModel productDS) {
    return Container(
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Description",
            style: TextStyle(
              fontSize: 15,
              color: Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(productDS.description),
        ],
      ),
    );
  }

  Widget _buildFooter(ProductModel productDS) {
    return Container(
      height: screenHeight * 0.1,
      width: screenWidth,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              foregroundColor: Colors.black,
              side: const BorderSide(width: 1.5),
              minimumSize: Size(screenWidth * 0.55, 40),
            ),
            onPressed: () {
              addToCart(productDS);
              setState(() {
                itemCount++;
              });
            },
            child: const Text("Add to Cart"),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: const RoundedRectangleBorder(),
              foregroundColor: Colors.white,
              backgroundColor: Colors.black,
              minimumSize: Size(screenWidth * 0.2, 40),
            ),
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.orders,
                arguments: {
                  'product': productDS,
                  'color': colornameProduct,
                },
              );
            },
            child: const Text("Buy Now"),
          ),
        ],
      ),
    );
  }
}
