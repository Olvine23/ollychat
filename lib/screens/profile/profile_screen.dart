import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        //  implement listener
        if(state is UpdatePictureSuccess) {
					setState(() {
					  context.read<MyUserBloc>().state.user!.image = state.userImage;
					});
				}
      },
      child: Scaffold(
      appBar: AppBar(
						centerTitle: false,
						elevation: 0,
						backgroundColor: Theme.of(context).colorScheme.background,
						title: BlocBuilder<MyUserBloc, MyUserState>(
							builder: (context, state) {
								if(state.status == MyUserStatus.success) {
                   
                  
									return Row(
										children: [
											state.user!.image == ""
												? GestureDetector(
														onTap: () async {
															final ImagePicker picker = ImagePicker();
															final XFile? image = await picker.pickImage(
																source: ImageSource.gallery,
																maxHeight: 500,
																maxWidth: 500,
																imageQuality: 40
															);
															if (image != null) {
																CroppedFile? croppedFile = await ImageCropper().cropImage(
																	sourcePath: image.path,
																	aspectRatio: const CropAspectRatio(
																		ratioX: 1, 
																		ratioY: 1
																	),
																	aspectRatioPresets: [
																		CropAspectRatioPreset.square
																	],
																	uiSettings: [
																		AndroidUiSettings(
																			toolbarTitle: 'Cropper',
																			toolbarColor: Theme.of(context).colorScheme.primary,
																			toolbarWidgetColor:Colors.white,
																			initAspectRatio: CropAspectRatioPreset.original,
																			lockAspectRatio: false
																		),
																		IOSUiSettings(
																			title: 'Cropper',
																		),
																	],
																);
																if(croppedFile != null) {
																	setState(() {
																		context.read<UpdateUserInfoBloc>().add(
																			UploadPicture(
																				croppedFile.path,
																				context.read<MyUserBloc>().state.user!.id
																			)
																		);
																	});
																}
															}
														},
														child: Container(
																width: 50,
																height: 50,
																decoration: BoxDecoration(
																	color: Colors.grey.shade300,
																	shape: BoxShape.circle
																),
																child: Icon(
																	Icons.person, 
																	color: Colors.grey.shade400
																),
															),
													)
												: Container(
														width: 50,
														height: 50,
														decoration: BoxDecoration(
															color: Colors.red,
															shape: BoxShape.circle,
															image: DecorationImage(
																image: NetworkImage(
																	state.user!.image!,
																),
																fit: BoxFit.cover
															)
														),
													),
											const SizedBox(width: 10),
											Text(
												state.user!.name
											)
										],
									);
								} else {
									return Container();
								}
							},
						),
						actions: [
							IconButton(
								onPressed: () {
									context.read<SignInBloc>().add( SignOutRequired());
								}, 
								icon: Icon(
									Icons.logout,
									color: Theme.of(context).colorScheme.onBackground,
								)
							)
						],
					),
        body: Center(
          child: Text("Profile screen"),
        ),
      ),
    );
  }
}
