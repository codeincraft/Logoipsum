import 'package:tumbrtest/domain/models/user.dart';
import 'package:tumbrtest/domain/repository/auth_repo.dart';


class AuthRepositoryImpl implements AuthRepository {
  // Simulate database
  static final Map<String, Map<String, dynamic>> _users = {};

  @override
  Future<bool> signIn(String email, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    
    if (_users.containsKey(email)) {
      return _users[email]!['password'] == password;
    }
    return false;
  }

  @override
  Future<bool> signUp(User user, String password) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate network delay
    
    if (_users.containsKey(user.email)) {
      return false; // User already exists
    }
    
    _users[user.email] = {
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'dateOfBirth': user.dateOfBirth,
      'phoneNumber': user.phoneNumber,
      'password': password,
    };
    
    return true;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(Duration(milliseconds: 500));
  }
}
