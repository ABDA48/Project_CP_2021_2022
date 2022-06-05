import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/constant.dart';

class Brand{
  late DocumentReference ref;
  late String documentId;
  late String name;
  late String image;
  late String description;
  late List<dynamic> followers;
  late String uid;
  late String post;
  late String branduid;

  Brand(DocumentSnapshot snapshot){
    ref=snapshot.reference;
    documentId=ref.id;
    Map<String,dynamic> datas= snapshot.data() as Map<String,dynamic>;
    name=datas[brandNameKey];
    description=datas[brandDescriptionKey];
    followers=datas[brandfollowersKey];
    uid=datas[uidKey];
    image=datas[imageBrandKey];
    post=datas[PosttotalKey];

  }




Map <String,dynamic> toMap(){
  Map <String,dynamic> map={
   uidKey:uid,
    brandNameKey:name,
    brandDescriptionKey:description,


  };
  return map;
}

}