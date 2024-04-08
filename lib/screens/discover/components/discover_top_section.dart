import 'package:flutter/material.dart';
import 'package:olly_chat/screens/bookmarks/bookmark.dart';
import 'package:olly_chat/screens/notifications/notification_screen.dart';
import 'package:olly_chat/screens/settings/settings.dart';
import 'package:olly_chat/theme/colors.dart';
 
class DiscoverTopSection extends StatelessWidget {
  const DiscoverTopSection({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
  
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Image.asset('assets/images/nobg.png',height: 100,),
                Text("Discover", style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize:20
                ),)
              ],
            ),
           
            IconButton(
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return BookMarkScreen();
                  }));
                },
                icon: Icon(
                  Icons.bookmark_added_outlined,
                  size: 30,
                  color: AppColors.secondaryColor,
                  
                )),
            // Icon(Icons.notifications_outlined, size: 30)
            // CircleAvatar(
            //   backgroundImage: NetworkImage(user!.photoURL!),
            // )
            // ignore: prefer_const_constructors
            // CircleAvatar(
            //   backgroundImage: NetworkImage(
            //       'https://cdn.icon-icons.com/icons2/1378/PNG/512/avatardefault_92824.png'),
            // )
          ],
        ),
 ],
    );
  }
}
