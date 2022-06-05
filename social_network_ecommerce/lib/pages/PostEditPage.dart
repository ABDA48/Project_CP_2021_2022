import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/utilities/Components.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:firebase_storage/firebase_storage.dart' as Storage;

import '../constant.dart';

class PostEditPage extends StatefulWidget {
  Post  post;
  Member member;
  PostEditPage({required this.post,required this.member});


  @override
  _PostEditPageState createState() => _PostEditPageState();
}

class _PostEditPageState extends State<PostEditPage> {
  late TextEditingController controller;
  late Post postSubscribed=widget.post;
 late StreamSubscription subscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=TextEditingController();
    takePost();
  }
  takePost(){
    subscription=FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Brands")
        .doc(widget.post.branduid).collection("Posts").doc(widget.post.documentId).snapshots().listen((event) {
          Post post=Post(event);
          setState(() {
            postSubscribed=post;
          });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: ()=>Navigator.pop(context),),
        title: Text("Post Edit",style: TextStyle(color: Colors.black),),),
      body: SingleChildScrollView(
        child: Container(
          child: Column(

            children: [
              ListTile(
                leading: Text("Title"),
                title: Text(postSubscribed.title),
                trailing: IconButton(onPressed: ()=>Changement(titleKey),icon: Icon(Icons.edit),),
              ),
              ImagePost(context, postSubscribed),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(onPressed: ()=>takepicture(ImageSource.gallery), icon:Icon(Icons.photo)),
                  IconButton(onPressed: ()=>takepicture(ImageSource.camera), icon: camera)
                ],
              ),
              ListTile(
                leading: Text("Price"),
                title: Text(postSubscribed.price.toString()),
                trailing: IconButton(onPressed: ()=>Changement(priceKey),icon: Icon(Icons.edit),),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(leading: Text("Description "),trailing: IconButton(onPressed: ()=>Changement(PostdescriptionKey),icon: Icon(Icons.edit),),)
                  ,Text(postSubscribed.description)

                ],
              )

            ],
          ),
        ),
      ),
    );
  }

  takepicture(ImageSource source)async{
    final imagepath=await ImagePicker().getImage(source: source,maxWidth: 500,maxHeight: 500);
    final file =File(imagepath!.path);
    if(file!=null){
      changeImage(file);
    }
  }
  changeImage(File image) async{
    final _ref=FirebaseHandler.firestorageinstance.child(widget.member.uid).child("Post").child(widget.post.branduid).child(widget.post.documentId);
    _ref.delete();
    final ref=FirebaseHandler.firestorageinstance.child(widget.member.uid).child("Post").child(widget.post.branduid).child(widget.post.documentId);
    Storage.UploadTask uploadTask=ref.putFile(image);
    Storage.TaskSnapshot snapshot= await uploadTask.whenComplete(() => null);
    String url=await snapshot.ref.getDownloadURL();
    FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Brands")
        .doc(widget.post.branduid).collection("Posts").doc(widget.post.documentId).update({ImagePostKey:url});
  }
  Future<void> Changement(String type) async{
    switch(await showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        title: Text("Change "+type),
        content: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Change "+type,
            labelText: type,
          ),
        ),
        actions: [
          TextButton(onPressed: (){Navigator.pop(context,'cancel');}, child: Text('cancel')),
          TextButton(onPressed: (){Navigator.pop(context,'submit');}, child: Text('submit'))
        ],
      );
    })){
      case 'cancel':

        break;
      case 'submit':
        if(controller.text!="")
          print(controller.text);
          FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Brands")
              .doc(widget.post.branduid).collection("Posts").doc(widget.post.documentId).update({type:controller.text});
        break;
    }
  }
}
