// class SharedGameDetails {
//   final String gameType;
//   final String gameId;

//   SharedGameDetails({required this.gameType, required this.gameId});

//   // Factory constructor to create an instance of GameDetails from a map.
//   factory SharedGameDetails.fromJson(Map<String, dynamic> json) {
//     if (json['gameType'] == null || json['gameId'] == null) {
//       throw ArgumentError('Missing required parameters for gameType or gameId');
//     }

//     return SharedGameDetails(
//       gameType: json['gameType'] as String,
//       gameId: json['gameId'] as String,
//     );
//   }

//   @override
//   String toString() => 'GameDetails(gameType: $gameType, gameId: $gameId)';
// }

class DeepLinkDetails {
  final String action;

  DeepLinkDetails(this.action);

  factory DeepLinkDetails.fromAction(String action, Map<String, dynamic> details) {
    switch (action) {
      case 'join':
        return JoinGameDetails.fromJson(details);
      // Add more cases for other actions if needed
      default:
        throw ArgumentError('Unknown action: $action');
    }
  }
}

class JoinGameDetails extends DeepLinkDetails {
  final String gameType;
  final String gameId;

  JoinGameDetails({required this.gameType, required this.gameId})
      : super('join');

  factory JoinGameDetails.fromJson(Map<String, dynamic> json) {
    if (json['gameType'] == null || json['gameId'] == null) {
      throw ArgumentError('Missing required parameters for gameType or gameId');
    }

    return JoinGameDetails(
      gameType: json['gameType'] as String,
      gameId: json['gameId'] as String,
    );
  }

  @override
  String toString() => 'JoinGameDetails(gameType: $gameType, gameId: $gameId)';
}
