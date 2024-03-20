import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:user_repository/user_repository.dart';

part 'myuser_event.dart';
part 'myuser_state.dart';

class MyuserBloc extends Bloc<MyuserEvent, MyUserState> {
  final UserRepository _userRepository;
  MyuserBloc({
    required UserRepository myUserRepository,
  })  : _userRepository = myUserRepository,
        super(const MyUserState.loading()) {
    on<GetMyUser>((event, emit) async {
      try {
        MyUser myUser = await _userRepository.getMyUser(event.myUserId);
      } catch (e) {
        print(e.toString());
      }
    });
  }
}
