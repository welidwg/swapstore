import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:swap_store/components/exchange_item.dart';
import 'package:swap_store/models/Exchange.dart';

class ExchangesReceived extends StatefulWidget {
  const ExchangesReceived({Key? key}) : super(key: key);

  @override
  State<ExchangesReceived> createState() => _ExchangesReceivedState();
}

class _ExchangesReceivedState extends State<ExchangesReceived> {
  double? containerHeight;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
void updateState(){
    setState(() {

    });
}
  @override
  Widget build(BuildContext context) {
    final CollectionReference exchangesCollection =
        FirebaseFirestore.instance.collection("exchanges");
    final userID = FirebaseAuth.instance.currentUser!.uid;
    Future<QuerySnapshot> fetchExchanges() async {
      final snapshot =
          await exchangesCollection.where("ownerUid", isEqualTo: userID).where("status",isEqualTo: 0).get();
      return snapshot;
    }

    if (containerHeight == null) {
      containerHeight = MediaQuery.of(context).size.height;
    }
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(height: 30,),
              Text(
                "Received Proposals",
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
              child: FutureBuilder<QuerySnapshot>(
                future: fetchExchanges(),
                builder: (builder, snapshot) {
                  if (snapshot.hasError) {
                    return Text("error : ${snapshot.error}");
                  }
                  if (snapshot.hasData) {
                    if(snapshot.data!.size==0){
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
                          SizedBox(height: 5,),
                          const Text("You have no proposals yet",style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
                        ],
                      );;
                    }else{
                      return ListView(
                        children: snapshot.data?.docs.map<Widget>((data) {
                          return ExchangeItem(
                              updateState: updateState,
                              exchange: Exchange(
                                id:data.id,
                                ownerUid: data.get("ownerUid"),
                                ownerProductID: data.get("ownerProductID"),
                                requesterUid: data.get("requesterUid"),
                                requesterProductID: data.get("requesterProductID"),
                                status:data.get("status"),
                                created_at: DateTime.parse(data.get("created_at")),
                              ));
                        }).toList() ??
                            [
                              Text(
                                "You have no products yet",
                                textAlign: TextAlign.center,
                              )
                            ],
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
  }
}
