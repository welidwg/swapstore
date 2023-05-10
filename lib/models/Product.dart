import 'package:swap_store/models/Utilisateur.dart';

class Product {
  Product(
      {this.id,
      this.statue,
      this.orderedBy,
      required this.title,
      required this.image,
      required this.description,
      required this.price,
      required this.age,
      required this.condition,
      required this.owner,
      required this.ownerTel,
      required this.type,
      required this.ownerUid});

  late String? id;
  late String title;
  late String ownerUid;
  late String image;
  late String description;
  late double price;
  late double age;
  late String condition;
  late String owner;
  late int ownerTel;
  late int type;
  late int? statue = 1;
  late Utilisateur? orderedBy;

  static Product defaultProd() {
    return Product(
        id: 'default-id',
        title: 'Default Product',
        image: 'default-image-url',
        description: 'Default Description',
        price: 0.0,
        age: 0.0,
        condition: 'New',
        owner: 'Default Owner',
        ownerTel: 0,
        type: 0,
        ownerUid: 'default-owner-id',
        statue: 1);
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        title: json['title'] ?? '',
        ownerUid: json['ownerUid'] ?? '',
        image: json['image'] ?? '',
        description: json['description'] ?? '',
        price: json['price'] as double ?? 0,
        age: double.parse(json['age'].toString()),
        condition: json['condition'] ?? '',
        owner: json['owner'] ?? '',
        ownerTel: json['ownerTel'] ?? '',
        type: json['type'] as int ?? 0,
        statue: json['statue'] as int ?? 0,
        orderedBy: json["orderedBy"]);
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'age': age,
      'condition': condition,
      'owner': owner,
      'ownerTel': ownerTel,
      'type': type,
      'ownerUid': ownerUid,
      'statue': statue,
      'id': id,
      'orderedBy': orderedBy
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'image': image,
      'price': price,
      'age': age,
      'condition': condition,
      'owner': owner,
      'ownerTel': ownerTel,
      'type': type,
      'ownerUid': ownerUid,
      'statue': statue,
      'id': id,
      'orderedBy': orderedBy
    };
  }
}
