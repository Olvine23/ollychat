import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';

class UpdateUserScreen extends StatelessWidget {
  final String userId;

  UpdateUserScreen({required this.userId});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        // TODO: implement listener
        if(state is UpdateUserInfoSuccess){
          print("success");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Update User'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final updates = {
                    'name': _nameController.text,
                    'handle': _emailController.text,
                  };

                  context.read<UpdateUserInfoBloc>().add(UpdateMyUser(userId, updates));
                  Navigator.pop(context);

              

                  
                },
                child: Text('Update'),

              
              ),
            ],
          ),
        ),
      ),
    );
  }
}
