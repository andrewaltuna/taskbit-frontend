import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/constants.dart';
import 'package:taskbit/tasks/models/stage.dart';
import 'package:taskbit/tasks/models/stats.dart';
import 'package:taskbit/tasks/models/task.dart';
import '../../gql_strings.dart' as gqlstrings;

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  TasksCubit() : super(const TasksState());

  void taskSelected(Task task) {
    emit(state.copyWith(selectedTask: () => task));
  }

  void taskDeselected() {
    emit(state.copyWith(selectedTask: () => null));
  }

  void resetState() {
    emit(const TasksState());
  }

  List<Task> ongoingTasks() {
    return state.tasks.where((task) => task.dateCompleted == null).toList();
  }

  List<Task> completedTasks() {
    return state.tasks.where((task) => task.dateCompleted != null).toList();
  }

  // GRAPHQL CALLS

  Future<bool> fetchTasksEnemyData({required String authToken}) async {
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

    final QueryResult result = await gqlClient.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.taskEnemyQuery,
        ),
      ),
    );

    // final bool success = result.data != null ? true : false;

    final data = result.data!['getTaskEnemy'];
    final Stage stage = Stage.fromJson(data);
    final Stats stats = Stats.fromJson(data);
    List<Task> tasks = [];

    for (var task in data['tasks']) {
      tasks.add(Task.fromJson(task));
    }

    emit(state.copyWith(
      tasks: tasks,
      stage: () => stage,
      stats: () => stats,
    ));

    if (!result.hasException) {
      return true;
    }
    return false;
  }

  Future<bool> taskCompleted(
      {required String authToken, required Task task}) async {
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

    final QueryResult result = await gqlClient.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.completeTaskMutation,
        ),
        variables: {
          'taskId': task.id.toString(),
        },
      ),
    );

    final bool success = result.data!['completeTask'] ?? false;
    return success;
  }

  Future<bool> taskDeleted(
      {required String authToken, required Task task}) async {
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

    final QueryResult result = await gqlClient.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.deleteTaskMutation,
        ),
        variables: {
          'taskId': task.id.toString(),
        },
      ),
    );

    final bool success = result.data!['deleteTask'] ?? false;
    return success;
  }
}
