import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class User {
  String? userid;
  String? usergmail;
  String? userprofile;
  String? username;
  User({
    this.userid,
    this.usergmail,
    this.userprofile,
    this.username,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userid': userid,
      'usergmail': usergmail,
      'userprofile': userprofile,
      'username': username,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userid: map['userid'] != null ? map['userid'] as String : null,
      usergmail: map['usergmail'] != null ? map['usergmail'] as String : null,
      userprofile: map['userprofile'] != null ? map['userprofile'] as String : null,
      username: map['username'] != null ? map['username'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  // factory User.fromJson(String source) => User.fromMap(json.decode(source) as Map<String, dynamic>);
}
