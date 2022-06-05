import 'dart:async';
import 'dart:io';

import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/pages/CartPage.dart';
import 'package:social_network_ecommerce/pages/StoryPage.dart';
import 'package:social_network_ecommerce/pages/WritePage.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/postTile.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';
import 'package:social_network_ecommerce/utilities/story.dart';
import 'package:social_network_ecommerce/pages/BrandAnalysisPage.dart';

import 'package:social_network_ecommerce/widgets/circle_button.dart';

import '../constant.dart';
import 'TestAPipage.dart';
class HomePage extends StatefulWidget {
  Member member;
  HomePage({required this.member});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late StreamSubscription subscription;
  late StreamSubscription storyStream;
  late String myuId=FirebaseHandler.firebaseAuth.currentUser!.uid;
  List<Post> postslist=[];
  List<Story> stories=[];
  List<Brand> brandPost=[];
  List<Member> members=[];
  final documentlimit=10;
  late DocumentSnapshot lastdoc;
  List<Brand> brandStoryNew=[];

  GlobalKey<ScaffoldState> globalKey=GlobalKey();
  late  TrackingScrollController controller;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

     controller = TrackingScrollController();
    takeAllStories();


  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    subscription.cancel();
    controller.dispose();
    storyStream.cancel();
  }


  takeAllStories(){
    List<Story> list=[];
    storyStream=FirebaseHandler.firestoreCollection.snapshots().listen((event) {
      event.docs.forEach((m) {
        FirebaseHandler.firestoreCollection.doc(m[uidKey]).collection("Brands").where(brandfollowersKey,arrayContains:myuId).snapshots().listen((event) {
          event.docs.forEach((element) {
            Brand b=Brand(element);
            FirebaseHandler.firestoreCollection.snapshots().listen((event) {
              event.docs.forEach((element) {
                FirebaseHandler.firestoreCollection.doc(element[uidKey]).collection("Brands").doc(b.documentId).collection("Stories").snapshots().listen((stor) {

                  stor.docs.forEach((element) {
                    Story story=Story(element);
                    list.add(story);

                    setState(() {
                      stories=list;

                    });
                  });
                });
              });
            });

          });
        });

        });
    });
  }














  @override
  Widget build(BuildContext context) {


    return Scaffold(
       backgroundColor: Colors.white,
       key: globalKey,
body: StreamBuilder(

    stream:FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Posts")
        .orderBy('date',descending: false).limit(10).snapshots() ,
    builder: (context,AsyncSnapshot <QuerySnapshot> snapshot){
      if(snapshot.hasData){
       print("has data");
        return GestureDetector(

          onTap:()=>FocusScope.of(context).unfocus(),

          child:   CustomScrollView(

            controller: controller,

            slivers: [

              SliverAppBar(

                  brightness: Brightness.light,

                  backgroundColor: Colors.white,

                  title:Text("Ecomerce Social Media",

                    style: GoogleFonts.openSans(color: Colors.black,fontSize: 15),

                  ) ,

                  centerTitle: false,

                  floating: true,

                  actions: [

                    IconButton(

                      icon: Icon(Icons.search,color: Colors.black,),

                      iconSize: 25.0,

                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>APIBrand(member: widget.member,)));
                      },

                    ),

                    IconButton(

                      icon: Badge(

                        badgeContent: Text('3',style: TextStyle(color: Colors.white,fontSize: 10),),

                        child: Icon(Icons.shopping_cart,color: Colors.black),

                        padding: EdgeInsets.all(4),

                        badgeColor: Colors.pinkAccent,

                        animationType:  BadgeAnimationType.slide,



                      ),

                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (ctx)=> new CartPage(member: widget.member))),

                    )



                    // IconButton(

                    //   icon:Icon(Icons.shopping_cart,color: Colors.black,),

                    //   iconSize: 20.0,

                    // ),

                  ]

              ),

              SliverPadding(

                padding: EdgeInsets.all(0),

                sliver: SliverToBoxAdapter(

                  child: Container(

                    height:MediaQuery.of(context).size.height*0.14,

                    decoration: BoxDecoration(



                    ),

                    child: ListView.builder(

                        scrollDirection: Axis.horizontal,

                        itemCount: stories.length+1,

                        itemBuilder: (context,index){

                          if(index==0){

                            return Column(

                              children: [

                                Stack(

                                  children: [

                                    ProfileImage(urlImage:widget.member.Imageurl, onPress: ()=>takepicture(ImageSource.gallery), imagesize: 30),

                                    Positioned(

                                      child: IconButton(onPressed: ()=>takepicture(ImageSource.gallery),icon: Icon(Icons.add,size: 30,color: Colors.white,),),

                                      bottom: 0,

                                      right: 0,

                                    )

                                  ],

                                ),

                                Text('Add story',style: TextStyle(color: Colors.black),)

                              ],

                            );

                          }



                          int i = index - 1;

                          return Padding(

                            padding: EdgeInsets.all(8.0),

                            child: Column(



                              children: [

                                ProfileImage(urlImage: stories[i].imagebrand, onPress: () {

                                  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) {

                                    return StoryPage(uid:stories[i].uid,branduid: stories[i].branduid, story: stories[i],);

                                  }));

                                }, imagesize: 25),

                                Text(stories[i].brandname, style: TextStyle(color: Colors.black),),

                              ],

                            ),

                          );

                        }

                    ),

                  ),

                ),

              ),

              SliverList(
                delegate: SliverChildBuilderDelegate(
                        (context,index){
                       Post p=Post(snapshot.data!.docs[index]);
                       if(members.isEmpty){
                         print("member emty");
                         FirebaseHandler.firestoreCollection.doc(p.memberId).snapshots().listen((event) {
                           Member member =Member(event);
                           setState(() {
                             members.add(member);
                             print(members.length);
                           });
                         });
                         FirebaseHandler.firestoreCollection.doc(p.memberId).collection("Brands").doc(p.branduid).snapshots().listen((event) {
                           Brand brand=Brand(event);
                           setState(() {
                             brandPost.add(brand);
                           });

                         });
                         return Container();
                       }


                      return PostTile(post:p, mpostowner:members[index],member: widget.member,isDetail: true,brand:brandPost[index],);

                    },

                    childCount: snapshot.data!.docs.length

                ),

              )

            ],

          ),

        );
      }else{
        print("no data");
        return Container();
      }
    }


),

   );
  }




  takepicture(ImageSource source)async{
    final imagepath=await ImagePicker().getImage(source: source,maxWidth: 500,maxHeight: 500);
    final file =File(imagepath!.path);
    if(file!=null)
    globalKey.currentState!.showBottomSheet((context) =>WritePage(uid: widget.member.uid,file: file,));
  }
}



