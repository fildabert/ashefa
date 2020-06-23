import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CustomAvatar extends StatelessWidget {
  final String picture;
  final double height;
  final double width;

  CustomAvatar({this.picture, this.height, this.width});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: picture,
      imageBuilder: (context, imageProvider) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
        ),
      ),
      placeholder: (context, url) => CircularProgressIndicator(),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }
}
