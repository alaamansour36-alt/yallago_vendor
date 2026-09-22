import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallago/features/catalog/data/models/vendor_models.dart';

import '../../data/repositories/vendor_orders_repository.dart';

class VendorOrdersState {
  const VendorOrdersState({
    this.loading = false,
    this.updating = false,
    this.orders = const [],
    this.selectedOrder,
    this.error,
  });

  final bool loading;
  final bool updating;
  final List<VendorOrder> orders;
  final VendorOrder? selectedOrder;
  final String? error;

  VendorOrdersState copyWith({
    bool? loading,
    bool? updating,
    List<VendorOrder>? orders,
    VendorOrder? selectedOrder,
    String? error,
    bool clearSelectedOrder = false,
    bool clearError = false,
  }) =>
      VendorOrdersState(
        loading: loading ?? this.loading,
        updating: updating ?? this.updating,
        orders: orders ?? this.orders,
        selectedOrder:
            clearSelectedOrder ? null : (selectedOrder ?? this.selectedOrder),
        error: clearError ? null : (error ?? this.error),
      );
}

class VendorOrdersCubit extends Cubit<VendorOrdersState> {
  VendorOrdersCubit(this._repository) : super(const VendorOrdersState());

  final VendorOrdersRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final orders = await _repository.getOrders();
      emit(VendorOrdersState(orders: orders));
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> selectOrder(String orderId) async {
    emit(state.copyWith(updating: true, clearError: true));
    try {
      final order = await _repository.getOrderDetails(orderId);
      emit(state.copyWith(updating: false, selectedOrder: order));
    } catch (error) {
      emit(state.copyWith(updating: false, error: error.toString()));
    }
  }

  Future<void> updateStatus({
    required String orderId,
    required String status,
  }) async {
    emit(state.copyWith(updating: true, clearError: true));
    try {
      final order =
          await _repository.updateOrderStatus(orderId: orderId, status: status);
      final refreshed = state.orders
          .map((item) => item.id == orderId ? order : item)
          .toList(growable: false);
      emit(state.copyWith(
          updating: false, orders: refreshed, selectedOrder: order));
    } catch (error) {
      emit(state.copyWith(updating: false, error: error.toString()));
    }
  }

  Future<void> updatePaymentStatus({
    required String orderId,
    required String paymentStatus,
  }) async {
    emit(state.copyWith(updating: true, clearError: true));
    try {
      final order = await _repository.updatePaymentStatus(
        orderId: orderId,
        paymentStatus: paymentStatus,
      );
      final refreshed = state.orders
          .map((item) => item.id == orderId ? order : item)
          .toList(growable: false);
      emit(state.copyWith(
          updating: false, orders: refreshed, selectedOrder: order));
    } catch (error) {
      emit(state.copyWith(updating: false, error: error.toString()));
    }
  }

  void clearSelection() => emit(state.copyWith(clearSelectedOrder: true));
}
