// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lottie/lottie.dart';

class ArticleCover extends StatelessWidget {
  final String categ;
  final String image;
  final dynamic stateCount;

  const ArticleCover({super.key, required this.categ, required this.image, this.stateCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      child: Stack(
        children: [
          CachedNetworkImage(
            imageUrl: image,
            placeholder: (context, url) =>
                Center(child: Lottie.asset('assets/lotti/imageload.json')),
            errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
            imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: imageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.black.withOpacity(0.7), Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
