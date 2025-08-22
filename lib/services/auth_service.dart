import 'package:bcrypt/bcrypt.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../database/db_helper.dart';
import '../models/user.dart';
import '../database/db_models.dart'; // for UserDbExtension.fromDbMap

class AuthService {
  static final AuthService _instance = AuthService._internal();
  final _dbHelper = DatabaseHelper();
  AuthService._internal();
  factory AuthService() => _instance;

  // ---- Helpers ----
  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();
  static const _kUserIdKey = 'userId';

  String _hash(String password) => BCrypt.hashpw(password, BCrypt.gensalt());
  bool _verify(String password, String hash) => BCrypt.checkpw(password, hash);

  Future<void> _saveUserId(String userId) async {
    final p = await _prefs;
    await p.setString(_kUserIdKey, userId);
  }

  Future<void> logout() async {
    final p = await _prefs;
    await p.remove(_kUserIdKey);
  }

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

    // Insert into users (include password_hash)
    await db.insert('users', {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'address': address,
      'image': image,
      'password_hash': passwordHash, // <-- here
      'created_at': DateTime.now().toIso8601String(),
      'updated_at': DateTime.now().toIso8601String(),
    });

    // Return the created user (without password)
    final row = (await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1)).first;
    return UserDbExtension.fromDbMap(row);
  }

// ---- Login ----
  Future<User?> login({required String email, required String password}) async {
    final db = await _dbHelper.database;

    print("🔍 Trying login with email: $email");
    print("🔑 Raw password entered: $password");

    final rows = await db.query(
      'users',
      columns: ['*'], // we need password_hash too
      where: 'email = ?',
      whereArgs: [email],
      limit: 1,
    );

    print("📊 Rows found: ${rows.length}");

    if (rows.isEmpty) {
      print("❌ No user found with this email");
      return null;
    }

    final row = rows.first;
    print("✅ User row: $row");

    final hash = row['password_hash'] as String?;
    print("🔒 Stored hash: $hash");

    if (hash == null) {
      print("❌ No password hash stored for this user");
      return null;
    }

    final passwordOk = _verify(password, hash);
    print("🔑 Password verification result: $passwordOk");

    if (!passwordOk) {
      print("❌ Wrong password");
      return null;
    }

    final user = UserDbExtension.fromDbMap(row);
    print("🎉 Login successful! User ID: ${user.id}");

    await _saveUserId(user.id);
    return user;
  }


  // ---- Current user ----
  Future<User?> currentUser() async {
      final id = await getLoggedInUserId();
      if (id == null) return null;

      final db = await _dbHelper.database;
      final rows = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
      if (rows.isEmpty) return null;

      return UserDbExtension.fromDbMap(rows.first);
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
}
