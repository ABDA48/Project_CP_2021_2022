import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/pages/BuyPage.dart';
import 'package:social_network_ecommerce/pages/ChatRoomPage.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Components.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/date_Handler.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';

import '../constant.dart';
class PostPage extends StatefulWidget {
  Post post;
  Member member;
  Member mpownerpost;

   PostPage({required this.member,required this.mpownerpost,required this.post});

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  late List<Member> postCommentMembers=[];
  late TextEditingController commentcontroller;
  late List<dynamic> commentslist;
  late int i=0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    commentcontroller=TextEditingController();
    commentslist=[];


  }

  @override
  Widget build(BuildContext context) {
    takeCommentMember(widget.post.commentsuid);
    FirebaseHandler.firestoreCollection.doc(widget.mpownerpost.uid).collection("Brands").doc(widget.post.branduid).
    collection("Posts").doc(widget.post.documentId).snapshots().listen((event) {
      Post post=Post(event);
      setState(() {
        widget.post=post;
      });
    });
    return Scaffold(
      appBar: AppBar(leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: ()=>Navigator.pop(context),),

        title: Center(child: Text('Post',style: TextStyle(color: Colors.blue),)),backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),

         child: Container(

           child: Column(
             mainAxisSize: MainAxisSize.max,
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Container(
                 child: Card(
                   elevation: 0,
                   child: Padding(
                     padding: EdgeInsets.all(0),
                     child: Column(
                       crossAxisAlignment: CrossAxisAlignment.start,
                       children: [
                         ListTile(
                           leading: ProfileImage(urlImage:widget.mpownerpost.Imageurl, onPress: (){}, imagesize: 40,) ,
                           title: Text('  ${widget.mpownerpost.Username} ${widget.mpownerpost.name}'),
                           subtitle:Text('${DateHandler().myDate(widget.post.date)}') ,
                           trailing: Icon(Icons.more_vert),
                         ),

                         Divider(),
                         Text(widget.post.title),
                         ImagePost(context,widget.post),
                         Row(
                             mainAxisAlignment: MainAxisAlignment.start,
                             children: [
                               IconButton(onPressed: (){
                                 FirebaseHandler().addlikes(widget.mpownerpost.uid,widget.post,FirebaseHandler.firebaseAuth.currentUser!.uid);

                               },
                                   icon:(widget.post.likes.contains(FirebaseHandler.firebaseAuth.currentUser!.uid)?likeIcon:unlike)),

                               Text("${widget.post.likes.length} likes"),
                               IconButton(onPressed: (){
                                 //  AlertHelper().writeAcomment(context, post: widget.post, controller: TextEditingController(), member: widget.member);
                               }, icon: (widget.post.comments.length==0)?comment:commentw),
                               Text("${widget.post.comments.length} comments"),
                             ],
                         ),
                         Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: Text(widget.post.description),
                         )
                       ],
                     ),
                   ),
                 ),
               ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(text:"Price  ",style:TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.bold)),
                        TextSpan(text:widget.post.price.toString()+"  "+rupee,
                            style:TextStyle(color: Colors.pinkAccent,fontSize: 20,fontWeight: FontWeight.bold))
                      ]
                    ),
                    ),
                ),
               Container(
                 height:200,

               child:Padding(
                 padding: const EdgeInsets.all(8.0),
                 child: ListView.builder(itemBuilder: (context,index){
                   return Container(
                     child: Row(
                       children: [
                         /*
                         ProfileImage(urlImage:postCommentMembers[index].Imageurl, onPress: (){
                           print(widget.post.ref);

                         }, imagesize: 20),


                          */
                         Text(widget.post.comments[index])
                       ],
                     ),
                   );
                 },
                   itemCount: widget.post.comments.length,
                 ),
               )
               )



             ],
           ),
         ),
      ),
      bottomNavigationBar: Container(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ElevatedButton.icon(onPressed: (){

                FirebaseHandler().addToCard(widget.post,FirebaseHandler.firebaseAuth.currentUser!.uid);

              }, icon: Icon(Icons.shopping_basket_rounded), label: Text("Add to card"),
                style: ElevatedButton.styleFrom(primary: Colors.amber),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ElevatedButton.icon(onPressed: (){
                FirebaseHandler.firestoreCollection.doc(widget.mpownerpost.uid).collection("Brands")
                    .doc(widget.post.branduid).snapshots().listen((event) {
                  Brand brand=Brand(event);
                  Navigator.push(context, MaterialPageRoute(builder: (ctx)=>ChatRoomPage(brand:brand,member: widget.mpownerpost,)));
                });


              }, icon: Icon(MdiIcons.message), label: Text("Contact"),
                style: ElevatedButton.styleFrom(primary: Colors.pinkAccent),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ElevatedButton.icon(onPressed: (){

                Navigator.push(context, MaterialPageRoute(builder: (ctx)=>BuyPage(post: widget.post,member:widget.member)));
              }, icon: Icon(Icons.shopping_cart), label: Text("Buy"),
                style: ElevatedButton.styleFrom(primary: Colors.green),
              ),
            ),

          ],
        ),
      ),
    );
  }
  takeCommentMember(List<dynamic> uids){
    List<Member> membs=[];
    uids.forEach((element) {
      FirebaseHandler.firestoreCollection.doc(element).snapshots().listen((event) {
        Member member=Member(event);
        membs.add(member);
        setState(() {
          postCommentMembers=membs;
        });
      });
    });
  }

  ImagePost(BuildContext context,Post post){
    if(post.imageUrl!=null&&post.imageUrl!=""){
      return Padding(
        padding: EdgeInsets.all(1),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height*0.45,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
          ),
          child:Image.network(post.imageUrl,fit: BoxFit.contain,),
        ),
      );
    }else{
      return  Container(height: 0,width: 0,);

    }
  }
}
