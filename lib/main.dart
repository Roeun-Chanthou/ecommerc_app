import 'package:ecommerc_app/pages/cart/cart.dart';
import 'package:ecommerc_app/pages/category/category.dart';
import 'package:ecommerc_app/pages/detail_page/detail_product.dart';
import 'package:ecommerc_app/pages/location/location_delivery.dart';
import 'package:ecommerc_app/pages/main_page/main_page.dart';
import 'package:ecommerc_app/pages/orders/orders.dart';
import 'package:ecommerc_app/pages/payment/paymetn_method.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'pages/favorite/favorite.dart';
import 'routes/routes.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => FavoritesManager()..loadFavorites(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.mainScreen,
      routes: {
        Routes.mainScreen: (context) => const MainScreen(),
        Routes.detailScreen: (context) => const DetailProduct(),
        Routes.category: (context) => const Category(),
        Routes.cart: (context) => const MyCart(),
        Routes.orders: (context) => const Orders(),
        Routes.payment: (context) => const PaymetnMethod(),
        Routes.location: (context) => const LocationDelivery(),
      },
    );
  }
}
