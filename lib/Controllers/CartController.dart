import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/models/Cart.dart';
import 'package:swap_store/models/Product.dart';

class CartController {
  CartController({this.context});

  late BuildContext? context;
  final cartCollection = FirebaseFirestore.instance.collection('carts');
  final currentUserID = FirebaseAuth.instance.currentUser!= null ? FirebaseAuth.instance.currentUser!.uid : null;

  Future<void> emptyCart(String id)async{
    await cartCollection.doc(id).delete();
  }
  Future<bool> checkInCart(Product product) async {
    bool exist = false;
    final cartDoc =
        FirebaseFirestore.instance.collection('carts').doc(currentUserID);
    final cartSnapshot = await cartDoc.get();
    if (cartSnapshot.exists) {
      Cart cart = Cart.fromJson(cartSnapshot.data()!);
      final existingProduct = cart.items.firstWhere(
        (item) => item.title == product.title,
        orElse: () => Product.defaultProd(),
      );
      if (existingProduct.id != "default-id") {
        exist = true;
      }
    }
    return exist;
  }
Future<List<Product>> getCardItems()async{
  final cartDoc = cartCollection.doc(currentUserID);
  final cartSnapshot = await cartDoc.get();
  if(cartSnapshot.data()!=null) {
    final cart = Cart.fromJson(cartSnapshot.data()!);
    return cart.items;
  }
  else{
    return [];
  }



}
  Future addToCart(Product product) async {
    final cartDoc =
        FirebaseFirestore.instance.collection('carts').doc(currentUserID);
    final cartSnapshot = await cartDoc.get();
    if (cartSnapshot.exists) {
      Cart cart = Cart.fromJson(cartSnapshot.data()!);
      final existingProduct = cart.items.firstWhere(
          (item) => item.title == product.title,
          orElse: () => Product.defaultProd());
      if (existingProduct.id != "default-id") {
        cart.items.remove(existingProduct);

      } else {
        cart.items.add(product);
      }
      await cartDoc.set(cart.toJson());
    } else {
      final cart = Cart(userID: currentUserID!, items: [product]);

      await cartDoc.set(cart.toJson());
    }
  }
}
