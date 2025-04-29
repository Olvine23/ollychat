import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/authentication_bloc/authentication_bloc.dart';
import 'package:olly_chat/blocs/get_post/get_post_bloc.dart';
import 'package:olly_chat/blocs/myuserbloc/myuser_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/blocs/sign_up/sign_up_bloc.dart';
import 'package:olly_chat/blocs/updateuserinfo/update_user_info_bloc.dart';
import 'package:olly_chat/components/custom_button.dart';
import 'package:olly_chat/components/custom_textfield.dart';
import 'package:olly_chat/screens/authentication/signup_screen.dart';
import 'package:olly_chat/screens/home_screen.dart';
import 'package:post_repository/post_repository.dart';
import 'package:user_repository/user_repository.dart';

import '../../theme/colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool obscureText = true;

  String? _errorMsg;
  bool signInRequired = false;
  bool obscurePPassword = true;
  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

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
      child: BlocListener<SignInBloc, SignInState>(
        listener: (context, state) {
          // implement listener
          if (state is SignInSuccess) {
            setState(() {
              signInRequired = false;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: Colors.green,
                content: Text(
                  'Login successful',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            );
          } else if (state is SignInProcess) {
            setState(() {
              signInRequired = true;
            });
          } else if (state is SignInFailure) {
            setState(() {
              signInRequired = false;
              _errorMsg = 'Invalid email or password';
            });
          }
        },
        child: Scaffold(
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: SingleChildScrollView(
                  physics: NeverScrollableScrollPhysics(),
                  child: Form(
                      key: _formKey,
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset('assets/images/nobg.png', height: 100),
                            const SizedBox(height: 24),
                            const Text(
                              'Welcome Back!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Text(
                              'Please sign in to continue',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    Theme.of(context).colorScheme.onBackground,
                              ),
                            ),
                            const SizedBox(height: 32),
                            // const Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text("Your email", style: TextStyle(fontWeight: FontWeight.bold),)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            CustomTextField(
                              controller: emailController,
                              hintText: 'Email',
                              obscureText: false,
                              keyboardType: TextInputType.emailAddress,
                            ),
                            const SizedBox(
                              height: 16,
                            ),
                            // const Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text("Your password", style: TextStyle(fontWeight: FontWeight.bold),)),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                            CustomTextField(
                              suffixIcon: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    obscureText = !obscureText;
                                  });
                                },
                                child: Icon(
                                    obscureText
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.grey),
                              ),
                              controller: passwordController,
                              hintText: 'Password',
                              obscureText: obscureText,
                              keyboardType: TextInputType.visiblePassword,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 8.0),
                                child: TextButton(
                                    onPressed: () {
                                      context.read<SignInBloc>().add(
                                          ResetPasswordRequired(
                                              emailController.text));
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Password resert link has been sent  to your email'),
                                        ),
                                      );
                                    },
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: AppColors.primaryColor,
                                        fontSize: 12,
                                      ),
                                    )),
                              ),
                            ),
                            !signInRequired
                                ? CustomButton(
                                    text: "Sign In",
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        context.read<SignInBloc>().add(
                                            SignInRequired(emailController.text,
                                                passwordController.text));
                                      }
                                    })
                                : const CircularProgressIndicator(),

                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            BlocProvider<SignUpBloc>(
                                          create: (context) => SignUpBloc(
                                            userRepository: context
                                                .read<AuthenticationBloc>()
                                                .userRepository,
                                          ),
                                          child: const SignUpScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'Create one now',
                                    style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      )),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
