/// Servicio de autenticación simple
/// Maneja el estado de login del usuario
class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  bool _isAuthenticated = false;
  String? _currentUser;

  /// Credenciales demo
  static const String demoEmail = 'demo@shopyland.com';
  static const String demoPassword = 'demo123';

  /// Verifica si el usuario está autenticado
  bool get isAuthenticated => _isAuthenticated;

  /// Obtiene el usuario actual
  String? get currentUser => _currentUser;

  /// Inicia sesión con credenciales demo
  /// Retorna true si el login es exitoso, false si hay error
  Future<AuthResult> loginWithDemo() async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 800));

      // Validar credenciales demo
      _isAuthenticated = true;
      _currentUser = demoEmail;

      return AuthResult.success(demoEmail);
    } catch (e) {
      return AuthResult.failure('Error al iniciar sesión: $e');
    }
  }

  /// Inicia sesión con email y password
  Future<AuthResult> login(String email, String password) async {
    try {
      // Simular delay de red
      await Future.delayed(const Duration(milliseconds: 800));

      // Validar credenciales
      if (email.isEmpty || password.isEmpty) {
        return AuthResult.failure('Por favor completa todos los campos');
      }

      if (email == demoEmail && password == demoPassword) {
        _isAuthenticated = true;
        _currentUser = email;
        return AuthResult.success(email);
      }

      return AuthResult.failure('Credenciales incorrectas');
    } catch (e) {
      return AuthResult.failure('Error al iniciar sesión: $e');
    }
  }

  /// Cierra sesión
  void logout() {
    _isAuthenticated = false;
    _currentUser = null;
  }
}

/// Resultado de autenticación
class AuthResult {
  final bool success;
  final String? message;
  final String? userEmail;

  AuthResult._({
    required this.success,
    this.message,
    this.userEmail,
  });

  factory AuthResult.success(String email) {
    return AuthResult._(
      success: true,
      userEmail: email,
    );
  }

  factory AuthResult.failure(String message) {
    return AuthResult._(
      success: false,
      message: message,
    );
  }
}
