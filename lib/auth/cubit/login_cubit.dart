import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/auth/models/user.dart';
import 'package:taskbit/constants.dart';
import '../../gql_strings.dart' as gqlstrings;

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(const LoginState());

  bool formIsValid() {
    return state.usernameInputStatus == InputStatus.valid &&
        state.passwordInputStatus == InputStatus.valid;
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
    emit(const LoginState());
  }

  Future<bool> fetchUser() async {
    HttpLink url = HttpLink(graphQlLink);
    GraphQLClient gqlClient = GraphQLClient(
      link: url,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
    QueryResult result = await gqlClient.query(
      QueryOptions(
        document: gql(
          gqlstrings.loginQuery,
        ),
        variables: {
          'username': state.username,
          'password': state.password,
        },
      ),
    );

    print(result);

    if (!result.hasException || result.data != null) {
      var data = result.data!['signIn'];
      User user = User.fromJson(data);
      emit(state.copyWith(user: () => user));
      return true;
    }
    emit(state.copyWith(passwordInputStatus: InputStatus.invalid));
    return false;
  }
}
