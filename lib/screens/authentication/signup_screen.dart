import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:olly_chat/blocs/sign_up/sign_up_bloc.dart';
import 'package:olly_chat/components/custom_button.dart';
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
  final confirmPasswordController = TextEditingController(); 
   bool obscureText = true;

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
          child: SingleChildScrollView(
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
                            child: Text("Your Name")),
                        const SizedBox(
                          height: 10,
                        ),
                         CustomTextField(
                          controller: nameController,
                          hintText: 'Name',
                          obscureText: false,
                          keyboardType: TextInputType.name,
                        ),
                          const SizedBox(
                          height: 10,
                        ),
                        const Align(
                            alignment: Alignment.topLeft,
                            child: Text("Your email")),
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
                            child: Text("Enter Password")),
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
                          const SizedBox(height: 10),
                      const Align(alignment: Alignment.topLeft, child: Text("Confirm Password")),
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
                                })
                            
                            : const CircularProgressIndicator()
                      ],
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
