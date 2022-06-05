import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/PostContent.dart';
import 'package:social_network_ecommerce/utilities/text_Editor.dart';

class AlertHelper{
  Future<void> disconnect(BuildContext context) async{
    Text title=Text("Do you want to disconnect ?");
    return showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(title:title ,actions: [close(context, "NO"),notconnect(context,"YES")],);
    });
  }
  Widget close(BuildContext context,String string){
    return TextButton(
      onPressed: () { Navigator.pop(context); },
      child: Text(string),
    );
  }
  TextButton notconnect(BuildContext context,String string){
    return TextButton(onPressed: (){Navigator.pop(context);
    FirebaseHandler().logout();
    }, child: Text(string));
  }

  Future<void> changeUser(
      BuildContext context,
      {required Member member,
        required TextEditingController name,
        required TextEditingController surname,
        required TextEditingController desc})async{
    MyTextEditor namete=MyTextEditor(textController: name,hintText: member.name,);
    MyTextEditor surnamete=MyTextEditor(textController: surname,hintText: member.Username,);
    MyTextEditor descte=MyTextEditor(textController: desc,hintText: (member.Description!=""&&member.Description!=null)?member.Description:"Aucune description");
    Text text=Text("Modification de donnee");
    return showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        title: text,
        content: Column(
          children: [
            namete,surnamete,descte
          ],
        ),
        actions: [close(context, "Annuler"),
          TextButton(onPressed: (){
            Map<String,dynamic> map={};
            if(name.text!=""){
              map[nameKey]=name.text;
            }
            if(surname.text!=""){
            //  map[UsernameKey]=surname.text;
            }
            if(desc.text!=""){
              map[DescriptionKey]=desc.text;
            }
           // FirebaseHandler().modifyMember(map, member.uid);
            Navigator.pop(context);
          }, child:Text("Valider")),
        ],
      );
    }
    );
  }
  Future<void>writeAcomment(BuildContext context,{required  Post post,required TextEditingController controller,required Member member}) async{
    MyTextEditor myTextEditor= MyTextEditor(textController: controller, hintText: "Comments");
    Text title=Text('Nouveau Commentaire');
    return showDialog(context: context, builder: (BuildContext ctx){
      return AlertDialog(
        title: title,
        content:SingleChildScrollView(
          child: Column(
            children: [
             // PostContent(member:member ,post: post,) ,
              myTextEditor,
            ],
          ),
        ),
        actions: [
          close(context, "Annuler"),
          TextButton(onPressed: (){
          //  FirebaseHandler().addComment(post, controller.text);
            Navigator.pop(context);
          }, child: Text('Envoyer'))
        ],
      );
    });
  }
}