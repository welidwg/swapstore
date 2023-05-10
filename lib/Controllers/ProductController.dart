import 'dart:collection';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:swap_store/models/Product.dart';

class ProductController {
  final CollectionReference productsCollection =
      FirebaseFirestore.instance.collection("products");
  late BuildContext? context;


  ProductController({this.context});
  Future updateProductStatus(String id, int status) async {
    final snapshot = productsCollection.doc(id);
    await snapshot.update({"statue":status});
  }
  Future updateProduct(String id, Product prod) async {
    final snapshot = productsCollection.doc(id);
    await snapshot.update(prod.toMap());
  }

  Future<Product> getProductById(String id) async {
    final snapshot = await productsCollection.doc(id).get();
    if (snapshot.exists) {
      final productData = snapshot.data() as Map<String, dynamic>;
      final Product product = Product.fromJson(productData)..id = snapshot.id;
      return product;
    } else {
      return Product.defaultProd();
    }
  }

  Future<QuerySnapshot> getUserProducts() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final snapshot = await productsCollection
        .where("ownerUid", isEqualTo: userId)
        .where("statue", isEqualTo: 1)
        .get();
    return snapshot;
  }

  Future<void> deleteProd(String id) async {
    final doc = productsCollection.doc(id);
    await doc.delete().then((value) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(const SnackBar(content: Text("Product deleted")));
    }).catchError((error) {
      ScaffoldMessenger.of(context!)
          .showSnackBar(SnackBar(content: Text('error : $error')));
    });
  }
  Future<List<Product>> searchProducts(String query) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('products')
        .where('title', isGreaterThanOrEqualTo: query)
        .where('title', isLessThanOrEqualTo: query + '\uf8ff')
        .get();

    return snapshot.docs.map((doc) => Product.fromJson(doc.data())).toList();
  }
  Future<QuerySnapshot> getToys() async {
    final snapshot = await productsCollection.where("type", isEqualTo: 1).where("statue",isEqualTo: 1).get();
    return snapshot;
  }

  Future<QuerySnapshot> getFournitures() async {
    final snapshot = await productsCollection.where("type", isEqualTo: 0).where("statue",isEqualTo: 1).get();
    return snapshot;
  }

  File getImage(String image) {
    final directory = Directory.systemTemp.parent;
    final file = File('${directory.path}/app_flutter/uploads/$image');
    return file;
  }

  Future<void> setAvailability(Product product, int statue) async {
    print("test");
    final snapshot =
        await productsCollection.where("title", isEqualTo: product.title).get();
    final docReference = snapshot.docs[0].reference;

    await docReference.update({
      "statue": statue,
    });
  }

  void CreateProduct(Product product) async {
    Map<String, dynamic> data = product.toMap();
    try {
      await productsCollection.add(data).then((value) {
        SnackBar(content: Text("Product succefully added"));
      }).catchError((error) {
        SnackBar(content: Text("Something went wrong : $error"));
      });
    } catch (e, trace) {
      print("error : ${e}");
    }
  }
}
