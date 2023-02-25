part of 'tasks_cubit.dart';

enum TasksStatus { initial, loaded }

class TasksState extends Equatable {
  const TasksState({
    this.tasksStatus = TasksStatus.initial,
    this.tasks = const [],
    this.stage,
    this.stats,
    this.selectedTask,
    this.enemyIsVisible = true,
  });

  final TasksStatus tasksStatus;
  final List<Task> tasks;
  final Stage? stage;
  final Stats? stats;
  final Task? selectedTask;
  final bool enemyIsVisible;

  TasksState copyWith({
    TasksStatus? tasksStatus,
    List<Task>? tasks,
    ValueGetter<Stage?>? stage,
    ValueGetter<Stats?>? stats,
    ValueGetter<Task?>? selectedTask,
    bool? enemyIsVisible,
  }) {
    return TasksState(
      tasksStatus: tasksStatus ?? this.tasksStatus,
      tasks: tasks ?? this.tasks,
      stage: stage != null ? stage() : this.stage,
      stats: stats != null ? stats() : this.stats,
      selectedTask: selectedTask != null ? selectedTask() : this.selectedTask,
      enemyIsVisible: enemyIsVisible ?? this.enemyIsVisible,
    );
  }

  @override
  List<Object?> get props => [
        tasksStatus,
        tasks,
        stage,
        stats,
        selectedTask,
        enemyIsVisible,
      ];
}
