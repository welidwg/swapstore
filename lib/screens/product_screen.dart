import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:swap_store/Controllers/CartController.dart';
import 'package:swap_store/Controllers/ExchangesController.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/components/MyActionButton.dart';
import 'package:swap_store/components/MyCard.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Cart.dart';
import 'package:swap_store/models/Product.dart';
import 'package:swap_store/screens/exchange_screen.dart';
import 'package:swap_store/screens/fullscreen_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ProductScreen extends StatefulWidget {
  final String id = "product_screen";
  late Product? product;

  ProductScreen({this.product});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  late DocumentReference productRef;
  late bool exist;
  late bool isExchanged = false;
  final userId = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser!.uid
      : null;
  String cartButtonText = "Add to Cart";
  IconData cartIcon = Icons.add_shopping_cart_rounded;
  CartController cartCtrl = CartController();
  ExchangesController exCtrl = ExchangesController();

  void updateState() {
    setState(() {
      isExchanged = true;
    });
  }

  Future<bool> check() async {
    if (userId != null) {
      bool check = await cartCtrl.checkInCart(widget.product!);
      bool checkEx = await exCtrl.checkExchange(userId!, widget.product!.id);
      if (check) {
        setState(() {
          cartButtonText = "Remove from Cart";
          cartIcon = Icons.remove_shopping_cart;
        });
      } else {
        setState(() {
          cartButtonText = "Add to Cart";
          cartIcon = Icons.add_shopping_cart_rounded;
        });
      }

      isExchanged = checkEx;

      return check;
    }
    return false;
  }

  late final months;
  late final duration;
  late final years;
  late final ageString;

  @override
  void initState() {
    // TODO: implement initState
    if (userId != null) {
      check();
    }
    final age = widget.product!.age; // 1 year and 5 months
    setState(() {
      years = age.truncate();
      months = ((age - years) * 12).round(); // Calculate the remaining months
      duration = Duration(days: (365 * years + 30 * months).round());
      ageString =
          '${duration.inDays ~/ 365} years, ${duration.inDays % 365 ~/ 30} months';
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser != null
        ? FirebaseAuth.instance.currentUser!.uid
        : null;
    ProductController ctrl = new ProductController(context: context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Expanded(
            flex: 1,
            child: Stack(children: [
              Hero(
                tag: "${widget.product!.title}",
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: Duration(milliseconds: 500),
                        pageBuilder: (_, __, ___) => FullScreenImageScreen(
                            image: widget.product!.image,
                            tag: widget.product!.title),
                      ),
                    );
                  },
                  child: Image.file(
                    width: double.infinity,
                    ctrl.getImage(widget.product!.image),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 16,
                right: 8,
                child: FloatingActionButton(
                  mini: true,
                  backgroundColor: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                    // do something when button is pressed
                  },
                  child: Icon(Icons.close,
                      color: CupertinoColors.darkBackgroundGray),
                ),
              ),
            ]),
          ),
          Expanded(
            flex: 2,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.7),
                    blurRadius: 5.0,
                    spreadRadius: 1.0,
                  ),
                ],
              ),
              child: ListView(
                children: [
                  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              "${widget.product?.title.toUpperCase()} ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 2),
                            ),
                          ),
                          Text(
                            "${widget.product?.description}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.normal,
                              color: Colors.black45,
                            ),
                          ),
                        ],
                      ),// title and desc
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            MyCard(title: "Price", value: "${widget.product!.price.toStringAsFixed(2)} TND"),
                            SizedBox(
                              height: 15,
                            ),
                            MyCard(title: "AGE", value: ageString),
                            SizedBox(
                              height: 15,
                            ),
                            MyCard(title: "Condition", value: widget.product!.condition.toString()),

                            SizedBox(
                              height: 15,
                            ),
                            MyCard(title: "Availability", value: widget.product!.statue == 1 ? "Available" : "Unavailable"),


                            SizedBox(
                              height: 15,
                            ),
                            MyCard(title: "Owner", value: widget.product!.ownerUid == userId ? "You" : widget.product!.owner),

                          ],
                        ),
                      ),//product details
                      Column(
                        children: [
                          SizedBox(height: 7,),
                          userId != widget.product!.ownerUid &&
                              widget.product!.statue != 0
                              ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: MyActionButton(
                                  label: "",
                                  color: CupertinoColors.systemGreen,
                                  icon: Icons.phone_enabled,
                                  onPressed: () async {
                                    await launchUrlString(
                                        "tel:${widget.product?.ownerTel}");
                                  },
                                ),
                              ),
                              isExchanged
                                  ? Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: MyActionButton(
                                  label: "",
                                  color: CupertinoColors.activeBlue
                                      .withOpacity(0.7),
                                  icon: Icons.close,
                                  onPressed: () async {
                                    try {
                                      await exCtrl.deleteExchange(
                                          userId!, widget.product!.id);
                                      setState(() {
                                        isExchanged = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text(
                                              "Proposal withdrawed")));
                                    } catch (e) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text(e.toString())));
                                    }
                                  },
                                ),
                              )
                                  : Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: MyActionButton(
                                  label: "",
                                  color: CupertinoColors.activeBlue,
                                  icon: Icons.compare_arrows,
                                  onPressed: () {
                                    if (userId == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                          content: Text(
                                              "You need to log in first!")));
                                    } else {
                                      showMaterialModalBottomSheet(
                                          context: context,
                                          expand: false,
                                          builder: (context) {
                                            return Container(
                                              padding:
                                              const EdgeInsets.all(20),
                                              height: 250,
                                              color: Colors.white,
                                              child: ExchangeScreen(
                                                prodId: widget.product!.id,
                                                ownerId: widget
                                                    .product!.ownerUid,
                                                updateState: updateState,
                                              ),
                                            );
                                          });
                                    }
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: MyActionButton(
                                  label: "",
                                  color: CupertinoColors.activeBlue,
                                  icon: cartIcon,
                                  onPressed: () async {
                                    if (userId != null) {
                                      await cartCtrl.addToCart(widget.product!);

                                      bool checkk = await cartCtrl
                                          .checkInCart(widget.product!);
                                      setState(() {
                                        exist = checkk;
                                      });
                                      if (exist) {
                                        ScaffoldMessenger.of(context!)
                                            .showSnackBar( SnackBar(
                                          content: Text("Added to cart }"),
                                          duration: Duration(seconds: 2),
                                        ));
                                        setState(() {
                                          cartButtonText = "Remove from cart";
                                          cartIcon = Icons.remove_shopping_cart;
                                        });
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Text("Removed from cart  "),
                                          duration: Duration(seconds: 2),
                                        ));
                                        setState(() {
                                          cartButtonText = "Add to cart";
                                          cartIcon = Icons.add_shopping_cart_rounded;
                                        });
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "You need to log in first!")));
                                    }
                                  },
                                ),
                              ),
                            ],
                          )
                              : widget.product!.ownerUid == userId
                              ? widget.product!.statue == 0
                              ? Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: MyActionButton(
                              label: "Make it available",
                              color: CupertinoColors.activeBlue,
                              icon: Icons.offline_bolt_outlined,
                              onPressed: () {
                                ctrl.setAvailability(widget.product!, 1);
                                setState(() {
                                  widget.product!.statue = 1;
                                });
                              },
                            ),
                          )
                              : Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: MyActionButton(
                              label: "Make it unavailable",
                              color: CupertinoColors.activeBlue,
                              icon: Icons.offline_bolt,
                              onPressed: () {
                                ctrl.setAvailability(widget.product!, 0);
                                setState(() {
                                  widget.product!.statue = 0;
                                });
                              },
                            ),
                          )
                              : Container()
                        ],
                      )
                    ],
                  ),




                ],
              ),
            ),
          )
        ]),
      ),
    );
  }
}
