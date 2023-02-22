import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskbit/tasks/models/task.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(NavigationState());

  void pageChanged(int index) {
    emit(state.copyWith(selectedPage: index));
  }

  void taskSelected(Task task) {
    emit(state.copyWith(selectedTask: () => task));
  }

  void taskDeselected(Task task) {
    emit(state.copyWith(selectedTask: () => null));
  }
}
