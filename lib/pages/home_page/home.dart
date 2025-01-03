import 'package:ecommerc_app/data/product_sliver.dart';
import 'package:ecommerc_app/models/product_model.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:ecommerc_app/widgets/slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

import '../../data/product_type _sliver.dart';
import '../../models/product_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Map<String, dynamic> selectedProductType = productType[0];
  var scrollController = ScrollController();

  var searchController = TextEditingController();
  List<Map<String, dynamic>> filtterItems = [];
  bool isSearchClick = false;

  List<Map<String, dynamic>> cart = [];

  @override
  void initState() {
    super.initState();
    filtterItems = products;
    searchController.addListener(filtterData);
  }

  void filtterData() {
    setState(() {
      final query = searchController.text.toLowerCase();
      filtterItems = products
          .where((item) => item['name'].toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: [
          SliverAppBar(
            pinned: true,
            forceElevated: true,
            backgroundColor: Colors.white,
            centerTitle: true,
            leading: const Padding(
              padding: EdgeInsets.only(
                left: 10,
              ),
              child: Center(
                child: Text(
                  "RS",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            title: Row(
              children: [
                Container(
                  width: 1,
                  height: 30,
                  color: Colors.grey,
                ),
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      controller: searchController,
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
                ),
              ],
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Bounceable(
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      Routes.cart,
                      arguments: cart,
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
          const SliverToBoxAdapter(
            child: SliderBanner(),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[100],
              height: 18,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              height: 180,
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20,
                    ),
                    child: Text(
                      "Product Type",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      shrinkWrap: true,
                      itemCount: productType.length,
                      itemBuilder: (context, index) {
                        var item = productType[index];
                        var product = ProductType.fromJson(item);
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16.0,
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Bounceable(
                                  scaleFactor: 0.5,
                                  onTap: () {
                                    setState(() {
                                      selectedProductType = productType[index];
                                    });
                                    List<Map<String, dynamic>> fitterProduct =
                                        products
                                            .where((product) =>
                                                product["product_type"]
                                                    .toLowerCase() ==
                                                selectedProductType["tag"]
                                                    .replaceFirst(" ", "_")
                                                    .toLowerCase())
                                            .toList();
                                    Navigator.pushNamed(
                                      context,
                                      Routes.category,
                                      arguments: fitterProduct,
                                    );
                                  },
                                  child: SvgPicture.network(
                                    product.image,
                                    placeholderBuilder: (context) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          width: 80,
                                          height: 80,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      );
                                    },
                                    width: 80,
                                    height: 80,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.black,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                ),
                                Text(
                                  product.title,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.grey[100],
              height: 18,
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              color: Colors.white,
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 30,
                    ),
                    child: Text(
                      "All Product",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
            ),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.7,
              ),
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  var item = products[index];
                  var product = ProductModel.fromJson(item);
                  var searchItem = filtterItems[index];
                  var productFiltter = ProductModel.fromJson(searchItem);
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        Routes.detailScreen,
                        arguments: product,
                      );
                    },
                    child: Card(
                      elevation: 6,
                      shadowColor: Colors.grey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image(
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("No Image"),
                                        ],
                                      );
                                    },
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) {
                                        return child;
                                      }
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      );
                                    },
                                    image: isSearchClick
                                        ? NetworkImage(
                                            "http:${product.image}",
                                          )
                                        : NetworkImage(
                                            "http:${productFiltter.image}",
                                          ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(
                                isSearchClick
                                    ? product.name
                                    : productFiltter.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                isSearchClick
                                    ? product.description
                                    : productFiltter.description,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              child: Text(
                                isSearchClick
                                    ? "Price: ${product.priceSign}${product.price}"
                                    : "Price: ${productFiltter.priceSign}${productFiltter.price}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                childCount:
                    isSearchClick ? products.length : filtterItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
