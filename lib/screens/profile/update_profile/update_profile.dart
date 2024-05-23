import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';
import 'package:olly_chat/screens/profile/components/custom_text_input.dart';
import 'package:olly_chat/screens/profile/components/divider.dart';
import 'package:olly_chat/theme/colors.dart';

// ignore: must_be_immutable
class UpdateUserScreen extends StatelessWidget {
  final String userId;
  final String dp;

  UpdateUserScreen({super.key, required this.userId, required this.dp});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    print(dp);
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state is UpdateUserInfoSuccess) {
          print("success");
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: Colors.white),
              child: const Text("Cancel"),
            ),
            const SizedBox(
              width: 4,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  side: BorderSide(
                    width: 1.0,
                    color: AppColors.primaryColor,
                  )),
              onPressed: () async {
                final updates = {
                  'name': _nameController.text,
                  'handle': _usernameController.text,
                };
                context
                    .read<UpdateUserInfoBloc>()
                    .add(UpdateMyUser(userId, updates));
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text(
                      'Profile details changed successfully. Pull to refresh',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );

                Navigator.pop(context);
              },
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : const Text("Save "),
            ),
          ],
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [

                Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 60,
            backgroundColor: Colors.white,
            backgroundImage: dp != null
                ? NetworkImage(dp)
                : NetworkImage(
                    'https://cdn1.iconfinder.com/data/icons/user-pictures/101/malecostume-512.png',
                  ) as ImageProvider,
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: (){
                

              },
              child: CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.secondaryColor,
                child: Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    )
                // CircleAvatar(
                //   radius: 60,
                //   backgroundColor: Colors.white,
                //   backgroundImage: NetworkImage(dp ??
                //       'https://cdn1.iconfinder.com/data/icons/user-pictures/101/malecostume-512.png'),
                // ),
               , CustomTextInput(
                  controller: _nameController,
                  text: "Display Name",
                ),
                SizedBox(height: 2.h),
                CustomTextInput(
                    controller: _usernameController, text: "Username"),
                SizedBox(height: 2.h),
                CustomTextInput(
                    controller: _descriptionController, text: "Description"),
                SizedBox(height: 2.h),
                DividerWidget(),
                SizedBox(height: 2.h),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Social Handles',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 19.dp),
                    )),
                     SizedBox(height: 2.h),
                     CustomTextInput(
                    controller: _descriptionController, text: "WhatsApp"),
                     SizedBox(height: 2.h),
                     CustomTextInput(
                    controller: _descriptionController, text: "Instagram"),
                     SizedBox(height: 2.h),
                     CustomTextInput(
                    controller: _descriptionController, text: "X (Formerly Twitter)"),
          
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
