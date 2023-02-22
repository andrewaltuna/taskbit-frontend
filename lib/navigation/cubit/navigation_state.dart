part of 'navigation_cubit.dart';

class NavigationState extends Equatable {
  const NavigationState({
    this.selectedPage = 0,
    this.selectedTask,
  });

  final int selectedPage;
  final Task? selectedTask;

  NavigationState copyWith({
    int? selectedPage,
    ValueGetter<Task?>? selectedTask,
  }) {
    return NavigationState(
      selectedPage: selectedPage ?? this.selectedPage,
      selectedTask: selectedTask != null ? selectedTask() : this.selectedTask,
    );
  }

  @override
  List<Object?> get props => [selectedPage, selectedTask];
}
