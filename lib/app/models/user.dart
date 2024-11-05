//User Model
class UserModel {
  final String uid;
  final String email;
  String name;
  Map<String, dynamic> fcmTokenMap;

  UserModel(
      {required this.uid, required this.email, required this.name, required this.fcmTokenMap});

  factory UserModel.fromJson(Map data) {
    return UserModel(
        uid: data['uid'],
        email: data['email'] ?? '',
        name: data['name'] ?? '',
        fcmTokenMap: data['fcmTokenMap'] ?? {});
  }

  Map<String, dynamic> toJson() =>
      {"uid": uid, "email": email, "name": name, "fcmTokenMap": fcmTokenMap};
}
