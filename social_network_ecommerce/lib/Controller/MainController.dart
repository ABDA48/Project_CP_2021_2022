import 'dart:async';

import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/pages/HomePage.dart';
import 'package:social_network_ecommerce/pages/NotificationPage.dart';
import 'package:social_network_ecommerce/pages/Profilepage.dart';
import 'package:social_network_ecommerce/pages/ShopPage.dart';
import 'package:social_network_ecommerce/pages/WritePage.dart';
import 'package:social_network_ecommerce/pages/loadingPage.dart';
import 'package:social_network_ecommerce/utilities/BarItem.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';

import '../constant.dart';
class MainController extends StatefulWidget {

  String uid;
  MainController({required this.uid});



  @override
  _MainControllerState createState() => _MainControllerState();
}

class _MainControllerState extends State<MainController> {
  late StreamSubscription subscription;
  late bool listen=false;
  late Member member;
  int index=0;
  GlobalKey<ScaffoldState> globalKey=GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listen=false;
    print("false");
    subscription=FirebaseHandler.firestoreCollection.doc(widget.uid).snapshots().listen((event) {
      setState(() {
        member=Member(event);
        listen=true;
        print("true");
      });

    });
  }
  @override
  void dispose() {
    // TODO: implement dispose
    subscription.cancel();
  }

  @override
  Widget build(BuildContext context) {
    if (listen==false){
      return Loading();
    }else{
      return Scaffold(
        key: globalKey,
        body:selectPage(),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: Icon(MdiIcons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_basket),
              label: 'Shop',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notification',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            )
          ],
          currentIndex: index,
          onTap: setbottomIndex,
          selectedItemColor: Colors.pinkAccent,
          selectedFontSize: 15.0,


        ),

      );
    }
  }
  void setbottomIndex(int ind){
    setState(() {
      index=ind;
    });

  }
  Widget selectPage(){
    switch(index){
      case 0:return HomePage(member: member,);
      case 1:return ShopPage(member: member,);
      case 2:return NotificationPage(member: member);
      case 3:return ProfilePage(member: member);
      default:return HomePage(member: member,);
    }
  }
}

