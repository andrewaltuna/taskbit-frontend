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

  void userLoggedIn(String authToken) {
    emit(state.copyWith(authToken: authToken));
  }

  void toggleProfileAvatarSelectVisibility() {
    emit(state.copyWith(
        isProfileAvatarSelectVisible: !state.isProfileAvatarSelectVisible));
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
          'avatar': state.avatarSpriteName(),
        },
      ),
    );

    final bool success = result.data!['signUp'] ?? false;

    if (success) {
      resetState();
    } else {
      emit(state.copyWith(
        usernameInputStatus: InputStatus.invalid,
        password: '',
        passwordInputStatus: InputStatus.initial,
      ));
    }
    return success;
  }

  Future<bool> updateAvatar({required String authToken}) async {
    final HttpLink link = HttpLink(graphQlLink);

    final AuthLink authLink =
        AuthLink(getToken: () async => 'Bearer $authToken');

    final authorizedLink = authLink.concat(link);

    GraphQLClient gqlClient = GraphQLClient(
      link: authorizedLink,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );

    QueryResult result = await gqlClient.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.updateAvatarMutation,
        ),
        variables: {
          'avatar': state.avatarSpriteName(),
        },
      ),
    );

    return true;
  }
}
