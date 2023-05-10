import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/components/carousel_item.dart';
import 'package:swap_store/components/productCard.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Product.dart';

class MainScreen extends StatefulWidget {
  final String id = "main_screen";
  final int index = 0;

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    ProductController ctrl = ProductController(context: context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          SizedBox(height: 14),
          CarouselSlider(
              items: ["test1.jpg", "test2.jpg", "test3.jpg"].map((i) {
                return Builder(builder: (BuildContext context) {
                  return CarouselItem(image: "images/$i");
                });
              }).toList(),
              options: CarouselOptions(
                  height: 150.0,
                  aspectRatio: 16/9,
                  viewportFraction: 0.8,
                  enlargeCenterPage: true,

                  autoPlay: true,
                  autoPlayInterval: Duration(seconds: 4),
                  autoPlayCurve: Curves.fastOutSlowIn,
                  initialPage: 2)),



          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Toys",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              width: 200,
              height: 200,
              color: Colors.white,
              child: FutureBuilder<QuerySnapshot>(
                future: ctrl.getToys(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // if (snapshot.connectionState ==
                  //     ConnectionState.waiting) {
                  //   return Text("loading");
                  // }
                  if (snapshot.hasError) {
                    return Text("erroor");
                  }
                  if (snapshot.hasData) {
                    Product product;
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data?.docs.map((data) {
                            double age;
                            try {
                              age = double.parse(data.get("age"));
                            } catch (e) {
                              age = 0.0; // or any default value you want
                            }
                            product = Product(
                                id: data.id,
                                title: data.get("title"),
                                image: data.get("image"),
                                description: data.get("description"),
                                price: data.get("price"),
                                age: double.parse(data.get("age").toString()),
                                condition: data.get("condition"),
                                owner: data.get("owner"),
                                ownerTel: data.get("ownerTel"),
                                type: data.get("type"),
                                statue: data.get("statue"),
                                ownerUid: data.get("ownerUid"));
                            return ProductCard(
                              product: product,
                            );
                          }).toList() ??
                          [
                            Text(
                              "You have no products yet",
                              textAlign: TextAlign.center,
                            )
                          ],
                    );
                  } else {
                    return const Center(
                      child: SizedBox(
                        height: 50,
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                },
              )),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: const Text(
              "Furnitures",
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
              width: 200,
              height: 200,
              color: Colors.white,
              child: FutureBuilder<QuerySnapshot>(
                future: ctrl.getFournitures(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  // if (snapshot.connectionState ==
                  //     ConnectionState.waiting) {
                  //   return Text("loading");
                  // }
                  if (snapshot.hasError) {
                    return Text("erroor");
                  }
                  if (snapshot.hasData) {
                    Product product;
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data?.docs.map((data) {
                            double age;
                            try {
                              age = double.parse(data.get("age"));
                            } catch (e) {
                              print(e);
                              age = 0.0; // or any default value you want
                            }
                            product = Product(
                                id: data.id,
                                title: data.get("title"),
                                image: data.get("image"),
                                description: data.get("description"),
                                price: data.get("price"),
                                age: double.parse(data.get("age").toString()),
                                condition: data.get("condition"),
                                statue: data.get("statue"),
                                owner: data.get("owner"),
                                ownerTel: data.get("ownerTel"),
                                type: data.get("type"),
                                ownerUid: data.get("ownerUid"));
                            return ProductCard(
                              product: product,
                            );
                          }).toList() ??
                          [
                            Text(
                              "You have no products yet",
                              textAlign: TextAlign.center,
                            )
                          ],
                    );
                  } else {
                    return Text("empty");
                  }
                },
              )),
        ],
      ),
    );
  }
}
