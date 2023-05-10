import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:swap_store/models/Utilisateur.dart';

class UserController{

Future<void> setAvatar(String image)async{
  final user = FirebaseAuth.instance.currentUser;
  final userRef = await  FirebaseFirestore.instance.collection('users').where("uid", isEqualTo: user!.uid ).get();
  if(userRef.docs.isNotEmpty){
    final docId = userRef.docs[0].id;
    await FirebaseFirestore.instance
        .collection('users')
        .doc(docId)
        .update({'avatar': image});
  }

}
  Future<Utilisateur> getUser() async {
    final user = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance.collection('users').where("uid", isEqualTo: user!.uid );
    final  querySnapshot  = await userRef.get();
    final dataUser = querySnapshot.docs.map((doc) => doc.data()).toList();
    Utilisateur data=Utilisateur(uid: user.uid, name: dataUser[0]["name"], password: "", email: dataUser[0]["email"], tel: dataUser[0]["tel"],avatar:dataUser[0]["avatar"] );
    return data;
  }
  Future<Utilisateur> getUserById(String id) async {
    final userRef = FirebaseFirestore.instance.collection('users').where("uid", isEqualTo: id );
    final  querySnapshot  = await userRef.get();
    final dataUser = querySnapshot.docs.map((doc) => doc.data()).toList();
    Utilisateur data=Utilisateur(uid:id, name: dataUser[0]["name"], password: "", email: dataUser[0]["email"], tel: dataUser[0]["tel"]);
    return data;
  }
}