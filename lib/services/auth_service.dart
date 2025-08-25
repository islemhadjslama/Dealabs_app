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

  Future<SharedPreferences> get _prefs async => SharedPreferences.getInstance();
  static const _kUserIdKey = 'userId';

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

  // ---- Register, Login, currentUser, changePassword here (unchanged) ----

  Future<User?> currentUser() async {
    final id = await getLoggedInUserId();
    if (id == null) return null;

    final db = await _dbHelper.database;
    final rows = await db.query('users', where: 'id = ?', whereArgs: [id], limit: 1);
    if (rows.isEmpty) return null;

    return UserDbExtension.fromDbMap(rows.first);
  }

  /// ---- NEW: Update profile info ----
  Future<void> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? address,
  }) async {
    final id = await getLoggedInUserId();
    if (id == null) throw Exception('No logged-in user');

    final db = await _dbHelper.database;
    await db.update(
      'users',
      {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (address != null) 'address': address,
        'updated_at': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
