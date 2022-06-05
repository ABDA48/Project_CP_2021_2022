import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/pages/PostPage.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/date_Handler.dart';
import 'package:social_network_ecommerce/utilities/notifiction_model.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';
class NotificationPage extends StatefulWidget {
  Member member;
  NotificationPage({required this.member});

  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  late StreamSubscription subscription;
  late List<Notifications> notificationList;
  late List<Notifications> notificationListintact;
  late List<Member> comMember=[];
 late TrackingScrollController controller;
 late TextEditingController editingController;

  String fromwhom="";
  String from="";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=TrackingScrollController();
    notificationList=[];
    comMember=[];
    notificationListintact=[];
    editingController=TextEditingController();
    takenotifications();

  }
  /*
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Expanded(child:ListView.builder(
                  itemCount: notificationList.length,
                  itemBuilder: (context,index){

                return Container(
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,

                  ),
                  child: ListTile(
                    onTap: (){
                      DocumentReference ref=notificationList[index].aboutRef;
                      ref.snapshots().listen((event) {
                        Post post=Post(event);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context){
                          return PostPage(member: widget.member, mpownerpost: widget.member, post: post);
                        }));
                      });
                    },
                    leading: ProfileImage(onPress: (){},urlImage:widget.member.Imageurl,imagesize: 20,),
                    title: TitleFrom(notificationList[index].userId,notificationList[index].text),
                    subtitle:  Text(notificationList[index].date),
                    trailing: IconType(notificationList[index].type),

                  ),
                );
              }) ),
            ],
          ),
        ),
      ),
    );
  }

   */
  Widget IconType(String type){
    switch(type){
      case Commentnotif:
        return IconButton(onPressed: (){}, icon:comment);
      case Likenotif:
        return IconButton(onPressed: (){}, icon: likeIcon);
      default:
        return Container(height: 0,width: 0,);
    }

  }
  Widget TitleFrom(String fromwhom,String text){

    return RichText(
      text: TextSpan(text: fromwhom,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
      children: [
        TextSpan(text: "  "+text,style: TextStyle(color: Colors.black,fontWeight: FontWeight.normal))
      ]
      ),

    );
  }
  From(String uid){
    String fromw="";
    FirebaseHandler.firestoreCollection.doc(uid).snapshots().listen((event) {
      Member m=Member(event);
      fromw=m.name;
      setState(() {
        from=fromw;
      });
    });

  }
  takenotifications(){
    List<Notifications> notifications=[];
    subscription= FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Notifications").snapshots().listen((event) {
      event.docs.forEach((element) {
        Notifications notif=Notifications(element);
        notifications.add(notif);
        setState(() {
          notificationList=notifications;
          notificationListintact=notifications;
          getnotifowner(notificationList);
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: controller,
      slivers: [
        SliverAppBar(
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title:Text("Notification",
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
        SliverPadding(padding: EdgeInsets.all(8),
        sliver: SliverToBoxAdapter(
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
          ),
        ),
        ),
        SliverList(delegate: SliverChildBuilderDelegate(
            (context,index){
              return Container(
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.white,

                ),
                child: ListTile(
                  onTap: (){
                    var value=notificationList[index].refProduct.split("/");

                    DocumentReference ref=FirebaseHandler.firestoreCollection.doc(value[0]).collection("Brands")
                    .doc(value[1]).collection("Posts").doc(value[2]);

                    ref.snapshots().listen((event) {
                      Post post=Post(event);
                      Navigator.of(context).push(MaterialPageRoute(builder: (context){
                        return PostPage(member: widget.member, mpownerpost: widget.member, post: post);
                      }));
                    });


                  },
                  leading: ProfileImage(onPress: (){},urlImage:notificationList[index].image,imagesize: 20,),
                  title: TitleFrom(notificationList[index].name,notificationList[index].text),
                  subtitle:  Text(notificationList[index].date),
                  trailing: Container(
                    width: MediaQuery.of(context).size.width*0.2,
                    child: Row(
                      children: [
                        IconType(notificationList[index].type),
                        sentimentWidget(notificationList[index].sentiment)
                      ],
                    ),
                  ),

                ),
              );
            },
          childCount: notificationList.length
        ))
      ],
    );

  }
Widget sentimentWidget(String sentiment){
    return (sentiment=="Positive")?  happy:  angry;

}
  getnotifowner(List<Notifications> notif) async{
    List<Member> mem=[];
    print("uid");
    notif.forEach((element) {
      FirebaseHandler.firestoreCollection.doc(element.userId).snapshots().listen((event) {
        Member m = Member(event);
        print("=>");
        mem.add(m);
        setState(() {
          comMember=mem;

        });
      });
    });
  }
  search(String query){
    List<Notifications> notifications=[];
    List<Notifications> notificationsfr=
    notificationList.where((element){
      From(element.userId);
      return from.toLowerCase().contains(query.toLowerCase());
    }).toList();
    notifications=(query=="")?notificationListintact:notificationsfr;
    setState(() {
      notificationList=notifications;
    });
    if(query==""){
      notificationList=notificationListintact;
    }
  }
}

