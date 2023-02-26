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

  List<Task> ongoingTasks() {
    // Sorted by date due ascending
    List<Task> ongoingTasks =
        tasks.where((task) => task.dateCompleted == null).toList();
    ongoingTasks.sort((a, b) => a.dateDue == null
        ? 1
        : b.dateDue == null
            ? -1
            : a.dateDue!.compareTo(b.dateDue!));
    return ongoingTasks;
  }

  List<Task> completedTasks() {
    // Sorted by date completed, followed by date due ascending
    List<Task> completedTasks =
        tasks.where((task) => task.dateCompleted != null).toList();

    completedTasks.sort((a, b) {
      int compare = DateUtils.dateOnly(b.dateCompleted!)
          .compareTo(DateUtils.dateOnly(a.dateCompleted!));

      if (compare == 0) {
        return a.dateDue == null
            ? 1
            : b.dateDue == null
                ? -1
                : a.dateDue!.compareTo(b.dateDue!);
      }
      return compare;
    });
    return completedTasks;
  }
}
