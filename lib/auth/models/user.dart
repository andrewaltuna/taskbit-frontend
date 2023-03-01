import 'package:equatable/equatable.dart';

class User extends Equatable {
  User({
    required this.accessToken,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

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

  User copyWith({
    String? accessToken,
    String? username,
    String? firstName,
    String? lastName,
    String? avatar,
  }) {
    return User(
      accessToken: accessToken ?? this.accessToken,
      username: username ?? this.username,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      avatar: avatar ?? this.avatar,
    );
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
