// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

class ContainerImage extends StatelessWidget {
  const ContainerImage({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 220,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: const DecorationImage(
              image: NetworkImage(
                  'https://images.unsplash.com/photo-1712334627388-8ef7423ac180?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzNXx8fGVufDB8fHx8fA%3D%3D'),
              fit: BoxFit.cover)),
      child:  Container(
        
        decoration:  BoxDecoration(
          borderRadius: BorderRadius.circular(20),
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
                Text("Category",
                 
                 style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 18.dp, fontWeight: FontWeight.bold)),
                 Text("10 Articles", style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.white, fontSize: 12.dp))
              ],
            ),
          ),
        ),
      )
          
        
      
    );
  }
}