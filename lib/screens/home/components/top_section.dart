import 'package:flutter/material.dart';
 
class TopSection extends StatelessWidget {
  const TopSection({
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
            Image.asset('assets/images/nobg.png',height: 100,),
           
            Row(
              children: [
                IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.bookmark_added_outlined,
                      size: 30,
                      
                    )),
                // user!.photoURL != null
                //     ? CircleAvatar(
                //         backgroundImage: AssetImage('assets/images/vid.png'),
                //       )
                //     : CircleAvatar(
                //         backgroundImage: AssetImage('assets/images/vid.png'),
                //       ),
                SizedBox(
                  width: 10,
                ),
                Icon(Icons.notifications_outlined, size: 30),

                  SizedBox(
                  width: 10,
                ),

                Icon(Icons.settings_outlined, size: 30),


              ],
            ),
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
