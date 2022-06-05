import 'package:flutter/material.dart';
import 'package:social_network_ecommerce/utilities/Brands.dart';
import 'package:social_network_ecommerce/utilities/Member.dart';
import 'package:social_network_ecommerce/utilities/ProfileHeader.dart';
import 'package:social_network_ecommerce/utilities/profileImage.dart';

class HeaderAppDelegate extends SliverPersistentHeaderDelegate{
  late bool scrolled;
  late Member member;
  late Brand brand;
  HeaderAppDelegate({
    required this.member ,
    required this.scrolled});
  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
   return HeaderSliver();
  }
  Widget textColumn(String title,String value){
    return Column(
      children: [
        Text(title),
        Text(value)
      ],
    );
  }

  Widget HeaderSliver(){
    return Column(
      children: [
        Heading(text: brand.name),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ProfileImage(urlImage: brand.image,imagesize: 60, onPress: (){}),
            ),
            textColumn("Post",brand.post),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: textColumn("Followers",brand.followers.length.toString()),
            ),

          ],
        )
      ],
    );
  }

  @override
  // TODO: implement maxExtent
  double get maxExtent => (scrolled?150:200);

  @override
  // TODO: implement minExtent
  double get minExtent => (scrolled?150:200);

  bool shouldRebuild(HeaderAppDelegate oldDelegate)=>scrolled!=oldDelegate.scrolled||member!=oldDelegate.member;


}