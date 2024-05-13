import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';

class imageWidget extends StatelessWidget {
  const imageWidget({
    super.key,
    required this.size,
    required this.widget,
  });

  final Size size;
  final PoemDetailScreen widget;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5 - 5,
      child: CachedNetworkImage(
        imageUrl: widget.post.thumbnail!,
        fit: BoxFit.cover,
        placeholder: (context, url) =>
            Center(child: Lottie.asset('assets/lotti/imageload.json')),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}