import '../../data/datasources/datasources.dart';
import '../../data/repositories/repositories.dart';
import '../../domain/usecases/usecases.dart';

/// Contenedor de inyección de dependencias
/// Centraliza la creación de dependencias siguiendo Clean Architecture
class InjectionContainer {
  // Datasources
  late final RemoteDataSource _remoteDataSource;

  // Repositories
  late final ProductRepositoryImpl _productRepository;
  late final CategoryRepositoryImpl _categoryRepository;
  late final UserRepositoryImpl _userRepository;

  // UseCases
  late final GetProducts _getProducts;
  late final GetCategories _getCategories;
  late final GetUsers _getUsers;

  InjectionContainer() {
    _initialize();
  }

  void _initialize() {
    // 1. Inicializar datasources
    _remoteDataSource = RemoteDataSourceImpl();

    // 2. Inicializar repositories
    _productRepository = ProductRepositoryImpl(
      remoteDataSource: _remoteDataSource,
    );
    _categoryRepository = CategoryRepositoryImpl(
      remoteDataSource: _remoteDataSource,
    );
    _userRepository = UserRepositoryImpl(remoteDataSource: _remoteDataSource);

    // 3. Inicializar use cases
    _getProducts = GetProducts(_productRepository);
    _getCategories = GetCategories(_categoryRepository);
    _getUsers = GetUsers(_userRepository);
  }

  // Getters para use cases (la presentación solo accede a estos)
  GetProducts get getProducts => _getProducts;
  GetCategories get getCategories => _getCategories;
  GetUsers get getUsers => _getUsers;
}
