part of 'sign_up_bloc.dart';
abstract class SignUpEvent extends Equatable{
  @override

  List<Object> get props => [];
}

class SignUpRequired extends SignUpEvent{
  final MyUser user;
  final String password;

  SignUpRequired(this.user,this.password);


}
