import 'package:yallago/features/catalog/data/models/vendor_models.dart';

import '../services/vendor_auth_service.dart';

class VendorAuthRepository {
  VendorAuthRepository(this._service);

  final VendorAuthService _service;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) =>
      _service.login(email: email, password: password);

  Future<AuthSession> register(VendorRegisterRequest request) =>
      _service.register(request);
}
