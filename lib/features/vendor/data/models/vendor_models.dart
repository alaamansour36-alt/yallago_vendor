class AuthSession {
  const AuthSession({
    required this.token,
    required this.userId,
    required this.email,
    required this.roles,
  });

  final String token;
  final String userId;
  final String email;
  final List<String> roles;

  factory AuthSession.fromJson(Map<String, dynamic> json) => AuthSession(
        token: json['token']?.toString() ?? '',
        userId: json['userId']?.toString() ?? '',
        email: json['email']?.toString() ?? '',
        roles: (json['roles'] as List<dynamic>? ?? const [])
            .map((role) => role.toString())
            .toList(),
      );
}

class VendorCategory {
  const VendorCategory({
    required this.id,
    required this.name,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String? imageUrl;

  factory VendorCategory.fromJson(Map<String, dynamic> json) => VendorCategory(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        imageUrl: json['imageUrl']?.toString(),
      );
}

class VendorProduct {
  const VendorProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    this.description,
    this.imageUrl,
    this.categoryId,
    this.categoryName,
  });

  final String id;
  final String name;
  final String? description;
  final double price;
  final bool isAvailable;
  final String? imageUrl;
  final String? categoryId;
  final String? categoryName;

  factory VendorProduct.fromJson(Map<String, dynamic> json) => VendorProduct(
        id: json['id']?.toString() ?? '',
        name: json['name']?.toString() ?? '',
        description: json['description']?.toString(),
        price: (json['price'] as num?)?.toDouble() ?? 0,
        isAvailable: json['isAvailable'] as bool? ?? true,
        imageUrl: json['imageUrl']?.toString(),
        categoryId: json['categoryId']?.toString(),
        categoryName: json['categoryName']?.toString(),
      );
}

class VendorOrderItem {
  const VendorOrderItem({
    required this.productName,
    required this.quantity,
    required this.unitPrice,
  });

  final String productName;
  final int quantity;
  final double unitPrice;

  factory VendorOrderItem.fromJson(Map<String, dynamic> json) =>
      VendorOrderItem(
        productName: json['productName']?.toString() ?? '',
        quantity: json['quantity'] as int? ?? 0,
        unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      );
}

class VendorOrder {
  const VendorOrder({
    required this.id,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.createdAt,
    required this.items,
    this.customerName,
    this.deliveryAddress,
    this.deliveryInstructions,
  });

  final String id;
  final String status;
  final String paymentStatus;
  final double totalAmount;
  final DateTime? createdAt;
  final List<VendorOrderItem> items;
  final String? customerName;
  final String? deliveryAddress;
  final String? deliveryInstructions;

  factory VendorOrder.fromJson(Map<String, dynamic> json) => VendorOrder(
        id: json['id']?.toString() ?? '',
        status: json['status']?.toString() ?? 'Pending',
        paymentStatus: json['paymentStatus']?.toString() ?? 'Pending',
        totalAmount: (json['totalAmount'] as num?)?.toDouble() ?? 0,
        createdAt: json['createdAt'] == null
            ? null
            : DateTime.tryParse(json['createdAt'].toString()),
        items: (json['items'] as List<dynamic>? ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(VendorOrderItem.fromJson)
            .toList(),
        customerName: json['customerName']?.toString(),
        deliveryAddress: json['deliveryAddress']?.toString(),
        deliveryInstructions: json['deliveryInstructions']?.toString(),
      );
}
