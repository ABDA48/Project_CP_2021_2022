import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Buy.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/widgets/BarCharSeries.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:social_network_ecommerce/widgets/BarChart.dart';
import 'package:intl/intl.dart';
import "package:collection/collection.dart";
import 'package:social_network_ecommerce/widgets/SimpleChartSries.dart';

import '../widgets/PieCharSeries.dart';
class BrandAnalysisPage extends StatefulWidget {
  Member member;
  Brand brand;
  BrandAnalysisPage({required this.member,required this.brand});

  @override
  _BrandAnalysisPageState createState() => _BrandAnalysisPageState();
}

class _BrandAnalysisPageState extends State<BrandAnalysisPage> {
  List<Map<String,dynamic>> buylist=[];
  Map<int,dynamic> m={};
  Map<int,dynamic> n={};
  late  TrackingScrollController controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    takedata(widget.member.uid,widget.brand.name);
    controller = TrackingScrollController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Analysis',style: TextStyle(color: Colors.blue),)),backgroundColor: Colors.white,),
      body: (buylist.length==0)?Container():
      CustomScrollView(
        controller: controller,
        slivers: [
          SliverPadding(
            padding: EdgeInsets.all(0),
              sliver:SliverToBoxAdapter(
                child:   Card(
                  child: Container(
                    padding: EdgeInsets.all(0.8),
                    height: MediaQuery.of(context).size.height*0.3,
                    child: Timeseries(
                      data: cleanData(buylist),
                    ),
                  ),
                ),
              )
          ),
          SliverPadding(
            padding: EdgeInsets.all(0),
    sliver:SliverToBoxAdapter(
      child:  Card(
        child: Column(

            children:[
              Text("User by sales Analysis"),
              Container(
                padding: EdgeInsets.all(0.8),
                width: MediaQuery.of(context).size.width*0.7,
                height: MediaQuery.of(context).size.height*0.3,
                child: SimpleChart(
                  data: CleanBuyUsers(buylist),
                ),
              ),
              Center(
                child: Container(
                  padding: EdgeInsets.all(0.8),
                  width: MediaQuery.of(context).size.width*0.7,
                  height: MediaQuery.of(context).size.height*0.3,
                  child:ListView.builder(itemBuilder: (ctx,index){

                    return Container(
                      child: Row(
                        children: [
                          Text("Name  "),
                          Text(n[index].toString())
                        ],
                      ),
                    );},itemCount:m.length,),
                ),
              )


            ]
        ),
      )
    )
          )
        ],
      )
    );
  }
  /*
    Card(
             child: Container(
               padding: EdgeInsets.all(0.8),
               height: MediaQuery.of(context).size.height*0.3,
               child: Timeseries(
                 data: cleanData(buylist),
               ),
             ),
           ),
   */
  takedata(String uid,String uidBrand){

    FirebaseHandler.firestoreCollection.doc(uid).collection("Brands").doc(uidBrand)
        .collection("Buy").snapshots().listen((event) {
       event.docs.forEach((element) {
         Buy buy=new Buy(element);
         var mapb=buy.toMap();
         setState(() {
           buylist.add(mapb);

         });
       });

    });

    
  }
  /*
         Card(
            child: Column(

              children:[
                Text("User by sales Analysis"),
                Container(
                padding: EdgeInsets.all(0.8),
                width: MediaQuery.of(context).size.width*0.7,
                height: MediaQuery.of(context).size.height*0.3,
                child: SimpleChart(
                  data: CleanBuyUsers(buylist),
                ),
              ),
        Center(
          child: Container(
              padding: EdgeInsets.all(0.8),
              width: MediaQuery.of(context).size.width*0.7,

          child:ListView.builder(itemBuilder: (ctx,index){

            return Container(
            child: Row(
              children: [
                Text("Name  "),
                Text(n[index].toString())
              ],
            ),
          );},itemCount:m.length,),
          ),
        )


            ]
            ),
          )
   */
  cleanData(List<Map<String,dynamic>> buys){
    buys.sort((a,b)=>a['date'].compareTo(b['date']));
    var nem=groupBy(buys,(Map obj)=>obj['date']);

    List<ChartTimeseries> buyl=[];
    nem.forEach((key, value) {
      var price=0;
      value.forEach((element) {
        price= price+int.parse(element["price"].toString());
      });
      var dateTime1 = DateFormat('M/d/y').parse(value[0]['date']);
      buyl.add(
        ChartTimeseries(date:dateTime1, price:price, barColor: charts.ColorUtil.fromDartColor(Colors.blue))
      );
    });

    return buyl;
  }
CleanBuyUsers(List<Map<String,dynamic>> buys){
  var nem=groupBy(buys,(Map obj)=>obj['Buyeruid']);
  var price=0;

  int i=0;

  List<PieCharSeries> data=[];
  nem.forEach((key, value) {

    value.forEach((element) {
      price=price+int.parse(element["price"].toString());
    });
    m[i]=key;
    n[i]=price;

    i=i+1;

    data.add(PieCharSeries(sentiment: i, value: price));
  });

return data;

}
  /*cleanDataPie(List<Map<String,dynamic>> buys){
    var nem=groupBy(buys,(Map obj)=>obj['Address']);
    print(nem);
    nem.forEach((key, value) {
      var price=0;
      value.forEach((element) {
        price= price+int.parse(element["price"].toString());
      });

    });
  }

   */

}
