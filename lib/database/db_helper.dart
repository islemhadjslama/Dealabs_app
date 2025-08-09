import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'ecommerce_app.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    // Products table
    await db.execute('''
      CREATE TABLE products (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        description TEXT NOT NULL,
        original_price INTEGER NOT NULL,
        discounted_price INTEGER NOT NULL,
        discount_percentage INTEGER NOT NULL,
        images TEXT NOT NULL, -- JSON array as string
        rating REAL NOT NULL,
        reviews INTEGER NOT NULL,
        brand TEXT NOT NULL,
        category TEXT NOT NULL,
        seller_name TEXT NOT NULL,
        seller_location TEXT NOT NULL,
        in_stock INTEGER NOT NULL, -- 0 or 1 (boolean)
        free_shipping INTEGER NOT NULL, -- 0 or 1 (boolean)
        specifications TEXT NOT NULL, -- JSON array as string
        tags TEXT NOT NULL, -- JSON array as string
        is_favorite INTEGER NOT NULL DEFAULT 0, -- 0 or 1 (boolean)
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Users table
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        address TEXT NOT NULL,
        image TEXT NOT NULL,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Cart items table
    await db.execute('''
      CREATE TABLE cart_items (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        is_selected INTEGER NOT NULL DEFAULT 1, -- 0 or 1 (boolean)
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (product_id) REFERENCES products (id),
        UNIQUE(user_id, product_id)
      )
    ''');

    // Orders table
    await db.execute('''
      CREATE TABLE orders (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        total_amount INTEGER NOT NULL,
        payment_method TEXT NOT NULL DEFAULT 'Cash',
        shipping_address TEXT NOT NULL,
        placement_date TEXT NOT NULL,
        delivery_date TEXT NOT NULL,
        status TEXT NOT NULL,
        shipping_fee INTEGER NOT NULL DEFAULT 0,
        discount INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id)
      )
    ''');

    // Order products table (items in each order)
    await db.execute('''
      CREATE TABLE order_products (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        order_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        product_name TEXT NOT NULL,
        product_image TEXT NOT NULL,
        quantity INTEGER NOT NULL,
        subtotal INTEGER NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (order_id) REFERENCES orders (id),
        FOREIGN KEY (product_id) REFERENCES products (id)
      )
    ''');

    // Categories table
    await db.execute('''
      CREATE TABLE categories (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL UNIQUE,
        icon_code INTEGER NOT NULL, -- IconData codePoint
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    // Favorites table (alternative to is_favorite in products)
    await db.execute('''
      CREATE TABLE favorites (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id TEXT NOT NULL,
        product_id TEXT NOT NULL,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users (id),
        FOREIGN KEY (product_id) REFERENCES products (id),
        UNIQUE(user_id, product_id)
      )
    ''');

    // Create indexes for better performance
    await db.execute(
      'CREATE INDEX idx_products_category ON products (category)',
    );
    await db.execute('CREATE INDEX idx_products_brand ON products (brand)');
    await db.execute(
      'CREATE INDEX idx_products_is_favorite ON products (is_favorite)',
    );
    await db.execute(
      'CREATE INDEX idx_cart_items_user_id ON cart_items (user_id)',
    );
    await db.execute('CREATE INDEX idx_orders_user_id ON orders (user_id)');
    await db.execute(
      'CREATE INDEX idx_order_products_order_id ON order_products (order_id)',
    );
    await db.execute(
      'CREATE INDEX idx_favorites_user_id ON favorites (user_id)',
    );
  }

  // Helper methods for common operations
  Future<void> insertData(String table, Map<String, dynamic> data) async {
    final db = await database;
    await db.insert(table, data, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> queryData(
    String table, {
    String? where,
    List<dynamic>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = await database;
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  Future<int> updateData(
    String table,
    Map<String, dynamic> data, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    data['updated_at'] = DateTime.now().toIso8601String();
    return await db.update(table, data, where: where, whereArgs: whereArgs);
  }

  Future<int> deleteData(
    String table, {
    required String where,
    required List<dynamic> whereArgs,
  }) async {
    final db = await database;
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  // Raw query method for complex queries
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<dynamic>? arguments,
  ]) async {
    final db = await database;
    return await db.rawQuery(sql, arguments);
  }

  // Get database info
  Future<void> printDatabaseInfo() async {
    final db = await database;
    print('Database path: ${db.path}');

    // Print all tables
    final tables = await db.rawQuery(
      "SELECT name FROM sqlite_master WHERE type='table'",
    );
    print('Tables: ${tables.map((t) => t['name']).toList()}');
  }

  // Clear all data (useful for development/testing)
  Future<void> clearAllData() async {
    final db = await database;

    // Delete all data from tables
    await db.delete('order_products');
    await db.delete('orders');
    await db.delete('cart_items');
    await db.delete('favorites');
    await db.delete('products');
    await db.delete('users');
    await db.delete('categories');
  }

  // Close database connection
  Future<void> closeDatabase() async {
    final db = await database;
    await db.close();
  }
}
