import 'package:equatable/equatable.dart';
import 'package:taskbit/auth/models/enemy.dart';

class Stage extends Equatable {
  late final int stage;
  late final int substage;
  late final Enemy enemy;

  Stage.fromJson(Map<String, dynamic> data) {
    stage = data['stage'];
    substage = data['substage'];
    enemy = Enemy.fromJson(data['currentEnemy']);
  }

  @override
  List<Object?> get props => [stage, substage, enemy];
}
