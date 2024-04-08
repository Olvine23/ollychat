import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/theme/colors.dart';

class TopCard extends StatelessWidget {
  const TopCard({super.key});

  @override
  Widget build(BuildContext context) {
    return  Stack(
      children: [

        Container(
          
          height: 90,
        
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(18)
        ),
        
        ),
        Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 2.w),
          child: Row(
            children: [
          
              CircleAvatar(
                maxRadius: 25,
                backgroundColor: Colors.white,
                child: Icon(Icons.lightbulb, color:AppColors.secondaryColor, size: 30,),
                
                ),
                SizedBox(width: 1.8.w,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Voice out your thoughts", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16.dp),),
                    ElevatedButton(onPressed: (){}, child: Text("Get Started"))
                  ],
                )
          
            ],
          ),
        ), 

        Positioned(
          right: -50,
          top: -45,
          child: Container(
            padding: EdgeInsets.all(30),
            decoration: BoxDecoration(
              color:Colors.transparent,
              shape: BoxShape.circle,
              border: Border.all(width: 18, color: AppColors.secondaryColor)
          
          
            ),
          ),
        )


        

      ],
    );
  }
}