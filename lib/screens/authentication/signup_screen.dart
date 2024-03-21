import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/sign_up/sign_up_bloc.dart';
import 'package:olly_chat/components/custom_textfield.dart';
import 'package:user_repository/user_repository.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final nameController = TextEditingController();
  bool signUpRequired = false;
  bool obscurePPassword = true;
  bool containsUpperCase = false;
  bool containsLowerCase = false;
  bool containsNumber = false;
  bool containsSpecialChar = false;
  bool contains8Length = false;

  @override
  Widget build(BuildContext context) {
    return BlocListener<SignUpBloc, SignUpState>(
      listener: (context, state) {
       // implement listener
        if(state is SignUpSuccess){
          setState(() {
            signUpRequired = false;
          });
          Navigator.pop(context);
        }else if(state is SignUpProcess){
          setState(() {
            signUpRequired = true;
          });
        }else if(state is SignUpFailure ){
          return;
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
                       CustomTextField(
                        controller: nameController,
                        hintText: 'Name',
                        obscureText: false,
                        keyboardType: TextInputType.name,
                      ),
                      CustomTextField(
                        controller: emailController,
                        hintText: 'Email',
                        obscureText: false,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      CustomTextField(
                        controller: passwordController,
                        hintText: 'Password',
                        obscureText: obscurePPassword,
                        keyboardType: TextInputType.visiblePassword,
                      ),
                      
                      !signUpRequired
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: TextButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      MyUser myUser = MyUser.empty;
                                      myUser = myUser.copyWith(
                                        email: emailController.text,
                                        name: nameController.text,
                                      );

                                      setState(() {
                                        context.read<SignUpBloc>().add(
                                            SignUpRequired(myUser,
                                                passwordController.text));
                                      });
                                    }
                                  },
                                  style: TextButton.styleFrom(
                                      elevation: 3.0,
                                      backgroundColor:
                                          Theme.of(context).colorScheme.primary,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(60))),
                                  child: const Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    child: Text(
                                      'Sign Up',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  )),
                            )
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
