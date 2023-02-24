part of 'tasks_cubit.dart';

class TasksState extends Equatable {
  const TasksState({
    this.tasks = const [],
    this.stage,
    this.selectedTask,
  });

  final List<Task> tasks;
  final Stage? stage;
  final Task? selectedTask;

  TasksState copyWith({
    List<Task>? tasks,
    ValueGetter<Stage?>? stage,
    ValueGetter<Task?>? selectedTask,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      stage: stage != null ? stage() : this.stage,
      selectedTask: selectedTask != null ? selectedTask() : this.selectedTask,
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        stage,
        selectedTask,
      ];
}
