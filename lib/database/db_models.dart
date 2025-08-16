import 'dart:convert';
import '../../models/product.dart';
import '../../models/user.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart';
import '../../models/order_product.dart';

/// Extension methods to convert between app models and database maps

extension ProductDbExtension on Product {
  // Convert Product to database map
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'original_price': originalPrice,
      'discounted_price': discountedPrice,
      'discount_percentage': discountPercentage,
      'images': jsonEncode(images),
      'rating': rating,
      'reviews': reviews,
      'brand': brand,
      'category': category,
      'seller_name': sellerName,
      'seller_location': sellerLocation,
      'in_stock': inStock ? 1 : 0,
      'free_shipping': freeShipping ? 1 : 0,
      'specifications': jsonEncode(specifications),
      'tags': jsonEncode(tags),
      'is_favorite': isFavorite ? 1 : 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Create Product from database map
  static Product fromDbMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'],
      name: map['name'],
      description: map['description'],
      originalPrice: map['original_price'],
      discountedPrice: map['discounted_price'],
      discountPercentage: map['discount_percentage'],
      images: List<String>.from(jsonDecode(map['images'])),
      rating: map['rating'].toDouble(),
      reviews: map['reviews'],
      brand: map['brand'],
      category: map['category'],
      sellerName: map['seller_name'],
      sellerLocation: map['seller_location'],
      inStock: map['in_stock'] == 1,
      freeShipping: map['free_shipping'] == 1,
      specifications: List<String>.from(jsonDecode(map['specifications'])),
      tags: List<String>.from(jsonDecode(map['tags'])),
      isFavorite: map['is_favorite'] == 1,
      createdAt: DateTime.parse(map['created_at']),
      updatedAt: DateTime.parse(map['updated_at']),
    );
  }

}

extension UserDbExtension on User {
  // Convert User to database map
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Create User from database map
  static User fromDbMap(Map<String, dynamic> map) {
    return User(
      id: map['id'],
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      address: map['address'],
      image: map['image'],
    );
  }
}

extension CartItemDbExtension on CartItem {
  // Convert CartItem to database map
  Map<String, dynamic> toDbMap(String userId) {
    return {
      'user_id': userId,
      'product_id': product.id,
      'quantity': quantity,
      'is_selected': isSelected ? 1 : 0,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Create CartItem from database map with product data
  static CartItem fromDbMapWithProduct(
    Map<String, dynamic> cartMap,
    Product product,
  ) {
    return CartItem(
      product: product,
      quantity: cartMap['quantity'],
      isSelected: cartMap['is_selected'] == 1,
    );
  }
}

extension OrderDbExtension on Order {
  // Convert Order to database map
  Map<String, dynamic> toDbMap() {
    return {
      'id': id,
      'user_id': userId,
      'total_amount': totalAmount,
      'payment_method': paymentMethod,
      'shipping_address': shippingAddress,
      'placement_date': placementDate.toIso8601String(),
      'delivery_date': deliveryDate.toIso8601String(),
      'status': status,
      'shipping_fee': shippingFee,
      'discount': discount,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  // Create Order from database map (without products - they're loaded separately)
  static Order fromDbMap(
    Map<String, dynamic> map,
    List<OrderProduct> products,
  ) {
    return Order(
      id: map['id'],
      products: products,
      totalAmount: map['total_amount'],
      paymentMethod: map['payment_method'],
      shippingAddress: map['shipping_address'],
      placementDate: DateTime.parse(map['placement_date']),
      deliveryDate: DateTime.parse(map['delivery_date']),
      status: map['status'],
      shippingFee: map['shipping_fee'],
      discount: map['discount'],
      userId: map['user_id'],
    );
  }
}

extension OrderProductDbExtension on OrderProduct {
  // Convert OrderProduct to database map
  Map<String, dynamic> toDbMap(String orderId) {
    return {
      'order_id': orderId,
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'quantity': quantity,
      'subtotal': subtotal,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  // Create OrderProduct from database map
  static OrderProduct fromDbMap(Map<String, dynamic> map) {
    return OrderProduct(
      productId: map['product_id'],
      productName: map['product_name'],
      productImage: map['product_image'],
      quantity: map['quantity'],
      subtotal: map['subtotal'],
    );
  }
}

// Database model for Category (since it's not in your original models)
class CategoryDb {
  final int? id;
  final String title;
  final int iconCode;

  CategoryDb({this.id, required this.title, required this.iconCode});

  Map<String, dynamic> toDbMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'icon_code': iconCode,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    };
  }

  static CategoryDb fromDbMap(Map<String, dynamic> map) {
    return CategoryDb(
      id: map['id'],
      title: map['title'],
      iconCode: map['icon_code'],
    );
  }
}

// Database model for Favorites
class FavoriteDb {
  final int? id;
  final String userId;
  final String productId;

  FavoriteDb({this.id, required this.userId, required this.productId});

  Map<String, dynamic> toDbMap() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'product_id': productId,
      'created_at': DateTime.now().toIso8601String(),
    };
  }

  static FavoriteDb fromDbMap(Map<String, dynamic> map) {
    return FavoriteDb(
      id: map['id'],
      userId: map['user_id'],
      productId: map['product_id'],
    );
  }
}
