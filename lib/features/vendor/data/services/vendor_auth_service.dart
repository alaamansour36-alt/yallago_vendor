import '../../../../core/network/api_client.dart';
import '../models/vendor_models.dart';

class VendorAuthService {
  VendorAuthService(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthSession> login({
    required String email,
    required String password,
  }) async {
    final data = await _apiClient.post(
      '/authentication/login',
      body: {
        'email': email,
        'password': password,
      },
    );
    return AuthSession.fromJson(data as Map<String, dynamic>);
  }
}
