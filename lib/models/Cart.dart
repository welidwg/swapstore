import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swap_store/models/Product.dart';

class Cart {
  final String userID;
  final List<Product> items;

  Cart({required this.userID, required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) => Cart(
        userID: json['userID'],
        items: List<Product>.from(
            json['items'].map((item) => Product.fromJson(item))),
      );

  Map<String, dynamic> toJson() => {
        'userID': userID,
        'items':
            List<Map<String, dynamic>>.from(items.map((item) => item.toMap())),
      };
}
