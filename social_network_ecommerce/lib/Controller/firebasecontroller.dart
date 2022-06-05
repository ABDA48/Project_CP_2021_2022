
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as Storage;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_network_ecommerce/constant.dart';
import 'package:social_network_ecommerce/services/takebrandRecommended.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Buy.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/Post.dart';
import 'package:social_network_ecommerce/utilities/date_Handler.dart';
import 'package:social_network_ecommerce/utilities/story.dart';
import 'package:path/path.dart' as Path;

class FirebaseHandler{
 static final   fireinstance=FirebaseFirestore.instance;
 static final googleSingin=GoogleSignIn();
 static final firebaseAuth=FirebaseAuth.instance;
 static final firestorageinstance=FirebaseStorage.instance.ref();
static final firestoreCollection=fireinstance.collection('Users');
List<dynamic> ImageList=[];

Future<User?> SingIn({required String email,required String password}) async{
try {
  final userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, password: password);
  final u = userCredential.user;
  return u;
}on FirebaseAuthException catch(e){

}


  }


Future <User?> SingUp({required String uname,required String email,required String name,required String password}) async{

    final userCredential=await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email, password: password);

  final user=userCredential.user;
  Map <String,dynamic> map=
  {
      uidKey:user!.uid,
      unameKey:uname,
      nameKey:name,
      emailKey:email,
    passwordKey:password,
    ImageKey:"",
    followingKey:[],
    DescriptionKey:"",
    brandKey:[],
    postTotalKey:"0",

      };
  addUserToFirestore(map);
  return user;
}
addUserToFirestore( Map <String,dynamic> map)  {
  firestoreCollection.doc(map[uidKey]).set(map);
}

addBrandToStorage(String uid,File image,String name,String description) async{
 Map<String,dynamic> map={
   uidKey:uid,
   brandNameKey:name,
   brandDescriptionKey:description,
   brandfollowersKey:[uid],
   PosttotalKey:"0",

 };
 if(image!=null){
   final ref=firestorageinstance.child(uid).child("Brand").child(name);
   Storage.UploadTask uploadTask=ref.putFile(image);
   Storage.TaskSnapshot snapshot= await uploadTask.whenComplete(() => null);
String url=await snapshot.ref.getDownloadURL();
map[imageBrandKey]=url;
print(url);
print(map);
   firestoreCollection.doc(uid).collection("Brands").add(map);
   addBrandTofirestore(name,uid);
   firestoreCollection.doc(uid).update({followingKey:FieldValue.arrayUnion(addBrandtoFollowing(uid))});

 }else{
   firestoreCollection.doc(uid).collection("Brands").doc().set(map);
   addBrandTofirestore(name,uid);
   addBrandtoFollowing(uid);
   firestoreCollection.doc(uid).update({followingKey:FieldValue.arrayUnion(addBrandtoFollowing(uid))});
 }
}
 addBuyer(String uid,Post post,String Address){
  Map<String,dynamic> map={
    "Address":Address,
    "Buyeruid":uid,
    "Description":post.description,
    "branduid":post.branduid,
    "uid":post.memberId,
    "date":DateHandler().toMyDate(takeDate()),
    "price":post.price
  };
   
  firestoreCollection.doc(post.memberId).collection("Brands").doc(post.branduid)
  .collection("Buy").doc().set(map);
  firestoreCollection.doc(post.memberId).collection("Buy").add(map);

 }
addBrandTofirestore(String name,String uid){
    DocumentReference ref=firestoreCollection.doc(uid);
    ref.update({brandKey:FieldValue.arrayUnion([name])});

}
addStoryMessage(String message,Story story){
    DocumentReference ref=firestoreCollection.doc(story.uid).collection("Brands").doc(story.branduid).
  collection("Stories").doc(story.documentId);
    ref.update({ MessageKey:FieldValue.arrayUnion([message])});
}
addBrandtoFollowing(String uid){
    List<String> branduid=[];
  firestoreCollection.doc(uid).collection("Brands").snapshots().listen((event) {
    event.docs.forEach((element) {
      Brand b=Brand(element);
      String buid=b.documentId;
      branduid.add(buid);
    });

  });
  return branduid;
}
 takeDate(){
   return DateTime.now().millisecondsSinceEpoch;

 }
addFollowBrand(Brand b){
    String uid=firebaseAuth.currentUser!.uid;
    print(b.documentId);
    //Some emprovement required


        DocumentReference ref=firestoreCollection.doc(b.uid).collection("Brands").doc(b.documentId);

        if(b.followers.contains(uid)){
          print(ref);
          ref.update({brandfollowersKey:FieldValue.arrayRemove([uid])});
          firestoreCollection.doc(uid).update({"Brand":FieldValue.arrayRemove([ref])});
          firestoreCollection.doc(uid).update({followingKey:FieldValue.arrayRemove([b.documentId])});
        }else{

          ref.update({"Follower":FieldValue.arrayUnion([uid])});
          firestoreCollection.doc(uid).update({"Brand":FieldValue.arrayUnion([ref])});
          firestoreCollection.doc(uid).update({followingKey:FieldValue.arrayUnion([b.documentId])});
          print(followingKey);
        }





}

 logout(){
   FirebaseAuth.instance.signOut();
 }

addPostintoBrand(String uid,String uidbrand,String name,String description,int price,File image) async{
  int date=DateTime.now().millisecondsSinceEpoch.toInt();
  List<dynamic> likes=[];
  List<dynamic> Comment=[];
  List<dynamic> Commentuid=[];

    Map<String,dynamic> map={
    uidKey:uid,
    branduidKey:uidbrand,
    namePostKey:name,
    PostdescriptionKey:description,
    priceKey:price,
      DateKey:date,
      likeKey:likes,
      commentKey:Comment,
      commentuidKey:Commentuid,

  };
  if(image!=null){
    final ref= firestorageinstance.child(uid).child(uidbrand).child("Post").child(Path.basename(image.path));
    Storage.UploadTask uploadTask=ref.putFile(image);
    Storage.TaskSnapshot snapshot= await uploadTask.whenComplete(() => print('complete Upload'));
    String url=await snapshot.ref.getDownloadURL();
    map[ImagePostKey]=url;
     firestoreCollection.doc(uid).collection("Brands").doc(uidbrand).collection("Posts").add(map).then((value) {

       value.snapshots().listen((event) {
         Post post=Post(event);
         map["reference"]=value;

         SendPostToFollower(post.documentId,map,uidbrand,uid);
       });

     }
     );



  }else{
    firestoreCollection.doc(uid).collection("Brands").doc(uidbrand).collection("Posts").add(map);
  }
}
Future sendImages(List<File> Images,String uid,String uidbrand,DocumentReference postref) async {

    for(var img in Images){
      final ref= firestorageinstance.child(uid).child("Post").child(Path.basename(img.path));
      Storage.UploadTask uploadTask=ref.putFile(img);
      Storage.TaskSnapshot snapshot= await uploadTask.whenComplete(() => print('complete Upload'));
      String url=await snapshot.ref.getDownloadURL();


    }

}
SendPostToFollower(String postid,Map<String,dynamic> map,String uidbrand,String uid){
  firestoreCollection.doc(uid).collection("Brands").doc(uidbrand).snapshots().listen((event) {
    Brand b=Brand(event);
    List<dynamic> followers=b.followers;
    followers.forEach((element) {
      firestoreCollection.doc(element).collection("Posts").doc(postid).set(map);
    });
  });

}

sendMessage(String branduid,String fuid,String  tuid,String text,String type) async{
    int date=DateTime.now().millisecondsSinceEpoch;
    Map<String,dynamic> map={
      branduidKey:branduid,
      fromuidKey:fuid,
      touidKey:tuid,
      typeKey:type,
      dateKey:date,
    };
    if(text.isNotEmpty){
      map[textKey]=text;
    }
    /*
    if(file!=null){
     final ref= firestorageinstance.child(tuid).child("Brand").child("Chat");
     Storage.UploadTask uploadTask=ref.putFile(file);
     Storage.TaskSnapshot snapshot=await uploadTask.whenComplete(() => null);
     String url=await snapshot.ref.getDownloadURL();
     map[ImageKey]=url;
    }

     */
    firestoreCollection.doc(tuid).collection("Brands").doc(branduid).collection("ChatRoom").add(map);
    
}
addlikes(String uid,Post post,String currentuser){

  DocumentReference ref=post.reference;
  if(post.likes.contains(currentuser)){
    ref.update({likeKey:FieldValue.arrayRemove([currentuser])});
    sendToUsersUnLikes(post,uid,currentuser);
  }else{
    ref.update({likeKey:FieldValue.arrayUnion([currentuser])});
    sendToUsersLikes(post,uid,currentuser);
    firestoreCollection.doc(uid).snapshots().forEach((element) {
      final image=element[ImageKey];
      final name=element[nameKey]+" "+element[unameKey];
    //  sendNotificationTo(uid, currentuser, "Likes",post.ref, Likenotif,image,name);
    });

  }

}

sendToUsersLikes(Post post,String uid,String currentuser){
  firestoreCollection.doc(uid).collection("Brands").doc(post.branduid).snapshots().listen((event) {
    Brand b=Brand(event);
    b.followers.forEach((element) {
      firestoreCollection.doc(element).collection("Posts").doc(post.documentId).update({likeKey:FieldValue.arrayUnion([currentuser])});
    });
  });
}
 sendToUsersUnLikes(Post post,String uid,String currentuser){
   firestoreCollection.doc(uid).collection("Brands").doc(post.branduid).snapshots().listen((event) {
     Brand b=Brand(event);
     b.followers.forEach((element) {
       firestoreCollection.doc(element).collection("Posts").doc(post.documentId).update({likeKey:FieldValue.arrayRemove([currentuser])});
     });
   });
 }

addToCard(Post post,String uid){
    Map <String,dynamic> map={
      imageBrandKey:post.imageUrl,
      postkey:post.documentId,
      titleKey:post.title,
      "Number":1,
      priceKey:post.price,
      recommendedKey:post.recommended,
    };
    firestoreCollection.doc(uid).collection("Card").add(map);
    Map<String,dynamic> body={
      'uid':uid,
      'branduid':post.branduid,
      'postuid':post.documentId
    };
    Recommended.PostRecomendationSystem(body);


}
addComments(String uid,Post post,String currentuser,String comments){
  DocumentReference ref=firestoreCollection.doc(uid).collection("Brands").doc(post.branduid).
  collection("Posts").doc(post.documentId);
  List<dynamic> pcommentuid=post.commentsuid;
  pcommentuid.add(currentuser);
    ref.update({commentuidKey:pcommentuid});
  ref.update({commentKey:FieldValue.arrayUnion([comments])});

  int date=DateTime.now().millisecondsSinceEpoch;
  var refProduct=uid+"/"+post.branduid+"/"+post.documentId;

  Map<String,dynamic> body={'comments':comments,'uid':uid,"branduid":post.branduid,"postuid":post.documentId,'currentuser':currentuser,
  "notif":Commentnotif,"date":date.toString(),"refProduct":refProduct
  };
  Recommended.PostRequestSentiment(body);
  firestoreCollection.doc(currentuser).collection("Posts").doc(post.documentId).update({commentKey:FieldValue.arrayUnion([comments])});

}


sendNotificationTo(String to,String from,String text,
    DocumentReference reference,String type,String image,String name){
   bool seen=false;
   int date=DateTime.now().millisecondsSinceEpoch;

   Map<String,dynamic> map={
     seenKey:seen,
     dateKey:date,
     textKey:text,
     refKeynotif:reference,
     typeKey:type,
     uidKey:from,
     ImageKey:image,
     nameKey:name,
   };
   firestoreCollection.doc(to).collection("Notifications").add(map);
 }

 sendToStories(String uid,String uidbrand,File image) async{
   int date=DateTime.now().millisecondsSinceEpoch;
   List<dynamic> message=[];
   Map<String,dynamic> map={
   uidKey:uid,
   dateKey:date,
   MessageKey:message,
   branduidKey:uidbrand,

   };
  final ref= firestorageinstance.child(uid).child("Brand").child("Stories").child(uidbrand);
   Storage.UploadTask uploadTask=ref.putFile(image);
   Storage.TaskSnapshot snapshot= await uploadTask.whenComplete(() => null);
   String url=await snapshot.ref.getDownloadURL();
   map[ContentKey]=url;
   firestoreCollection.doc(uid).collection("Brands").doc(uidbrand).snapshots().forEach((element) {
     map[ImageKey]=element[imageBrandKey];
     map[brandNameKey]=element[brandNameKey];
     firestoreCollection.doc(uid).collection("Brands").doc(uidbrand).collection("Stories").get().then((value) =>
     value.docs.forEach((element) {
       element.reference.delete();
     })
     );
     firestoreCollection.doc(uid).collection("Brands").doc(uidbrand).collection("Stories").add(map);

   });
 }





}
