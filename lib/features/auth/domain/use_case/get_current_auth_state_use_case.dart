import 'package:injectable/injectable.dart';
import 'package:panna_app/core/use_cases/no_params.dart';
import 'package:panna_app/core/use_cases/use_case.dart';
import 'package:panna_app/features/auth/domain/repository/auth_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

@injectable
class GetCurrentAuthStateUseCase implements StreamUseCase<AuthState, NoParams> {
  GetCurrentAuthStateUseCase(this._authRepository);

  final AuthRepository _authRepository;

  @override
  Stream<AuthState> execute(NoParams params) {
    return _authRepository.getCurrentAuthState();
  }
}
