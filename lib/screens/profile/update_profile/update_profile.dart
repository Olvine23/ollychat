import 'dart:io';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';
import 'package:olly_chat/screens/profile/components/custom_text_input.dart';
import 'package:olly_chat/screens/profile/components/divider.dart';
import 'package:olly_chat/theme/colors.dart';

class UpdateUserScreen extends StatefulWidget {
  final String userId;
  final String dp;
  final String bio;
  final String name;
  final String handle;

  UpdateUserScreen({super.key, required this.userId, required this.dp, required this.bio, required this.name, required this.handle});

  @override
  _UpdateUserScreenState createState() => _UpdateUserScreenState();
}

class _UpdateUserScreenState extends State<UpdateUserScreen> {
  late TextEditingController _nameController = TextEditingController();
  late TextEditingController _usernameController = TextEditingController();
  late TextEditingController _descriptionController = TextEditingController();
  bool loading = false;
  File? _profileImage;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        aspectRatioPresets: [CropAspectRatioPreset.square],
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Theme.of(context).colorScheme.primary,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),
          IOSUiSettings(title: 'Cropper'),
        ],
      );
      if (croppedFile != null) {
        setState(() {
          _profileImage = File(croppedFile.path);
        });
        // Trigger the bloc event to upload the image
        context.read<UpdateUserInfoBloc>().add(UploadPicture(croppedFile.path, widget.userId));
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _descriptionController = TextEditingController(text: widget.bio);
    _usernameController = TextEditingController(text: widget.handle);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        if (state is UpdatePictureSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text(
                'Profile picture updated successfully.',
                style: TextStyle(color: Colors.white),
              ),
            ),
          );
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
            const SizedBox(width: 4),
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
                  'bio':_descriptionController.text
                };
                context.read<UpdateUserInfoBloc>().add(UpdateMyUser(widget.userId, updates));
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
                  : const Text("Save"),
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
                        backgroundImage: _profileImage != null
                            ? FileImage(_profileImage!)
                            : NetworkImage(widget.dp) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: InkWell(
                          onTap: _pickImage,
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: AppColors.secondaryColor,
                            child: const Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                CustomTextInput(
                  lines: 1,
                  controller: _nameController,
                  text: "Display Name",
                ),
                SizedBox(height: 2.h),
                CustomTextInput(
                    controller: _usernameController, text: "Username", lines: 1,),
                SizedBox(height: 2.h),
                CustomTextInput(
                    controller: _descriptionController, text: "Description", lines: 2,),
                SizedBox(height: 2.h),
                const DividerWidget(),
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
                    controller: _descriptionController, text: "WhatsApp", lines: 1,),
                SizedBox(height: 2.h),
                CustomTextInput(
                    controller: _descriptionController, text: "Instagram", lines: 1,),
                SizedBox(height: 2.h),
                CustomTextInput(
                    controller: _descriptionController, text: "X (Formerly Twitter)", lines: 1,),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
