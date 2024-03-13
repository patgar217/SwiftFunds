import 'dart:convert';

User userFromMap(String str) => User.fromMap(json.decode(str));

String userToMap(User data) => json.encode(data.toMap());

class User {
    int? userId;
    String? fullName;
    String? email;
    String username;
    String password;
    double? swiftpoints;

    User({
        this.userId,
        this.fullName,
        this.email,
        required this.username,
        required this.password,
        this.swiftpoints,
    });

    factory User.fromMap(Map<String, dynamic> json) => User(
        userId: json["userId"],
        fullName: json["fullName"],
        email: json["email"],
        username: json["username"],
        password: json["password"],
        swiftpoints: json["swiftpoints"],
    );

    Map<String, dynamic> toMap() => {
        "userId": userId,
        "fullName": fullName,
        "email": email,
        "username": username,
        "password": password,
        "swiftpoints": swiftpoints,
    };
}
