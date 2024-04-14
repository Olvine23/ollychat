import 'package:flutter/material.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/theme/colors.dart';

class RowTile extends StatelessWidget {
  const RowTile({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        child: Row(
          children: [
            Container(
                height: 150,
                width: 180,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: const DecorationImage(
                        image: NetworkImage(
                            'https://images.unsplash.com/photo-1712334627388-8ef7423ac180?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxlZGl0b3JpYWwtZmVlZHwzNXx8fGVufDB8fHx8fA%3D%3D'),
                        fit: BoxFit.cover)),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      ),
                )),
    
                SizedBox(width: 16.dp,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Title", style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontWeight: FontWeight.bold, fontSize: 18),),
                    SizedBox(height: 8,),
                    Row(
                      children: [
                        CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.primaryColor,
             
            ),
            SizedBox(width: 4.dp,),
            Text(
                  'Writers',
                  
                  textAlign: TextAlign.justify,
                  style: Theme.of(context)
                      .textTheme
                      .bodySmall!
                      .copyWith(
                        fontWeight: FontWeight.bold),
                ),
                      ],
                    ),
                    SizedBox(height: 8,),
                    Row(
    
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("2 days ago"),
                        SizedBox(width: 16.dp,),
                        Container(
                          child: 
                          Row(
                           
                            children: [
                            Icon(Icons.bookmark)
                          ]),
                        )
                      ],
                    )
                  ],
                ),
          ],
        ),
      ),
    );
  }
}
