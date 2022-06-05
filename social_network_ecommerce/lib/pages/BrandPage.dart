import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/utilities/BtnCreator.dart';
import 'package:social_network_ecommerce/utilities/Components.dart';
import 'package:social_network_ecommerce/utilities/ProfileHeader.dart';
import 'dart:io';

import '../constant.dart';
import '../services/takebrandRecommended.dart';
class BrandPage extends StatefulWidget {
  String uid;
BrandPage({required this.uid});

  @override
  _BrandPageState createState() => _BrandPageState();
}

class _BrandPageState extends State<BrandPage> {
  late File _Image;
  bool forimage=false;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController=TextEditingController();
    _descriptionController=TextEditingController();

  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Create Brand',style: TextStyle(color: Colors.blue),)),backgroundColor: Colors.white,),
      body: SingleChildScrollView(
        child: Container(
            child: Column(
              children: [

                CreatEditor(_nameController, "Write the name of the brand", "Brand"),
                Text('Image'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    IconButton(onPressed: (){takepicture(ImageSource.camera);}, icon: camera),
                    IconButton(onPressed: (){takepicture(ImageSource.gallery);}, icon: library),
                  ],
                ),
                Container(
                  height: MediaQuery.of(context).size.height*0.3,
                  width: MediaQuery.of(context).size.width*0.3,

                  child: !forimage?Text('Aucun Image'):Image.file(_Image),
                ),
                CreateDescription(_descriptionController,"Description","Write your description "),
                TextButton(
                    onPressed: () {
                      sendtofirebase();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                              Radius.circular(10))
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 50),
                        child: Text('Submit', style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),),
                      ),
                    ))
              ],
            ),
        ),
      ),
    );
  }

  takepicture(ImageSource source)async{
    final imagepath=await ImagePicker().getImage(source: source,maxWidth: 500,maxHeight: 500);
    final file =File(imagepath!.path);
    setState(() {
      _Image=file;
      forimage=true;
    });
  }

  sendtofirebase(){
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.pop(context);
    if((_Image!=null)||(_nameController.text!="" && _descriptionController.text!="")){
      FirebaseHandler().addBrandToStorage(widget.uid, _Image,_nameController.text,_descriptionController.text);
  }
  }

}
