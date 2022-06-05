

import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';
import 'package:social_network_ecommerce/utilities/story.dart';
class StoryPage extends StatefulWidget {
  late String branduid;
  late Story story;
  late String uid;
  StoryPage({required this.uid,required this.branduid,required this.story});

  @override
  _StoryPageState createState() => _StoryPageState();
}

class _StoryPageState extends State<StoryPage> {
  late  TextEditingController controller;
   double progress=0.0;
   late Timer _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=TextEditingController();
    startTimer();
  }
  void startTimer(){
    _timer=Timer.periodic(Duration(milliseconds: 20), (timer) {
      setState(() {
        progress+=0.01;
        if(progress>1){
           Navigator.pop(context);
           _timer.cancel();
        }
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(widget.story.content,),fit: BoxFit.cover
        ),
      ),
        child: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LinearProgressIndicator(
                  value: progress,
                ),
              ),
              ListTile(
                leading: ProfileImage(urlImage:widget.story.imagebrand,onPress: (){},imagesize: 20,),
                title: Text(widget.story.brandname,style: TextStyle(color: Colors.white),),
                subtitle:Text(widget.story.date,style: TextStyle(color: Colors.white),) ,
                trailing: IconButton(onPressed: (){},icon: Icon(Icons.more_vert),),
              ),


            ],
          ),
        ),
      ),

    );
  }

}
