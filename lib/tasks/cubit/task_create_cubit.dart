import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';

part 'task_create_state.dart';

class TaskCreateCubit extends Cubit<TaskCreateState> {
  TaskCreateCubit() : super(const TaskCreateState());

  bool formIsValid() {
    return state.nameInputStatus == InputStatus.valid;
  }

  void nameChanged(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(name: value, nameInputStatus: InputStatus.invalid));
    } else {
      emit(state.copyWith(name: value, nameInputStatus: InputStatus.valid));
    }
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(
        description: () => value, descriptionInputStatus: InputStatus.valid));
  }

  void dateDueChanged(DateTime value) {
    emit(state.copyWith(
        dateDue: () => value, dateDueInputStatus: InputStatus.valid));
  }

  void resetState() {
    emit(const TaskCreateState());
  }
}
