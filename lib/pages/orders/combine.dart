// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:ecommerc_app/pages/order_proudct/detail_order_screen.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:intl/intl.dart';

// import '../../data/network/database/order_helper.dart';
// import '../../data/network/helpers/order_helper2.dart';
// import '../../widgets/space_height.dart';

// class MyOrdersCombined extends StatefulWidget {
//   const MyOrdersCombined({super.key});

//   @override
//   State<MyOrdersCombined> createState() => _MyOrdersCombinedState();
// }

// class _MyOrdersCombinedState extends State<MyOrdersCombined> {
//   List<dynamic> orders = [];
//   bool isLoading = true;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     loadOrders();
//   }

//   Future<void> _loadOrder() async {
//     try {
//       final savedOrders = await DatabaseHelper().getOrders(
//       );

//       if (mounted) {
//         setState(() {
//           orders = savedOrders.reversed.toList();
//           isLoading = false;
//         });
//       }
//       if (orders.isNotEmpty) _scrollToTop();
//     } catch (e) {
//       if (mounted) setState(() => isLoading = false);
//       print("Error loading orders: $e");
//     }
//   }

//   Future<void> loadOrders() async {
//     try {
//       setState(() {
//         isLoading = true;
//       });

//       final orders1 = await DatabaseHelper().getOrders();
//       final orders2 = await OrderDatabaseHelper.getOrders();

//       if (mounted) {
//         setState(() {
//           orders = [...orders2, ...orders1];
//           orders.sort((a, b) => b.datetime.compareTo(a.datetime));
//           isLoading = false;
//         });
//       }

//       if (orders.isNotEmpty) _scrollToTop();
//     } catch (e) {
//       print('Error loading orders: $e');
//       if (mounted) {
//         setState(() {
//           isLoading = false;
//         });
//       }
//     }
//   }

//   void _scrollToTop() {
//     if (_scrollController.hasClients) {
//       _scrollController.animateTo(
//         0.0,
//         duration: const Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'PROCESSING':
//         return Colors.grey;
//       case 'COMPLETED':
//         return Colors.green;
//       default:
//         return Colors.black;
//     }
//   }

//   Future<void> _deleteOrder(dynamic order) async {
//     try {
//       await DatabaseHelper().deleteOrder(order.id);
//       await OrderDatabaseHelper.deleteOrder(order.id);

//       setState(() {
//         orders.remove(order);
//       });
//     } catch (e) {
//       print('Error deleting order: $e');
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         centerTitle: true,
//         title: const Text('My Orders'),
//         backgroundColor: Colors.white,
//       ),
//       body: RefreshIndicator(
//         onRefresh: loadOrders,
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : orders.isEmpty
//                 ? const Center(
//                     child: Text(
//                       'No orders found',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   )
//                 : ListView.separated(
//                     controller: _scrollController,
//                     itemCount: orders.length,
//                     separatorBuilder: (context, index) => const SpaceHeight(),
//                     itemBuilder: (context, index) {
//                       final order = orders[index];
//                       return Dismissible(
//                         key: Key(order.id.toString()), // Unique key
//                         direction: DismissDirection.endToStart,
//                         background: Container(
//                           alignment: Alignment.centerRight,
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           color: Colors.red,
//                           child: const Icon(Icons.delete, color: Colors.white),
//                         ),
//                         onDismissed: (direction) async {
//                           await _deleteOrder(order);
//                         },
//                         child: _buildOrderCard(order),
//                       );
//                     },
//                   ),
//       ),
//     );
//   }

//   Widget _buildOrderCard(dynamic order) {
//     double totalAmount = order.items.fold(
//       0,
//       (sum, item) => sum + (item.price * item.quantity),
//     );

//     return Bounceable(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => OrderDetailsScreen(order: order),
//           ),
//         );
//       },
//       child: Container(
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(12),
//           color: Colors.white,
//         ),
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "#${order.id}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     Text(
//                       DateFormat('hh:mm a, MMM dd yyyy').format(order.datetime),
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const Spacer(),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       "\$${totalAmount.toStringAsFixed(2)}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         color: Colors.grey,
//                       ),
//                     ),
//                     const SizedBox(height: 10),
//                     GestureDetector(
//                       onTap: () async {
//                         if (order.status != "COMPLETED") {
//                           await DatabaseHelper()
//                               .updateOrderStatus(order.id, "COMPLETED");
//                           _loadOrder();
//                         }
//                         if (order.status.toLowerCase() != "completed") {
//                           await OrderDatabaseHelper.updateOrderStatus(
//                               order.id, "COMPLETED");
//                           loadOrders();
//                         }
//                       },
//                       child: Chip(
//                         label: Text(order.status),
//                         backgroundColor:
//                             _getStatusColor(order.status).withOpacity(0.2),
//                         labelStyle:
//                             TextStyle(color: _getStatusColor(order.status)),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const Divider(
//               color: Colors.grey,
//               height: 20,
//               thickness: 0.3,
//             ),
//             SizedBox(
//               height: 80,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: order.items.length,
//                 itemBuilder: (context, itemIndex) {
//                   var item = order.items[itemIndex];
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 8),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: CachedNetworkImage(
//                         width: 50,
//                         imageUrl: item.image.startsWith("http")
//                             ? item.image
//                             : "https:${item.image}",
//                         placeholder: (context, url) => const Center(
//                           child: CircularProgressIndicator(
//                             color: Colors.red,
//                           ),
//                         ),
//                         errorWidget: (context, url, error) => const Icon(
//                           Icons.broken_image,
//                           size: 50,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerc_app/pages/order_proudct/detail_order_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/database/login_helper.dart';
import '../../data/network/database/order_helper.dart';
import '../../data/network/helpers/order_helper2.dart';
import '../../widgets/space_height.dart';

class MyOrdersCombined extends StatefulWidget {
  const MyOrdersCombined({super.key});

  @override
  State<MyOrdersCombined> createState() => _MyOrdersCombinedState();
}

class _MyOrdersCombinedState extends State<MyOrdersCombined> {
  List<dynamic> orders = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _getUserIdAndLoadOrders();
  }

  Future<void> _getUserIdAndLoadOrders() async {
    var pref = await SharedPreferences.getInstance();
    var username = pref.getString('username') ?? '';

    var data = await LoginDatabaseHelper.getUserDetails(username);
    int userId = data['id'] ?? 0;

    loadOrders(userId);
  }

  Future<void> _loadOrder(int userId) async {
    try {
      final savedOrders = await DatabaseHelper().getOrders(userId);

      if (mounted) {
        setState(() {
          orders = savedOrders.reversed.toList();
          isLoading = false;
        });
      }
      if (orders.isNotEmpty) _scrollToTop();
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
      print("Error loading orders: $e");
    }
  }

  Future<void> loadOrders(int userId) async {
    try {
      setState(() {
        isLoading = true;
      });

      final orders1 = await DatabaseHelper().getOrders(userId);
      final orders2 = await OrderDatabaseHelper.getOrders(userId);

      if (mounted) {
        setState(() {
          orders = [...orders2, ...orders1];
          orders.sort((a, b) => b.datetime.compareTo(a.datetime));
          isLoading = false;
        });
      }

      if (orders.isNotEmpty) _scrollToTop();
    } catch (e) {
      print('Error loading orders: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _scrollToTop() {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'PROCESSING':
        return Colors.grey;
      case 'COMPLETED':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  Future<void> _deleteOrder(dynamic order, int userId) async {
    try {
      await DatabaseHelper().deleteOrder(order.id);
      await OrderDatabaseHelper.deleteOrder(order.id);

      setState(() {
        orders.remove(order);
      });

      loadOrders(userId);
    } catch (e) {
      print('Error deleting order: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('My Orders'),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var pref = await SharedPreferences.getInstance();
          var username = pref.getString('username') ?? '';

          var data = await LoginDatabaseHelper.getUserDetails(username);
          int userId = data['id'] ?? 0;

          loadOrders(userId);
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orders.isEmpty
                ? const Center(
                    child: Text(
                      'No orders found',
                      style: TextStyle(fontSize: 16),
                    ),
                  )
                : ListView.separated(
                    controller: _scrollController,
                    itemCount: orders.length,
                    separatorBuilder: (context, index) => const SpaceHeight(),
                    itemBuilder: (context, index) {
                      final order = orders[index];
                      return Dismissible(
                        key: Key(order.id.toString()), // Unique key
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        onDismissed: (direction) async {
                          var pref = await SharedPreferences.getInstance();
                          var username = pref.getString('username') ?? '';
                          var data = await LoginDatabaseHelper.getUserDetails(
                              username);
                          int userId = data['id'] ?? 0;

                          await _deleteOrder(order, userId);
                        },
                        child: _buildOrderCard(order),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildOrderCard(dynamic order) {
    double totalAmount = order.items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Bounceable(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailsScreen(order: order),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "#${order.id}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      DateFormat('hh:mm a, MMM dd yyyy').format(order.datetime),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "\$${totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    GestureDetector(
                      onTap: () async {
                        if (order.status != "COMPLETED") {
                          await DatabaseHelper()
                              .updateOrderStatus(order.id, "COMPLETED");
                          var pref = await SharedPreferences.getInstance();
                          var username = pref.getString('username') ?? '';
                          var data = await LoginDatabaseHelper.getUserDetails(
                              username);
                          int userId = data['id'] ?? 0;

                          _loadOrder(userId);
                        }
                        if (order.status.toLowerCase() != "completed") {
                          await OrderDatabaseHelper.updateOrderStatus(
                              order.id, "COMPLETED");
                          var pref = await SharedPreferences.getInstance();
                          var username = pref.getString('username') ?? '';
                          var data = await LoginDatabaseHelper.getUserDetails(
                              username);
                          int userId = data['id'] ?? 0;

                          loadOrders(userId);
                        }
                      },
                      child: Chip(
                        label: Text(order.status),
                        backgroundColor:
                            _getStatusColor(order.status).withOpacity(0.2),
                        labelStyle:
                            TextStyle(color: _getStatusColor(order.status)),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(
              color: Colors.grey,
              height: 20,
              thickness: 0.3,
            ),
            SizedBox(
              height: 80,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: order.items.length,
                itemBuilder: (context, itemIndex) {
                  var item = order.items[itemIndex];
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        width: 50,
                        imageUrl: item.image.startsWith("http")
                            ? item.image
                            : "https:${item.image}",
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        ),
                        errorWidget: (context, url, error) => const Icon(
                          Icons.broken_image,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
