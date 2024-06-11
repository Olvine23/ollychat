import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lottie/lottie.dart';
import 'package:olly_chat/blocs/create_post/create_post_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/screens/poems/add_poem_screen.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';
import 'package:shimmer/shimmer.dart';

class CustomBottomSheet extends StatefulWidget {
  final VoidCallback onModalClosed;

  const CustomBottomSheet({super.key, required this.onModalClosed});

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyUserBloc, MyUserState>(builder: (context, state) {
      if (state.status == MyUserStatus.success) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Write an article',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'How would you like to write your piece ?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.grey[300], // Background color
                      ),
                      onPressed: () async{
                          var newPost = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BlocProvider<CreatePostBloc>(
                            create: (context) => CreatePostBloc(
                                postRepositry: FirebasePostRepository()),
                            child: AddPoemScreen(state.user!),
                          );
                        }));

                        if (newPost != null) {
                          setState(() {
                            context
                                .read<GetPostBloc>()
                                .state
                                .posts!
                                .insert(0, newPost);
                          });
                        }
                      },
                      child: Text(
                        'Write with AI? ',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Theme.of(context)
                            .colorScheme
                            .primary, // Background color
                      ),
                      onPressed: () async {
                        var newPost = await Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return BlocProvider<CreatePostBloc>(
                            create: (context) => CreatePostBloc(
                                postRepositry: FirebasePostRepository()),
                            child: AddPoemScreen(state.user!),
                          );
                        }));

                        if (newPost != null) {
                          setState(() {
                            context
                                .read<GetPostBloc>()
                                .state
                                .posts!
                                .insert(0, newPost);
                          });
                        }
                      },
                      child: Text(
                        'Don\'t use AI',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        );
      } else {
        return Shimmer.fromColors(
          baseColor: const Color(0xffdedad7),
          highlightColor: Colors.white54,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xfff5f5f5),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    width: double.infinity,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 14,
                    color: Colors.grey[300],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 100,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                      Container(
                        width: 100,
                        height: 40,
                        color: Colors.grey[300],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      }
    });
  }
}
