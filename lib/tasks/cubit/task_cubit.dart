import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/repositories/tasks_repository.dart';
import 'package:taskbit/tasks/models/task.dart';

part 'task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit({required this.loginCubit}) : super(const TaskState());

  final LoginCubit loginCubit;

  String get authToken => loginCubit.state.user!.accessToken;
  TasksRepository get tasksRepository => TasksRepository(authToken)..init();

  void nameChanged(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(name: value, nameInputStatus: InputStatus.invalid));
    } else {
      emit(state.copyWith(name: value, nameInputStatus: InputStatus.valid));
    }
  }

  void descriptionChanged(String value) {
    emit(state.copyWith(description: () => value.isEmpty ? null : value));
  }

  void dateDueChanged(DateTime value) {
    emit(state.copyWith(dateDue: () => value));
  }

  void copyDetails(Task task) {
    emit(state.copyWith(
      id: () => task.id,
      name: task.name,
      description: () => task.description,
      dateDue: () => task.dateDue,
      nameInputStatus: InputStatus.valid,
    ));
  }

  void resetState() {
    emit(const TaskState());
  }

  Future<bool> createTask() async {
    final success = await tasksRepository.create(
      name: state.name,
      description: state.description,
      dateDue: state.dateDue?.toString(),
    );

    if (success) {
      resetState();
    }
    return success;
  }

  Future<bool> updateTask() async {
    final success = await tasksRepository.update(
      id: state.id!,
      name: state.name,
      description: state.description,
      dateDue: state.dateDue?.toString(),
    );

    if (success) {
      resetState();
    }
    return success;
  }

  Future<bool> taskCompleted(Task task) async {
    final bool success = await tasksRepository.complete(
      taskId: task.id.toString(),
    );
    return success;
  }

  Future<bool> taskDeleted(Task task) async {
    final success = await tasksRepository.delete(taskId: task.id.toString());
    return success;
  }
}
