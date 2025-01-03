import 'package:ecommerc_app/models/product_model.dart';
import 'package:ecommerc_app/routes/routes.dart';
import 'package:ecommerc_app/services/cart_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bounceable/flutter_bounceable.dart';

class MyCart extends StatefulWidget {
  const MyCart({super.key});

  @override
  State<MyCart> createState() => _MyCartState();
}

class _MyCartState extends State<MyCart> {
  late double screenWidth;
  late double screenHeight;
  List<Map<String, dynamic>> cart = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadCart();
  }

  void _loadCart() async {
    final cartService = CartService();
    final savedCart = await cartService.getCart();

    setState(() {
      cart = _mergeDuplicateProducts(savedCart);
    });
  }

  List<Map<String, dynamic>> _mergeDuplicateProducts(
      List<Map<String, dynamic>> savedCart) {
    List<Map<String, dynamic>> mergedCart = [];
    for (var item in savedCart) {
      var product = ProductModel.fromJson(item['product']);
      bool isExisting = false;

      for (var mergedItem in mergedCart) {
        if (mergedItem['product'] == product) {
          mergedItem['quantity'] += item['quantity'];
          isExisting = true;
          break;
        }
      }

      if (!isExisting) {
        mergedCart.add({
          'product': product,
          'quantity': item['quantity'],
          'color': item['color'],
        });
      }
    }
    return mergedCart;
  }

  void _saveCart() {
    final cartService = CartService();
    final serializedCart = cart.map((item) {
      return {
        'product': (item['product'] as ProductModel).toJson(),
        'quantity': item['quantity'],
        'color': item['color'],
      };
    }).toList();
    cartService.saveCart(serializedCart);
  }

  void _removeFromCart(int index) {
    setState(() {
      cart.removeAt(index);
    });
    _saveCart();
  }

  void _decreaseQuantity(int index) {
    setState(() {
      if (cart[index]['quantity'] > 1) {
        cart[index]['quantity']--;
      } else {
        cart.removeAt(index);
      }
    });
    _saveCart();
  }

  void _increaseQuantity(int index) {
    setState(() {
      cart[index]['quantity']++;
    });
    _saveCart();
  }

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Cart"),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.delete,
            ),
          ),
        ],
      ),
      body: cart.isNotEmpty
          ? Column(
              children: [
                const SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.length,
                    separatorBuilder: (context, index) {
                      return const SizedBox(
                        height: 12,
                      );
                    },
                    itemBuilder: (context, index) {
                      var cartItem = cart[index];
                      var product = cartItem['product'] as ProductModel;
                      var quantity = cartItem['quantity'];

                      return Bounceable(
                        onTap: () {
                          Navigator.pushNamed(context, Routes.detailScreen,
                              arguments: product);
                        },
                        child: Container(
                          color: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Row(
                            children: [
                              SizedBox(
                                height: 130,
                                child: Image.network(
                                  "http:${product.image}",
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Center(
                                        child: Icon(Icons.error));
                                  },
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "${product.priceSign} ${product.price}",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                    Text(
                                      "Color: ${cartItem['color']}",
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 100,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            _increaseQuantity(index);
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text("+"),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          width: 25,
                                          height: 25,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.black,
                                              width: 1,
                                            ),
                                          ),
                                          child:
                                              Center(child: Text("$quantity")),
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            _decreaseQuantity(index);
                                          },
                                          child: Container(
                                            width: 25,
                                            height: 25,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                color: Colors.black,
                                                width: 1,
                                              ),
                                            ),
                                            child: const Center(
                                              child: Text("-"),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // IconButton(
                                    //   icon: const Icon(Icons.delete),
                                    //   onPressed: () {
                                    //     _removeFromCart(index);
                                    //   },
                                    // ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            )
          : const Center(
              child: Text(
                "No Product in Cart",
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
