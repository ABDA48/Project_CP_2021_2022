import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:social_network_ecommerce/constant.dart';

class CardMarket{
  late String image;
  late String postuid;
  late String title;
  late int number;
  late int price;
  late String documentId;
  late DocumentReference reference;
  late List<dynamic>recommended=[];
  CardMarket(DocumentSnapshot snapshot){
    documentId=snapshot.id;
    reference=snapshot.reference;
    Map<String,dynamic> map=snapshot.data() as Map<String,dynamic>;
    image=map[imageBrandKey];
    postuid=map[postkey];
    title=map[titleKey];
    number=map["Number"];
    price=map[priceKey];
    if(map[recommendedKey]!=null){
      recommended=map[recommendedKey];
    }
  }
}