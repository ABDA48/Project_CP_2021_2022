import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/constant.dart';
class Post{
  late DocumentReference ref;
  late String documentId;
  late String Id;
  late String memberId;
  late String description;
   late String imageUrl;
  late int date;
  late String branduid;
  late List<dynamic>likes=[];
  late List<dynamic>comments=[];
  late List<dynamic>recommended=[];
  late List<dynamic>commentsuid=[];
  late List<dynamic> sentiments=[];
  late DocumentReference reference;
  late int price;
  late String title;
  Post(DocumentSnapshot snapshot){
    ref=snapshot.reference;
    documentId=snapshot.id;
    Id=snapshot.id;
    Map<String ,dynamic>? datas=snapshot.data() as Map<String, dynamic>?;
    memberId=datas![uidKey];
    description=datas[PostdescriptionKey];
    imageUrl=datas[ImagePostKey];
    if(datas[recommendedKey]!=null){
      recommended=datas[recommendedKey];
    }
    date=int.parse(datas[dateKey].toString());
    if (datas["sentiment"]!=null){
      sentiments=datas["sentiment"];
    }

    likes=datas[likeKey];
    branduid=datas[branduidKey];
    comments=datas[commentKey];
    commentsuid=datas[commentuidKey];
    price=datas[priceKey];
    title=datas[titleKey];
    if(datas["reference"]!=null){
      reference=datas["reference"];
    }

  }
  Map<String,dynamic> toMap() {
    Map<String,dynamic> map={
      uidKey:memberId,
      likeKey:likes,
      commentKey:comments,
      priceKey:price,
      PostdescriptionKey:description,
      commentuidKey:commentsuid,
      dateKey:date,
      branduidKey:branduid,
      titleKey:title
    };
    if(imageUrl!=null){
      map[ImageKey]=imageUrl;
    }
    return map;
  }
}