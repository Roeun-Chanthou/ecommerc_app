import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerc_app/widgets/space_height.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';
import 'package:intl/intl.dart';

import '../../data/network/helpers/order_helper2.dart';

class MyOrder2 extends StatefulWidget {
  const MyOrder2({super.key});

  @override
  State<MyOrder2> createState() => _MyOrder2State();
}

class _MyOrder2State extends State<MyOrder2> {
  List<OrderSingle> orders = [];
  bool isLoading = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    try {
      setState(() {
        isLoading = true;
      });

      final loadedOrders = await OrderDatabaseHelper.getOrders();

      if (mounted) {
        setState(() {
          orders = loadedOrders.reversed.toList();
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
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading orders: ${e.toString()}')),
        );
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

  Future<void> _deleteOrder(String id) async {
    try {
      await OrderDatabaseHelper.deleteOrder(id);
      loadOrders();
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

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'process':
        return Colors.amber;
      case 'completed':
        return Colors.green;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        forceMaterialTransparency: true,
        backgroundColor: Colors.white,
        title: const Text('My Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: loadOrders,
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
                      return _buildOrderCard(order);
                    },
                  ),
      ),
    );
  }

  Widget _buildOrderCard(OrderSingle order) {
    double totalAmount = order.items.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

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
        if (shouldDelete) await _deleteOrder(order.id);
        return shouldDelete;
      },
      child: Bounceable(
        onTap: () {
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => OrderDetailScreenSingle(
          //       order: order,
          //     ),
          //   ),
          // );
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
                          if (order.status.toLowerCase() != "completed") {
                            await OrderDatabaseHelper.updateOrderStatus(
                                order.id, "COMPLETED");
                            loadOrders();
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
      ),
    );
  }
}
