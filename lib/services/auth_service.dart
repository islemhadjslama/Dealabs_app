import 'package:bcrypt/bcrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database/db_helper.dart';
import '../models/user.dart';
import '../database/db_models.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final _dbHelper = DatabaseHelper();
  AuthService._internal();
  factory AuthService() => _instance;

  // SharedPreferences
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();
  static const _kUserIdKey = 'userId';

  // Hashing
  String _hash(String password) => BCrypt.hashpw(password, BCrypt.gensalt());
  bool _verify(String password, String hash) => BCrypt.checkpw(password, hash);

  // Save userId
  Future<void> _saveUserId(String userId) async {
    final p = await _prefs;
    await p.setString(_kUserIdKey, userId);
  }

  // Logout
  Future<void> logout() async {
    final p = await _prefs;
    await p.remove(_kUserIdKey);
  }

  // Get logged-in user ID
  Future<String?> getLoggedInUserId() async {
    final p = await _prefs;
    return p.getString(_kUserIdKey);
  }

  // ---- Register ----
  Future<User> register({
    required String name,
    required String email,
    required String password,
    String phone = '',
    String address = '',
    String image = '',
  }) async {
    final db = await _dbHelper.database;

    // Enforce unique email
    final exists = await db.query(
      'users',
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );
    if (exists.isNotEmpty) {
      throw Exception('Email already in use');
    }

    final id = const Uuid().v4();
    final passwordHash = _hash(password);

    await db.insert('users', {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image,
      'password_hash': passwordHash,
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    final row = (await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1)).first;
    return UserDbExtension.fromDbMap(row);
  }

  // ---- Login ----
  Future<User?> login({required String email, required String password}) async {
    final db = await _dbHelper.database;

    final rows = await db.query(
      'users',
      columns: ['*'],
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    if (rows.isEmpty) return null;

    final row = rows.first;
    final hash = row['password_hash'] as String?;
    if (hash == null || !_verify(password, hash)) return null;

    final user = UserDbExtension.fromDbMap(row);
    await _saveUserId(user.id);
    return user;
  }

  // ---- Current user ----
  Future<User?> currentUser() async {
    final id = await getLoggedInUserId();
    if (id == null) return null;

    final db = await _dbHelper.database;
    final maps = await db.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (maps.isNotEmpty) {
      return UserDbExtension.fromDbMap(maps.first);
    }
    return null;
  }

  // ---- Change password ----
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final id = await getLoggedInUserId();
    if (id == null) throw Exception('Not logged in');

    final db = await _dbHelper.database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) throw Exception('User not found');

    final row = rows.first;
    final hash = row['password_hash'] as String?;
    if (hash == null || !_verify(currentPassword, hash)) {
      throw Exception('Current password is incorrect');
    }

    final newHash = _hash(newPassword);
    await db.update(
      'users',
      {
        'password_hash': newHash,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ---- Update profile info ----
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? image,
  }) async {
    final id = await getLoggedInUserId();
    if (id == null) throw Exception('No logged-in user');

    final db = await _dbHelper.database;

    // If email is being updated, ensure it's unique
    if (email != null) {
      final exists = await db.query(
        'users',
        where: 'email = ? AND id != ?',
        whereArgs: [email, id],
        limit: 1,
      );
      if (exists.isNotEmpty) throw Exception('Email already in use');
    }

    await db.update(
      'users',
      {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        if (image != null) 'image': image,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
