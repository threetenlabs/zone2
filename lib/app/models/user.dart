//User Model
class UserModel {
  final String uid;
  final String email;
  String name;
  String svgString;
  String svgConfig;
  Map<String, dynamic> fcmTokenMap;

  UserModel(
      {required this.uid,
      required this.email,
      required this.name,
      required this.svgString,
      required this.svgConfig,
      required this.fcmTokenMap});

  factory UserModel.fromJson(Map data) {
    return UserModel(
        uid: data['uid'],
        email: data['email'] ?? '',
        name: data['name'] ?? '',
        svgString: data['svgString'] ?? '',
        svgConfig: data['svg'] ?? '',
        fcmTokenMap: data['fcmTokenMap'] ?? {});
  }

  Map<String, dynamic> toJson() => {
        "uid": uid,
        "email": email,
        "name": name,
        "svgString": svgString,
        "svg": svgConfig,
        "fcmTokenMap": fcmTokenMap
      };
}
