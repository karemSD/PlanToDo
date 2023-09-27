// ignore_for_file: constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';

enum ProfileDummyType { Icon, Image, Button }
enum ImageType { Network, Assets, File }

class ProfileDummy extends StatelessWidget {
   final ImageType imageType;
  final ProfileDummyType dummyType;
  final double scale;
  final String? image;
  final Color? color;
  final IconData? icon;

  const ProfileDummy(
      {Key? key,
      required this.imageType,
     
      required this.dummyType,
      required this.scale,
      required this.color,
      this.icon,
      this.image})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

  ImageProvider imageProvider;
    switch (imageType) {
      case ImageType.Network:
        imageProvider = NetworkImage(image!);
        break;
      case ImageType.Assets:
        imageProvider = AssetImage(image!);
        break;
      case ImageType.File:
        imageProvider = FileImage(File(image!));
        break;
     
    }


    return Container(
        width: 40 * scale,
        height: 40 * scale,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: ClipOval(
          child: dummyType == ProfileDummyType.Icon
              ? Icon(Icons.person, color: Colors.white, size: 30 * scale)
              : 
                Image(
                      fit: (scale == 1.2) ? BoxFit.cover : BoxFit.contain,
                      image: imageProvider,
                    )
                 
        ),);
  }
}
