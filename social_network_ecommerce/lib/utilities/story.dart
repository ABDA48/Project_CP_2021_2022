import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constant.dart';
import 'date_Handler.dart';
class Story{
  late String uid;
  late String memberuid;
  late String content;
  late String date;
  late List<dynamic> message;
  late DocumentReference ref;
  late String documentId;
  late String branduid;
  late String imagebrand;
  late String brandname;
  Story(DocumentSnapshot snapshot){
    ref=snapshot.reference;
    uid=snapshot.id;
    Map<String,dynamic> datas=snapshot.data() as Map<String,dynamic>;
    memberuid=datas[uidKey];
    content=datas[ContentKey];
    date=DateHandler().myDate(datas[dateKey]);
    message=datas[MessageKey];
    branduid=datas[branduidKey];
    imagebrand=datas[ImageKey];
    brandname=datas[brandNameKey];
  }

}