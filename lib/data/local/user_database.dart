import 'package:system_reports_app/ui/registerModule/user_privileges.dart';

class UserDatabase {
  String? uid;
  final String name;
  final String email;
  final UserPrivileges privileges;

  UserDatabase(this.uid, this.name, this.email, this.privileges);

  // Factory constructor for creating a new User instance from a map.
  factory UserDatabase.fromJson(Map<String, dynamic> json) {
    return UserDatabase(
      json['uid'],
      json['name'],
      json['email'],
      getUserPrivilegeFromString(json['privileges']),
    );
  }

  // Method for converting a User instance into a map.
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'privileges': privileges.name,
    };
  }
}
