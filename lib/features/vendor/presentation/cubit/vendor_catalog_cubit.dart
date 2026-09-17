import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/vendor_models.dart';
import '../../data/repositories/vendor_catalog_repository.dart';

class VendorCatalogState {
  const VendorCatalogState({
    this.loading = false,
    this.saving = false,
    this.products = const [],
    this.categories = const [],
    this.error,
  });

  final bool loading;
  final bool saving;
  final List<VendorProduct> products;
  final List<VendorCategory> categories;
  final String? error;

  VendorCatalogState copyWith({
    bool? loading,
    bool? saving,
    List<VendorProduct>? products,
    List<VendorCategory>? categories,
    String? error,
    bool clearError = false,
  }) =>
      VendorCatalogState(
        loading: loading ?? this.loading,
        saving: saving ?? this.saving,
        products: products ?? this.products,
        categories: categories ?? this.categories,
        error: clearError ? null : (error ?? this.error),
      );
}

class VendorCatalogCubit extends Cubit<VendorCatalogState> {
  VendorCatalogCubit(this._repository) : super(const VendorCatalogState());

  final VendorCatalogRepository _repository;

  Future<void> load() async {
    emit(state.copyWith(loading: true, clearError: true));
    try {
      final results = await Future.wait([
        _repository.getProducts(),
        _repository.getCategories(),
      ]);
      emit(VendorCatalogState(
        products: results[0] as List<VendorProduct>,
        categories: results[1] as List<VendorCategory>,
      ));
    } catch (error) {
      emit(state.copyWith(loading: false, error: error.toString()));
    }
  }

  Future<void> saveProduct({
    String? productId,
    required String name,
    required String description,
    required double price,
    required bool isAvailable,
    String? imageUrl,
    String? categoryId,
  }) async {
    emit(state.copyWith(saving: true, clearError: true));
    try {
      if (productId == null) {
        await _repository.createProduct(
          name: name,
          description: description,
          price: price,
          isAvailable: isAvailable,
          imageUrl: imageUrl,
          categoryId: categoryId,
        );
      } else {
        await _repository.updateProduct(
          productId: productId,
          name: name,
          description: description,
          price: price,
          isAvailable: isAvailable,
          imageUrl: imageUrl,
          categoryId: categoryId,
        );
      }
      await load();
      emit(state.copyWith(saving: false));
    } catch (error) {
      emit(state.copyWith(saving: false, error: error.toString()));
    }
  }

  Future<void> deleteProduct(String productId) async {
    emit(state.copyWith(saving: true, clearError: true));
    try {
      await _repository.deleteProduct(productId);
      await load();
      emit(state.copyWith(saving: false));
    } catch (error) {
      emit(state.copyWith(saving: false, error: error.toString()));
    }
  }

  Future<void> createCategory({required String name, String? imageUrl}) async {
    emit(state.copyWith(saving: true, clearError: true));
    try {
      await _repository.createCategory(name: name, imageUrl: imageUrl);
      await load();
      emit(state.copyWith(saving: false));
    } catch (error) {
      emit(state.copyWith(saving: false, error: error.toString()));
    }
  }
}
