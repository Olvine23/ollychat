import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/screens/profile/widgets/bottom_sheet_modal.dart';
import 'package:user_repository/user_repository.dart';

class SettingsScreen extends StatefulWidget {
   final Function(ThemeMode) toggleTheme;
  
  const SettingsScreen({super.key, required this.toggleTheme});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
     bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
       
        children: [
          _buildListTile(
            context,
            icon: Icons.person,
            title: 'Personal Info',
            onTap: () {
              // Navigate to Personal Info screen
              Navigator.pushNamed(context, '/personalInfo');
            },
          ),
          _buildListTile(
            context,
            icon: Icons.notifications,
            title: 'Notification',
            onTap: () {
              // Navigate to Notification settings screen
              Navigator.pushNamed(context, '/notification');
            },
          ),
          _buildListTile(
            context,
            icon: Icons.lock,
            title: 'Security',
            onTap: () {
              // Navigate to Security settings screen
              Navigator.pushNamed(context, '/security');
            },
          ),
          _buildListTile(
            context,
            icon: Icons.info,
            title: 'About',
            onTap: () {
              // Navigate to About screen
              Navigator.pushNamed(context, '/about');
            },
          ),

          ListTile(

            leading: Icon(Icons.remove_red_eye),
            trailing: Switch(
            value: isDarkMode,
            onChanged: (bool value) {

               print('Switch toggled: $value');

                  value
                  ? widget.toggleTheme(ThemeMode.dark)
                  : widget.toggleTheme(ThemeMode.light);
            
               
               }
           
          ),

            title: Text("Dark Mode"),

          ),
          _buildListTile(
            context,
            icon: Icons.logout,
            title: 'Logout',
            onTap: () {
              // Handle logout
              _handleLogout(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildListTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      trailing: Icon(Icons.chevron_right),
      leading: Icon(icon, color: Theme.of(context).iconTheme.color),
      title: Text(title, style: Theme.of(context).textTheme.bodyText1),
      onTap: onTap,
    );
  }

  void _handleLogout(BuildContext context) {
    // Implement logout logic here
    // For example:
    // Navigator.pushReplacementNamed(context, '/login');
      
    print('Logout clicked');
      showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return BlocProvider(
                                    create: (context) => SignInBloc(
                                        userRepository: FirebaseUserRepo()),
                                    child: LogoutBottomSheet(),
                                  );
                                },
                              );
  }
}
