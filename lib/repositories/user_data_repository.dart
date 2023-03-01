import 'package:graphql_flutter/graphql_flutter.dart';

import '../constants.dart';
import '../gql_strings.dart' as gqlstrings;

class UserDataRepository {
  UserDataRepository(this._authToken);
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

  Future<Map<String, dynamic>?> fetchData() async {
    final QueryResult result = await _gqlClient.query(
      QueryOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.taskEnemyQuery,
        ),
      ),
    );
    try {
      final data = result.data!['getTaskEnemy'];
      return data;
    } catch (_) {
      return null;
    }
  }

  Future<bool> updateAvatar({required String avatarSpriteName}) async {
    final result = await _gqlClient.mutate(
      MutationOptions(
        fetchPolicy: FetchPolicy.networkOnly,
        document: gql(
          gqlstrings.updateAvatarMutation,
        ),
        variables: {
          'avatar': avatarSpriteName,
        },
      ),
    );
    return true;
  }
}
