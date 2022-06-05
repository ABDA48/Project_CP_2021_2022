import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network_ecommerce/constant.dart';

class ChatRoom{
  late String fuid;
  late String tuid;
  late String branduid;
  late int date;
  late String documentId;
  late String text;
  late String type;
  late DocumentReference reference;


  //late String brandname;
  //late String brandImage;
  ChatRoom(DocumentSnapshot snapshot){
    documentId=snapshot.id;
    reference=snapshot.reference;
    Map<String,dynamic> map=snapshot.data() as Map<String,dynamic>;
    fuid=map[fromuidKey];
    tuid=map[touidKey];
    branduid=map[branduidKey];
    date=map[dateKey];
    text=map[textKey];
    type=map[typeKey];



  }
}