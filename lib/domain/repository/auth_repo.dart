import 'package:tumbrtest/domain/models/user.dart';

abstract class AuthRepository {
  Future<bool> signIn(String email, String password);
  Future<bool> signUp(User user, String password);
  Future<void> signOut();
}