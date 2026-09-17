import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/vendor_models.dart';
import '../../data/repositories/vendor_auth_repository.dart';

class VendorAuthState {
  const VendorAuthState({
    this.loading = false,
    this.session,
    this.error,
  });

  final bool loading;
  final AuthSession? session;
  final String? error;

  bool get isAuthenticated => session != null;

  VendorAuthState copyWith({
    bool? loading,
    AuthSession? session,
    String? error,
    bool clearSession = false,
    bool clearError = false,
  }) =>
      VendorAuthState(
        loading: loading ?? this.loading,
        session: clearSession ? null : (session ?? this.session),
        error: clearError ? null : (error ?? this.error),
      );
}

class VendorAuthCubit extends Cubit<VendorAuthState> {
  VendorAuthCubit(this._repository) : super(const VendorAuthState());

  final VendorAuthRepository _repository;

  Future<void> login({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final session = await _repository.login(email: email, password: password);
      emit(VendorAuthState(session: session));
    } catch (error) {
      print('Login error: $error');
      emit(state.copyWith(
          loading: false, error: error.toString(), clearSession: true));
    }
  }

  void logout() => emit(const VendorAuthState());
}
