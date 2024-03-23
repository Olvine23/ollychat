part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UploadPicture extends UpdateUserInfoEvent{
  final String uid;
  final String file;

  const UploadPicture(
     this.file, 
     this.uid,
  );

  @override

  List<Object> get props => [file, uid];
}
