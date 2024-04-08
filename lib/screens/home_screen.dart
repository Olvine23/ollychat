import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/create_post/create_post_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';
import 'package:olly_chat/screens/discover/discover_screen.dart';
import 'package:olly_chat/screens/home/main_home.dart';
import 'package:olly_chat/screens/poems/add_poem_screen.dart';
import 'package:olly_chat/screens/profile/profile_screen.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final PageController pageController = PageController(initialPage: 0);

  static const List<Widget> _pages = [
    MainHome(),
    DiscoverScreen(),
   DiscoverScreen(),
    ProfileScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserInfoBloc, UpdateUserInfoState>(
      listener: (context, state) {
        // implement listener
        if (state is UpdatePictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.image = state.userImage;
          });
        }
      },
      child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          floatingActionButton: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if(state.status == MyUserStatus.success){
              return FloatingActionButton(
                  shape: const CircleBorder(),
                  backgroundColor: AppColors.primaryColor,
                  foregroundColor: AppColors.white,
                  child: const Icon(Icons.add),
                  onPressed: () async {
                  var newPost =  await  Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return BlocProvider<CreatePostBloc>(
                        create: (context) => CreatePostBloc(
                            postRepositry: FirebasePostRepository()),
                        child:  AddPoemScreen(state.user!),
                      );
                    }));

                    if(newPost != null){
                      setState(() {
                        context.read<GetPostBloc>().state.posts!.insert(0, newPost);
                      });


                    }
                  });}else {
								return const FloatingActionButton(
									onPressed: null,
									child: Icon(
										Icons.clear
									),
								); 
            }
            }
          ),
          bottomNavigationBar: BlocBuilder<MyUserBloc, MyUserState>(
            builder: (context, state) {
              if (state.status == MyUserStatus.success) {
                return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: AppColors.primaryColor,
                  onTap: _onItemTapped,
                  currentIndex: _selectedIndex,
                  items: <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.home),
                        label: 'Home',
                        backgroundColor: AppColors.primaryColor),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.explore),
                        label: 'Discover',
                        backgroundColor: AppColors.primaryColor),
                    BottomNavigationBarItem(
                        icon: const Icon(Icons.edit_document),
                        label: 'My Creations',
                        backgroundColor: AppColors.primaryColor),
                    BottomNavigationBarItem(
                      backgroundColor: AppColors.primaryColor,
                      icon: SizedBox(
                        width: 30, // Adjust width as needed
                        height: 30, // Adjust height as needed
                        child: state.user!.image == ''
                            ? const CircleAvatar(
                                radius: 14, // Adjust radius as needed
                                backgroundImage: NetworkImage(
                                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDtKPoN9mIRT0KIyuzVkku3Jh4udgh_IavU_drNSrCCA&s',
                                ),
                              )
                            : CircleAvatar(
                                radius: 14, // Adjust radius as needed
                                backgroundImage:
                                    NetworkImage(state.user!.image!),
                              ),
                      ),
                      label: 'Profile',
                    ),
                  ],
                  // Increase the height of the navigation bar
                  // Adjust as needed based on icon sizes and layout preferences

                  iconSize: 24, // Adjust as needed
                  selectedFontSize: 14, // Adjust as needed
                  unselectedFontSize: 12, // Adjust as needed
                  unselectedItemColor: Colors.white,
                  selectedItemColor: const Color(0xffB1816D),
                );
              } else if (state.status == MyUserStatus.loading) {
                return Container(child: Center(child: Text("loading ..."),),);
              }
              return Container();
            },
          ),
         
          body: _pages.elementAt(_selectedIndex)),
    );
  }
}
