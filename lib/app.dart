import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/app_view.dart';
import 'package:olly_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

class MyApp extends StatelessWidget {
  final UserRepository userRepository;
  final PostRepository postRepository;
  const MyApp(this.userRepository,this.postRepository ,{super.key});
 
  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(create: (_) => AuthenticationBloc(myUserRepository: userRepository),
        
         ),
         RepositoryProvider<GetPostBloc>(create: (_) => GetPostBloc(postRepository: postRepository))
      ], 
      child: const MyAppView());
  }
}

 