import 'package:zone2/app/models/deep_link.dart';

DeepLinkDetails parseGameUrl(Uri uri) {
  // Extract the action from the last segment of the path
  final pathSegments = uri.pathSegments;
  if (pathSegments.isEmpty) {
    throw ArgumentError('URL must contain a valid action. $uri');
  }

  final action = pathSegments.last;

  // Extract the query parameters
  String? gameType = uri.queryParameters['gameType'];
  String? gameId = uri.queryParameters['gameId'];

  final details = {
    'gameType': gameType,
    'gameId': gameId,
  };

  return DeepLinkDetails.fromAction(action, details);
}
