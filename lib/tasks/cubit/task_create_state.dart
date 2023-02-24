part of 'task_create_cubit.dart';

class TaskCreateState extends Equatable {
  const TaskCreateState({
    this.id,
    this.name = '',
    this.description = '',
    this.dateDue,
    this.nameInputStatus = InputStatus.initial,
    this.descriptionInputStatus = InputStatus.initial,
    this.dateDueInputStatus = InputStatus.initial,
  });

  final String? id;
  final String name;
  final String? description;
  final DateTime? dateDue;
  final InputStatus nameInputStatus;
  final InputStatus descriptionInputStatus;
  final InputStatus dateDueInputStatus;

  TaskCreateState copyWith({
    ValueGetter<String?>? id,
    String? name,
    ValueGetter<String?>? description,
    ValueGetter<DateTime?>? dateDue,
    InputStatus? nameInputStatus,
    InputStatus? descriptionInputStatus,
    InputStatus? dateDueInputStatus,
  }) {
    return TaskCreateState(
      id: id != null ? id() : this.id,
      name: name ?? this.name,
      description: description != null ? description() : this.description,
      dateDue: dateDue != null ? dateDue() : this.dateDue,
      nameInputStatus: nameInputStatus ?? this.nameInputStatus,
      descriptionInputStatus:
          descriptionInputStatus ?? this.descriptionInputStatus,
      dateDueInputStatus: dateDueInputStatus ?? this.dateDueInputStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        dateDue,
        nameInputStatus,
        descriptionInputStatus,
        dateDueInputStatus,
      ];
}
