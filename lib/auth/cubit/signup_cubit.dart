import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/constants.dart';
import 'package:taskbit/cubit/avatar_select_cubit.dart';
import 'package:taskbit/repositories/auth_repository.dart';
import '../../gql_strings.dart' as gqlstrings;

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit({required this.avatarSelectCubit}) : super(const SignupState());

  final AvatarSelectCubit avatarSelectCubit;

  void userLoggedIn(String authToken) {
    emit(state.copyWith(authToken: authToken));
  }

  void firstNameChanged(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(
          firstName: value, firstNameInputStatus: InputStatus.invalid));
    } else {
      emit(state.copyWith(
          firstName: value, firstNameInputStatus: InputStatus.valid));
    }
  }

  void lastNameChanged(String value) {
    if (value.isEmpty) {
      emit(state.copyWith(
          lastName: value, lastNameInputStatus: InputStatus.invalid));
    } else {
      emit(state.copyWith(
          lastName: value, lastNameInputStatus: InputStatus.valid));
    }
  }

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

  void resetState() {
    emit(const SignupState());
  }

  Future<bool> registerUser() async {
    final success = await AuthRepository().signup(
      username: state.username,
      firstName: state.firstName,
      lastName: state.lastName,
      password: state.password,
      avatar: avatarSelectCubit.state.selectedAvatar!,
    );

    if (success) {
      resetState();
      avatarSelectCubit.resetState();
    } else {
      emit(state.copyWith(
        usernameInputStatus: InputStatus.invalid,
        password: '',
        passwordInputStatus: InputStatus.invalid,
      ));
    }
    return success;
  }
}
