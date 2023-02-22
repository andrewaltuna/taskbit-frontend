import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/auth/models/user.dart';

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

  Future<void> onUserFetched() async {}

  Future<User> _fetchUser() async {
    HttpLink url = HttpLink("localhost:8000/graphql");
    GraphQLClient gqlClient = GraphQLClient(
      link: url,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
    QueryResult result = await gqlClient.query(
      QueryOptions(
        document: gql(
          """query {
              
            }
          """,
        ),
      ),
    );
    return result.data!['user'];
  }
}
