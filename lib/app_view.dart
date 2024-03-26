import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:olly_chat/blocs/connectivity_bloc/connectivity_bloc_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/screens/welcome_screen.dart';
import 'package:olly_chat/theme/colors.dart';

import 'blocs/updateuserinfo/update_user_info_bloc.dart';
import 'screens/home_screen.dart';

class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'OllyChat',
      theme: ThemeData(
          colorScheme: ColorScheme.light(
              onBackground: Colors.black,
              primary:  AppColors.primaryColor,
              onPrimary: Colors.black,
              secondary:  AppColors.secondaryColor,
              tertiary: Color.fromRGBO(255, 204, 128, 1),
              error: Colors.red,
              outline: Color(0xFF424242))),
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
                        userRepository:
                            context.read<AuthenticationBloc>().userRepository)),
                BlocProvider(
                    create: (context) => MyUserBloc(
                        myUserRepository:
                            context.read<AuthenticationBloc>().userRepository)
                      ..add(GetMyUser(
                          myUserId: context
                              .read<AuthenticationBloc>()
                              .state
                              .user!
                              .uid)))
              ],
              child: HomeScreen(),
            );
          } else {
            return WelcomeScreen();
          }
        },
      ),
    );
  }
}
