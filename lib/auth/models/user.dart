import 'package:equatable/equatable.dart';
import 'package:taskbit/auth/models/enemy.dart';

class User extends Equatable {
  // User({
  //   required this.accessToken,
  //   required this.username,
  //   required this.firstName,
  //   required this.lastName,
  //   required this.avatar,
  //   required this.currentEnemy,
  //   required this.stage,
  //   required this.substage,
  // });

  late final String accessToken;
  late final String username;
  late final String firstName;
  late final String lastName;
  late final String avatar;
  // late final Enemy currentEnemy;
  // late final String stage;
  // late final String substage;

  User.fromJson(Map<String, dynamic> data) {
    accessToken = data['accessToken'];
    username = data['username'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    avatar = data['avatar'];
    // currentEnemy = Enemy.fromJson(data['currentEnemy']);
    // stage = data['stage'];
    // substage = data['substage'];
  }

  @override
  List<Object?> get props => [
        accessToken,
        username,
        firstName,
        lastName,
        avatar,
        // currentEnemy,
        // stage,
        // substage,
      ];
}
