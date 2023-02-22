import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskbit/tasks/models/task.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksState());

  bool pageIsAuth() {
    return state.selectedPage == Pages.login ||
        state.selectedPage == Pages.signUp;
  }

  int getPageNavIndex(Pages page) {
    if (page == Pages.profile) {
      return 1;
    }
    return 0;
  }

  void taskSelected(Task task) {
    emit(state.copyWith(selectedTask: () => task));
  }

  void taskDeselected() {
    emit(state.copyWith(selectedTask: () => null));
  }

  void taskCompleted(Task task) {
    List<Task> tasks = [...state.tasks];
    int index = tasks.indexOf(task);
    tasks[index] = tasks[index].copyWith(
      dateCompleted: () => TimeOfDay.now().toString(),
    );
    emit(state.copyWith(tasks: tasks));
  }

  void pageChanged(Pages page) {
    // emit(state.copyWith(selectedPage: () => index));
    emit(state.copyWith(selectedPage: page));
  }

  void logout() {
    // emit(state.copyWith(selectedPage: () => null));
    emit(state.copyWith(selectedPage: Pages.login));
  }

  List<Task> ongoingTasks() {
    return state.tasks.where((task) => task.dateCompleted == null).toList();
  }

  List<Task> completedTasks() {
    return state.tasks.where((task) => task.dateCompleted != null).toList();
  }
}
