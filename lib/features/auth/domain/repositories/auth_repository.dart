
import 'package:fpdart/fpdart.dart';
import '../../../../core/failures/value_failure.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<AuthFailure, User>> login({
    required String email,
    required String password,
  });
  
  Future<Either<AuthFailure, User>> register({
    required String name,
    required String email,
    required String password,
  });
}
