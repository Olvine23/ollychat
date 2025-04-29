import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/sign_up/sign_up_bloc.dart';
import 'package:olly_chat/components/custom_button.dart';
import 'package:olly_chat/components/custom_textfield.dart';
import 'package:olly_chat/theme/colors.dart';
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
  final confirmPasswordController = TextEditingController(); 
   bool obscureText = true;

   Widget glassTextField({required Widget child}) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.3)),
          ),
          child: child,
        ),
      ),
    );
  }

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
        body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF6A11CB), // Purple-ish
                  Color(0xFF2575FC), // Blue-ish
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),

          child: SafeArea(
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
                            Container(
                                  // padding: const EdgeInsets.all(8.0),
                                  decoration: const BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54                                         , // subtle shadow
                                        blurRadius: 6,
                                        offset: Offset(0,
                                            3), // moves the shadow down a bit
                                      ),
                                    ],
                                  ),
                                  child: ClipRRect(
                                       borderRadius: BorderRadius.circular(20),
                                    child: Image.asset('assets/images/nobg.png',
                                        height: 200),
                                  )),
                              const SizedBox(height: 24),
                              const Text(
                                'Create your account ',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 30, fontWeight: FontWeight.bold),
                              ),
                               const SizedBox(
                                height: 8,
                              ),
                              Text(
                           'Fill in your details',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color:
                                       Colors.white70,
                                ),
                              ),
                                 const SizedBox(height: 32),
                            // const Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text("Your Name")),
                            // const SizedBox(
                            //   height: 10,
                            // ),
                             glassTextField(
                               child: CustomTextField(
                                controller: nameController,
                                hintText: 'Name',
                                obscureText: false,
                                keyboardType: TextInputType.name,
                                                           ),
                             ),
                              const SizedBox(
                              height: 16,
                            ),
                            // const Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text("Your email")),
                            glassTextField(
                              child: CustomTextField(
                                controller: emailController,
                                hintText: 'Email',
                                obscureText: false,
                                keyboardType: TextInputType.emailAddress,
                              ),
                            ),
                              const SizedBox(
                              height: 16,
                            ),
                            // const Align(
                            //     alignment: Alignment.topLeft,
                            //     child: Text("Enter Password")),
                            glassTextField(
                              child: CustomTextField(
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
                                        color: Colors.white),
                                  ),
                                controller: passwordController,
                                hintText: 'Password',
                                obscureText: obscureText,
                                keyboardType: TextInputType.visiblePassword,
                              ),
                            ),
                              const SizedBox(height: 16),
                          // const Align(alignment: Alignment.topLeft, child: Text("Confirm Password")),
                             glassTextField(
                               child: CustomTextField(
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
                                        color: Colors.white),
                                  ),
                                                           controller: confirmPasswordController,
                                                           hintText: 'Confirm Password',
                                                           obscureText: obscureText, // Always obscure the confirm password field
                                                           keyboardType: TextInputType.visiblePassword,
                                                           validator: (value) {
                                if (value != passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                                                           },
                                                         ),
                             ),
                              const SizedBox(
                              height: 20,
                            ),
                            
                            !signUpRequired
                                ? 
                                CustomButton(
                                    text: "Sign Up",
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
                                    }, butttonColor: AppColors.primaryColor,)
                                
                                : const CircularProgressIndicator()
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
