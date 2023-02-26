import 'package:equatable/equatable.dart';
import 'package:taskbit/auth/models/enemy.dart';

class User extends Equatable {
  late final String accessToken;
  late final String username;
  late final String firstName;
  late final String lastName;
  late final String avatar;

  User.fromJson(Map<String, dynamic> data) {
    accessToken = data['accessToken'];
    username = data['username'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    avatar = data['avatar'];
  }

  @override
  List<Object?> get props => [
        accessToken,
        username,
        firstName,
        lastName,
        avatar,
      ];
}
