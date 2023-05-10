import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:swap_store/Controllers/ExchangesController.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/Controllers/UserController.dart';
import 'package:swap_store/components/MyActionButton.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Exchange.dart';
import 'package:swap_store/models/Product.dart';
import 'package:swap_store/models/Utilisateur.dart';
import 'package:swap_store/screens/product_screen.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ExchangeItem extends StatefulWidget {
  late Exchange exchange;
  late Product? mainProduct = null;
  late Product? exchangeProduct;
  late Utilisateur? requester;
  late String currentUserUid;
  late VoidCallback? updateState;

  ExchangeItem({super.key, required this.exchange, this.updateState});

  @override
  State<ExchangeItem> createState() => _ExchangeItemState();
}

class _ExchangeItemState extends State<ExchangeItem> {
  ProductController productController = ProductController();
  ExchangesController exchangesController = ExchangesController();
  UserController userController = UserController();

  void setProducts() async {
    final temp1 =
        await productController.getProductById(widget.exchange.ownerProductID);
    final temp2 = await productController
        .getProductById(widget.exchange.requesterProductID);

    final temp3 =
        await userController.getUserById(widget.exchange.requesterUid);
    setState(() {
      widget.mainProduct = temp1;
      widget.exchangeProduct = temp2;
      widget.requester = temp3;
      widget.currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setProducts();
  }

  @override
  Widget build(BuildContext context) {
    String statusString = "Pending";
    Color statusColor = Colors.orangeAccent;
    switch (widget.exchange.status) {
      case 1:
        statusString = "Accepted";
        statusColor = Colors.greenAccent;
        break;
      case 2:
        statusString = "Denied";
        statusColor = Colors.redAccent;
        break;
      default:
        statusColor = Colors.orangeAccent;
        statusString = "Pending";
    }
    if (widget.mainProduct == null) {
      return const Center(
        child: SizedBox(
          width: 40,
          child: CircularProgressIndicator(color: kPrimaryColor),
        ),
      );
    } else {
      return Card(
        color: Colors.white.withOpacity(0.8),
        elevation: 3,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            productController
                                .getImage(widget.mainProduct!.image),
                            fit: BoxFit.cover,
                          ),
                        ),
                        Text(
                          "${widget.mainProduct!.title} (${widget.mainProduct!.price.toStringAsFixed(2)} dt)",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontWeight: FontWeight.normal, fontSize: 14),
                        ),
                        Text(
                          statusString,
                          style: TextStyle(color: statusColor),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 7,
                ),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await launchUrlString(
                                      "tel:${widget.requester!.tel}");
                                },
                                child: Text(
                                  "Proposed by : ${widget.requester!.uid == widget.currentUserUid ? "You" : widget.requester!.name}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: 14,
                                      color: Colors.blue),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            Icon(
                              Icons.phone_enabled,
                              size: 16,
                              color: Colors.blue,
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Exchange with : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 14),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ProductScreen(
                                        product: widget.exchangeProduct!,
                                      ),
                                    ));
                              },
                              child: Card(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    textBaseline: TextBaseline.alphabetic,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Hero(
                                            tag:
                                                "${widget.exchangeProduct!.title}",
                                            child: Image.file(
                                              productController.getImage(widget
                                                  .exchangeProduct!.image),
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 3,
                                      ),
                                      Expanded(
                                          flex: 3,
                                          child: Text(
                                              "${widget.exchangeProduct!.title}  (${widget.exchangeProduct!.price.toStringAsFixed(2)} dt)",
                                              style: TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black45)))
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: widget.exchange.status == 0
                                  ? widget.exchange.requesterUid ==
                                          widget.currentUserUid
                                      ? Container()
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            MyActionButton(
                                              label: "",
                                              icon: Icons.check,
                                              color:
                                                  CupertinoColors.activeGreen,
                                              onPressed: () async {
                                                String? id = widget.exchange.id;
                                                await exchangesController
                                                    .manageStatus(1, id!);
                                                widget.updateState!();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                        content: Text(
                                                            "Proposal Accepted !")));
                                              },
                                            ),
                                            SizedBox(
                                              width: 7,
                                            ),
                                            MyActionButton(
                                              label: "",
                                              icon: Icons.close,
                                              color:
                                              CupertinoColors.systemPink,
                                              onPressed: () async {
                                                String? id = widget.exchange.id;
                                                await exchangesController
                                                    .manageStatus(2, id!);
                                                widget.updateState!();
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(SnackBar(
                                                    content: Text(
                                                        "Proposal rejected !")));
                                              },
                                            ),
                                          ],
                                        )
                                  : Container(),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ],
        ),
      );
    }
  }
}
