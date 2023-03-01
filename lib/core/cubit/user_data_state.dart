part of 'user_data_cubit.dart';

enum TasksStatus { initial, loaded }

class UserDataState extends Equatable {
  const UserDataState({
    this.tasksStatus = TasksStatus.initial,
    this.tasks = const [],
    this.stage,
    this.stats,
    this.enemyIsVisible = true,
  });

  final TasksStatus tasksStatus;
  final List<Task> tasks;
  final Stage? stage;
  final Stats? stats;
  final bool enemyIsVisible;

  UserDataState copyWith({
    TasksStatus? tasksStatus,
    List<Task>? tasks,
    ValueGetter<Stage?>? stage,
    ValueGetter<Stats?>? stats,
    bool? enemyIsVisible,
  }) {
    return UserDataState(
      tasksStatus: tasksStatus ?? this.tasksStatus,
      tasks: tasks ?? this.tasks,
      stage: stage != null ? stage() : this.stage,
      stats: stats != null ? stats() : this.stats,
      enemyIsVisible: enemyIsVisible ?? this.enemyIsVisible,
    );
  }

  @override
  List<Object?> get props => [
        tasksStatus,
        tasks,
        stage,
        stats,
        enemyIsVisible,
      ];

  List<Task> get ongoingTasks {
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

  List<Task> get completedTasks {
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

  bool get isLoaded => stage != null && stats != null;
}
