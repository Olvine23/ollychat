import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_sizer/flutter_sizer.dart';
import 'package:olly_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:olly_chat/blocs/connectivity_bloc/connectivity_bloc_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/screens/onboarding/swipe_page.dart';
import 'package:olly_chat/screens/settings/pref.dart';
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

   ThemeMode _themeMode = ThemeMode.light;
   final ThemePreferences _preferences = ThemePreferences();

    @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

   void _loadThemeMode() async {
    ThemeMode mode = await _preferences.getThemeMode();
    setState(() {
      _themeMode = mode;
    });
  }

  void _toggleTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
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
