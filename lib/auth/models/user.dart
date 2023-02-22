import 'package:equatable/equatable.dart';
import 'package:taskbit/tasks/models/task.dart';

class User extends Equatable {
  User({
    required this.authToken,
    required this.username,
    required this.firstName,
    required this.lastName,
    required this.avatar,
    required this.currentEnemy,
    required this.stage,
    required this.substage,
  });

  late String authToken;
  late String username;
  late String firstName;
  late String lastName;
  late String avatar;
  late String currentEnemy;
  late int stage;
  late int substage;

  User.fromJson(Map<String, dynamic> data) {
    authToken = data['username'];
    username = data['username'];
    firstName = data['first_name'];
    lastName = data['last_name'];
    avatar = data['avatar'];
    currentEnemy = data['enemy'];
    stage = data['stage'];
    substage = data['substage'];
  }

  @override
  List<Object?> get props => [
        username,
        firstName,
        lastName,
        avatar,
        currentEnemy,
        stage,
        substage,
      ];
}
