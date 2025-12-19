import 'package:flutter_test/flutter_test.dart';
import 'package:shopyland/data/datasources/datasources.dart';
import 'package:shopyland/data/repositories/repositories.dart';
import 'package:shopyland/domain/usecases/usecases.dart';

void main() {
  group('API Integration Tests', () {
    late RemoteDataSource remoteDataSource;
    late ProductRepositoryImpl productRepository;
    late CategoryRepositoryImpl categoryRepository;
    late UserRepositoryImpl userRepository;

    setUp(() {
      remoteDataSource = RemoteDataSourceImpl();
      productRepository = ProductRepositoryImpl(
        remoteDataSource: remoteDataSource,
      );
      categoryRepository = CategoryRepositoryImpl(
        remoteDataSource: remoteDataSource,
      );
      userRepository = UserRepositoryImpl(remoteDataSource: remoteDataSource);
    });

    test('GetProducts usecase should return products', () async {
      // Arrange
      final getProducts = GetProducts(productRepository);

      // Act
      final result = await getProducts();

      // Assert
      result.fold((failure) => fail('Should not fail: ${failure.message}'), (
        products,
      ) {
        expect(products, isNotEmpty);
        expect(products.first.id, isPositive);
        expect(products.first.title, isNotEmpty);
        expect(products.first.price, isPositive);
      });
    });

    test('GetCategories usecase should return categories', () async {
      // Arrange
      final getCategories = GetCategories(categoryRepository);

      // Act
      final result = await getCategories();

      // Assert
      result.fold((failure) => fail('Should not fail: ${failure.message}'), (
        categories,
      ) {
        expect(categories, isNotEmpty);
        expect(categories.first.name, isNotEmpty);
      });
    });

    test('GetUsers usecase should return users', () async {
      // Arrange
      final getUsers = GetUsers(userRepository);

      // Act
      final result = await getUsers();

      // Assert
      result.fold((failure) => fail('Should not fail: ${failure.message}'), (
        users,
      ) {
        expect(users, isNotEmpty);
        expect(users.first.id, isPositive);
        expect(users.first.email, isNotEmpty);
        expect(users.first.username, isNotEmpty);
      });
    });
  });
}
