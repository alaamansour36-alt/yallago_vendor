import 'package:yallago/features/catalog/data/models/vendor_models.dart';

import '../../../../core/network/api_client.dart';

class VendorRegisterRequest {
  const VendorRegisterRequest({
    required this.fullName,
    required this.email,
    required this.phoneNumber,
    required this.password,
    required this.confirmPassword,
    required this.storeName,
    this.address,
    this.storeDescription,
    this.businessAddress,
    this.logoUrl,
  });

  final String fullName;
  final String email;
  final String phoneNumber;
  final String? address;
  final String password;
  final String confirmPassword;
  final String storeName;
  final String? storeDescription;
  final String? businessAddress;
  final String? logoUrl;

  Map<String, dynamic> toJson() => {
        'fullName': fullName,
        'email': email,
        'phoneNumber': phoneNumber,
        'address': address,
        'password': password,
        'confirmPassword': confirmPassword,
        'storeName': storeName,
        'storeDescription': storeDescription,
        'businessAddress': businessAddress,
        'logoUrl': logoUrl,
      };
}

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

  Future<AuthSession> register(VendorRegisterRequest request) async {
    final data = await _apiClient.post(
      '/authentication/register/vendor',
      body: request.toJson(),
    );
    return AuthSession.fromJson(data as Map<String, dynamic>);
  }
}
