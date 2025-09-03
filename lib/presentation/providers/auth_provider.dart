
import 'package:flutter/foundation.dart';
import 'package:tumbrtest/data/auth_repo_impl.dart';
import 'package:tumbrtest/domain/models/user.dart';


class AuthProvider with ChangeNotifier {
  final AuthRepositoryImpl _repository = AuthRepositoryImpl();
  
  bool _isLoading = false;
  String? _error;
  User? _currentUser;
  String _sharedEmail = '';
  String _sharedPassword = '';

  bool get isLoading => _isLoading;
  String? get error => _error;
  User? get currentUser => _currentUser;
  String get sharedEmail => _sharedEmail;
  String get sharedPassword => _sharedPassword;

  void updateSharedCredentials(String email, String password) {
    _sharedEmail = email;
    _sharedPassword = password;
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _repository.signIn(email, password);
      if (success) {
        updateSharedCredentials(email, password);
        _error = null;
      } else {
        _error = 'Invalid email or password';
      }
      return success;
    } catch (e) {
      _error = 'An error occurred during sign in';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(User user, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final success = await _repository.signUp(user, password);
      if (success) {
        _currentUser = user;
        updateSharedCredentials(user.email, password);
        _error = null;
      } else {
        _error = 'User with this email already exists';
      }
      return success;
    } catch (e) {
      _error = 'An error occurred during sign up';
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}