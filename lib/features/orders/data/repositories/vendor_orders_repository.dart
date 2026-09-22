import 'package:yallago/features/catalog/data/models/vendor_models.dart';

import '../services/vendor_orders_service.dart';

class VendorOrdersRepository {
  VendorOrdersRepository(this._service);

  final VendorOrdersService _service;

  Future<List<VendorOrder>> getOrders() => _service.getOrders();

  Future<VendorOrder> getOrderDetails(String orderId) =>
      _service.getOrderDetails(orderId);

  Future<VendorOrder> updateOrderStatus({
    required String orderId,
    required String status,
  }) =>
      _service.updateOrderStatus(orderId: orderId, status: status);

  Future<VendorOrder> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
  }) =>
      _service.updatePaymentStatus(
          orderId: orderId, paymentStatus: paymentStatus);
}
