import 'package:ecommerc_app/pages/cart/cart.dart';
import 'package:ecommerc_app/pages/cart/my_order.dart';
import 'package:ecommerc_app/pages/cart/order_cart.dart';
import 'package:ecommerc_app/pages/category/category.dart';
import 'package:ecommerc_app/pages/detail_page/detail_product.dart';
import 'package:ecommerc_app/pages/home_page/search_screen.dart';
import 'package:ecommerc_app/pages/location/location_delivery.dart';
import 'package:ecommerc_app/pages/login/login.dart';
import 'package:ecommerc_app/pages/login/register.dart';
import 'package:ecommerc_app/pages/main_page/main_page.dart';
import 'package:ecommerc_app/pages/orders/orders.dart';
import 'package:ecommerc_app/pages/settings/dart_mode.dart';
import 'package:ecommerc_app/pages/splash_screen/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'helpers/favorite_helper.dart';
import 'logic/theme_logic.dart';
import 'pages/payment/paymetn_method.dart';
import 'routes/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  String username = prefs.getString('username') ?? '';

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
        username: username,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  String username;
  final bool isLoggedIn;

  MyApp({super.key, required this.isLoggedIn, this.username = ''});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late String username;

  @override
  void initState() {
    super.initState();
    username = widget.username;
  }

  @override
  Widget build(BuildContext context) {
    // ThemeMode mode = context.watch<ThemeLogic>().mode;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: widget.isLoggedIn ? Routes.mainScreen : Routes.login,
      routes: {
        Routes.login: (context) => const Login(),
        Routes.splashscreen: (context) => const SplashScreen(),
        Routes.mainScreen: (context) => MainScreen(
              username: widget.username,
            ),
        Routes.detailScreen: (context) => const DetailProduct(),
        Routes.category: (context) => const Category(),
        Routes.cart: (context) => const Cart(),
        Routes.orders: (context) => const Orders(),
        Routes.payment: (context) => const PaymetnMethod(),
        Routes.location: (context) => const LocationDelivery(),
        Routes.search: (context) => const SearchScreen(),
        Routes.ordercart: (context) => const OrdersCart(),
        Routes.myorder: (context) => const MyOrder(),
        Routes.register: (context) => Register(),
        Routes.darkMode: (context) => DartMode(),
      },
    );
  }
}
