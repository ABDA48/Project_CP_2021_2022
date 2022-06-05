import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/Controller/firebasecontroller.dart';
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/pages/AddpostPage.dart';
import 'package:social_network_ecommerce/pages/HeaderDelegate.dart';
import 'package:social_network_ecommerce/pages/PostEditPage.dart';
import 'package:social_network_ecommerce/utilities/AlertHelper.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/BtnCreator.dart';
import 'package:social_network_ecommerce/utilities/Header_Delegate.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/ProfileHeader.dart';
import 'package:social_network_ecommerce/utilities/date_Handler.dart';
import 'package:social_network_ecommerce/utilities/postTile.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';

import 'BrandAnalysisPage.dart';
import 'PoductPageAnalysis.dart';
class BrandPostPage extends StatefulWidget {

  Brand brand;
  Member member;
   BrandPostPage({required this.member,required this.brand});

  @override
  _BrandPostPageState createState() => _BrandPostPageState();

}

class _BrandPostPageState extends State<BrandPostPage> {
  late StreamSubscription subscription;
  late TrackingScrollController controller;
  String uidAuth=FirebaseHandler.firebaseAuth.currentUser!.uid;
  late  List<Post> postlist=[];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller=TrackingScrollController();
    takePostFrom(widget.member.uid,widget.brand.documentId);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();


  }
  @override
  Widget build(BuildContext context)  {
    print(uidAuth);
    FirebaseHandler.firestoreCollection.doc(widget.brand.uid).collection("Brands").doc(widget.brand.documentId).snapshots().listen((event) {
      Brand b=Brand(event);
      setState(() {
        widget.brand=b;
      });
    });
    return Scaffold(
    body: CustomScrollView(
      controller: controller,
      slivers: [
        SliverAppBar(
          leading: IconButton(icon: Icon(Icons.arrow_back,color: Colors.black,),onPressed: ()=>Navigator.pop(context),),
          title: Text("Brand",style: TextStyle(color: Colors.black26),),backgroundColor: Colors.white,
        actions: [
          PopupMenuButton(
          icon: Icon(Icons.more_vert,color: Colors.black,),

    itemBuilder: (ctx)=>[
      PopupMenuItem(
        child: GestureDetector(
          child: Row(
            children: [
              Icon(Icons.edit,color: Colors.black,),
              Text("Show Analysis")
            ],
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          ),
          onTap: ()=>Navigator.of(context).push(MaterialPageRoute(builder: (_)=>BrandAnalysisPage(member:widget.member,brand: widget.brand,)))

        )),
      
    ]),
        ],
        ),
        SliverPadding(padding: EdgeInsets.all(10),
        sliver: SliverToBoxAdapter(
          child: HeaderSliver(postlist.length),
        ),
        ),
        SliverPadding(padding: EdgeInsets.all(2),
          sliver: SliverToBoxAdapter(
            child:Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BtnCreator(name: "Add Post", onPress: (){
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext ctx){
                    return PostCreatePage(uid:widget.member.uid,uidbrand: widget.brand.documentId);
                  }));
                }),

                ElevatedButton.icon(onPressed: (){

                  FirebaseHandler().addFollowBrand(widget.brand);
                }, icon:Icon(Icons.face), label: (widget.brand.followers.contains(uidAuth))?Text("Unfollow"):Text("follow"))

              ],
            ),

          ),
        ),
        SliverList(delegate: SliverChildBuilderDelegate(
            (context,index){
               return brandPost(postlist[index],widget.member,);
            },
          childCount: postlist.length

        ))

      ],
    ),
      );

  }
  Widget brandPost(Post post,Member mpownerpost){
    return Container(
      child: Card(
        elevation: 0,
        child: Padding(
          padding: EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                leading: ProfileImage(urlImage:mpownerpost.Imageurl, onPress: (){}, imagesize: 40,) ,
                title: Text('  ${mpownerpost.Username} ${mpownerpost.name}'),
                subtitle:Text('${DateHandler().myDate(post.date)}') ,
                trailing: PopupMenuButton(
                  itemBuilder: (ctx)=>[
                    PopupMenuItem(
                        child: GestureDetector(
                            child: Row(
                              children: [
                                Icon(Icons.edit,color: Colors.black,),
                                Text("Show Analysis")
                              ],
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            ),
                            onTap: (){

                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx){
                                FirebaseHandler.firestoreCollection.doc(post.memberId).collection("Brands")
                                    .doc(post.branduid).collection("Posts").doc(post.documentId).snapshots().listen((event) {
                                   setState(() {
                                     post=Post(event);
                                   });
                                });

                                return ProductAnalysis(post: post,);
                              }));
                            }

                        )),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title:Text("Edit") ,
                        onTap: ()=>Navigator.push(context,MaterialPageRoute(builder: (ctx)=>PostEditPage(post: post,member:mpownerpost ,))),
                      ),

                    ),
                    PopupMenuItem(
                      child: ListTile(
                        leading: Icon(Icons.delete),
                        title:Text("Delete") ,
                        onTap: (){
                          alertWidget(post);
                        },

                      ),

                    )
                  ],
                ),
              ),

              Divider(),
              Text(post.title),
              ImagePost(context,post),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(onPressed: (){
                    FirebaseHandler().addlikes(mpownerpost.uid,post,FirebaseHandler.firebaseAuth.currentUser!.uid);

                  },
                      icon:(post.likes.contains(FirebaseHandler.firebaseAuth.currentUser!.uid)?likeIcon:unlike)),

                  Text("${post.likes.length} likes"),
                  IconButton(onPressed: (){
                    //  AlertHelper().writeAcomment(context, post: widget.post, controller: TextEditingController(), member: widget.member);
                  }, icon: (post.comments.length==0)?comment:commentw),
                  Text("${post.comments.length} comments"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(post.description),
              )
            ],
          ),
        ),
      ),
    );
  }
alertWidget(Post post) async{
    switch(await showDialog(context: context, builder: (ctx){
      return AlertDialog(
        title: Text("Confiramtion"),
        content: Text("Are you sure to delete this post"),
        actions: [
          ElevatedButton(onPressed: ()=>Navigator.pop(context,"cancel"), child: Text("cancel")),
          ElevatedButton(onPressed: ()=>Navigator.pop(context,"submit"), child: Text("submit")),

        ],
      );
    })){
      case "cancel":
        break;
      case "submit":
        final _ref=FirebaseHandler.firestorageinstance.child(widget.member.uid).child("Post").child(post.branduid).child(post.documentId);
        _ref.delete();
        FirebaseHandler.firestoreCollection.doc(widget.member.uid).collection("Brands")
            .doc(post.branduid).collection("Posts").doc(post.documentId).delete();
        Navigator.pop(context);
        break;
    }
}

  Widget HeaderSliver(int i){

    return Column(
      children: [

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ProfileImage(urlImage: widget.brand.image,imagesize: 60, onPress: (){}),
            ),
            textColumn("Posts",i.toString()),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: textColumn("Followers",widget.brand.followers.length.toString()),
            ),

          ],
        )
      ],
    );
  }

takePostFrom(String uid,String uidbrand){
    List<Post> p=[];
  subscription= FirebaseHandler.firestoreCollection.doc(uid).collection("Brands").doc(uidbrand).collection("Posts").snapshots().listen((event) {
    event.docs.forEach((element) {
      Post post=Post(element);

      p.add(post);
      setState(() {
        postlist=p;
      });
    });
  });
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


  Widget textColumn(String title,String value){
    return Column(
      children: [
        Text(title),
        Text(value)
      ],
    );
  }




}
