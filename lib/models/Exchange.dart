import 'package:cloud_firestore/cloud_firestore.dart';

class Exchange{
  //status  ; 0 pending  / 1 approved / 2 denied
  late String? id;
  late String requesterUid;
  late String ownerUid;
  late String requesterProductID;
  late String ownerProductID;
  late DateTime created_at;
  late int status=0;
  Exchange({required this.requesterUid, required this.ownerUid, required this.requesterProductID, required this.ownerProductID,required this.created_at, this.id,required this.status});
  factory Exchange.fromJson(Map<String, dynamic> json) {
    return Exchange(
      requesterUid: json['requesterUid'],
      ownerUid: json['ownerUid'],
      requesterProductID: json['requesterProductID'],
      ownerProductID: json['ownerProductID'],
      created_at: DateTime.parse(json['created_at']),
      status : json['status']
    ) ;
  }
  Map<String, dynamic> toMap() {
    return {
      'requesterUid': requesterUid,
      'ownerUid': ownerUid,
      'requesterProductID': requesterProductID,
      'ownerProductID': ownerProductID,
      'created_at': created_at.toUtc().toString(),
      'status': status,
    };
  }

}