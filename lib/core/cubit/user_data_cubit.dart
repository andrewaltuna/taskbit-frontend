import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/cubit/avatar_select_cubit.dart';
import 'package:taskbit/repositories/user_data_repository.dart';
import 'package:taskbit/core/models/stage.dart';
import 'package:taskbit/core/models/stats.dart';
import 'package:taskbit/tasks/models/task.dart';

part 'user_data_state.dart';

class UserDataCubit extends Cubit<UserDataState> {
  UserDataCubit({
    required this.loginCubit,
    required this.avatarSelectCubit,
  }) : super(const UserDataState());

  final LoginCubit loginCubit;
  final AvatarSelectCubit avatarSelectCubit;

  String get authToken => loginCubit.state.user!.accessToken;
  UserDataRepository get userDataRepository =>
      UserDataRepository(authToken)..init();

  void resetState() {
    emit(const UserDataState());
  }

  Future<void> toggleEnemyOpacity() async {
    emit(state.copyWith(enemyIsVisible: false));
    await Future.delayed(
      const Duration(milliseconds: 200),
      () async {
        emit(state.copyWith(enemyIsVisible: true));
      },
    );
  }

  Future<void> damageIndicator(int currentHp) async {
    if (state.tasksStatus != TasksStatus.initial) {
      int oldHp = state.stage!.enemy.currentHp;

      if (currentHp != oldHp) {
        await toggleEnemyOpacity();
        await Future.delayed(const Duration(milliseconds: 200));
        await toggleEnemyOpacity();
      }
    }
  }

  Future<bool> fetchUserData() async {
    final data = await userDataRepository.fetchData();

    if (data == null) {
      return false;
    }

    final stage = Stage.fromJson(data);
    final stats = Stats.fromJson(data);
    List<Task> tasks = [];

    for (var task in data['tasks']) {
      tasks.add(Task.fromJson(task));
    }

    await damageIndicator(stage.enemy.currentHp);

    emit(state.copyWith(
      tasks: tasks,
      tasksStatus: TasksStatus.loaded,
      stage: () => stage,
      stats: () => stats,
    ));

    return true;
  }

  Future<bool> updateAvatar() async {
    final selectedAvatar = avatarSelectCubit.state.selectedAvatar!;
    loginCubit.changeUserAvatar(selectedAvatar);
    final success =
        await userDataRepository.updateAvatar(avatarSpriteName: selectedAvatar);

    return success;
  }
}
