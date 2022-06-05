import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/pages/PostPage.dart';
import 'package:social_network_ecommerce/utilities/Card.dart';
import 'package:social_network_ecommerce/utilities/Components.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/widgets/circle_button.dart';

import '../constant.dart';
import '../utilities/Post.dart';
class CartPage extends StatefulWidget {
  Member member;
  CartPage({required this.member});

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late TrackingScrollController controller;
  late List<CardMarket> cardlist=[];
  late StreamSubscription subscription;
  double Total=0.0;
  List<Post> recommendePosts=[];

  List<Member> membersowner=[];

  @override
  void initState() {
    // TODO: implement initState
    controller=TrackingScrollController();
    takeCard(widget.member.uid);

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    getTotal(cardlist);

    takeRecommende();
    return Scaffold(
      body: CustomScrollView(
        controller:controller ,
        slivers: [
          SliverAppBar(
            leading:iconleading(context),
            title: Text("Card"),
          ),
          SliverPadding(padding: EdgeInsets.symmetric(vertical: 10),
            sliver: SliverToBoxAdapter(
              child: Card(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    (cardlist.length>0)?Text("Total  ",style: TextStyle(
                      fontSize: 20,

                    )):Container(),
                    (cardlist.length>0)?Text(rupee+Total.toString(),style: TextStyle(
                      fontSize: 20,

                    ),):Container(),



                  ],
                ),
              ),
            ),
          ),


          SliverList(

             delegate: SliverChildBuilderDelegate(

                 (context,index){
                   return ProductTile(cardlist[index]);
                 },
               childCount: cardlist.length

             )
          ),

          SliverToBoxAdapter(child: Text("Recommended"),),
          SliverGrid(delegate:SliverChildBuilderDelegate(
              (ctx,index){
                return showPostinBrand(index);
                             },childCount: recommendePosts.length
          ) , gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,

          ),)
          



        ],
      ),
      bottomNavigationBar: Container(

        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12,offset: Offset(0,0),blurRadius:20,spreadRadius: 1.5)
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                primary: Colors.red
              ),
                onPressed: (){
                cardlist.forEach((element) {
                  element.reference.delete();
                });
               setState(() {
                 cardlist.clear();
               });

                }, icon: Icon(Icons.delete), label: Text("Delete All"))
            ,ElevatedButton.icon(
                style: ElevatedButton.styleFrom(primary: Colors.green),
                onPressed: (){}, icon: Icon(Icons.shopping_cart), label: Text("Buy"))
          ],
        ),
      ),
    );
  }
  takeRecommende(){
print(recommendePosts);
List<Post> post_rec=[];
    cardlist.forEach((cardmarket) {

      cardmarket.recommended.forEach((element) {

       final value=element.split("/");
       final ref=FirebaseHandler.firestoreCollection.doc(value[1]).collection(value[2]).
        doc(value[3]).collection(value[4]).doc(value[5]);
       ref.snapshots().listen((event) {
         Post post=Post(event);
         post_rec.add(post);
         setState(() {
           recommendePosts=post_rec;

         });

       });
      // print(recommendePosts);




      });



     });
  }
  takeMemberowner(){

    List<Member> members=[];
    recommendePosts.forEach((element) {
      String uid=element.memberId;
      FirebaseHandler.firestoreCollection.doc(uid).snapshots().listen((event) {
        Member member=Member(event);
        members.add(member);
        setState(() {
          membersowner.add(member);
        });
      });
    });
  }
  Widget showPostinBrand(int i){
    Post posts=recommendePosts[i];
    takeMemberowner();
    return  Container(
      height: 100,
      width: 60,
      child: GestureDetector(
        onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (ctx){

          return PostPage(member: widget.member, mpownerpost:membersowner[i], post: posts);
        }

        )),
        child: Container(
          width:80,
          height: 100,
          padding: const EdgeInsets.all(8.0),

          child: Column(

            children: [
              Container(
                height: 80,
                child: Image.network(posts.imageUrl,fit: BoxFit.cover,),),
              Container(
                  width:50,
                  height: 20,
                  child: Center(child: Text(posts.title,))),
              Text(posts.price.toString()+rupee)

            ],
          ),
        ),
      ),
    );


  }
  Widget ProductTile(CardMarket cardMarket){

    return Container(
      child:
        Card(
          child:Row(
            crossAxisAlignment:CrossAxisAlignment.start,
            children: [
              Image.network(cardMarket.image,height: 150,width:150,),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: RichText(
                      text: TextSpan(
                         children: [
                           TextSpan(text: cardMarket.title,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15,color: Colors.black))
                         ]
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom:10.0),
                    child: Text("x"+cardMarket.number.toString(),style: TextStyle(fontSize: 20),),
                  ),
                  Text(rupee+cardMarket.price.toString()),
                  Row(
                    children: [
                      CircleButton(
                        iconSize: 30,
                          onPressed: (){
                        setState(() {
                          if(cardMarket.number>1)
                          cardMarket.reference.update({"Number":cardMarket.number-1});


                         });
                      }, icon: Icons.remove),
                      CircleButton(
                        icon:Icons.add,
                        onPressed: (){
                          setState(() {
                            cardMarket.reference.update({"Number":cardMarket.number+1});

                          });
                        },
                        iconSize: 20,
                      ),


                    ],

                  ),
                  ElevatedButton.icon(

                    onPressed: (){
                      if(cardlist.length==1){
                        setState(() {
                          cardlist.clear();
                        });
                      }
                      cardMarket.reference.delete();
                    }, icon: Icon(Icons.delete), label: Text("Remove"),
                  )

                ],
              )
            ],
          ) ,
        ),

    );
  }
  getTotal(List<CardMarket> cardmarket){
    var total=0.0;

    cardmarket.forEach((element) {
      total=total+element.price*element.number;
    });
   setState(() {
     Total=total;
   });
  }
  takeCard(String uid){
    List<CardMarket> card=[];
   subscription= FirebaseHandler.firestoreCollection.doc(uid).collection("Card").snapshots().listen((event) {
   cardlist.clear();
   event.docs.forEach((element) {
     CardMarket market=CardMarket(element);

     card.add(market);
     setState(() {
       cardlist=card;
     });

   });

    });
  }

}
