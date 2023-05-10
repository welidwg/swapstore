import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swap_store/Controllers/CartController.dart';
import 'package:swap_store/Controllers/OrderController.dart';
import 'package:swap_store/components/MyActionButton.dart';
import 'package:swap_store/components/cart_item.dart';
import 'package:swap_store/components/empty_page.dart';
import 'package:swap_store/components/productCard.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/OrderModel.dart';
import 'package:swap_store/models/Product.dart';

class CartScreen extends StatefulWidget {
  final String id = "card_screen";

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  CartController ctrl = CartController();
  bool _isDataLoaded = false;
  late double? total;

  late List<Product> cart_items = [];
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  Future fetchData() async {
    double tempTotal = 0;
    List<Product> list = await ctrl.getCardItems();
    // list.map((e) {
    //
    // });
    for (var i in list) {
      tempTotal += i.price;
    }

    setState(() {
      cart_items = list;
      total = tempTotal;
    });

    return list;
  }

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    fetchData();
    setState(() {});
  }

  void _deleteFromCart(Product product) async {
    CartController ctrl1 = CartController();
    ctrl1.addToCart(product);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (cart_items.length == 0) {
      return EmptyScreen(text: "Your cart is empty");
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Card(
                color: Colors.white,
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  child: SizedBox(
                      height: 460,
                      child: FutureBuilder(
                        future: fetchData(),
                        builder: (builder, snapshot) {
                          if (snapshot.hasError) {
                            return Text(
                                "something went wrong ${snapshot.stackTrace}");
                          }
                          if (snapshot.hasData) {
                            return ListView(
                              children: snapshot.data?.map<Widget>((data) {
                                    return CartItem(
                                      id: data.id,
                                      title: data.title,
                                      price: data.price,
                                      image: data.image,
                                      product: data,
                                      onDelete: () => _deleteFromCart(data),
                                      is_cart: true,
                                    );
                                  }).toList() ??
                                  [
                                    Text(
                                      "Your cart is empty",
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                            );
                          } else {
                            return Text("Your cart is empty");
                          }
                        },
                      )),
                ),
              ),
              Card(
                color: Colors.white,
                elevation: 0,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total :",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 22),
                        ),
                        total == null
                            ? Text("loading")
                            : Text("${total!.toStringAsFixed(2)} TND"),
                      ],
                    ),
                    SizedBox(
                      height: 14,
                    ),
                    MyActionButton(
                      label: "Checkout",
                      color: CupertinoColors.activeBlue,
                      icon: Icons.shopping_cart_checkout_outlined,
                      onPressed: () async {

                        OrderController ctrlOrder = OrderController();
                        OrderModel order = OrderModel(
                            created_at: DateTime.now(),
                            userUid: userId,
                            items: cart_items,
                            total: total);
                        await ctrlOrder.createOrder(order);

                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text("Your order have been placed")));

                      },
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
