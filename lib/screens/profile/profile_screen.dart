import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';
import 'package:olly_chat/components/row_tile.dart';
import 'package:olly_chat/screens/home/widgets/shimmer_widget.dart';
import 'package:olly_chat/screens/poems/poem_detail.dart';
import 'package:olly_chat/screens/profile/components/divider.dart';
import 'package:olly_chat/screens/profile/components/social_handles.dart';
import 'package:olly_chat/screens/profile/update_profile/update_profile.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:shimmer/shimmer.dart';
import 'package:user_repository/user_repository.dart';

class ProfileScreen extends StatefulWidget {

  final String currentUserId;
  final String profileUserId;
  const ProfileScreen({super.key, required this.currentUserId, required this.profileUserId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async{

        BlocProvider.of<MyUserBloc>(context).add(GetMyUser(myUserId: FirebaseAuth.instance.currentUser!.uid));

      },
      child: BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
        listener: (context, state) {
          //  implement listener
          if (state is UpdatePictureSuccess) {
            setState(() {
              context.read<MyUserBloc>().state.user!.image = state.userImage;
            });
          }
        },
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
            appBar: AppBar(
              leading: Image.asset(
                'assets/images/nobg.png',
                height: 100,
              ),
              centerTitle: false,
              elevation: 0,
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Text(
                "Profile ",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      context.read<SignInBloc>().add(SignOutRequired());
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Theme.of(context).colorScheme.onBackground,
                    )),
                IconButton(
                    onPressed: () {
                      context.read<SignInBloc>().add(SignOutRequired());
                    },
                    icon: Icon(
                      Icons.settings,
                      color: Theme.of(context).colorScheme.onBackground,
                    ))
              ],
            ),
            body: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8.dp,
                      ),
                      BlocBuilder<MyUserBloc, MyUserState>(
                        builder: (context, state) {
                          if (state.status == MyUserStatus.success) {
                            return Column(
                              children: [
                                ListTile(
                                  leading: state.user!.image == ""
                                      ? GestureDetector(
                                          onTap: () async {
                                            final ImagePicker picker =
                                                ImagePicker();
                                            final XFile? image =
                                                await picker.pickImage(
                                                    source: ImageSource.gallery,
                                                    maxHeight: 500,
                                                    maxWidth: 500,
                                                    imageQuality: 40);
                                            if (image != null) {
                                              CroppedFile? croppedFile =
                                                  await ImageCropper().cropImage(
                                                sourcePath: image.path,
                                                aspectRatio:
                                                    const CropAspectRatio(
                                                        ratioX: 1, ratioY: 1),
                                                aspectRatioPresets: [
                                                  CropAspectRatioPreset.square
                                                ],
                                                uiSettings: [
                                                  AndroidUiSettings(
                                                      toolbarTitle: 'Cropper',
                                                      toolbarColor:
                                                          Theme.of(context)
                                                              .colorScheme
                                                              .primary,
                                                      toolbarWidgetColor:
                                                          Colors.white,
                                                      initAspectRatio:
                                                          CropAspectRatioPreset
                                                              .original,
                                                      lockAspectRatio: false),
                                                  IOSUiSettings(
                                                    title: 'Cropper',
                                                  ),
                                                ],
                                              );
                                              if (croppedFile != null) {
                                                setState(() {
                                                  context
                                                      .read<UpdateUserInfoBloc>()
                                                      .add(UploadPicture(
                                                          croppedFile.path,
                                                          context
                                                              .read<MyUserBloc>()
                                                              .state
                                                              .user!
                                                              .id));
                                                });
                                              }
                                            }
                                          },
                                          child: Container(
                                            width: 50,
                                            height: 50,
                                            decoration: BoxDecoration(
                                                color: Colors.grey.shade300,
                                                shape: BoxShape.circle),
                                            child: Icon(Icons.person,
                                                color: Colors.grey.shade400),
                                          ),
                                        )
                                      : Container(
                                          width: 50.dp,
                                          height: 50.dp,
                                          decoration: BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                    state.user!.image!,
                                                  ),
                                                  fit: BoxFit.cover)),
                                        ),
                                  title: Text(
                                    state.user!.name,
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyLarge!
                                        .copyWith(
                                            fontSize: 18.dp,
                                            fontWeight: FontWeight.bold),
                                  ),
                                  subtitle:  Text('@${state.user!.handle ?? "handle" }', style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: AppColors.secondaryColor,
                                    fontWeight: FontWeight.bold
                                  ),),
                                  trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor:
                                              AppColors.primaryColor),
                                      onPressed: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                          return BlocProvider<UpdateUserInfoBloc>(
                                            create: (context) => UpdateUserInfoBloc(userRepository: FirebaseUserRepo()),
                                            child: UpdateUserScreen(
                                                userId: state.user!.id),
                                          );
                                        }));
                                      },
                                      child: const Text("Edit")),
                                ),
                              ],
                            );
                          } else if (state.status == MyUserStatus.failure) {
                            return Center(
                              child: Text(state.status.toString()),
                            );
                          }
                          return const Center(child: CircularProgressIndicator());
                        },
                      ),
                      SizedBox(
                        height: 8.dp,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0.dp),
                        child: Column(
                          children: [
                            const DividerWidget(),
                            SizedBox(
                              height: 8.dp,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      "125",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4.dp,
                                    ),
                                    const Text("Articles")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "105",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4.dp,
                                    ),
                                    const Text("Following")
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      "23334",
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium!
                                          .copyWith(fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4.dp,
                                    ),
                                    const Text("Followers")
                                  ],
                                ),
                              ],
                            ),
                            const DividerWidget(),
                            const TabBar(dividerHeight: 0, tabs: [
                              Tab(
                                text: "Articles",
                              ),
                              Tab(
                                text: "About",
                              )
                            ]),
                            Padding(
                              padding: EdgeInsets.only(top: 12.0.dp),
                              child: SizedBox(
                                height: constraints.maxHeight -
                                    kToolbarHeight -
                                    128.dp, // Adjust as needed
                                child: TabBarView(children: [
                                  BlocBuilder<GetPostBloc, GetPostState>(
                                    builder: (context, state) {
                                      if (state.status == GetPostStatus.success) {
                                        return SizedBox(
                                          height:
                                              MediaQuery.of(context).size.height,
                                          child: ListView.builder(
                                            shrinkWrap: true, // Add this line
                                            physics:
                                                const AlwaysScrollableScrollPhysics(), // Add this line
                                            itemCount: state.posts?.length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  // Handle onTap
                                                  Navigator.push(context, MaterialPageRoute(builder: (context){

                                                    return PoemDetailScreen(post: state.posts![index]);
                                                  }));
                                                },
                                                child: RowTile(
                                                  imageUrl: state
                                                      .posts![index].thumbnail!,
                                                  title:
                                                      state.posts![index].title,
                                                  userAvatar: state.posts![index]
                                                      .myUser.image!,
                                                  authorName: state
                                                      .posts![index].myUser.name,
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      } else if (state.status ==
                                          GetPostStatus.unknown) {
                                        return Shimmer.fromColors(
                                          highlightColor: Colors.white54,
                                          baseColor: const Color(0xffdedad7),
                                          child: project_screen_shimmer(context),
                                        );
                                      }
                                      return const Text(
                                          "No data available"); // Handle other states
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 16.0.dp),
                                    child: ListView(
                                      shrinkWrap: true,
                                      physics: AlwaysScrollableScrollPhysics(),
                                      children: [
                                        Text(
                                          "Description",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.dp),
                                        ),
                                        SizedBox(
                                          height: 8.dp,
                                        ),
                                        Text(
                                          "Lorem ipsum dolor sit amet,  t",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge,
                                        ),
                                        SizedBox(
                                          height: 8.dp,
                                        ),
                                        const DividerWidget(),
                                        SizedBox(
                                          height: 8.dp,
                                        ),
                                        Text(
                                          "Social Handles",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.dp),
                                        ),
                                        SizedBox(
                                          height: 8.dp,
                                        ),
                                        const SocialHandles(
                                          icon: FontAwesomeIcons.instagram,
                                          platform: 'instagram',
                                        ),
                                        SizedBox(
                                          height: 8.dp,
                                        ),
                                        const SocialHandles(
                                          icon: FontAwesomeIcons.whatsapp,
                                          platform: 'whatsapp',
                                        ),
                                        SizedBox(
                                          height: 8.dp,
                                        ),
                                        const SocialHandles(
                                          icon: FontAwesomeIcons.x,
                                          platform: 'twitter',
                                        ),
                                        SizedBox(
                                          height: 8.dp,
                                        ),
                                        const DividerWidget(),
                                        Text(
                                          "More Information",
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium!
                                              .copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18.dp),
                                        ),
                                        SizedBox(
                                          height: 4.dp,
                                        ),
                                        const SocialHandles(
                                            icon: FontAwesomeIcons.globe,
                                            platform: 'www.mysite.com')
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
