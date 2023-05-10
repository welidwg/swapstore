import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/components/MyActionButton.dart';
import 'package:swap_store/components/MyCard.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Product.dart';
import 'package:url_launcher/url_launcher_string.dart';

class OrderProduct extends StatefulWidget {
  late Product product;

  OrderProduct({required this.product});

  @override
  State<OrderProduct> createState() => _OrderProductState();
}

class _OrderProductState extends State<OrderProduct> {
  ProductController ctrl = ProductController();

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            Expanded(
                flex: 1,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.file(ctrl.getImage(widget.product.image)))),
            Expanded(
                flex: 2,
                child: Column(
                  children: [
                    Text(
                      widget.product.title,
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    GestureDetector(
                      onTap:  () async {
                        await launchUrlString(
                            "tel:${widget.product.orderedBy!.tel}");
                      },
                      child: Card(
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        color: Colors.white70,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                        "ordered by : ${widget.product.orderedBy!.name}",
                        style: kPriceStyle.copyWith(fontSize: 17),
                      ),
                          )),
                    ),

                  ],
                ))
          ],
        ),
      ),
    );
  }
}
