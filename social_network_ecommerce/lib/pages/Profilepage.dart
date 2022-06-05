import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/pages/BrandPage.dart';
import 'package:social_network_ecommerce/pages/BrandPostsPage.dart';
import 'package:social_network_ecommerce/pages/EditProfilePage.dart';
import 'package:social_network_ecommerce/pages/HomePage.dart';
import 'package:social_network_ecommerce/utilities/AlertHelper.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/BtnCreator.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/ProfileHeader.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';
import 'package:social_network_ecommerce/widgets/circle_button.dart';

import '../constant.dart';
class ProfilePage extends StatefulWidget {
  Member member;
  ProfilePage({required this.member});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
 late List<Brand> brandsList=[];
 late int i=0;
 late int postnum;
 late StreamSubscription streamSubscription;
 late TrackingScrollController controller;

  @override
  void initState() {
    // TODO: implement initState
  //  getBrands(widget.member.uid);
   controller=TrackingScrollController();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    streamSubscription.cancel();
  }




  Widget textColumn(String title,String value){
    return Column(
      children: [
        Text(value,style: GoogleFonts.openSans(fontSize: 20),),
        Text(title,style: GoogleFonts.openSans(fontSize: 15),),

      ],
    );
  }

  Widget brands(String name,String image,VoidCallback onpress){



    return Card(
      child: ListTile(
        onTap: onpress,
        leading: ProfileImage(imagesize: 13,onPress: (){},urlImage: image),
        title: Text(name),
        //subtitle: Text("post number:"+postnum.toString()),
        // trailing:(widget.member.uid==FirebaseHandler.firebaseAuth.currentUser!.uid) ?TextButton(child:Text("see") ,onPressed: ()=>onpress,):
        //     TextButton(onPressed: (){}, child: Text("follow"))


      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Brands").snapshots(),
        builder:(ctx,AsyncSnapshot <QuerySnapshot>snapshot)=>(snapshot.hasData)?CustomScrollView(
          controller: controller,
          slivers: [
            SliverAppBar(
              brightness: Brightness.light,
              backgroundColor: Colors.white,
              title:Text(widget.member.Username,
                style: TextStyle(
                  color: Colors.black26,
                  fontSize: 28.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -1.2,
                ),
              ) ,
              centerTitle: false,
              floating: true,
               actions: [
                PopupMenuButton(
                  icon: Icon(Icons.more_vert,color: Colors.black,),
                    itemBuilder: (ctx)=>[
                      PopupMenuItem(
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Icon(Icons.edit,color: Colors.black,),
                              Text("Edit Profile")
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return EditProfilePage(member: widget.member);
                          })),
                        ),
                      ),
                      PopupMenuItem(
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Icon(Icons.business,color: Colors.black,),
                              Text("Add Brands")
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          onTap: ()=> Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return BrandPage(uid: widget.member.uid);
                          })),
                        ),
                      ),
                      PopupMenuItem(
                        child: GestureDetector(
                          child: Row(
                            children: [
                              Icon(Icons.logout,color: Colors.black,),
                              Text("Log out")
                            ],
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          ),
                          onTap: (){AlertHelper().disconnect(context); },
                        ),
                      ),

                ])

               ]
            ),
            SliverPadding(
                padding: EdgeInsets.all(8),
              sliver: SliverToBoxAdapter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: Column(children:[
                        ProfileImage(urlImage: widget.member.Imageurl,imagesize: 40, onPress: (){}),
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(widget.member.name,style: GoogleFonts.openSans(fontSize: 20),),
                        ),
                      ]),
                    ),
                   // textColumn("Post",i.toString()),
                    textColumn("Brands",snapshot.data!.docs.length.toString()),
                    textColumn("Following",widget.member.following.length.toString())
                  ],
                ),
              ),
            ),

            SliverList(delegate: SliverChildBuilderDelegate(
                (context,index)   {
                  Brand brand=new Brand(snapshot.data!.docs[index]);


                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: brands(brand.name,brand.image,
                            (){
                          Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            return BrandPostPage(member: widget.member, brand: brand);
                          }));
                        }),
                  );
                },
              childCount: snapshot.data!.docs.length
            )),

          ],
        ):Container(),
      ),
    );
  }
coutsPost(Brand b){

             FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Brands").doc(b.documentId).collection("Posts").snapshots().listen((event) {
               setState(() {
                 i=event.docs.length;
               });
             });
}
}




