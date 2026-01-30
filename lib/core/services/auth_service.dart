/// Servicio de autenticación. Estado local (login/logout).
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isAuthenticated = false;
  String? _currentUser;

  bool get isAuthenticated => _isAuthenticated;
  String? get currentUser => _currentUser;

  Future<AuthResult> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure('Completa todos los campos');
    }
    if (password.length < 6) {
      return AuthResult.failure('La contraseña debe tener al menos 6 caracteres');
    }
    _isAuthenticated = true;
    _currentUser = email;
    return AuthResult.success(email);
  }

  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
  }
}

class AuthResult {
  final bool success;
  final String? message;
  final String? userEmail;

  AuthResult._({required this.success, this.message, this.userEmail});

  factory AuthResult.success(String email) =>
      AuthResult._(success: true, userEmail: email);

  factory AuthResult.failure(String message) =>
      AuthResult._(success: false, message: message);
}
