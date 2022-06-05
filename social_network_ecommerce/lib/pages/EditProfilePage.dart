import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:firebase_storage/firebase_storage.dart' as Storage;
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';
class EditProfilePage extends StatefulWidget {
  Member member;
    EditProfilePage({required this.member});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late StreamSubscription subscription;
  late TextEditingController controller;
  late Member OnlineMember=widget.member;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=TextEditingController();
    takeMember(widget.member.uid);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: ()=>Navigator.pop(context),),
        title: Center(child: Text('Edit Profile',style: TextStyle(color: Colors.blue),)),backgroundColor: Colors.white,),
      body: Container(
        child: Column(
          children: [
               Container(
                 child: ProfileImage(urlImage: OnlineMember.Imageurl,onPress: (){
                   takepicture(ImageSource.gallery);
                 },imagesize: 50,),
               ),
               Center(
                 child: TextButton(onPressed: (){
                   takepicture(ImageSource.camera);
                 }, child: Row(
                   mainAxisSize: MainAxisSize.min,
                   children: [
                     Text('take picture'),
                     IconButton(onPressed: (){}, icon:camera )
                   ],
                 )),
               ),
               TexttoChange("Name :",OnlineMember.name,"name"),
                TexttoChange("Username :",OnlineMember.Username,"Username"),
                TexttoChange("Description :",OnlineMember.Description,"Description"),
            TextButton(onPressed: (){}, child: Text("Do you want to change the password ?"))
             
          ],
        ),
      ),
    );
  }
  takeMember(String uid){
    subscription=FirebaseHandler.firestoreCollection.doc(uid).snapshots().listen((event) {
      Member member=Member(event);
      setState(() {
        OnlineMember=member;
      });
    });
  }
  Widget TexttoChange(String text,String value,String type){
    return  ListTile(
      leading: Text(text),
      title:Text(value),
      trailing: TextButton(onPressed: (){Changement(type);},child: Text("change"),),
    );
  }
  changeImage(File image) async{
    final ref=FirebaseHandler.firestorageinstance.child(widget.member.uid).child("Profile");
    Storage.UploadTask uploadTask=ref.putFile(image);
    Storage.TaskSnapshot snapshot= await uploadTask.whenComplete(() => null);
    String url=await snapshot.ref.getDownloadURL();
    FirebaseHandler.firestoreCollection.doc(widget.member.uid).update({ImageKey:url});
  }
  takepicture(ImageSource source)async{
    final imagepath=await ImagePicker().getImage(source: source,maxWidth: 500,maxHeight: 500);
    final file =File(imagepath!.path);
    if(file!=null){
      changeImage(file);
    }
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
       FirebaseHandler.firestoreCollection.doc(widget.member.uid).update({type:controller.text});
       break;
   }
  }
}
