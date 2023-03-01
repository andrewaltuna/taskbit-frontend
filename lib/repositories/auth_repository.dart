import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:taskbit/auth/models/user.dart';

import '../constants.dart';
import '../gql_strings.dart' as gqlstrings;

class AuthRepository {
  final gqlClient = GraphQLClient(
    link: HttpLink(graphQlLink),
    cache: GraphQLCache(
      store: HiveStore(),
    ),
  );

  Future<User?> login({
    required String username,
    required String password,
  }) async {
    QueryResult result = await gqlClient.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.loginQuery,
        ),
        variables: {
          'username': username,
          'password': password,
        },
      ),
    );

    try {
      final data = result.data!['signIn'];
      final user = User.fromJson(data);
      return user;
    } catch (_) {
      return null;
    }
  }

  Future<bool> signup({
    required String username,
    required String firstName,
    required String lastName,
    required String password,
    required String avatar,
  }) async {
    QueryResult result = await gqlClient.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.createUserMutation,
        ),
        variables: {
          'username': username,
          'first_name': firstName,
          'last_name': lastName,
          'password': password,
          'avatar': avatar,
        },
      ),
    );

    final data = result.data;

    try {
      return data!['signUp'];
    } catch (_) {
      return false;
    }
  }
}
