import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:user_repository/user_repository.dart';

class BookMarkScreen extends StatelessWidget {
  const BookMarkScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      
      create: (context) => MyUserBloc(myUserRepository: FirebaseUserRepo())..add(LoadBookmarkedPosts(FirebaseAuth.instance.currentUser!.uid)),
      child: Scaffold(
        body:  BlocBuilder<MyUserBloc, MyUserState>(
          builder:(context, state){
            if(state.status == MyUserStatus.loading){
              return Center(child: CircularProgressIndicator(),);

            } else if (state.status == MyUserStatus.success && state.bookmarkedPosts != null){

               return ListView.builder(
                itemCount: state.bookmarkedPosts!.length,
                itemBuilder: (context, index) {
                  final post = state.bookmarkedPosts![index];
                  return ListTile(
                    title: Text(post.title),
                    subtitle: Text(post.body!),
                  );
                },
              );
            }else if (state.status == MyUserStatus.failure) {
              return Center(child: Text('Failed to load bookmarked posts'));
            } else {
              return Container();
            }

          })
      ),
    );
  }
}
