import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:olly_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:olly_chat/blocs/connectivity_bloc/connectivity_bloc_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/screens/onboarding/swipe_page.dart';
import 'package:olly_chat/screens/welcome_screen.dart';
import 'package:olly_chat/theme/app_theme.dart';
import 'package:olly_chat/theme/colors.dart';
import 'package:post_repository/post_repository.dart';
import 'blocs/updateuserinfo/update_user_info_bloc.dart';
import 'screens/home_screen.dart';

class MyAppView extends StatefulWidget {
  const MyAppView({super.key});

  @override
  State<MyAppView> createState() => _MyAppViewState();
}

class _MyAppViewState extends State<MyAppView> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  Future<void> _loadThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeModeString = prefs.getString('themeMode') ?? 'system';
    setState(() {
      _themeMode = ThemeMode.values.firstWhere(
          (e) => e.toString() == 'ThemeMode.$themeModeString',
          orElse: () => ThemeMode.system);
    });
  }

  Future<void> _saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', themeMode.toString().split('.').last);
  }

  void _toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
    _saveThemeMode(themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return FlutterSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
        themeMode: _themeMode,
        debugShowCheckedModeBanner: false,
        title: 'OllyChat',
        theme: appTheme,
        darkTheme: appThemeDark,
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider<ConnectivityBloc>(
                    create: (BuildContext context) => ConnectivityBloc(),
                  ),
                  BlocProvider(
                    create: (context) => SignInBloc(
                        userRepository:
                            context.read<AuthenticationBloc>().userRepository),
                  ),
                  BlocProvider(
                      create: (context) => UpdateUserInfoBloc(
                          userRepository: context
                              .read<AuthenticationBloc>()
                              .userRepository, postRepository: FirebasePostRepository())),
                  BlocProvider(
                      create: (context) => MyUserBloc(
                          myUserRepository:
                              context.read<AuthenticationBloc>().userRepository)
                        ..add(GetMyUser(
                            myUserId: context
                                .read<AuthenticationBloc>()
                                .state
                                .user!
                                .uid))),
                  BlocProvider.value(
                    value: context.read<GetPostBloc>()..add(GetPosts()),
                  )
                ],
                child: HomeScreen(toggleTheme: _toggleTheme),
              );
            } else {
              return SwipePage();
              //initially
              // return WelcomeScreen();
            }
          },
        ),
      );
    });
  }
}
