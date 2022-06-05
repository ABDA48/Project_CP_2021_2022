import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../Controller/firebasecontroller.dart';
import '../utilities/Member.dart';
import '../utilities/Post.dart';
class RecommendationPage extends StatefulWidget {
  late Member member;
   RecommendationPage({required member});

  @override
  _RecommendationPageState createState() => _RecommendationPageState();
}

class _RecommendationPageState extends State<RecommendationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("Post"),
          // StreamBuilder(
          //     stream:FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Brands").doc('rTQzlxXukSNQ560jidsOgyiVq3w2').collection("Posts").orderBy('date',descending: true).snapshots(),
          //      builder: (BuildContext ctx,AsyncSnapshot <QuerySnapshot> snapshot){
          //
          //       return ListView.builder(itemBuilder: ((context, index) => ){})
          //      },
          // )

        ],
      ),
    );
  }
}
