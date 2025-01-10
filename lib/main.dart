import 'package:ecommerc_app/pages/cart/cart.dart';
import 'package:ecommerc_app/pages/cart/order_cart.dart';
import 'package:ecommerc_app/pages/category/category.dart';
import 'package:ecommerc_app/pages/detail_page/detail_product.dart';
import 'package:ecommerc_app/pages/home_page/search_screen.dart';
import 'package:ecommerc_app/pages/location/location_delivery.dart';
import 'package:ecommerc_app/pages/main_page/main_page.dart';
import 'package:ecommerc_app/pages/orders/orders.dart';
import 'package:ecommerc_app/pages/payment/paymetn_method.dart';
import 'package:ecommerc_app/pages/splash_screen/no_internet_screen.dart';
import 'package:ecommerc_app/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_no_internet_widget/flutter_no_internet_widget.dart';
import 'package:provider/provider.dart';

import 'helpers/favorite_helper.dart';
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
    return InternetWidget(
      offline: const FullScreenWidget(
        child: NoInternetScreen(),
      ),
      online: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.splashscreen,
        routes: {
          Routes.splashscreen: (context) => const SplashScreen(),
          Routes.mainScreen: (context) => const MainScreen(),
          Routes.detailScreen: (context) => const DetailProduct(),
          Routes.category: (context) => const Category(),
          Routes.cart: (context) => const MyCart(),
          Routes.orders: (context) => const Orders(),
          Routes.payment: (context) => const PaymetnMethod(), // Fixed typo
          Routes.location: (context) => const LocationDelivery(),
          Routes.search: (context) => const SearchScreen(),
          Routes.ordercart: (context) => const OrdersCart()
        },
      ),
    );
  }
}
