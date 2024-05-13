import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:olly_chat/theme/colors.dart';

class ImageContainer extends StatelessWidget {
  final String imageUrl;
  final double height;
  final double width;
  final String textOverlay;

  const ImageContainer({
    Key? key,
    required this.imageUrl,
    this.height = 180,
    this.width = 180,
    this.textOverlay = 'Hello Writer',
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl),
        ),
      ),
      child: Stack(
        children: [
          // Image
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: ColorFiltered(
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0),
                  BlendMode.srcOver,
                ),
                // child: CachedNetworkImage(
                //   imageUrl:  imageUrl,
                //    key: UniqueKey(),
                //    maxHeightDiskCache: 100,
                //    fit: BoxFit.cover,
                //   errorWidget: (context, url, error) => Icon(Icons.error),
                // ),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),

          Positioned(
            top: 5,
            right: 10,
            child: Container(
              decoration: BoxDecoration(
                  color: AppColors.secondaryColor, shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(Icons.bookmark_outline, color: Colors.white),
                onPressed: () {
                  // Handle bookmark action
                },
              ),
            ),
          ),
          // Text Overlay (Left Center)
          Positioned(
            bottom: 4,
            left: 20,
            child: Text("Hello", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),))
        ],
      ),
    );
  }
}
