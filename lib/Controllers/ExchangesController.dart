import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/models/Exchange.dart';

class ExchangesController {
  final CollectionReference exchangesCollection =
      FirebaseFirestore.instance.collection("exchanges");

  Future<void> deleteExchange(
      String requesterUid, String? ownerProductID) async {
    final check = await exchangesCollection
        .where("requesterUid", isEqualTo: requesterUid)
        .where("ownerProductID", isEqualTo: ownerProductID)
        .get();
    if (check.docs.isNotEmpty) {
      final documentSnapshot = check.docs.first;
      await documentSnapshot.reference.delete();
    }
  }

  Future<void> manageStatus(int status, String id) async {
    final ex = exchangesCollection.doc(id);

    final docSnapshot = await ex.get();
    if (docSnapshot.exists) {
      final data = Exchange.fromJson(docSnapshot.data() as Map<String, dynamic>);
      ProductController productController = ProductController();
      if(status==1){
        final p1 = await productController.getProductById(data.ownerProductID);
        final p2 = await productController.getProductById(data.requesterProductID);
        p1.statue=0;
        p2.statue=0;
        String? id1=p1.id;
        String? id2=p2.id;
        await productController.updateProduct(id1!, p1);
        await productController.updateProduct(id2!, p2);
      }
    }
    await ex.update({"status": status});

  }

  Future<bool> checkExchange(
      String requesterUid, String? ownerProductID) async {
    bool exist = false;
    final check = await exchangesCollection
        .where("requesterUid", isEqualTo: requesterUid)
        .where("ownerProductID", isEqualTo: ownerProductID)
        .get();
    if (check.docs.isNotEmpty) {
      exist = true;
    }
    return exist;
  }

  Future<void> storeExchange(Exchange exchange) async {
    try {
      final check = await exchangesCollection
          .where("requesterUid", isEqualTo: exchange.requesterUid)
          .where("ownerProductID", isEqualTo: exchange.ownerProductID)
          .get();
      if (check.docs.isNotEmpty) {
        final documentSnapshot = check.docs.first;
        await documentSnapshot.reference.delete();
        throw Exception("Proposal withdrawed");
      } else {
        await exchangesCollection.add(exchange.toMap());
      }
    } catch (e) {
      // Handle the error
      print(' ${e.toString()}');
      rethrow;
    }
  }
}
