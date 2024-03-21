import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text("VoiceHub Pro"),
        actions: [
          IconButton(onPressed: (){
            context.read<SignInBloc>().add(SignOutRequired());
          }, 
          icon: const Icon(Icons.logout_outlined))
        ],

      ),
      body: Center(child: Text("Welcome home"),),
    );
  }
}