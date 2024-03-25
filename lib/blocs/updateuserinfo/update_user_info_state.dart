part of 'update_user_info_bloc.dart';
abstract  class UpdateUserInfoState extends Equatable {
  const UpdateUserInfoState();
  
  @override
  List<Object> get props => [];
}

 class UpdateUserInfoInitial extends UpdateUserInfoState {}

 class UpdateUserLoading extends UpdateUserInfoState{}

 class UpdateUserInfoFailure extends UpdateUserInfoState{}

 class UpdatePictureSuccess extends UpdateUserInfoState{
  final String userImage;

  const UpdatePictureSuccess(this.userImage);

@override
  List<Object> get props => [userImage];
 }
