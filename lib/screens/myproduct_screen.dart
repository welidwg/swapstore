import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/Controllers/UserController.dart';
import 'package:swap_store/components/Input.dart';
import 'package:swap_store/components/cart_item.dart';
import 'package:swap_store/constants.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/models/Product.dart';
import 'package:swap_store/models/Utilisateur.dart';
import 'package:swap_store/screens/addproduct_screen.dart';

class MyProductsScreen extends StatefulWidget {
  const MyProductsScreen({Key? key}) : super(key: key);

  @override
  State<MyProductsScreen> createState() => _MyProductsScreenState();
}

class _MyProductsScreenState extends State<MyProductsScreen> {
  late List<Product>? prods = null;
  late Utilisateur? user = null;
  UserController ctrl = UserController();
  ProductController productCtrl = ProductController();

  Future setData() async {
    return await ctrl.getUser();
  }

  Timer? _timer;

  void _onTimerTick(Timer timer) {
    setState(() {});
  }

  @override
  void initState() {
    setData().then((value) {
      setState(() {
        user = value;
      });
    });

    super.initState();
    _timer = Timer.periodic(Duration(seconds: 10), _onTimerTick);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReference productsCollection =
        FirebaseFirestore.instance.collection("products");
    Future<QuerySnapshot> fetchProducts() async {
      final snapshot = await productsCollection
          .where("ownerUid", isEqualTo: user!.uid)
          .get();
      return snapshot;
    }

    void _deleteProduct(String productId, String? image) async {
      final directory = Directory.systemTemp.parent;
      final file = File('${directory.path}/app_flutter/uploads/$image');
      file.delete();
      final productController = ProductController(context: context);
      await productController.deleteProd(productId);
      setState(() {
      });
    }

    final scrollController = ScrollController();

    if (user == null) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Your products",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(),
                  ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(0),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () {
                        showMaterialModalBottomSheet(
                            context: context,
                            expand: false,
                            builder: (context) => AddProductScreen());
                      },
                      child: const Icon(
                        Icons.add,
                        size: 30,
                        color: kPrimaryColor,
                      ))
                ],
              ),
            ),
            Card(
              elevation: 0,
              color: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 11),
                child: SizedBox(
                  height: 530,
                  child: FutureBuilder<QuerySnapshot>(
                    future: fetchProducts(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      // if (snapshot.connectionState ==
                      //     ConnectionState.waiting) {
                      //   return Text("loading");
                      // }
                      if (snapshot.hasError) {
                        return Text("erroor");
                      }

                      if (snapshot.hasData) {
                        if (snapshot.data!.size == 0) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 260,
                                height: 270,
                                child: Lottie.network(
                                    'https://assets1.lottiefiles.com/private_files/lf30_e3pteeho.json',
                                    repeat: true,
                                    frameRate: FrameRate(30),
                                    fit: BoxFit.contain),
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              const Text(
                                "You have no products yet",
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              )
                            ],
                          );
                        } else {
                          return CupertinoScrollbar(
                            child: ListView(
                              children: snapshot.data?.docs.map((data) {
                                    Product prod = Product(
                                      title: data.get("title"),
                                      image: data.get("image"),
                                      description: data.get("description"),
                                      price: data.get("price"),
                                      age: double.parse(data.get("age").toString()),
                                      condition: data.get("condition"),
                                      owner: data.get("owner"),
                                      ownerTel: data.get("ownerTel"),
                                      ownerUid: data.get("ownerUid"),
                                      type: data.get("type"),
                                      statue: data.get("statue"),
                                    );
                                    return CartItem(
                                      id: data.id,
                                      title: data.get("title"),
                                      price: data.get("price"),
                                      image: data.get("image"),
                                      is_cart: false,
                                      product: prod,
                                      onDelete: () => _deleteProduct(
                                          data.id, data.get("image")),
                                    );
                                  }).toList() ??
                                  [
                                    Text(
                                      "You have no products yet",
                                      textAlign: TextAlign.center,
                                    )
                                  ],
                            ),
                          );
                        }
                      } else {
                        return Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }
  }
}
