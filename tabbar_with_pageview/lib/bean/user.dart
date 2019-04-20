import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  Map<String, dynamic> toJson() => _$UserToJson(this);

  // User.fromJson(Map<String, dynamic> json)
  //     : name = json['name'],
  //       email = json['email'];

  // Map<String, dynamic> toJson() => {
  //       'name': name,
  //       'email': email,
  //     };
}
