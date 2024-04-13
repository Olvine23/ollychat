import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:user_repository/user_repository.dart';

part 'sign_in_event.dart';
part 'sign_in_state.dart';

class SignInBloc extends Bloc<SignInEvent, SignInState> {
  final UserRepository _userRepository;
  SignInBloc({
    required UserRepository userRepository
  }) : 
  _userRepository = userRepository,
  super(SignInInitial()) {
    on<SignInRequired>((event, emit) async{
      emit(SignInProcess());
      try{
        await _userRepository.signIn(event.email, event.password);
        emit(SignInSuccess());



      }catch(e){
        print(e.toString());
        emit(SignInFailure(e.toString()));
        
      }
    });

    on<SignOutRequired>((event, emit) async{
      await _userRepository.logOut();
    });

    on<ResetPasswordRequired>(((event, emit) async {

      await _userRepository.resetPassword(event.email);
      
    }));
  }
}