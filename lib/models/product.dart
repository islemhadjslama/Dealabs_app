class Product {
  final String id;
  final String name;
  final String description;
  final int originalPrice;
  final int discountedPrice;
  final int discountPercentage;
  final List<String> images;
  final double rating;
  final int reviews;
  final String brand;
  final String category;
  final String sellerName;
  final String sellerLocation;
  final bool inStock;
  final bool freeShipping;
  final List<String> specifications;
  final List<String> tags;
  final DateTime createdAt;
  final DateTime updatedAt;
  bool isFavorite;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.originalPrice,
    required this.discountedPrice,
    required this.discountPercentage,
    required this.images,
    required this.rating,
    required this.reviews,
    required this.brand,
    required this.category,
    required this.sellerName,
    required this.sellerLocation,
    required this.inStock,
    required this.freeShipping,
    required this.specifications,
    required this.tags,
    required this.createdAt,
    required this.updatedAt,
    required this.isFavorite,
  });

  int get savings => originalPrice - discountedPrice;
}

