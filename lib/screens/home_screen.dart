import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/screens/discover/discover_screen.dart';
import 'package:olly_chat/screens/home/main_home.dart';
import 'package:olly_chat/screens/poems/add_poem_screen.dart';
import 'package:olly_chat/screens/profile/profile_screen.dart';
import 'package:olly_chat/theme/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  final PageController pageController = PageController(initialPage: 0);

  static const List<Widget> _pages =  [
    MainHome(),
   DiscoverScreen(),
    AddPoemScreen(),
     ProfileScreen()


  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            shape: const CircleBorder(),
            backgroundColor: AppColors.primaryColor,
            foregroundColor: AppColors.white,
            child: const Icon(Icons.add),
            onPressed: () {
             
            }),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        items:  <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: 'Home',
            backgroundColor: AppColors.primaryColor
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.explore),
            label: 'Discover',
             backgroundColor: AppColors.primaryColor
          ),

          BottomNavigationBarItem(
            icon: const Icon(Icons.edit_document),
            label: 'Chats',
             backgroundColor: AppColors.primaryColor
          ),
          BottomNavigationBarItem(
             backgroundColor: AppColors.primaryColor,
            icon: const SizedBox(
              width: 24, // Adjust width as needed
              height: 24, // Adjust height as needed
              child: CircleAvatar(
                radius: 14, // Adjust radius as needed
                backgroundImage: NetworkImage(
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQDtKPoN9mIRT0KIyuzVkku3Jh4udgh_IavU_drNSrCCA&s',
                ),
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
      ),
      appBar: AppBar(
        title: const Text("VoiceHub Pro"),
        actions: [
          IconButton(
              onPressed: () {
                context.read<SignInBloc>().add(SignOutRequired());
              },
              icon: const Icon(Icons.logout_outlined))
        ],
      ),
      body:  _pages.elementAt(_selectedIndex)
    );
  }
}
