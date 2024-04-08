import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class WritersContainer extends StatelessWidget {
  const WritersContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:  const EdgeInsets.symmetric(horizontal:  16.0),
      child: Column(
        children: [
         const  CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage('https://avatars.githubusercontent.com/u/53298501?v=4'),
          ),
          const SizedBox(height: 8,),
          Text("Olvine", style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),)
        ],
      ),
    );
  }
}