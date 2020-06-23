class User {
  String id;
  String firstName;
  String lastName;
  String userType;
  String picture;
  String email;

  User(
      {this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.userType,
      this.picture});

  static User parseObject(dynamic user) {
    return User(
      id: user['_id'],
      firstName: user['firstName'],
      lastName: user['lastName'],
      email: user['email'],
      userType: user['userType'],
      picture: user['picture'],
    );
  }

  static List<User> parseList(List<dynamic> users) {
    List<User> result = [];

    users.forEach((user) {
      result.add(User(
        id: user['_id'],
        firstName: user['firstName'],
        lastName: user['lastName'],
        email: user['email'],
        userType: user['userType'],
        picture: user['picture'],
      ));
    });
    return result;
  }
}
