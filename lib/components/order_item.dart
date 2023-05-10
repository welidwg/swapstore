import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/Controllers/OrderController.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/components/MyActionButton.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/OrderModel.dart';
import 'package:intl/intl.dart';
import 'package:swap_store/screens/product_screen.dart';

class OrderItem extends StatefulWidget {
  late OrderModel order;
  late VoidCallback? updateState;

  OrderItem({super.key, required this.order, this.updateState});

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  ProductController productController = ProductController();
  OrderController orderController = OrderController();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${DateFormat("yyyy-MM-dd HH:mm").format(widget.order.created_at)}",
                  style: TextStyle(fontSize: 13),
                ),
                SizedBox(
                  height: 10,
                ),
                MyActionButton(
                  label: "Cancel",
                  color: Colors.pink,
                  onPressed: () async {
                    try {
                      String? id = widget.order.id;
                      await orderController.deleteOrder(id!);
                      widget.updateState!();
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Order cancelled")));
                    } catch (e) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(SnackBar(content: Text("Error $e")));
                    }
                  },
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: widget.order.items.map((product) {
                      return Card(
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                    product: product,
                                  ),
                                ));
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Hero(
                                    tag: product.title,
                                    child: Image.file(
                                      productController.getImage(product.image),
                                      height: 30,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 6,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      product.title,
                                      style: TextStyle(fontSize: 15),
                                    ),
                                    Text(
                                      "owner : ${product.owner}",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "price : ${product.price.toStringAsFixed(2)} TND",
                                      style: kPriceStyle.copyWith(fontSize: 12),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList()),
                Text(
                  "Total : ${widget.order.total} TND",
                  style: kPriceStyle,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
