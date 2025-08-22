import 'package:newapp/database/db_helper.dart';
import 'package:sqflite/sqflite.dart';

class FavoriteService {
  final DatabaseHelper _dbHelper = DatabaseHelper();

  /// Add product to favorites
  Future<void> addFavorite(String userId, String productId) async {
    final db = await _dbHelper.database;
    await db.insert(
      'favorites',
      {
        'user_id': userId,
        'product_id': productId,
        'created_at': DateTime.now().toIso8601String(),
      },
      conflictAlgorithm: ConflictAlgorithm.ignore, // avoids duplicate entries
    );
  }

  /// Remove product from favorites
  Future<void> removeFavorite(String userId, String productId) async {
    final db = await _dbHelper.database;
    await db.delete(
      'favorites',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
    );
  }

  /// Check if product is in favorites
  Future<bool> isFavorite(String userId, String productId) async {
    final db = await _dbHelper.database;
    final result = await db.query(
      'favorites',
      where: 'user_id = ? AND product_id = ?',
      whereArgs: [userId, productId],
      limit: 1,
    );
    return result.isNotEmpty;
  }

  /// Get all favorite products for a user
  Future<List<Map<String, dynamic>>> getFavorites(String userId) async {
    final db = await _dbHelper.database;
    return await db.rawQuery('''
      SELECT p.* FROM products p
      INNER JOIN favorites f ON p.id = f.product_id
      WHERE f.user_id = ?
    ''', [userId]);
  }
}
