// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:ecommerc_app/pages/order_proudct/detail_order_screen.dart';
// import 'package:ecommerc_app/widgets/space_height.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bounceable/flutter_bounceable.dart';
// import 'package:intl/intl.dart';

// import '../../data/network/database/order_helper.dart';

// class MyOrder extends StatefulWidget {
//   const MyOrder({super.key});

//   @override
//   State<MyOrder> createState() => _MyOrderState();
// }

// class _MyOrderState extends State<MyOrder> {
//   List<Order> orders = [];
//   bool isLoading = true;
//   final ScrollController _scrollController = ScrollController();

//   @override
//   void initState() {
//     super.initState();
//     _loadOrders();
//   }

//   Color _getStatusColor(String status) {
//     if (status == "COMPLETED") return Colors.green;
//     if (status == "PROCESS") return Colors.grey;
//     return Colors.black;
//   }

//   Future<void> _loadOrders() async {
//     try {
//       final savedOrders = await DatabaseHelper().getOrders();
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

//   Future<void> _deleteOrder(String id) async {
//     try {
//       await DatabaseHelper().deleteOrder(id);
//       _loadOrders();
//     } catch (e) {
//       print("Error deleting order: $e");
//     }
//   }

//   Future<bool> _confirmDelete(String orderId) async {
//     return await showCupertinoDialog(
//           context: context,
//           builder: (context) => CupertinoAlertDialog(
//             title: const Text("Delete Order"),
//             content: const Text("Are you sure you want to delete this order?"),
//             actions: [
//               CupertinoDialogAction(
//                 child: const Text("Cancel"),
//                 onPressed: () => Navigator.pop(context, false),
//               ),
//               CupertinoDialogAction(
//                 isDestructiveAction: true,
//                 child: const Text("Delete"),
//                 onPressed: () => Navigator.pop(context, true),
//               ),
//             ],
//           ),
//         ) ??
//         false;
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

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         forceMaterialTransparency: true,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         title: const Text("My Orders"),
//       ),
//       body: RefreshIndicator(
//         onRefresh: _loadOrders,
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : orders.isNotEmpty
//                 ? ListView.separated(
//                     controller: _scrollController,
//                     shrinkWrap: true,
//                     separatorBuilder: (context, index) => SpaceHeight(),
//                     itemCount: orders.length,
//                     itemBuilder: (context, index) {
//                       var order = orders[index];
//                       double totalPrice = order.items.fold(
//                           0, (sum, item) => sum + (item.price * item.quantity));

//                       return Dismissible(
//                         key: Key(order.id),
//                         direction: DismissDirection.endToStart,
//                         background: Container(
//                           color: Colors.red,
//                           alignment: Alignment.centerRight,
//                           padding: const EdgeInsets.symmetric(horizontal: 20),
//                           child: const Icon(Icons.delete, color: Colors.white),
//                         ),
//                         confirmDismiss: (direction) async {
//                           bool shouldDelete = await _confirmDelete(order.id);
//                           if (shouldDelete) await _deleteOrder(order.id);
//                           return shouldDelete;
//                         },
//                         child: Bounceable(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               CupertinoPageRoute(
//                                 builder: (context) => OrderDetailsScreen(
//                                   order: order,
//                                 ),
//                               ),
//                             );
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(12),
//                               color: Colors.white,
//                             ),
//                             padding: const EdgeInsets.all(16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Row(
//                                   children: [
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         Text(
//                                           "#${order.id}",
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         Text(
//                                           DateFormat('hh:mm a, MMM dd yyyy')
//                                               .format(order.datetime),
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             fontWeight: FontWeight.bold,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const Spacer(),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.end,
//                                       children: [
//                                         Text(
//                                           "\$${totalPrice.toStringAsFixed(2)}",
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                         const SizedBox(height: 10),
//                                         GestureDetector(
//                                           onTap: () async {
//                                             if (order.status != "COMPLETED") {
//                                               await DatabaseHelper()
//                                                   .updateOrderStatus(
//                                                       order.id, "COMPLETED");
//                                               _loadOrders();
//                                             }
//                                           },
//                                           child: Chip(
//                                             label: Text(order.status),
//                                             backgroundColor:
//                                                 _getStatusColor(order.status)
//                                                     .withOpacity(0.2),
//                                             labelStyle: TextStyle(
//                                                 color: _getStatusColor(
//                                                     order.status)),
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(
//                                   color: Colors.grey,
//                                   height: 20,
//                                   thickness: 0.3,
//                                 ),
//                                 Container(
//                                   height: 80,
//                                   child: ListView.builder(
//                                     scrollDirection: Axis.horizontal,
//                                     itemCount: order.items.length,
//                                     itemBuilder: (context, itemIndex) {
//                                       var item = order.items[itemIndex];
//                                       return Padding(
//                                         padding:
//                                             const EdgeInsets.only(right: 8),
//                                         child: ClipRRect(
//                                           borderRadius:
//                                               BorderRadius.circular(8),
//                                           child: CachedNetworkImage(
//                                             width: 50,
//                                             imageUrl:
//                                                 item.image.startsWith("http")
//                                                     ? item.image
//                                                     : "https:${item.image}",
//                                             placeholder: (context, url) =>
//                                                 const Center(
//                                               child: CircularProgressIndicator(
//                                                 color: Colors.red,
//                                               ),
//                                             ),
//                                             errorWidget:
//                                                 (context, url, error) =>
//                                                     const Icon(
//                                               Icons.broken_image,
//                                               size: 50,
//                                               color: Colors.grey,
//                                             ),
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                   )
//                 : const Center(
//                     child: Text(
//                       "No orders found",
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ),
//       ),
//     );
//   }
// }

import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerc_app/pages/order_proudct/detail_order_screen.dart';
import 'package:ecommerc_app/widgets/space_height.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/network/database/login_helper.dart';
import '../../data/network/database/order_helper.dart';

class MyOrder extends StatefulWidget {
  const MyOrder({super.key});

  @override
  State<MyOrder> createState() => _MyOrderState();
}

class _MyOrderState extends State<MyOrder> {
  List<Order> orders = [];
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

    _loadOrders(userId);
  }

  Color _getStatusColor(String status) {
    if (status == "COMPLETED") return Colors.green;
    if (status == "PROCESS") return Colors.grey;
    return Colors.black;
  }

  Future<void> _loadOrders(int userId) async {
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

  Future<void> _deleteOrder(String id, int userId) async {
    try {
      await DatabaseHelper().deleteOrder(id);
      _loadOrders(userId);
    } catch (e) {
      print("Error deleting order: $e");
    }
  }

  Future<bool> _confirmDelete(String orderId) async {
    return await showCupertinoDialog(
          context: context,
          builder: (context) => CupertinoAlertDialog(
            title: const Text("Delete Order"),
            content: const Text("Are you sure you want to delete this order?"),
            actions: [
              CupertinoDialogAction(
                child: const Text("Cancel"),
                onPressed: () => Navigator.pop(context, false),
              ),
              CupertinoDialogAction(
                isDestructiveAction: true,
                child: const Text("Delete"),
                onPressed: () => Navigator.pop(context, true),
              ),
            ],
          ),
        ) ??
        false;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        centerTitle: true,
        backgroundColor: Colors.white,
        title: const Text("My Orders"),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          var pref = await SharedPreferences.getInstance();
          var username = pref.getString('username') ?? '';

          var data = await LoginDatabaseHelper.getUserDetails(username);
          int userId = data['id'] ?? 0;

          _loadOrders(userId);
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : orders.isNotEmpty
                ? ListView.separated(
                    controller: _scrollController,
                    shrinkWrap: true,
                    separatorBuilder: (context, index) => SpaceHeight(),
                    itemCount: orders.length,
                    itemBuilder: (context, index) {
                      var order = orders[index];
                      double totalPrice = order.items.fold(
                          0, (sum, item) => sum + (item.price * item.quantity));

                      return Dismissible(
                        key: Key(order.id),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          bool shouldDelete = await _confirmDelete(order.id);
                          if (shouldDelete) {
                            var pref = await SharedPreferences.getInstance();
                            var username = pref.getString('username') ?? '';
                            var data = await LoginDatabaseHelper.getUserDetails(
                                username);
                            int userId = data['id'] ?? 0;

                            await _deleteOrder(order.id, userId);
                          }
                          return shouldDelete;
                        },
                        child: Bounceable(
                          onTap: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => OrderDetailsScreen(
                                  order: order,
                                ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          DateFormat('hh:mm a, MMM dd yyyy')
                                              .format(order.datetime),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Spacer(),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "\$${totalPrice.toStringAsFixed(2)}",
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
                                                  .updateOrderStatus(
                                                      order.id, "COMPLETED");
                                              var pref = await SharedPreferences
                                                  .getInstance();
                                              var username =
                                                  pref.getString('username') ??
                                                      '';
                                              var data =
                                                  await LoginDatabaseHelper
                                                      .getUserDetails(username);
                                              int userId = data['id'] ?? 0;

                                              _loadOrders(userId);
                                            }
                                          },
                                          child: Chip(
                                            label: Text(order.status),
                                            backgroundColor:
                                                _getStatusColor(order.status)
                                                    .withOpacity(0.2),
                                            labelStyle: TextStyle(
                                                color: _getStatusColor(
                                                    order.status)),
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
                                Container(
                                  height: 80,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: order.items.length,
                                    itemBuilder: (context, itemIndex) {
                                      var item = order.items[itemIndex];
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(right: 8),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: CachedNetworkImage(
                                            width: 50,
                                            imageUrl:
                                                item.image.startsWith("http")
                                                    ? item.image
                                                    : "https:${item.image}",
                                            placeholder: (context, url) =>
                                                const Center(
                                              child: CircularProgressIndicator(
                                                color: Colors.red,
                                              ),
                                            ),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(
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
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      "No orders found",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
      ),
    );
  }
}
