import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';

import '../Controller/firebasecontroller.dart';
import '../widgets/PieCharSeries.dart';
import '../widgets/SimpleChartSries.dart';
class ProductAnalysis extends StatefulWidget {
  Post post;
  ProductAnalysis({required this.post});

  @override
  _ProductState createState() => _ProductState();
}

class _ProductState extends State<ProductAnalysis> {
late String positive;
late String negative;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    /*
    FirebaseHandler.firestoreCollection.doc(widget.post.memberId).collection("Brands").doc(widget.post.branduid).
    collection("Posts").doc(widget.post.documentId).snapshots().listen((event) {

      Post post=Post(event);
      setState(() {
        widget.post=post;

      });
    });

     */

  }
  @override
  Widget build(BuildContext context) {

print(widget.post.sentiments);

    return Scaffold(
      appBar: AppBar(title: Text("Product Analysis"),),
     body: Container(

       child: Column(

         children: [
           buildPieChart(context)
         ],
       ),
     ),
    );
  }

  Widget buildPieChart(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("Sentiment Analysis",style: TextStyle(color: Colors.blue,fontSize: 20),),
        ),
        Row(

          children: [
            Container(
               height: MediaQuery.of(context).size.height*0.3,
               width: MediaQuery.of(context).size.width*0.7,
               child: SimpleChart( data:takeProduct(widget.post.sentiments),),
             ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Posivive "+positive),
                Text("Negative "+negative)
              ],
            )
          ]
        ),
      ]
    );
  }
takeProduct(List<dynamic> sentments){

  int pos=0;
  int neg=0;
  sentments.forEach((element) {
    if (element=="Positive"){
      pos=pos+1;
    }else {
      neg=neg+1;
    }
  });
  var posp=(pos*100)/(pos+neg);
  var negp=(neg*100)/(pos+neg);

  setState(() {
    positive=posp.toStringAsFixed(2);
    negative=negp.toStringAsFixed(2);
  });



  List<PieCharSeries> series=[
    PieCharSeries(sentiment:1,value: pos),
    PieCharSeries(sentiment: 0, value: neg),

  ];
  return series;

}
}



