// features/auth/domain/usecases/register_usecase.dart
import 'package:fpdart/fpdart.dart';
import '../../../../core/failures/value_failure.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class RegisterUseCase {
  RegisterUseCase(this.repository);
  final AuthRepository repository;

  Future<Either<AuthFailure, User>> call({
    required String name,
    required String email,
    required String password,
  }) {
    return repository.register(name: name, email: email, password: password);
  }
}
