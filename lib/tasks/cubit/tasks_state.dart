part of 'tasks_cubit.dart';

enum Pages { login, signUp, home, taskCreate, profile }

class TasksState extends Equatable {
  const TasksState({
    this.tasks = const [
      Task(
        id: 'asdfasdf',
        name: 'Task 1',
        dateCreated: '2/20',
      ),
      Task(
        id: 'fdsafssdsd',
        name: 'Task 2',
        dateCreated: '2/20',
      ),
    ],
    this.selectedTask,
    this.selectedPage = Pages.login,
  });

  final List<Task> tasks;
  final Task? selectedTask;
  // final int selectedPage;
  final Pages selectedPage;

  TasksState copyWith({
    List<Task>? tasks,
    ValueGetter<Task?>? selectedTask,
    // ValueGetter<int?>? selectedPage,
    Pages? selectedPage,
  }) {
    return TasksState(
      tasks: tasks ?? this.tasks,
      selectedTask: selectedTask != null ? selectedTask() : this.selectedTask,
      // selectedPage: selectedPage != null ? selectedPage() : this.selectedPage,
      selectedPage: selectedPage ?? this.selectedPage,
    );
  }

  @override
  List<Object?> get props => [
        tasks,
        selectedTask,
        selectedPage,
      ];
}
