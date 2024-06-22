// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class HeadImage extends StatelessWidget {
  final String categ;       
  final String image;
  final dynamic stateCount;
  
  const HeadImage({super.key, required this.categ, required this.image, this.stateCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      width: double.infinity,
      decoration: BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
              image: NetworkImage(
                  image),
              fit: BoxFit.cover)
              
              ),
      child:  Container(
        
        decoration:  BoxDecoration(
          // borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(colors: [Colors.transparent, Colors.black],
          
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)
        ),
        child:  Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
          child: Align(
              alignment: Alignment.bottomLeft,
            child: Column(
              mainAxisAlignment:MainAxisAlignment.end,
              children: [
                Text(categ,
                 
                 style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 18.dp, fontWeight: FontWeight.bold)),
                 Text("${stateCount.toString()} Articles", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 12.dp))
              ],
            ),
          ),
        ),
      )
          
        
      
    );
  }
}