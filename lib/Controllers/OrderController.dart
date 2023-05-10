import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/logger.dart';
import 'package:swap_store/Controllers/CartController.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/Controllers/UserController.dart';
import 'package:swap_store/models/OrderModel.dart';
import 'package:swap_store/models/Product.dart';
import 'package:swap_store/models/Utilisateur.dart';

class OrderController {
  final orderCollection = FirebaseFirestore.instance.collection('orders');
  final currentUserID = FirebaseAuth.instance.currentUser != null
      ? FirebaseAuth.instance.currentUser!.uid
      : null;

  Future<void> createOrder(OrderModel order) async {
    final prodCollection = FirebaseFirestore.instance.collection('products');
    try {
      final docRef = await orderCollection.add(order.toJson());
      order.id = docRef.id;
      CartController cartController = CartController();
      await cartController.emptyCart(order.userUid);
      for (var it in order.items) {
        await prodCollection.doc(it.id).update({"statue": 0});
      }
    } catch (e) {
      print('Error creating order: $e');
      rethrow;
    }
  }

  Future<List<Product>> getProducts() async {
    List<Product> list = [];
    final currentUserUid = FirebaseAuth.instance.currentUser!.uid;
    final querySnapshot = await orderCollection.get();
    UserController userCtrl = UserController();
    Utilisateur? user;
    if (querySnapshot.docs.isNotEmpty) {
      for (var e in querySnapshot.docs) {
        user =await userCtrl.getUserById(e.get("userUid"));
        
        for (var item in e.get("items")) {
          if (item["ownerUid"] == currentUserUid) {
            list.add(Product.fromJson(item)..orderedBy=user);
          }
        }
      }
    }
    return list;
  }

  Future<QuerySnapshot> getAllOrders() async {
    try {
      final querySnapshot = await orderCollection
          .where("userUid", isEqualTo: currentUserID)
          .get();
      return querySnapshot;
    } catch (e) {
      print('Error getting orders: $e');
      rethrow;
    }
  }

  Future<void> updateOrder(OrderModel order) async {
    try {
      await orderCollection.doc(order.id).update(order.toJson());
      print('Order updated with ID: ${order.id}');
    } catch (e) {
      print('Error updating order: $e');
      rethrow;
    }
  }

  Future<void> deleteOrder(String orderId) async {
    try {
      final querySnapshot=await orderCollection.doc(orderId).get();
      ProductController prodCtrl=ProductController();
      if(querySnapshot.data()!.isNotEmpty){
        for(var i in querySnapshot.get("items")){
          print(i["id"]);
          await prodCtrl.updateProductStatus(i["id"], 1);
        }
      }
      await orderCollection.doc(orderId).delete();
      print('Order deleted with ID: $orderId');
    } catch (e) {
      print('Error deleting order: $e');
      rethrow;
    }
  }
}
