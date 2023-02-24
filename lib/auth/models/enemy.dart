import 'package:equatable/equatable.dart';

class Enemy extends Equatable {
  late final String name;
  late final String sprite;
  late final int maxHp;
  late final int currentHp;

  Enemy.fromJson(Map<String, dynamic> data) {
    name = data['rootenemy']['name'];
    sprite = data['rootenemy']['sprite'];
    maxHp = data['rootenemy']['maxHp'];
    currentHp = data['currentHp'];
  }

  @override
  List<Object?> get props => [name, sprite, maxHp, currentHp];
}
