import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

class FirebaseHelper {
  static MockUser createMockUser({
    bool isAnonymous = false,
    String uid = 'someuid',
    String email = 'bob@somedomain.com',
    String displayName = 'Bob',
  }) {
    return MockUser(
      isAnonymous: isAnonymous,
      uid: uid,
      email: email,
      displayName: displayName,
    );
  }

  static MockFirebaseAuth createMockFirebaseAuth({MockUser? mockUser}) {
    return MockFirebaseAuth(mockUser: mockUser ?? FirebaseHelper.createMockUser());
  }

  static FakeFirebaseFirestore createMockFirestore() {
    return FakeFirebaseFirestore();
  }
}
