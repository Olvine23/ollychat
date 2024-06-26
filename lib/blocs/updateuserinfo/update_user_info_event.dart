part of 'update_user_info_bloc.dart';

abstract class UpdateUserInfoEvent extends Equatable {
  const UpdateUserInfoEvent();

  @override
  List<Object> get props => [];
}

class UploadPicture extends UpdateUserInfoEvent{
  final String userId;
  final String file;

  const UploadPicture(
     this.file, 
     this.userId,
  );

  @override

  List<Object> get props => [file, userId];
}

class UpdateMyUser extends UpdateUserInfoEvent {
  final String userId;
  final Map<String, dynamic> updates;

  const UpdateMyUser(this.userId, this.updates);

  @override
  List<Object> get props => [userId, updates];
}
