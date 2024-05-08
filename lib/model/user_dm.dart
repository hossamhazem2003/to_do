class UserDm{
  static UserDm? currentUser;
  String id;
  String userName;
  String email;

  UserDm({required this.id,required this.userName,required this.email});
}