import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/screens/welcome_screen.dart';

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
          colorScheme: const ColorScheme.light(
              onBackground: Colors.black,
              primary: Color.fromRGBO(206, 147, 216, 1),
              onPrimary: Colors.black,
              secondary: Color.fromRGBO(244, 143, 177, 1),
              tertiary: Color.fromRGBO(255, 204, 128, 1),
              error: Colors.red,
              outline: Color(0xFF424242))),
      home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
        builder: (context, state) {
          if (state.status == AuthenticationStatus.authenticated) {
            return MultiBlocProvider(
              providers: [
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
                    create: (context) => MyuserBloc(
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
