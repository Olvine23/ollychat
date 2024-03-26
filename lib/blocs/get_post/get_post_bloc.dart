import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:post_repository/post_repository.dart';

part 'get_post_event.dart';
part 'get_post_state.dart';

class GetPostBloc extends Bloc<GetPostEvent, GetPostState> {
  GetPostBloc() : super(GetPostInitial()) {
    on<GetPostEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
