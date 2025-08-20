import 'package:bcrypt/bcrypt.dart';

void main() {
  final password = 'password123';
  final hash = BCrypt.hashpw(password, BCrypt.gensalt());
  print('Hash: $hash');

  final isValid = BCrypt.checkpw(password, hash);
  print('Password matches: $isValid'); // should be true
}
