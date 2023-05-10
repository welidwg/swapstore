import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/Controllers/OrderController.dart';
import 'package:swap_store/components/empty_page.dart';
import 'package:swap_store/components/order_item.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/OrderModel.dart';

class OrdersPlacedScreen extends StatefulWidget {
  OrdersPlacedScreen({super.key});

  @override
  State<OrdersPlacedScreen> createState() => _OrdersPlacedScreenState();
}

class _OrdersPlacedScreenState extends State<OrdersPlacedScreen> {
  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    OrderController orderController = OrderController();
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: Column(
          children: [
            const Text("Placed orders",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            SizedBox(
              height: 20,
            ),
            FutureBuilder(
                future: orderController.getAllOrders(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text("Error : ${snapshot.error}");
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(
                          color: kPrimaryColor, backgroundColor: Colors.black),
                    );
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.size == 0) {
                      return Center(
                          child: EmptyScreen(text: "You have not placed any orders yet"));
                    } else {
                      return Container(
                        height: 400,
                        child: CupertinoScrollbar(
                          child: ListView(
                              children: snapshot.data?.docs.map<Widget>((e) {
                                    OrderModel order = OrderModel.fromJson(
                                        e.data() as Map<String, dynamic>)
                                      ..id = e.id;
                                    return OrderItem(
                                      order: order,
                                      updateState: updateState,
                                    );
                                  }).toList() ??
                                  []),
                        ),
                      );
                    }
                  } else {
                    return Text("empty");
                  }
                })
          ],
        ),
      ),
    ));
  }
}
