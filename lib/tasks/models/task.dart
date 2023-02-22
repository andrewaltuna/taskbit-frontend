import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Task extends Equatable {
  const Task({
    required this.id,
    required this.name,
    this.description,
    required this.dateCreated,
    this.dateDue,
    this.dateCompleted,
  });

  final String id;
  final String name;
  final String? description;
  final String dateCreated;
  final String? dateDue;
  final String? dateCompleted;

  Task copyWith({
    String? id,
    String? name,
    ValueGetter<String?>? description,
    String? dateCreated,
    ValueGetter<String?>? dateDue,
    ValueGetter<String?>? dateCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description != null ? description() : this.description,
      dateCreated: dateCreated ?? this.dateCreated,
      dateDue: dateDue != null ? dateDue() : this.dateDue,
      dateCompleted:
          dateCompleted != null ? dateCompleted() : this.dateCompleted,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, dateCreated, dateDue, dateCompleted];
}
