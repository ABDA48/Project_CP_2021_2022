import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/pages/PostPage.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/ProfileHeader.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';
import 'package:social_network_ecommerce/widgets/circle_button.dart';

import '../services/takebrandRecommended.dart';
import '../utilities/Post.dart';
import 'BrandPostsPage.dart';
class ShopPage extends StatefulWidget {
 Member member;

 ShopPage({required this.member});

  @override
  _ShopPageState createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
 late StreamSubscription subscription;
 List<Brand> brands=[];
 List<Member> MemberBrands=[];
 List<List<Post>> postslist=[];
 List<Brand> brandfollowlist=[];
 List<Member> membersowner=[];
 late  TrackingScrollController controller;
  @override
  void initState() {
    // TODO: implement initState
    controller = TrackingScrollController();
    takeBrands();
    Recommended.TakeRecommended(widget.member.uid);
    takebrandProduct(widget.member.uid);

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: CustomScrollView(
        controller: controller,
        slivers: [
          SliverAppBar(
        brightness: Brightness.light,

        backgroundColor: Colors.white,
            centerTitle: false,

            floating: true,
            title: Text('Shop',style: GoogleFonts.openSans(color: Colors.black,fontSize: 15),),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 5,bottom: 5,left: 10),
            sliver: SliverToBoxAdapter(
              child: Text('Brand followed', style: GoogleFonts.lato(color: Colors.black,fontSize: 15)),
            ),
          ),
          SliverPadding(padding: EdgeInsets.only(top: 0,bottom: 5,left:10),
            sliver: SliverToBoxAdapter(
              child:createRecommended(brands: brandfollowlist,widget: widget,members: membersowner) ,
            ),
          ),
        SliverPadding(padding: EdgeInsets.only(top: 0,bottom: 5,left:10),
        sliver: SliverToBoxAdapter(
          child: Text('Recommended for you',style: GoogleFonts.lato(color: Colors.black,fontSize: 15)),
        ),
        ),
        SliverPadding(padding: EdgeInsets.only(top: 0),
        sliver: SliverToBoxAdapter(
          child:createRecommended(brands: brands,widget: widget,members: MemberBrands) ,
        ),
        ),
          SliverList(delegate: SliverChildBuilderDelegate(
              (ctx,index)=>Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(brandfollowlist[index].name,style: GoogleFonts.lato(color: Colors.black,fontSize: 15)),
                  showPostinBrand(index),
                ],
              ),childCount: brandfollowlist.length,
          ))

        ],
      ),
    );
  }

  Widget showPostinBrand(int i){
    List<Post>posts=postslist[i];
    takeMemberowner();
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Container(
        height: MediaQuery.of(context).size.height*0.25,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) =>Container(

          child: GestureDetector(
            onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (ctx){

              return PostPage(member: widget.member, mpownerpost:membersowner[i], post: posts[index]);
            }

            )),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(

                children: [
                  Container(
                      width:80,
                      height: 120,
                      child: Image.network(posts[index].imageUrl,fit: BoxFit.contain,),),
                  Container(
                      width:80,
                      height:15,
                      child: Center(child: Text(posts[i].title,))),
                  Text(posts[index].price.toString()+rupee)

                ],
              ),
            ),
          ),
        ),itemCount:posts.length , ),
      ),
    );
  }

takeBrands(){
 List<dynamic> brandsdocument=widget.member.brands;
 brandsdocument.forEach((element) {
   DocumentReference reference=element;
   reference.snapshots().forEach((element) {
     Brand brand=Brand(element);
     setState(() {
       brandfollowlist.add(brand);
     });
   });
   reference.collection("Posts").snapshots().listen((event) {

     List<Post> posts=[];
     for(int i=0;i<event.docs.length-1;i++){
       Post post=Post(event.docs[i]);
       posts.add(post);
     }

     setState(() {

       postslist.add(posts);
     });


   });

 });

}
takeMemberowner(){

    List<Member> members=[];
    brandfollowlist.forEach((element) {
      String uid=element.uid;
      FirebaseHandler.firestoreCollection.doc(uid).snapshots().listen((event) {
        Member member=Member(event);
        members.add(member);
        setState(() {
          membersowner.add(member);
        });
      });
    });
}

  takebrandProduct(String uid){

    
    List<Brand> bra=[];
    List<Member> members=[];
    
    FirebaseHandler.firestoreCollection.doc(uid).collection("Recommendation").limit(10)
        .snapshots().listen((event) {
         event.docs.forEach((element) {
           Brand brand=Brand(element);

           bra.add(brand);
           setState(() {
             brands=bra;

           });
           FirebaseHandler.firestoreCollection.doc(brand.uid).snapshots().listen((event) {
             Member member=Member(event);
             members.add(member);
             setState(() {
               MemberBrands=members;

             });
           });
         });
    });

  }

}


class createRecommended extends StatelessWidget {
  const createRecommended({
    Key? key,
    required this.brands,
    required this.widget,
    required this.members,

  }) : super(key: key);

  final List<Brand> brands;
  final ShopPage widget;
  final List<Member> members;


  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height*0.15,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemBuilder: (context,index)=>Container(
        child: Column(
          children: [
            Container(
                height: 30,
                child: ProfileImage(urlImage: brands[index].image,onPress:(){
                 Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                   print(members);
                  return  BrandPostPage(member: members[index],brand: brands[index],);
                 }));
                },imagesize: 20, ) ,
            ),
            Text(brands[index].name),

          ],
        ),
      ),
        itemCount: brands.length,),


    );
  }
}