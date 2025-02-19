// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../../data/network/helpers/order_helper2.dart';

// class OrderDetailScreenSingle extends StatefulWidget {
//   final OrderSingle order;

//   const OrderDetailScreenSingle({Key? key, required this.order})
//       : super(key: key);

//   @override
//   State<OrderDetailScreenSingle> createState() =>
//       _OrderDetailScreenSingleState();
// }

// class _OrderDetailScreenSingleState extends State<OrderDetailScreenSingle> {
//   late OrderSingle _order;

//   @override
//   void initState() {
//     super.initState();
//     _order = widget.order;
//   }

//   Future<void> _updateOrderStatus(String newStatus) async {
//     try {
//       await OrderDatabaseHelper.updateOrderStatus(_order.id, newStatus);
//       setState(() {
//         _order = OrderSingle(
//           id: _order.id,
//           datetime: _order.datetime,
//           status: newStatus,
//           items: _order.items,
//         );
//       });

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Order marked as $newStatus')),
//         );
//       }
//     } catch (e) {
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Error updating order: $e')),
//         );
//       }
//     }
//   }

//   Color _getStatusColor(String status) {
//     switch (status.toLowerCase()) {
//       case 'process':
//         return Colors.amber;
//       case 'completed':
//         return Colors.green;
//       default:
//         return Colors.black;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     double totalAmount = _order.items.fold(
//       0,
//       (sum, item) => sum + (item.price * item.quantity),
//     );

//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         forceMaterialTransparency: true,
//         backgroundColor: Colors.white,
//         title: Text('Detail Order'),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildOrderSummaryCard(),
//               const SizedBox(height: 16),
//               // _buildOrderStatusCard(),
//               // const SizedBox(height: 16),
//               _buildOrderItemsCard(),
//               const SizedBox(height: 16),
//               _buildPricingSummaryCard(totalAmount),
//               const SizedBox(height: 24),
//               _buildActionButton(),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderSummaryCard() {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Order Summary',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Order Date',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       DateFormat('MMM dd, yyyy').format(_order.datetime),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Text(
//                       'Order Time',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       DateFormat('hh:mm a').format(_order.datetime),
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//             const SizedBox(height: 16),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'Status',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Chip(
//                       label: Text(_order.status),
//                       backgroundColor:
//                           _getStatusColor(_order.status).withOpacity(0.2),
//                       labelStyle:
//                           TextStyle(color: _getStatusColor(_order.status)),
//                       padding: EdgeInsets.zero,
//                       materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
//                     ),
//                   ],
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     const Text(
//                       'Items',
//                       style: TextStyle(
//                         color: Colors.grey,
//                         fontSize: 14,
//                       ),
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       '${_order.items.length} items',
//                       style: const TextStyle(
//                         fontWeight: FontWeight.w500,
//                         fontSize: 16,
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderItemsCard() {
//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Order Items',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 16),
//             ListView.separated(
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemCount: _order.items.length,
//               separatorBuilder: (context, index) => Divider(
//                 color: Colors.grey.shade200,
//                 height: 32,
//               ),
//               itemBuilder: (context, index) {
//                 final item = _order.items[index];
//                 return _buildOrderItem(item);
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderItem(OrderItem item) {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: CachedNetworkImage(
//             width: 80,
//             height: 80,
//             fit: BoxFit.cover,
//             imageUrl: item.image.startsWith("http")
//                 ? item.image
//                 : "https:${item.image}",
//             placeholder: (context, url) => Container(
//               width: 80,
//               height: 80,
//               color: Colors.grey.shade200,
//               child: const Center(
//                 child: CircularProgressIndicator(
//                   color: Colors.red,
//                   strokeWidth: 2,
//                 ),
//               ),
//             ),
//             errorWidget: (context, url, error) => Container(
//               width: 80,
//               height: 80,
//               color: Colors.grey.shade200,
//               child: const Icon(
//                 Icons.broken_image,
//                 color: Colors.grey,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 item.name,
//                 style: const TextStyle(
//                   fontWeight: FontWeight.w500,
//                   fontSize: 16,
//                 ),
//                 maxLines: 2,
//                 overflow: TextOverflow.ellipsis,
//               ),
//               const SizedBox(height: 8),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     '\$${item.price.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       color: Colors.grey.shade700,
//                       fontSize: 14,
//                     ),
//                   ),
//                   Text(
//                     'x${item.quantity}',
//                     style: TextStyle(
//                       color: Colors.grey.shade700,
//                       fontSize: 14,
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 8),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   '\$${(item.price * item.quantity).toStringAsFixed(2)}',
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildPricingSummaryCard(double totalAmount) {
//     // Example values - in real app these would come from order data
//     final double subtotal = totalAmount * 0.9; // 90% of total
//     final double shipping = 5.99;
//     final double tax = totalAmount * 0.1; // 10% tax

//     return Card(
//       elevation: 0,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(12),
//         side: BorderSide(color: Colors.grey.shade200),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const Text(
//               'Price Details',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 20),
//             _buildPriceRow('Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
//             const SizedBox(height: 12),
//             _buildPriceRow('Shipping', '\$${shipping.toStringAsFixed(2)}'),
//             const SizedBox(height: 12),
//             _buildPriceRow('Tax', '\$${tax.toStringAsFixed(2)}'),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 16),
//               child: Divider(color: Colors.grey.shade300),
//             ),
//             _buildPriceRow(
//               'Total',
//               '\$${totalAmount.toStringAsFixed(2)}',
//               isBold: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPriceRow(String label, String amount, {bool isBold = false}) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         Text(
//           label,
//           style: TextStyle(
//             fontSize: isBold ? 18 : 16,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             color: isBold ? Colors.black : Colors.grey.shade700,
//           ),
//         ),
//         Text(
//           amount,
//           style: TextStyle(
//             fontSize: isBold ? 18 : 16,
//             fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
//             color: isBold ? Colors.black : Colors.grey.shade700,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildActionButton() {
//     if (_order.status.toLowerCase() == 'completed') {
//       return ElevatedButton(
//         onPressed: () {
//           // Implement reorder functionality
//           Navigator.pop(context);
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.grey.shade200,
//           foregroundColor: Colors.black,
//           minimumSize: const Size(double.infinity, 50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: const Text(
//           'Back to Orders',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       );
//     } else if (_order.status.toLowerCase() == 'process') {
//       return ElevatedButton(
//         onPressed: () => _updateOrderStatus('COMPLETED'),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.green,
//           minimumSize: const Size(double.infinity, 50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: const Text(
//           'Mark as Completed',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       );
//     } else {
//       return ElevatedButton(
//         onPressed: () => _updateOrderStatus('PROCESS'),
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.amber,
//           minimumSize: const Size(double.infinity, 50),
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//           ),
//         ),
//         child: const Text(
//           'Start Processing',
//           style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//         ),
//       );
//     }
//   }
// }
