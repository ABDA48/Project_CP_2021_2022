import 'dart:async';

import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';
import 'package:social_network_ecommerce/widgets/circle_button.dart';

import '../constant.dart';
class CommentPage extends StatefulWidget {
  Member mpownerpost;
  Member member;
  Post post;
    CommentPage({required this.member,required this.mpownerpost,required this.post});

  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  late TrackingScrollController controller;
  late TextEditingController commentcontroller;
  late StreamSubscription subscription;
  late List<dynamic> commentslist;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentslist=[];
    controller=TrackingScrollController();
    commentcontroller=TextEditingController();
    takeComments(widget.mpownerpost.uid,widget.post);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
            leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: ()=>Navigator.pop(context),),
            brightness: Brightness.light,
              backgroundColor: Colors.white,
              title:Text("Comments",
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2,
                ),
              ) ,
              centerTitle: false,
              floating: true,

          ),
SliverPadding(padding: EdgeInsets.all(10),
sliver: SliverToBoxAdapter(
  child:  Container(
    width: MediaQuery.of(context).size.width*0.9,

    decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        borderRadius: BorderRadius.all(Radius.circular(10))
    ),
    child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children:[
          ProfileImage(urlImage:widget.member.Imageurl, onPress: (){}, imagesize: 20,),
          Container(
            padding: EdgeInsets.all(8),
            width: MediaQuery.of(context).size.width*0.7,
            child: TextFormField(controller: commentcontroller,
                decoration: InputDecoration(
                  hintText: "Add comments",

                )
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: 10),
            decoration:BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: IconButton(onPressed: (){
              if(commentcontroller.text!=""){
                FirebaseHandler().addComments(widget.mpownerpost.uid,widget.post,FirebaseHandler.firebaseAuth.currentUser!.uid,commentcontroller.text);
                commentcontroller.text="";
              }
            }, icon: share,padding: EdgeInsets.all(4),),
          ),

        ]
    ),
  ),
),
),
SliverList(delegate: SliverChildBuilderDelegate(
    (context,index){
      return ListTile(
        leading: ProfileImage(urlImage:widget.member.Imageurl,onPress: (){},imagesize:10,),
        title: Text(commentslist[index]),
        subtitle: Text(widget.member.name),
      );
    },
  childCount: commentslist.length,


))

        ],
      ),
    );

  }
  takeComments(String uid,Post post){

    subscription=FirebaseHandler.firestoreCollection.doc(uid).collection("Brands")
        .doc(post.branduid).collection("Posts").doc(post.documentId).snapshots().listen((event) {
      Post post=Post(event);
      setState(() {
        commentslist=post.comments;

      });
    });

  }


}
