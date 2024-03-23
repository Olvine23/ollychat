part of 'sign_in_bloc.dart';

abstract class SignInEvent extends Equatable {

  @override
  List<Object> get props => [];
}

class SignInRequired extends SignInEvent{
  final String email;
  final String password;


  SignInRequired(this.email, this.password);
}

class SignOutRequired extends SignInEvent{

   SignOutRequired();

}

class ResetPasswordRequired extends SignInEvent{
  final String email;
  ResetPasswordRequired(this.email);
}