import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';

class TopCard extends StatelessWidget {
  final Post post;
  final dynamic onTap;
  const TopCard({super.key, required this.post, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return  ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: Stack(
        children: [

          
            // Background Image
              Container(
                height: 200,
                width: double.infinity,
                decoration:  BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(post.thumbnail!), // Replace with your asset or NetworkImage
                    fit: BoxFit.cover,
                  ),
                ),
              ),
      
              
              // Dark overlay
            // Darker overlay only on the left side
Container(
  height: 200,
  width: double.infinity,
  decoration: BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: [
        Colors.black.withOpacity(0.7), // Dark on left
        Colors.transparent, // Fades out to right
      ],
    ),
  ),
),

      
      
               // Content
              Positioned(
                bottom: 20,
                left: 20,
                right: 20,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ), 
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(post.myUser.image!), // Replace with your asset
                          radius: 20,
                        ),
                        const SizedBox(width: 8),
                      Text(
                        post.myUser.name,
                          style: TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton.icon(
                      label: const Text('Read...', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),),
                      icon: Icon(Icons.auto_stories, color: AppColors.secondaryColor,) ,
                      onPressed:onTap,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:AppColors.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    
                    ),
                  ],
                ),
              ),
      
          // Container(
            
          //   height: 90,
          
          // width: double.infinity,
          // decoration: BoxDecoration(
          //   color: AppColors.primaryColor,
          //   borderRadius: BorderRadius.circular(18)
          // ),
          
          // ),
          // Container(
          //   padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          //   child: Row(
          //     children: [
            
          //       CircleAvatar(
          //         maxRadius: 25,
          //         backgroundColor: Colors.white,
          //         child: Icon(Icons.lightbulb, color:AppColors.secondaryColor, size: 30,),
                  
          //         ),
          //         SizedBox(width: 1.8.w,),
          //         Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text("Voice out your thoughts", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.dp),),
          //             ElevatedButton(onPressed: (){}, child: Text("Get Started", style: TextStyle(color: isDark? Colors.white70 : Colors.black),))
          //           ],
          //         )
            
          //     ],
          //   ),
          // ), 
      
          // Positioned(
          //   right: -50,
          //   top: -45,
          //   child: Container(
          //     padding: EdgeInsets.all(30),
          //     decoration: BoxDecoration(
          //       color:Colors.transparent,
          //       shape: BoxShape.circle,
          //       border: Border.all(width: 18, color: AppColors.secondaryColor)
            
            
          //     ),
          //   ),
          // )
      
      
          
      
        ],
      ),
    );
  }
}