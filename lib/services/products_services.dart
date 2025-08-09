import 'package:newapp/database/db_helper.dart';
import 'package:newapp/database/db_models.dart';

import '../models/product.dart';

class ProductsService {
  static final ProductsService _instance = ProductsService._internal();
  final DatabaseHelper _dbHelper = DatabaseHelper();

  ProductsService._internal();

  factory ProductsService() => _instance;

  // Create a new product in the database
  Future<bool> createProduct(Product product) async {
    try {
      await _dbHelper.insertData('products', product.toDbMap());
      return true;
    } catch (e) {
      print('Error creating product: $e');
      return false;
    }
  }

  // Create multiple products at once
  Future<bool> createMultipleProducts(List<Product> products) async {
    try {
      final db = await _dbHelper.database;
      final batch = db.batch();

      for (final product in products) {
        batch.insert('products', product.toDbMap());
      }

      await batch.commit(noResult: true);
      return true;
    } catch (e) {
      print('Error creating multiple products: $e');
      return false;
    }
  }

  // Get product by ID
  Future<Product?> getProductById(String productId) async {
    try {
      final result = await _dbHelper.queryData(
        'products',
        where: 'id = ?',
        whereArgs: [productId],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return ProductDbExtension.fromDbMap(result.first);
      }
      return null;
    } catch (e) {
      print('Error getting product by ID: $e');
      return null;
    }
  }

  // Get all products by category
  Future<List<Product>> getProductsByCategory(String category) async {
    try {
      final result = await _dbHelper.queryData(
        'products',
        where: 'category = ?',
        whereArgs: [category],
        orderBy: 'name ASC',
      );

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error getting products by category: $e');
      return [];
    }
  }

  // Get all products
  Future<List<Product>> getAllProducts() async {
    try {
      final result = await _dbHelper.queryData('products', orderBy: 'name ASC');

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error getting all products: $e');
      return [];
    }
  }

  // Get products with pagination
  Future<List<Product>> getProductsPaginated({
    required int limit,
    required int offset,
    String? category,
  }) async {
    try {
      String? whereClause;
      List<dynamic>? whereArgs;

      if (category != null) {
        whereClause = 'category = ?';
        whereArgs = [category];
      }

      final result = await _dbHelper.rawQuery(
        '''
        SELECT * FROM products 
        ${whereClause != null ? 'WHERE $whereClause' : ''}
        ORDER BY name ASC 
        LIMIT ? OFFSET ?
        ''',
        whereArgs != null ? [...whereArgs, limit, offset] : [limit, offset],
      );

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error getting paginated products: $e');
      return [];
    }
  }

  // Get products by brand
  Future<List<Product>> getProductsByBrand(String brand) async {
    try {
      final result = await _dbHelper.queryData(
        'products',
        where: 'brand = ?',
        whereArgs: [brand],
        orderBy: 'name ASC',
      );

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error getting products by brand: $e');
      return [];
    }
  }

  // Search products by name or description
  Future<List<Product>> searchProducts(String query) async {
    try {
      final result = await _dbHelper.queryData(
        'products',
        where: 'name LIKE ? OR description LIKE ?',
        whereArgs: ['%$query%', '%$query%'],
        orderBy: 'name ASC',
      );

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error searching products: $e');
      return [];
    }
  }

  // Get products on sale (with discount)
  Future<List<Product>> getProductsOnSale() async {
    try {
      final result = await _dbHelper.queryData(
        'products',
        where: 'discount_percentage > 0',
        orderBy: 'discount_percentage DESC',
      );

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error getting products on sale: $e');
      return [];
    }
  }

  // Get in-stock products
  Future<List<Product>> getInStockProducts() async {
    try {
      final result = await _dbHelper.queryData(
        'products',
        where: 'in_stock = 1',
        orderBy: 'name ASC',
      );

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error getting in-stock products: $e');
      return [];
    }
  }

  // Get products by price range
  Future<List<Product>> getProductsByPriceRange({
    required int minPrice,
    required int maxPrice,
    String? category,
  }) async {
    try {
      String whereClause = 'discounted_price >= ? AND discounted_price <= ?';
      List<dynamic> whereArgs = [minPrice, maxPrice];

      if (category != null) {
        whereClause += ' AND category = ?';
        whereArgs.add(category);
      }

      final result = await _dbHelper.queryData(
        'products',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'discounted_price ASC',
      );

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error getting products by price range: $e');
      return [];
    }
  }

  // Update product
  Future<bool> updateProduct(Product product) async {
    try {
      final updated = await _dbHelper.updateData(
        'products',
        product.toDbMap(),
        where: 'id = ?',
        whereArgs: [product.id],
      );
      return updated > 0;
    } catch (e) {
      print('Error updating product: $e');
      return false;
    }
  }

  // Toggle product favorite status
  Future<bool> toggleProductFavorite(String productId) async {
    try {
      final product = await getProductById(productId);
      if (product == null) return false;

      final updated = await _dbHelper.updateData(
        'products',
        {'is_favorite': product.isFavorite ? 0 : 1},
        where: 'id = ?',
        whereArgs: [productId],
      );
      return updated > 0;
    } catch (e) {
      print('Error toggling product favorite: $e');
      return false;
    }
  }

  // Get favorite products
  Future<List<Product>> getFavoriteProducts() async {
    try {
      final result = await _dbHelper.queryData(
        'products',
        where: 'is_favorite = 1',
        orderBy: 'name ASC',
      );

      return result.map((map) => ProductDbExtension.fromDbMap(map)).toList();
    } catch (e) {
      print('Error getting favorite products: $e');
      return [];
    }
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    try {
      final deleted = await _dbHelper.deleteData(
        'products',
        where: 'id = ?',
        whereArgs: [productId],
      );
      return deleted > 0;
    } catch (e) {
      print('Error deleting product: $e');
      return false;
    }
  }

  // Get unique categories from products
  Future<List<String>> getUniqueCategories() async {
    try {
      final result = await _dbHelper.rawQuery(
        'SELECT DISTINCT category FROM products ORDER BY category ASC',
      );

      return result.map((map) => map['category'] as String).toList();
    } catch (e) {
      print('Error getting unique categories: $e');
      return [];
    }
  }

  // Get unique brands from products
  Future<List<String>> getUniqueBrands() async {
    try {
      final result = await _dbHelper.rawQuery(
        'SELECT DISTINCT brand FROM products ORDER BY brand ASC',
      );

      return result.map((map) => map['brand'] as String).toList();
    } catch (e) {
      print('Error getting unique brands: $e');
      return [];
    }
  }

  // Get product count by category
  Future<Map<String, int>> getProductCountByCategory() async {
    try {
      final result = await _dbHelper.rawQuery(
        'SELECT category, COUNT(*) as count FROM products GROUP BY category',
      );

      final Map<String, int> categoryCount = {};
      for (final map in result) {
        categoryCount[map['category'] as String] = map['count'] as int;
      }

      return categoryCount;
    } catch (e) {
      print('Error getting product count by category: $e');
      return {};
    }
  }

  // Check if product exists
  Future<bool> productExists(String productId) async {
    try {
      final result = await _dbHelper.rawQuery(
        'SELECT COUNT(*) as count FROM products WHERE id = ?',
        [productId],
      );

      return (result.first['count'] as int) > 0;
    } catch (e) {
      print('Error checking if product exists: $e');
      return false;
    }
  }

  // Clear all products (useful for development/testing)
  Future<bool> clearAllProducts() async {
    try {
      await _dbHelper.deleteData('products', where: '1', whereArgs: []);
      return true;
    } catch (e) {
      print('Error clearing all products: $e');
      return false;
    }
  }
}
