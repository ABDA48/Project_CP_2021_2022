import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/validator.dart';

Widget buildHeader(String str) {
  return Text(str,style: TextStyle(fontSize: 40,
    color: Colors.white,
  ),);
}

Widget CreatEditor(TextEditingController controller,String hint,String label){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.white,
      ),
      child: TextFormField(
        validator: (value)=>(value!.isEmpty)?"fill form":null,
        controller: controller,
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
Widget CreatEmail(TextEditingController controller,String hint,String label){
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color: Colors.white,
      ),
      child: TextFormField(
        validator: (value){
          if(value!.isEmpty){
            return "Please Enter Email";
          }else if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
            return "Please Enter a valid Email";
          }
          return null;
        },
        controller: controller,
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
Widget CreateDescription(TextEditingController controller,String label,String hint){
  return  Container(
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: Colors.white
    ),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder()
      ),
      maxLines: 10,
    ),
  );
}
ImagePost(BuildContext context,Post post){
  if(post.imageUrl!=null&&post.imageUrl!=""){
    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),

        ),
        child:Image.network(post.imageUrl,fit: BoxFit.none,),
      ),
    );
  }else{
    return  Container(height: 0,width: 0,);

  }
}

Widget iconleading(BuildContext context){
  return   IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: ()=>Navigator.pop(context),);
}
