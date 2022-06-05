import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/utilities/Components.dart';
import 'package:social_network_ecommerce/utilities/ProfileHeader.dart';

import '../constant.dart';
class PostCreatePage extends StatefulWidget {
  String uidbrand;
  String uid;
   PostCreatePage({required this.uid,required this.uidbrand});

  @override
  _PostCreatePageState createState() => _PostCreatePageState();
}

class _PostCreatePageState extends State<PostCreatePage> {
  late File _Image;
  bool forimage=false;
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _nameController=TextEditingController();
    _descriptionController=TextEditingController();
    _priceController=TextEditingController();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Heading(text: "Create Post"),
              CreatEditor(_nameController, "Write the title of the Post", "Title"),
              Text('Image'),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(onPressed: (){takepicture(ImageSource.camera);}, icon: camera),
                  IconButton(onPressed: (){takepicture(ImageSource.gallery);}, icon: library),
                ],
              ),
              BuildImage(),
              Text("Add images"),

              CreateDescription(_descriptionController, "Description", "Write some description of your post/product "),
              CreatEditorPrice(_priceController, "Write the price of the Product", "Price"),
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
  Widget BuildImage(){
    if (forimage) {
      return Image.file(_Image);
    } else {
      return Container();
    }
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
    if((_Image!=null)||(_nameController.text!="" && _descriptionController.text!=""&& _priceController.text!="")){
      String textinput=_priceController.text;

      FirebaseHandler().addPostintoBrand(widget.uid, widget.uidbrand, _nameController.text,
          _descriptionController.text,int.parse(textinput), _Image);
    }
  }

  Widget CreatEditorPrice(TextEditingController controller,String hint,String label){
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
        ),
        child: TextFormField(
           keyboardType: TextInputType.number,
          controller: controller,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly
          ],
          decoration: InputDecoration(

              hintText: hint,
              labelText: label,
              border:OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10)
              )
          ),),
      ),
    );

  }
}
