part of 'tasks_cubit.dart';

class TasksState extends Equatable {
  const TasksState({
    this.tasks = const [],
    this.stage,
    this.stats,
    this.selectedTask,
  });

  final List<Task> tasks;
  final Stage? stage;
  final Stats? stats;
  final Task? selectedTask;

  TasksState copyWith({
    List<Task>? tasks,
    ValueGetter<Stage?>? stage,
    ValueGetter<Stats?>? stats,
    ValueGetter<Task?>? selectedTask,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      stage: stage != null ? stage() : this.stage,
      stats: stats != null ? stats() : this.stats,
      selectedTask: selectedTask != null ? selectedTask() : this.selectedTask,
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        stage,
        stats,
        selectedTask,
      ];
}
