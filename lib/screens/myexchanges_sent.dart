import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:swap_store/components/exchange_item.dart';
import 'package:swap_store/models/Exchange.dart';

class MyExchangesSent extends StatefulWidget {
  const MyExchangesSent({Key? key}) : super(key: key);

  @override
  State<MyExchangesSent> createState() => _MyExchangesSentState();
}

class _MyExchangesSentState extends State<MyExchangesSent> {
  double? containerHeight;

  void updateState() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    containerHeight ??= MediaQuery.of(context).size.height;
    final CollectionReference exchangesCollection =
        FirebaseFirestore.instance.collection("exchanges");
    final userID = FirebaseAuth.instance.currentUser!.uid;
    Future<List<QuerySnapshot>> fetchExchanges() async {
      List<QuerySnapshot> futures = [];
      var firstQuery =
          await exchangesCollection.where("ownerUid", isEqualTo: userID).get();
      var secondQuery = await exchangesCollection
          .where('requesterUid', isEqualTo: userID)
          .get();
      futures.add(firstQuery);
      futures.add(secondQuery);

      return futures;
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Row(
            children: const [
              Text(
                "Your exchanges history",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          SizedBox(
            height: 15,
          ),
          Container(
              height: containerHeight! - 215,
              color: Colors.white,
              child: FutureBuilder<List<QuerySnapshot>>(
                future: fetchExchanges(),
                builder: (builder, snapshot) {
                  if (snapshot.hasError) {
                    return Text("error : ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    if (snapshot.data!.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 260,
                            height: 270,
                            child: Lottie.network(
                                'https://assets1.lottiefiles.com/private_files/lf30_e3pteeho.json',
                                repeat: true,
                                frameRate: FrameRate(30),
                                fit: BoxFit.contain),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          const Text(
                            "You have no history",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )
                        ],
                      );
                      ;
                    } else {
                     late List<Widget> listW = [];
                     for(var snap in snapshot.data!){

                       for(var data in snap.docs){
                         listW.add(ExchangeItem(
                             updateState: updateState,
                             exchange: Exchange(
                               id: data.id,
                               ownerUid: data.get("ownerUid"),
                               status: data.get("status"),
                               ownerProductID: data.get("ownerProductID"),
                               requesterUid: data.get("requesterUid"),
                               requesterProductID:
                               data.get("requesterProductID"),
                               created_at:
                               DateTime.parse(data.get("created_at")),
                             )));
                       }
                     }

                      return ListView(
                        children: listW,
                      );
                    }
                  } else {
                    return const Center(
                      child: Text("No data"),
                    );
                  }
                },
              ))
        ],
      ),
    );
    ;
  }
}
