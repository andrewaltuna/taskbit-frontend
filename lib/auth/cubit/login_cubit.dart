import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:taskbit/auth/models/user.dart';
import 'package:taskbit/repositories/auth_repository.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  void usernameChanged(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(
          username: value, usernameInputStatus: InputStatus.invalid));
    } else {
      emit(state.copyWith(
          username: value, usernameInputStatus: InputStatus.valid));
    }
  }

  void passwordChanged(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(
          password: value, passwordInputStatus: InputStatus.invalid));
    } else {
      emit(state.copyWith(
          password: value, passwordInputStatus: InputStatus.valid));
    }
  }

  void changeUserAvatar(String avatar) {
    User user = state.user!.copyWith(avatar: avatar);
    emit(state.copyWith(user: () => user));
  }

  void resetState() {
    emit(const LoginState());
  }

  Future<bool> fetchUser() async {
    final user = await AuthRepository().login(
      username: state.username,
      password: state.password,
    );

    if (user != null) {
      emit(state.copyWith(user: () => user));
      return true;
    } else {
      emit(state.copyWith(passwordInputStatus: InputStatus.invalid));
      return false;
    }
  }
}
