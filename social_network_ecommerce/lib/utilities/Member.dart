import 'package:cloud_firestore/cloud_firestore.dart';

import '../constant.dart';

class Member {
  late String uid;
  late String name;
  late String Username;
  late String email;
  late String password;
  late String Imageurl;
  late List<dynamic>following;
  late List<dynamic>brands;
  late DocumentReference ref;
  late String documentId;
  late String Description;
  late String PostTotal;

  Member(DocumentSnapshot snapshot) {
    ref = snapshot.reference;
    uid = snapshot.id;
    Map<String, dynamic>? datas = snapshot.data() as Map<String, dynamic>?;
    name = datas![nameKey];
    Username = datas[unameKey];
    password = datas[emailKey];
    Imageurl = datas[ImageKey];
    PostTotal=datas[postTotalKey];
    following = datas[followingKey];
    Description = datas[DescriptionKey];

    brands=datas[brandKey];
  }
  Map<String, dynamic> toMap() {
    return {
      uidKey: uid,
      nameKey: name,
      unameKey: Username,
      emailKey: email,
      passwordKey: password,
      ImageKey: Imageurl,
      followingKey: following,
      DescriptionKey: Description,
      postTotalKey:PostTotal
    };
  }
}