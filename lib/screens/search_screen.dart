import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/components/empty_page.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Product.dart';
import 'package:swap_store/screens/product_screen.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late String? searchValue = "";
  ProductController ctrl = ProductController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(
                  child: TextField(
                onChanged: (String? value) {
                  setState(() {
                    searchValue = value;
                  });
                },
                style: TextStyle(color: Colors.black),
                cursorColor: Colors.black,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  hintText: "Search...",
                  hintStyle: TextStyle(color: Colors.black),
                  filled: true,
                  labelStyle: TextStyle(color: Colors.black),
                  fillColor: kPrimaryColor.withOpacity(0.2),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: kPrimaryColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              )),
            ],
          ),
        ),
        StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("products")
              .where('title', isGreaterThanOrEqualTo: searchValue)
              .where('title', isLessThanOrEqualTo: '${searchValue!}\uf8ff')
              .where("statue", isEqualTo: 1)
              .limit(4)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasData) {
              if (snapshot.data!.size == 0) {
                return EmptyScreen(text: "No results");
              } else {
                return Container(
                  height: MediaQuery.of(context).size.height - 150,
                  child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = snapshot.data!.docs[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ProductScreen(
                                    product: Product.fromJson(
                                        data.data() as Map<String, dynamic>)
                                      ..id = data.id,
                                  ),
                                ));
                          },
                          child: Card(
                            child: Row(
                              children: <Widget>[
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(15),
                                  child: Hero(
                                    tag: data['title'],
                                    child: Image.file(
                                      ctrl.getImage(data['image']),
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 25,
                                ),
                                Text(
                                  data['title'],
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                );
              }
            } else {
              return Text("no no");
            }
          },
        )
      ],
    ));
  }
}
