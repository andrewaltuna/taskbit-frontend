part of 'task_cubit.dart';

class TaskState extends Equatable {
  const TaskState({
    this.id,
    this.name = '',
    this.description = '',
    this.difficulty = 'EASY',
    this.dateDue,
    this.nameInputStatus = InputStatus.initial,
  });

  final String? id;
  final String name;
  final String? description;
  final String difficulty;
  final DateTime? dateDue;
  final InputStatus nameInputStatus;

  static final difficulties = [
    'EASY',
    'MEDIUM',
    'HARD',
  ];

  static final difficultyColors = [
    AppColors().taskEasy,
    AppColors().taskMedium,
    AppColors().taskHard,
  ];

  TaskState copyWith({
    ValueGetter<String?>? id,
    String? name,
    ValueGetter<String?>? description,
    String? difficulty,
    ValueGetter<DateTime?>? dateDue,
    InputStatus? nameInputStatus,
  }) {
    return TaskState(
      id: id != null ? id() : this.id,
      name: name ?? this.name,
      description: description != null ? description() : this.description,
      difficulty: difficulty ?? this.difficulty,
      dateDue: dateDue != null ? dateDue() : this.dateDue,
      nameInputStatus: nameInputStatus ?? this.nameInputStatus,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        difficulty,
        dateDue,
        nameInputStatus,
      ];

  bool get formIsValid => nameInputStatus == InputStatus.valid;

  bool get isCreate => id == null;

  String difficultyByIndex(int index) => difficulties[index];

  Color difficultyColorByIndex(int index) => difficultyColors[index]!;

  Color difficultyColorByDifficulty(String difficulty) {
    final index = difficulties.indexOf(difficulty);
    return difficultyColors[index]!;
  }
}
