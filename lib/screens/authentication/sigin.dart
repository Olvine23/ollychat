import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/sign_in/sign_in_bloc.dart';
import 'package:olly_chat/blocs/sign_up/sign_up_bloc.dart';
import 'package:olly_chat/components/custom_button.dart';
import 'package:olly_chat/components/custom_textfield.dart';
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
    return BlocListener<SignInBloc, SignInState>(
      listener: (context, state) {
        // implement listener
        if (state is SignInSuccess) {
          setState(() {
            signInRequired = false;
          });
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
        body: SafeArea(
          child: Center(
            child: Form(
                key: _formKey,
                child: Center(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Your email")),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text("Your password")),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: obscurePPassword,
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
                              onPressed: () {},
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
                                  context.read<SignInBloc>().add(SignInRequired(
                                      emailController.text,
                                      passwordController.text));
                                }
                              })
                          //  SizedBox(
                          //     width: MediaQuery.of(context).size.width * 0.5,
                          //     child: TextButton(
                          //         onPressed: () {
                          //           if (_formKey.currentState!.validate()) {
                          //             context.read<SignInBloc>().add(
                          //                 SignInRequired(emailController.text,
                          //                     passwordController.text));
                          //           }
                          //         },
                          //         style: TextButton.styleFrom(
                          //             elevation: 3.0,
                          //             backgroundColor:
                          //                 Theme.of(context).colorScheme.primary,
                          //             foregroundColor: Colors.white,
                          //             shape: RoundedRectangleBorder(
                          //                 borderRadius:
                          //                     BorderRadius.circular(60))),
                          //         child: const Padding(
                          //           padding: EdgeInsets.symmetric(
                          //               horizontal: 25, vertical: 5),
                          //           child: Text(
                          //             'Sign In',
                          //             textAlign: TextAlign.center,
                          //             style: TextStyle(
                          //                 color: Colors.white,
                          //                 fontSize: 16,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //         )),
                          //   )
                          : const CircularProgressIndicator()
                    ],
                  ),
                )),
          ),
        ),
      ),
    );
  }
}
