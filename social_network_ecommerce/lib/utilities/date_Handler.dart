import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';



class DateHandler{
  String myDate(int timestamp){
    String local="fr_FR";
    initializeDateFormatting(local,"");
    DateTime postdata=DateTime.fromMillisecondsSinceEpoch(timestamp);
    DateTime now=DateTime.now();
    DateFormat format;
    if(now.difference(postdata).inDays>0){
      format=DateFormat.yMMMd(local);

    }else{
      format=DateFormat.Hm(local);
    }
    return format.format(postdata).toString();
  }
  String toMyDate(int ti){
    String local="en_EN";
    initializeDateFormatting(local,"");
    DateTime postdata=DateTime.fromMillisecondsSinceEpoch(ti);

    DateFormat format;
    format=DateFormat.yMd(local);
    var data=format.format(postdata).toString();
    print(data);


    return data;

  }
}