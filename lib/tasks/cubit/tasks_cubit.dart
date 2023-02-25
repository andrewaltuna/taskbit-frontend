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
    // Sorted by date due ascending
    List<Task> tasks =
        state.tasks.where((task) => task.dateCompleted == null).toList();
    tasks.sort((a, b) => a.dateDue == null
        ? 1
        : b.dateDue == null
            ? -1
            : a.dateDue!.compareTo(b.dateDue!));
    return tasks;
  }

  List<Task> completedTasks() {
    // Sorted by date completed, followed by date due ascending
    List<Task> tasks =
        state.tasks.where((task) => task.dateCompleted != null).toList();
    tasks.sort((a, b) {
      int cmp = a.dateDue == null
          ? 1
          : b.dateDue == null
              ? -1
              : a.dateDue!.compareTo(b.dateDue!);
      if (cmp != 0) return cmp;
      return b.dateCompleted!.compareTo(a.dateCompleted!);
    });
    return tasks;
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

  Future<void> damageIndicator() async {
    await toggleEnemyOpacity();
    await Future.delayed(const Duration(milliseconds: 200));
    await toggleEnemyOpacity();
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

    final data = result.data!['getTaskEnemy'];
    final Stage stage = Stage.fromJson(data);
    final Stats stats = Stats.fromJson(data);
    List<Task> tasks = [];

    for (var task in data['tasks']) {
      tasks.add(Task.fromJson(task));
    }

    if (state.tasksStatus != TasksStatus.initial) {
      int oldHp = 0;
      if (state.stage != null) {
        oldHp = state.stage!.enemy.currentHp;
      }

      if (stage.enemy.currentHp != oldHp) {
        await damageIndicator();
      }
    }

    emit(state.copyWith(
      tasksStatus: TasksStatus.loaded,
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
