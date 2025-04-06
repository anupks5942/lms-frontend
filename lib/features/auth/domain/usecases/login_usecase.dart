// features/auth/domain/usecases/login_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/failures/value_failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this.repository);
  final AuthRepository repository;

  Future<Either<AuthFailure, User>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}
