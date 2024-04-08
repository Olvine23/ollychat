import 'package:flutter/material.dart';

class StackedTextOnImage extends StatelessWidget {
  final String imageUrl;
  final String text;

  const StackedTextOnImage({
    Key? key,
    required this.imageUrl,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // Image
        Positioned(
          child: Container(

            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(imageUrl))

            ) ,
            child: Container(


            )
          ),
        ),
        // Darkened background for text area
        
      ],
    );
  }
}
