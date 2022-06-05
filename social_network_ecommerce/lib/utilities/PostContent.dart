
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:readmore/readmore.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/date_Handler.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';

import '../constant.dart';
class PostContent extends StatelessWidget {
  late Post post;
  late Brand brand;
  PostContent({required this.post,required this.brand});

  @override
  Widget build(BuildContext context) {
    return  Container(

      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,

        children: [
          ListTile(
      leading:ProfileImage(urlImage:brand.image, onPress: (){}, imagesize: 30,),
            title: Text('  ${brand.name}'),
            subtitle:Text('${DateHandler().myDate(post.date)}') ,
             trailing: Icon(Icons.more_vert),
          ),

          Text(post.title),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(132))
            ),
            child: ImagePost(context),
          ),

         Text(post.description)
        ],
      ),
    );
  }
  ImagePost(BuildContext context){
    if(post.imageUrl!=null&&post.imageUrl!=""){
      return Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height*0.45,

        child:Image.network(post.imageUrl,fit: BoxFit.contain,),

      );
    }else{
      return  Container(height: 0,width: 0,);

    }
  }
  TextPost(){
    if(post.description!=null&&post.description!=""){
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ReadMoreText(
          post.description,
          trimLines: 2,
          colorClickableText: Colors.pinkAccent,
          trimMode: TrimMode.Line,
          trimCollapsedText: 'Show more',
          trimExpandedText: 'Show less',
          moreStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      );
    }else{
      return  Container(height: 0,width: 0,);
    }

  }
}
