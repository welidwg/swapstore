import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swap_store/models/Product.dart';

class OrderModel{
  OrderModel({
    this.id,
    required this.created_at,
    required this.userUid,
    required this.items,
    required this.total
  });

  late String? id;
  late DateTime created_at;
  late String userUid;
  late List<Product> items;
  late double? total;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>;
    final items =
    itemsList.map((itemJson) => Product.fromJson(itemJson)).toList();
    return OrderModel(
      id: json['id'] as String?,
      created_at: DateTime.parse(json['created_at']) ,
      userUid: json['userUid'] as String,
      items: items,
      total: json['total'] as double
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'created_at': created_at.toUtc().toString(),
      'userUid': userUid,
      'total': total,
      'items': items.map((product) => product.toJson()).toList(),
    };
  }

}