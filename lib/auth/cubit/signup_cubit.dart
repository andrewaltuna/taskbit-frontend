import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/constants.dart';
import '../../gql_strings.dart' as gqlstrings;

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

  // Future<void> onUserRegistered() async {
  //   if ()
  // }

  Future<bool> registerUser() async {
    HttpLink link = HttpLink(graphQlLink);
    GraphQLClient gqlClient = GraphQLClient(
      link: link,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );

    QueryResult result = await gqlClient.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.createUserMutation,
        ),
        variables: {
          'username': state.username,
          'first_name': state.firstName,
          'last_name': state.lastName,
          'password': state.password,
          'avatar': state.avatars[state.selectedAvatarIndex!].substring(8),
        },
      ),
    );

    print(result);
    print(result.hasException);

    if (!result.hasException) {
      resetState();
      return true;
    }

    emit(state.copyWith(
      usernameInputStatus: InputStatus.invalid,
      password: '',
      passwordInputStatus: InputStatus.initial,
    ));
    return false;
  }
}
