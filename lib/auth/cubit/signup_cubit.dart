import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';

part 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  SignupCubit() : super(SignupState());

  bool formIsValid() {
    return state.firstNameInputStatus == InputStatus.valid &&
        state.lastNameInputStatus == InputStatus.valid &&
        state.usernameInputStatus == InputStatus.valid &&
        state.passwordInputStatus == InputStatus.valid &&
        state.selectedAvatarIndex != null;
  }

  void avatarSelected(int index) {
    emit(state.copyWith(selectedAvatarIndex: () => index));
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
    emit(SignupState());
  }

  // Future<void> onUserCreated() async {

  // }

  Future<void> createUser() async {
    HttpLink link = HttpLink('localhost:8000/graphql');
    GraphQLClient gqlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );

    await gqlClient.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          r"""
            mutation {
              signUp (signUpDetails: {
                username
                first_name
                last_name
                password
                avatar
              })
            }
          """,
        ),
        variables: {
          'username': state.username,
          'first_name': state.firstName,
          'last_name': state.lastName,
          'password': state.password,
          'avatar': state.avatars[state.selectedAvatarIndex!].substring(9),
        },
      ),
    );

    resetState();
  }
}
