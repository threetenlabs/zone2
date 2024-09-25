import 'dart:convert';

import 'package:crypto/crypto.dart';

String generateSHA256Hash(String input) {
  var bytes =
      utf8.encode(input.trim()); // Convert input to bytes and trim any leading/trailing spaces
  var digest = sha256.convert(bytes); // Hash the bytes using SHA-256
  return digest.toString(); // Convert the hash digest to a string
}
