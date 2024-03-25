part of 'authentication_bloc.dart';

 enum AuthenticationStatus { authenticated, unauthenticated , uknown}

 class AuthenticationState extends Equatable{

  final AuthenticationStatus status;
  final User? user;

  const AuthenticationState._({
    this.status = AuthenticationStatus.uknown,
    this.user
  }); 

  //no info

  const AuthenticationState.uknown() : this._();

  //user is authenticated

  const AuthenticationState.authenticated(User user) : this._(status: AuthenticationStatus.authenticated, user: user);


//user is unauthenticated

  const AuthenticationState.unauthenticated() : this._(status: AuthenticationStatus.unauthenticated);
  @override
 
  List<Object?> get props => [status, user];

 }