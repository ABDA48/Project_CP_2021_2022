
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/pages/CommentPage.dart';
import 'package:social_network_ecommerce/pages/PostPage.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/PostContent.dart';


class PostTile extends StatefulWidget {

  late Post post;
  late Member mpostowner;
  late Member member;
  bool isDetail=false;
  late Brand brand;
  PostTile({required this.post,required this.mpostowner,required this.member,required this.isDetail,required this.brand});

  @override
  _PostTileState createState() => _PostTileState();
}

class _PostTileState extends State<PostTile> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        if(widget.isDetail){
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext ctx){
          return PostPage(member: widget.member,post: widget.post,mpownerpost:widget.mpostowner ,);
         }));
        }
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 0),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                PostContent(post: widget.post, brand:widget.brand),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    IconButton(onPressed: (){
                      FirebaseHandler().addlikes(widget.mpostowner.uid,widget.post,FirebaseHandler.firebaseAuth.currentUser!.uid);

                    },
                       icon:(widget.post.likes.contains(FirebaseHandler.firebaseAuth.currentUser!.uid)?likeIcon:unlike)),

                    Text("${widget.post.likes.length} likes"),
                    IconButton(onPressed: (){
                     Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>CommentPage(member:widget.member, mpownerpost:widget.mpostowner, post:widget.post)));
                    }, icon: (widget.post.comments.length==0)?comment:commentw),
                    Text("${widget.post.comments.length} comments"),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

}
