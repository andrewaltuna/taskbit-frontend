part of 'task_cubit.dart';

class TaskState extends Equatable {
  const TaskState({
    this.id,
    this.name = '',
    this.description = '',
    this.dateDue,
    this.nameInputStatus = InputStatus.initial,
  });

  final String? id;
  final String name;
  final String? description;
  final DateTime? dateDue;
  final InputStatus nameInputStatus;

  TaskState copyWith({
    ValueGetter<String?>? id,
    String? name,
    ValueGetter<String?>? description,
    ValueGetter<DateTime?>? dateDue,
    InputStatus? nameInputStatus,
  }) {
    return TaskState(
      id: id != null ? id() : this.id,
      name: name ?? this.name,
      description: description != null ? description() : this.description,
      dateDue: dateDue != null ? dateDue() : this.dateDue,
      nameInputStatus: nameInputStatus ?? this.nameInputStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        dateDue,
        nameInputStatus,
      ];

  bool get formIsValid => nameInputStatus == InputStatus.valid;

  bool get isCreate => id == null;
}
