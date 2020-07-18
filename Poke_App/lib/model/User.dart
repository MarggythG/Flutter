class User{
  String uid;
  String fullName;
  String userName;
  List<dynamic> favorites;
  List<dynamic> friends;
  String token;

  User({
    this.uid,
    this.fullName,
    this.userName,
    this.favorites,
    this.friends
  });
}