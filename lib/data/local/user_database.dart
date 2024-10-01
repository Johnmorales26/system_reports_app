import 'package:system_reports_app/ui/registerModule/user_privileges.dart';

class UserDatabase {
  String? uid;
  String name;
  String image;
  final String email;
  final UserPrivileges privileges;

  UserDatabase(this.uid, this.name, this.image, this.email, this.privileges);

  // Factory constructor for creating a new User instance from a map.
  factory UserDatabase.fromJson(Map<String, dynamic> json) {
    return UserDatabase(
      json['uid'],
      json['name'],
      json['image'],
      json['email'],
      getUserPrivilegeFromString(json['privileges']),
    );
  }

  // Method for converting a User instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'image': image,
      'email': email,
      'privileges': privileges.name,
    };
  }
}
