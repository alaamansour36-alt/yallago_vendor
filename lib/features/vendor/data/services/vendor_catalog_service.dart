import '../../../../core/network/api_client.dart';
import '../models/vendor_models.dart';

class VendorCatalogService {
  VendorCatalogService(this._apiClient);

  final ApiClient _apiClient;

  Future<List<VendorCategory>> getCategories() async {
    final data = await _apiClient.get('/categories/mine');
    return (data as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(VendorCategory.fromJson)
        .toList();
  }

  Future<List<VendorProduct>> getProducts() async {
    final data = await _apiClient.get('/products/mine');
    return (data as List<dynamic>)
        .whereType<Map<String, dynamic>>()
        .map(VendorProduct.fromJson)
        .toList();
  }

  Future<VendorProduct> createProduct({
    required String name,
    required String description,
    required double price,
    required bool isAvailable,
    String? imageUrl,
    String? categoryId,
  }) async {
    final data = await _apiClient.post(
      '/products',
      body: {
        'name': name,
        'description': description,
        'price': price,
        'isAvailable': isAvailable,
        'imageUrl': imageUrl,
        'categoryId': categoryId,
      },
    );
    return VendorProduct.fromJson(data as Map<String, dynamic>);
  }

  Future<VendorProduct> updateProduct({
    required String productId,
    required String name,
    required String description,
    required double price,
    required bool isAvailable,
    String? imageUrl,
    String? categoryId,
  }) async {
    final data = await _apiClient.put(
      '/products/$productId',
      body: {
        'name': name,
        'description': description,
        'price': price,
        'isAvailable': isAvailable,
        'imageUrl': imageUrl,
        'categoryId': categoryId,
      },
    );
    return VendorProduct.fromJson(data as Map<String, dynamic>);
  }

  Future<void> deleteProduct(String productId) =>
      _apiClient.delete('/products/$productId');

  Future<VendorCategory> createCategory({
    required String name,
    String? imageUrl,
  }) async {
    final data = await _apiClient.post(
      '/categories',
      body: {
        'name': name,
        'imageUrl': imageUrl,
      },
    );
    return VendorCategory.fromJson(data as Map<String, dynamic>);
  }
}
