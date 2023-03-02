import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskbit/mixins/date_formatter.dart';

class Task extends Equatable with DateFormatter {
  Task({
    required this.id,
    required this.name,
    this.description,
    required this.difficulty,
    this.dateDue,
    this.dateCompleted,
  });

  late final String id;
  late final String name;
  late final String? description;
  late final String? difficulty;
  late final DateTime? dateDue;
  late final DateTime? dateCompleted;

  Task.fromJson(Map<String, dynamic> data) {
    id = data['id'];
    name = data['name'];
    description = data['description'];
    difficulty = data['difficulty'];
    dateDue = DateTime.tryParse(data['dateDue'] ?? '');
    dateCompleted = DateTime.tryParse(data['dateCompleted'] ?? '');
  }

  bool isLate() {
    if (dateDue == null) {
      return false;
    }
    return DateUtils.dateOnly(DateTime.now()).isAfter(dateDue!);
  }

  bool isCompleted() {
    return dateCompleted != null;
  }

  // Task copyWith({
  //   String? id,
  //   String? name,
  //   ValueGetter<String?>? description,
  //   // String? dateCreated,
  //   ValueGetter<DateTime?>? dateDue,
  //   ValueGetter<DateTime?>? dateCompleted,
  // }) {
  //   return Task(
  //     id: id ?? this.id,
  //     name: name ?? this.name,
  //     description: description != null ? description() : this.description,
  //     // dateCreated: dateCreated ?? this.dateCreated,
  //     dateDue: dateDue != null ? dateDue() : this.dateDue,
  //     dateCompleted:
  //         dateCompleted != null ? dateCompleted() : this.dateCompleted,
  //   );
  // }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        difficulty,
        dateDue,
        dateCompleted,
      ];
}
