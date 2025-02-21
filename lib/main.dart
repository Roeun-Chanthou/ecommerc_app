import 'package:ecommerc_app/pages/category/category.dart';
import 'package:ecommerc_app/pages/detail_page/detail_product.dart';
import 'package:ecommerc_app/pages/home_page/search_screen.dart';
import 'package:ecommerc_app/pages/location/location_delivery.dart';
import 'package:ecommerc_app/pages/login/login.dart';
import 'package:ecommerc_app/pages/login/register.dart';
import 'package:ecommerc_app/pages/main_page/main_page.dart';
import 'package:ecommerc_app/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/network/helpers/favorite_helper.dart';
import 'logic/theme_logic.dart';
import 'pages/cart/cart.dart';
import 'pages/order_proudct/my_order.dart';
import 'pages/order_proudct/order_cart.dart';
import 'pages/orders/orders.dart';
import 'pages/payment/paymetn_method.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => FavoritesManager()..loadFavorites(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeLogic(),
        ),
      ],
      child: MyApp(
        isLoggedIn: isLoggedIn,
        // username: username,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String username;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Routes.splashscreen,
      routes: {
        Routes.login: (context) => const Login(),
        Routes.splashscreen: (context) => SplashScreen(
              isLoggedIn: widget.isLoggedIn,
            ),
        Routes.mainScreen: (context) => MainScreen(),
        Routes.detailScreen: (context) => const DetailProduct(),
        Routes.category: (context) => const Category(),
        Routes.cart: (context) => const Cart(),
        Routes.orders: (context) => const Orders(),
        Routes.payment: (context) => const PaymetnMethod(),
        Routes.location: (context) => const LocationDelivery(),
        Routes.search: (context) => const SearchScreen(),
        Routes.ordercart: (context) => const OrdersCart(),
        Routes.myorder: (context) => MyOrder(),
        Routes.register: (context) => Register(),
      },
    );
  }
}
