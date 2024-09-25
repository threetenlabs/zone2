import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class FirebaseUtils {
  static String handleFirebaseException(Exception e, {String? action}) {
    FirebaseCrashlytics.instance.recordError(e, StackTrace.current);
    if (e is FirebaseException) {
      switch (e.code) {
        case 'invalid-argument':
          return e.message ?? 'Invalid argument';
        case 'internal':
          return 'Unknown errror occurred in bedlam service';
        case 'failed-precondition':
          return e.message ?? 'Unknown errror occurred in bedlam service';
        case 'not-found':
          return e.message ?? 'The $action does not exist.';
        // Add more cases as needed
        default:
          return 'Error connecting to application backend';
      }
    } else {
      return 'There was an error${action != null ? 'while $action' : ''}';
    }
  }
}

class FirebaseFunctionResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  FirebaseFunctionResult.success(T this.data)
      : isSuccess = true,
        error = null;

  FirebaseFunctionResult.failure(this.error)
      : data = null,
        isSuccess = false;

  @override
  String toString() {
    return 'FirebaseFunctionResult(isSuccess: $isSuccess, data: $data, error: $error)';
  }
}

class FirebaseFirestoreResult<T> {
  final T? data;
  final String? error;
  final bool isSuccess;

  FirebaseFirestoreResult.success(T this.data)
      : isSuccess = true,
        error = null;

  FirebaseFirestoreResult.failure(this.error)
      : data = null,
        isSuccess = false;

  @override
  String toString() {
    return 'FirebaseFirestoreResult(isSuccess: $isSuccess, data: $data, error: $error)';
  }
}