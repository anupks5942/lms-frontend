import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import 'auth_providers.dart';

final authViewModelProvider = StateNotifierProvider<AuthViewModel, AsyncValue<User?>>(
  (ref) =>
      AuthViewModel(loginUseCase: ref.read(loginUseCaseProvider), registerUseCase: ref.read(registerUseCaseProvider)),
);

class AuthViewModel extends StateNotifier<AsyncValue<User?>> {
  AuthViewModel({required this.loginUseCase, required this.registerUseCase}) : super(const AsyncValue.data(null));

  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  Future<void> login(String email, String password) async {
    state = const AsyncValue.loading();
    final result = await loginUseCase(email: email, password: password);
    result.match(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }

  Future<void> register(String name, String email, String password) async {
    state = const AsyncValue.loading();
    final result = await registerUseCase(name: name, email: email, password: password);
    result.match(
      (failure) => state = AsyncValue.error(failure, StackTrace.current),
      (user) => state = AsyncValue.data(user),
    );
  }
}
