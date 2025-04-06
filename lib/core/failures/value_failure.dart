// core/failures/value_failure.dart
abstract class ValueFailure {
  ValueFailure(
    this.message,
  );
  final String message;
}

class ServerFailure
    extends
        ValueFailure {
  ServerFailure(
    super.message,
  );
}

class AuthFailure
    extends
        ValueFailure {
  AuthFailure(
    super.message,
  );
}
