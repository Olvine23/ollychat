// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:olly_chat/screens/home/components/top-card.dart';
// import 'package:post_repository/post_repository.dart';
// import 'package:olly_chat/screens/home/widgets/article_card.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:user_repository/user_repository.dart';
// import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
// import 'package:olly_chat/screens/poems/poem_detail.dart';

// class HomeCarousel extends StatelessWidget {
//   final List<Post> posts;

//   const HomeCarousel({super.key, required this.posts});

//   @override
//   Widget build(BuildContext context) {
//     return CarouselSlider.builder(
//       itemCount: posts.length > 5 ? 5 : posts.length,
//       options: CarouselOptions(
//         autoPlay: true,
//         enlargeCenterPage: true,
//         aspectRatio: 16 / 9,
//         viewportFraction: 0.8,
//         enlargeStrategy: CenterPageEnlargeStrategy.height,
//       ),
//       itemBuilder: (context, index, realIdx) {
//         final post = posts[index];
//         return GestureDetector(
//           onTap: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(
//                   builder: (context) => BlocProvider<MyUserBloc>(
//                         create: (context) =>
//                             MyUserBloc(myUserRepository: FirebaseUserRepo()),
//                         child: PoemDetailScreen(post: post),
//                       )),
//             );
//           },
//           child: TopCard(post,)
//         );
//       },
//     );
//   }
// }
