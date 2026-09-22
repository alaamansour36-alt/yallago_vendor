import 'package:yallago/features/catalog/data/models/vendor_models.dart';

import '../../../../core/network/api_client.dart';

class VendorOrdersService {
  VendorOrdersService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<VendorOrder>> getOrders() async {
    final data = await _apiClient.get('/orders?page=1&pageSize=50');
    final items =
        (data as Map<String, dynamic>)['data'] as List<dynamic>? ?? const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(VendorOrder.fromJson)
        .toList();
  }

  Future<VendorOrder> getOrderDetails(String orderId) async {
    final data = await _apiClient.get('/orders/$orderId');
    return VendorOrder.fromJson(data as Map<String, dynamic>);
  }

  Future<VendorOrder> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    final data = await _apiClient.patch(
      '/orders/$orderId/status',
      body: {'status': status},
    );
    return VendorOrder.fromJson(data as Map<String, dynamic>);
  }

  Future<VendorOrder> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
  }) async {
    final data = await _apiClient.patch(
      '/orders/$orderId/payment-status',
      body: {'paymentStatus': paymentStatus},
    );
    return VendorOrder.fromJson(data as Map<String, dynamic>);
  }
}
