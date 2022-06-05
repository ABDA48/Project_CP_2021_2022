import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ProfileImage extends InkWell{
  ProfileImage({
    required String urlImage,
    required VoidCallback onPress,

    required double imagesize,
  }):super(
      onTap: onPress,
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: imagesize,

        backgroundImage: (urlImage!=null && urlImage!="")?CachedNetworkImageProvider(urlImage):AssetImage('Assets/login.png') as ImageProvider,
      )
  );
}