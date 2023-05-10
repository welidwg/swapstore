import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Product.dart';
import 'package:swap_store/screens/product_screen.dart';

class CartItem extends StatefulWidget {
  late String? title;
  late String? id;
  late String? image;
  late double? price;
  final VoidCallback? onDelete;
  late bool? is_cart = false;
  late Product product;

  CartItem(
      {super.key,
       this.title,
       this.price,
       this.image,
      this.is_cart,
      this.id,
      required this.product,
      this.onDelete});

  @override
  State<CartItem> createState() => _CartItemState();
}

class _CartItemState extends State<CartItem> {
  File? _image;

  File getImage() {
    final directory = Directory.systemTemp.parent;
    final file = File('${directory.path}/app_flutter/uploads/${widget.product.image}');
    return file;
  }

  @override
  Widget build(BuildContext context) {
    ProductController ctrl = ProductController(context: context);

    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
                flex: 2,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Hero(
                    tag: widget.product.title,
                    child: Image.file(
                      getImage(),
                      height: 160,
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            SizedBox(
              width: 15,
            ),
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.product.title.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  SizedBox(
                    height: 9,
                  ),
                  !widget.is_cart!
                      ? widget.product.statue == 1
                          ? Text(
                              "Available",
                              textAlign: TextAlign.center,
                              style: kPriceStyle.copyWith(
                                  color: CupertinoColors.activeGreen,
                                  fontWeight: FontWeight.bold),
                            )
                          : Text(
                              "Sold",
                              textAlign: TextAlign.center,
                              style: kPriceStyle.copyWith(
                                  color: Colors.redAccent,
                                  fontWeight: FontWeight.bold),
                            )
                      : Text(
                          "Price : ${widget.product.price.toStringAsFixed(2)} TND",
                          textAlign: TextAlign.center,
                          style: kPriceStyle.copyWith(
                              color: Colors.black,
                              fontWeight: FontWeight.normal),
                        ),
                  SizedBox(
                    height: 7,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Material(
                          color: CupertinoColors.systemGrey,
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          elevation: 5.0,
                          textStyle: TextStyle(color: Colors.white),
                          child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ProductScreen(
                                      product: widget.product,
                                    ),
                                  ));
                            },
                            child: Icon(
                              Icons.remove_red_eye,
                              color: Colors.white,
                            ),
                          )),
                      Material(
                        color: Colors.pink,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        elevation: 5.0,
                        textStyle: TextStyle(color: Colors.white),
                        child: MaterialButton(
                            padding: EdgeInsets.zero,
                            onPressed: widget.onDelete,
                            child: widget.is_cart! == true
                                ? Icon(
                                    Icons.close,
                                    color: Colors.white,
                                  )
                                : Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )),
                      ),
                    ],
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
