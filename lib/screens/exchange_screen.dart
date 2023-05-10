import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:swap_store/Controllers/ExchangesController.dart';
import 'package:swap_store/Controllers/ProductController.dart';
import 'package:swap_store/constants.dart';
import 'package:swap_store/models/Exchange.dart';
import 'package:swap_store/models/Product.dart';

enum dropdowItem { title, image }

class ExchangeScreen extends StatefulWidget {
  ExchangeScreen({required this.prodId, required this.ownerId,required this.updateState});

  late String? prodId;
  late String? ownerId;
  final VoidCallback updateState; // Accept the callback function

  @override
  State<ExchangeScreen> createState() => _ExchangeScreenState();
}

class _ExchangeScreenState extends State<ExchangeScreen> {
  late List<Product> prods = [];

  ProductController prodsCtrl = ProductController();
  String selected_value = "";
  String requesterID = FirebaseAuth.instance.currentUser!.uid;
  String requesterProdID = "";
  String ownerId = "";
  String ownerProdID = "";

  Future setProds() async {
    final tempProds = await prodsCtrl.getUserProducts();
    for (var p in tempProds.docs) {
      setState(() {
        prods.add(Product.fromJson(p.data() as Map<String, dynamic>)..id = p.id);
      });
    }

    setState(() {
      selected_value = prods.first.id ?? "";
      requesterProdID=selected_value;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    setProds();
    ownerProdID = widget.prodId!;
    ownerId = widget.ownerId!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ProductController prodCtrl = ProductController();
    ExchangesController exCtrl = ExchangesController();

    if (prods.length == 0) {
      return Center(
        child: Text("You have no products to exchange with"),
      );
    } else {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Choose product from you list",
            style: TextStyle(
                fontSize: 17, color: Colors.black, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            color: Colors.white54,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 9),
              child: DropdownButton(
                underline: Container(),
                value: selected_value,
                style: const TextStyle(color: Colors.black),
                icon: const Icon(Icons.keyboard_arrow_down),
                items: prods.map((Product item) {
                  return DropdownMenuItem(
                    value: item.id,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.file(
                          prodCtrl.getImage(item.image),
                          fit: BoxFit.cover,
                          height: 25,
                        ),
                        SizedBox(
                          width: 14,
                        ),
                        Text("${item.title} (${item.price})"),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selected_value = newValue!;
                    requesterProdID = newValue;
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          ElevatedButton(
            onPressed: () async{
              Exchange ex=Exchange(requesterUid: requesterID, ownerUid: ownerId, requesterProductID: requesterProdID, ownerProductID: ownerProdID, created_at: DateTime.now(),status: 0);
              try{
                await exCtrl.storeExchange(ex);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Proposal successfully sent")));
                widget.updateState();


              }catch(e){
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              }
              Navigator.pop(context);
            },
            child: Text("Send proposal"),
            style: ButtonStyle(
                backgroundColor: MaterialStatePropertyAll(kPrimaryColor)),
          )
        ],
      );
    }
  }
}
