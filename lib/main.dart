import 'package:ecommerc_app/pages/cart/cart.dart';
import 'package:ecommerc_app/pages/cart/order_cart.dart';
import 'package:ecommerc_app/pages/category/category.dart';
import 'package:ecommerc_app/pages/detail_page/detail_product.dart';
import 'package:ecommerc_app/pages/home_page/search_screen.dart';
import 'package:ecommerc_app/pages/location/location_delivery.dart';
import 'package:ecommerc_app/pages/main_page/main_page.dart';
import 'package:ecommerc_app/pages/orders/orders.dart';
import 'package:ecommerc_app/pages/payment/paymetn_method.dart';
import 'package:flutter/material.dart';
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
        Routes.search: (context) => const SearchScreen(),
        Routes.order_cart: (context) => const OrdersCart()
      },
    );
  }
}

// import 'package:add_to_cart_animation/add_to_cart_animation.dart';
// import 'package:flutter/material.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Add To Cart Animation Example',
//       theme: ThemeData(
//         useMaterial3: false,
//         primarySwatch: Colors.blue,
//       ),
//       home: const MyHomePage(title: 'Add To Cart Animation Example'),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   const MyHomePage({super.key, required this.title});
//   final String title;

//   @override
//   MyHomePageState createState() => MyHomePageState();
// }

// class MyHomePageState extends State<MyHomePage> {
//   // We can detect the location of the cart by this  GlobalKey<CartIconKey>
//   GlobalKey<CartIconKey> cartKey = GlobalKey<CartIconKey>();
//   late Function(GlobalKey) runAddToCartAnimation;
//   var _cartQuantityItems = 0;

//   @override
//   Widget build(BuildContext context) {
//     return AddToCartAnimation(
//       // To send the library the location of the Cart icon
//       cartKey: cartKey,
//       height: 30,
//       width: 30,
//       opacity: 0.85,
//       dragAnimation: const DragToCartAnimationOptions(
//         rotation: true,
//       ),
//       jumpAnimation: const JumpAnimationOptions(),
//       createAddToCartAnimation: (runAddToCartAnimation) {
//         // You can run the animation by addToCartAnimationMethod, just pass trough the the global key of  the image as parameter
//         this.runAddToCartAnimation = runAddToCartAnimation;
//       },
//       child: Scaffold(
//         appBar: AppBar(
//           title: Text(widget.title),
//           centerTitle: false,
//           actions: [
//             //  Adding 'clear-cart-button'
//             IconButton(
//               icon: const Icon(Icons.cleaning_services),
//               onPressed: () {
//                 _cartQuantityItems = 0;
//                 cartKey.currentState!.runClearCartAnimation();
//               },
//             ),
//             const SizedBox(width: 16),
//             AddToCartIcon(
//               key: cartKey,
//               icon: const Icon(Icons.shopping_cart),
//               badgeOptions: const BadgeOptions(
//                 active: true,
//                 backgroundColor: Colors.red,
//               ),
//             ),
//             const SizedBox(
//               width: 16,
//             )
//           ],
//         ),
//         body: ListView(
//           children: List.generate(
//             15,
//             (index) => AppListItem(
//               onClick: listClick,
//               index: index,
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void listClick(GlobalKey widgetKey) async {
//     await runAddToCartAnimation(widgetKey);
//     await cartKey.currentState!
//         .runCartAnimation((++_cartQuantityItems).toString());
//   }
// }

// class AppListItem extends StatelessWidget {
//   final GlobalKey widgetKey = GlobalKey();
//   final int index;
//   final void Function(GlobalKey) onClick;

//   AppListItem({super.key, required this.onClick, required this.index});
//   @override
//   Widget build(BuildContext context) {
//     //  Container is mandatory. It can hold images or whatever you want
//     Container mandatoryContainer = Container(
//       key: widgetKey,
//       width: 60,
//       height: 60,
//       color: Colors.transparent,
//       child: Image.network(
//         "https://img.freepik.com/free-vector/hand-drawn-glossary-illustration_23-2150287961.jpg?t=st=1736221615~exp=1736225215~hmac=8ebb00b367774a46aabdaad4a41adf7438a534058744011836438f3acf78a1ad&w=1380",
//         width: 60,
//         height: 60,
//       ),
//     );

//     return ListTile(
//       onTap: () => onClick(widgetKey),
//       leading: mandatoryContainer,
//       title: Text(
//         "Animated Apple Product Image $index",
//       ),
//     );
//   }
// }
