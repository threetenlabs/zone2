import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:zone2/app/models/user.dart'; // Ensure you have this import for DateFormat

String generateSHA256Hash(String input) {
  var bytes =
      utf8.encode(input.trim()); // Convert input to bytes and trim any leading/trailing spaces
  var digest = sha256.convert(bytes); // Hash the bytes using SHA-256
  return digest.toString(); // Convert the hash digest to a string
}

void printWrapped(String text) {
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => debugPrint(match.group(0)));
}

int calculateAge(DateTime birthDate) {
  final currentDate = DateTime.now();
  int age = currentDate.year - birthDate.year;

  // Adjust age if the current date is before the birthdate in the current year
  if (currentDate.month < birthDate.month ||
      (currentDate.month == birthDate.month && currentDate.day < birthDate.day)) {
    age--;
  }

  return age;
}

DateTime getBirthdateFromZone2User(Zone2User user) {
  return DateFormat('MM-dd-yyyy').parse(user.zoneSettings?.birthDate ?? DateTime.now().toString());
}
