import '../models/vendor_models.dart';
import '../services/vendor_catalog_service.dart';

class VendorCatalogRepository {
  VendorCatalogRepository(this._service);

  final VendorCatalogService _service;

  Future<List<VendorCategory>> getCategories() => _service.getCategories();

  Future<List<VendorProduct>> getProducts() => _service.getProducts();

  Future<VendorProduct> createProduct({
    required String name,
    required String description,
    required double price,
    required bool isAvailable,
    String? imageUrl,
    String? categoryId,
  }) =>
      _service.createProduct(
        name: name,
        description: description,
        price: price,
        isAvailable: isAvailable,
        imageUrl: imageUrl,
        categoryId: categoryId,
      );

  Future<VendorProduct> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required bool isAvailable,
    String? imageUrl,
    String? categoryId,
  }) =>
      _service.updateProduct(
        productId: productId,
        name: name,
        description: description,
        price: price,
        isAvailable: isAvailable,
        imageUrl: imageUrl,
        categoryId: categoryId,
      );

  Future<void> deleteProduct(String productId) =>
      _service.deleteProduct(productId);

  Future<VendorCategory> createCategory({
    required String name,
    String? imageUrl,
  }) =>
      _service.createCategory(name: name, imageUrl: imageUrl);
}
