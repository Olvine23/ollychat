import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/blocs/sign_up/sign_up_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';
import 'package:olly_chat/screens/authentication/sigin.dart';
import 'package:olly_chat/screens/authentication/signup_screen.dart';
import 'package:olly_chat/screens/home_screen.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      initialIndex: 0,
      length: 2,
      vsync: this,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      listener: (context, state) {
        // TODO: implement listener
        if (state.status == AuthenticationStatus.authenticated) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => MultiBlocProvider(
                      providers: [

                          BlocProvider<SignInBloc>(
            create: (context) => SignInBloc(
              userRepository: FirebaseUserRepo(),
            ),
          ),
                        BlocProvider<UpdateUserInfoBloc>(
                          create: (context) => UpdateUserInfoBloc(
                              userRepository: FirebaseUserRepo(),
                              postRepository: FirebasePostRepository()),
                        ),
                          BlocProvider(
                      create: (context) => MyUserBloc(
                          myUserRepository:
                              context.read<AuthenticationBloc>().userRepository)
                        ..add(GetMyUser(
                            myUserId: context
                                .read<AuthenticationBloc>()
                                .state
                                .user!
                                .uid))
                                
                                ),
                        BlocProvider.value(
                            value: context.read<GetPostBloc>()..add(GetPosts())),

                             
                      ],
                      child: HomeScreen(toggleTheme: (ThemeMode ) {  },),
                    )),
          );
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: SingleChildScrollView(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Image.asset('assets/images/nobg.png' , height: 100,),
                    const Text(
                      'Welcome Back !',
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                     
                    TabBar(
                        controller: tabController,
                        unselectedLabelColor: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                        labelColor: Theme.of(context).colorScheme.onBackground,
                        tabs: const [
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ]),
                    Expanded(
                      child: TabBarView(controller: tabController, children: [
                        BlocProvider<SignInBloc>(
                          create: (context) => SignInBloc(
                              userRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository),
                          child: const SignInScreen(),
                        ),
                        BlocProvider<SignUpBloc>(
                          create: (context) => SignUpBloc(
                              userRepository: context
                                  .read<AuthenticationBloc>()
                                  .userRepository),
                          child: const SignUpScreen(),
                        ),
                      ]),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
