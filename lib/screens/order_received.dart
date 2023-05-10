import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/Controllers/OrderController.dart';
import 'package:swap_store/components/MyActionButton.dart';
import 'package:swap_store/components/cart_item.dart';
import 'package:swap_store/components/empty_page.dart';
import 'package:swap_store/components/order_item.dart';
import 'package:swap_store/components/order_product.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/OrderModel.dart';
import 'package:swap_store/models/Product.dart';

class OrderReceived extends StatefulWidget {
  OrderReceived({super.key});

  @override
  State<OrderReceived> createState() => _OrderReceivedState();
}

class _OrderReceivedState extends State<OrderReceived> {
  OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            const Text("Received orders",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: orderController.getProducts(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error : ${snapshot.error}");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child:  CircularProgressIndicator(color: kPrimaryColor,backgroundColor: Colors.black),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Center(
                          child: EmptyScreen(text: "You have not received any orders yet"));
                    } else {
                      return Container(
                        height: 400,
                        child: CupertinoScrollbar(
                          child: ListView(
                              children: snapshot.data?.map<Widget>((e) {
                                    return OrderProduct(product: e);
                                  }).toList() ??
                                  []),
                        ),
                      );
                    }
                  } else {
                    return Text("empty");
                  }
                }),
          ],
        ),
      ),
    ));
  }
}
