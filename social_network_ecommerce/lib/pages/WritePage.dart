import 'dart:async';
import 'dart:io';



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/pages/BrandPage.dart';
import 'package:social_network_ecommerce/pages/Profilepage.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';

import '../constant.dart';
class WritePage extends StatefulWidget {
  String uid;
  File file;
  WritePage({required this.uid,required this.file});


  @override
  _WritePageState createState() => _WritePageState();
}

class _WritePageState extends State<WritePage> {
  late List<Brand> brandList = [];
  late List<Brand> brandListintact = [];
  late StreamSubscription subscription;
late TextEditingController editingController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    editingController=TextEditingController();
    takelistbrand(widget.uid);


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(

      height: MediaQuery.of(context).size.height*0.4,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(50),topRight:Radius.circular(50)),
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black,spreadRadius: 5,blurRadius: 25,offset:Offset(15,15) )
        ]
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,

        children: [


              Container(
                  width: MediaQuery.of(context).size.width*0.7,
                  child: Container(
                    width:MediaQuery.of(context).size.width*0.8 ,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(30))

                    ),
                    child:ListTile(
                      leading: Icon(Icons.search),
                      title: TextFormField(
                        controller: editingController,
                        decoration: InputDecoration(
                          hintText: "Type brand's name",

                        ),
                        onTap: ()=>editingController.clear(),
                        onChanged: (value)=>search(value),
                      ),

                    ),
                  )),

           Container(
           height: MediaQuery.of(context).size.height*0.3,
             child: Expanded(
                 child: ListView.builder(

               itemCount: brandList.length,
                 itemBuilder: (context,index){
               return ListTile(
                 onTap: (){

                 },
                 leading: ProfileImage(imagesize: 20,onPress: (){},urlImage: brandList[index].image,),
                 title: Text(brandList[index].name),
                 trailing: TextButton(child: Text('Send'),onPressed: (){
                   FirebaseHandler().sendToStories(widget.uid,brandList[index].documentId, widget.file);
                 },),
               );
             })),
           )
        ],
      ),
    );
  }
  search(String query){
    List<Brand> brand=[];
    brand=(query=="")?brandListintact:brandList.where((element) => element.name.toLowerCase().contains(query.toLowerCase())).toList();
    setState(() {
      brandList=brand;
    });
    if(query==""){
      brandList=brandListintact;
    }
  }

takelistbrand(String uid){
    List<Brand> brands=[];
    subscription=FirebaseHandler.firestoreCollection.doc(uid).collection("Brands").snapshots().listen((event) {
      event.docs.forEach((element) {
        Brand brand=Brand(element);
        brands.add(brand);
        setState(() {
          brandList=brands;
          brandListintact=brands;
        });

      });
    });
}
}

