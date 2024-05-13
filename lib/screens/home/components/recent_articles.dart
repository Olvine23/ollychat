// import 'package:flutter/material.dart';
// import 'package:olly_chat/screens/home/widgets/article_card.dart';

// class Articles extends StatelessWidget {
//   const Articles({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final height = MediaQuery.of(context).size.height / 2 - 90;
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: SizedBox(
//         height: height,
//         child: ListView.builder(
//             scrollDirection: Axis.horizontal,
//             itemCount: 12,
//             itemBuilder: (context, index) {
//               return ArticleCard(
//                 articleimg:
//                     'https://images.pexels.com/photos/6702446/pexels-photo-6702446.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=2',
//                 author: 'Olvine George',
//                 authorImg:
//                     'https://avatars.githubusercontent.com/u/53298501?v=4',
//                 daysago: '7 days ago', title: 'Title',
//               );
//             }),
//       ),
//     );
//   }
// }
