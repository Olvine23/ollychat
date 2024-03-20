class MyUserEntity {
  final String name;
  final String? image;
  final String email;
  final String id;

  MyUserEntity(
      {required this.name, this.image, required this.email, required this.id});
}
