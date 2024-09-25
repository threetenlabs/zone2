import 'package:cloud_firestore/cloud_firestore.dart';

class ChatMessage {
  final String message;
  final DateTime timestamp;
  final String user;
  final String svgString;
  final DateTime ttl;

  ChatMessage({
    required this.message,
    required this.timestamp,
    required this.user,
    required this.svgString,
    required this.ttl,
  });

  // Factory constructor to create an instance of ChatMessage from a map.
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] as String,
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      user: json['user'] as String,
      svgString: json['svgString'] as String,
      ttl: (json['ttl'] as Timestamp).toDate(),
    );
  }

  // Method to convert an instance of ChatMessage to a map.
  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'user': user,
      'svgString': svgString,
      'ttl': Timestamp.fromDate(ttl),
    };
  }
}
