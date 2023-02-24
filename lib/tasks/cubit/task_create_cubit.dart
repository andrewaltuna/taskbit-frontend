import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/auth/cubit/login_cubit.dart';
import 'package:taskbit/constants.dart';
import '../../gql_strings.dart' as gqlstrings;

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

  Future<bool> createTask({required String authToken}) async {
    final HttpLink link = HttpLink(graphQlLink);

    final AuthLink authLink =
        AuthLink(getToken: () async => 'Bearer $authToken');

    final authorizedLink = authLink.concat(link);

    final GraphQLClient gqlClient = GraphQLClient(
      link: authorizedLink,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );

    final QueryResult result = await gqlClient.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.createTaskMutation,
        ),
        variables: {
          'name': state.name,
          'description': state.description,
          'dateDue': state.dateDue?.toString(),
        },
      ),
    );

    if (!result.hasException) {
      resetState();
      return true;
    }
    return false;
  }
}
