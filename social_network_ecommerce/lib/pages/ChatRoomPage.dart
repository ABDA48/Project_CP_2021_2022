import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/ChatRoom.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';

class ChatRoomPage extends StatefulWidget {
   Brand brand;
   Member member;

   ChatRoomPage({required this.brand,required this.member});

  @override
  _ChatRoomPageState createState() => _ChatRoomPageState();
}

class _ChatRoomPageState extends State<ChatRoomPage> {
  late TrackingScrollController controller;
  late TextEditingController controllermess;
  late File image;

  @override
  void initState() {

    controller=TrackingScrollController();
    controllermess=TextEditingController();

    
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: StreamBuilder(
      stream:FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Brands").doc(widget.brand.documentId).collection("ChatRoom")
          .orderBy('date',descending: false).snapshots(),
      builder: (context, AsyncSnapshot <QuerySnapshot> snapshot)=>(snapshot.hasData)?
       CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.white,
              leading:ProfileImage(onPress: (){},imagesize: 8, urlImage:widget.brand.image,) ,
              title: Text(widget.brand.name,style: GoogleFonts.lato(color: Colors.black),),
              actions: [

                  PopupMenuButton(
                     itemBuilder: (ctx)=>[
                       PopupMenuItem(child: Text("Brand info"))
                     ],
                  )

              ],
            ),
            SliverList(delegate: SliverChildBuilderDelegate(
                (context,index){
                  ChatRoom chatRom=ChatRoom(snapshot.data!.docs[index]);
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: textMessageModel(chatRom.fuid,chatRom.text),
                  );
                },
              childCount: snapshot.data!.docs.length
            ))
          ],
        ):Container(),

      ),
        bottomNavigationBar: Container(

          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(spreadRadius: 0.2,blurRadius: 10,offset: Offset(0,0),color: Colors.black12)
              ]
          ),
          child:  Row(
              children:[ Container(


                width:MediaQuery.of(context).size.width*0.8 ,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(30))

                ),
                child:TextFormField(
                  controller: controllermess,
                  decoration: InputDecoration(
                      hintText: "Send message",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(30))
                      ),
                      suffixIcon: IconButton(
                        onPressed: (){
                          FirebaseHandler().sendMessage(widget.brand.documentId,FirebaseHandler.firebaseAuth.currentUser!.uid,widget.member.uid,controllermess.text,typeTextK);
                          controllermess.text="";
                        },
                        icon: Icon(Icons.send) ,
                      )

                  ),
                ),
              ),
                IconButton(onPressed: (){

                }, icon:Icon(Icons.image,color: Colors.green,))
              ]
          ),
        )
    );
  }
  

 Widget textMessageModel(String uid,String text){
    bool m=uid==FirebaseHandler.firebaseAuth.currentUser!.uid;
    return Container(
        width: MediaQuery.of(context).size.width,

        child: Row(
          mainAxisAlignment:(m)?MainAxisAlignment.start:MainAxisAlignment.end,
          children:[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
            decoration: BoxDecoration(
                color:(m)?Colors.blueAccent:Colors.lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(10))

            ),
            child: Text(text,style: TextStyle(color: Colors.white),),
          ),
           // (!m)?ProfileImage(urlImage:widget.member.Imageurl, onPress:(){}, imagesize: 15):Container(),

          ]
          ,
        ),
      );
    }

}
