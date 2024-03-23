import 'package:flutter/material.dart';
import 'package:olly_chat/screens/home/components/image_container.dart';
import 'package:olly_chat/theme/colors.dart';

class Articles extends StatelessWidget {
  const Articles({super.key});

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height / 2 - 95;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: height,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
            itemCount: 12,
            itemBuilder: (context, index) {
              return Container(
                height: height,
                width: MediaQuery.of(context).size.width * 0.5,
                margin: const EdgeInsets.only(right: 15),
                child:  Column(
                   crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ImageContainer(imageUrl: 'https://images.pexels.com/photos/6702446/pexels-photo-6702446.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2'),
                     SizedBox(height: 8,),
                     Text(
                            
                            "Title gets large  veru very ",
                            maxLines: 2,
                            style: Theme.of(context)
                                .textTheme
                                .bodyLarge!
                                .copyWith(fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height:8),

                           GestureDetector(
                             onTap: (){
                                
                             },
                             child: Row(
                               crossAxisAlignment: CrossAxisAlignment.start,
                                
                               children: [
                             
                                  CircleAvatar(
                                     radius: 20,
                                     backgroundColor: AppColors.primaryColor,
                                     backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/53298501?v=4'),
                                   ),
                             
                                
                             
                                    SizedBox(width: 6,),
                                 Expanded(
                                   child: Padding(
                                     padding: const EdgeInsets.only(top: 8.0),
                                     child: Text(
                                     
                                      "Olvine George",
                                      textDirection: TextDirection.ltr,
                                      textAlign: TextAlign.justify,
                                       style: Theme.of(context)
                                           .textTheme
                                           .bodySmall!
                                           .copyWith(fontWeight: FontWeight.bold),
                                     ),
                                   ),
                                 ),
                             
                                  SizedBox(width: 6,),
                             
                                 Expanded(child: Padding(
                                   padding: const EdgeInsets.only(top: 8.0),
                                   child: Text("7 days ago", style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10),),
                                 ))
                                 
                               ],
                             ),
                           ),
                  ],
                ),
              );
            }),
      ),
    );
  }
}
