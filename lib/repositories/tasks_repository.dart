import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants.dart';
import '../gql_strings.dart' as gqlstrings;

class TasksRepository {
  TasksRepository(this._authToken);
  final String _authToken;
  late final GraphQLClient _gqlClient;

  void init() {
    final authLink = AuthLink(getToken: () async => 'Bearer $_authToken');
    final authorizedLink = authLink.concat(HttpLink(graphQlLink));

    _gqlClient = GraphQLClient(
      link: authorizedLink,
      cache: GraphQLCache(
        store: HiveStore(),
      ),
    );
  }

  Future<bool> create({
    required String name,
    required String? description,
    required String? dateDue,
  }) async {
    final QueryResult result = await _gqlClient.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.createTaskMutation,
        ),
        variables: {
          'name': name,
          'description': description,
          'dateDue': dateDue,
        },
      ),
    );

    return result.data!['createTask'] ?? false;
  }

  Future<bool> update({
    required String id,
    required String name,
    required String? description,
    required String? dateDue,
  }) async {
    final QueryResult result = await _gqlClient.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.updateTaskMutation,
        ),
        variables: {
          'taskId': id,
          'name': name,
          'description': description,
          'dateDue': dateDue,
        },
      ),
    );

    return result.data!['updateTask'] ?? false;
  }

  Future<bool> complete({required String taskId}) async {
    final QueryResult result = await _gqlClient.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.completeTaskMutation,
        ),
        variables: {
          'taskId': taskId,
        },
      ),
    );

    return result.data!['completeTask'] ?? false;
  }

  Future<bool> delete({required String taskId}) async {
    final QueryResult result = await _gqlClient.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.deleteTaskMutation,
        ),
        variables: {
          'taskId': taskId,
        },
      ),
    );

    return result.data!['deleteTask'] ?? false;
  }
}
