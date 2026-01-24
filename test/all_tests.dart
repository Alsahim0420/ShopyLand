import 'package:flutter_test/flutter_test.dart';

// Importar todos los tests unitarios
import 'unit/usecases/get_products_test.dart' as get_products_test;
import 'unit/usecases/get_categories_test.dart' as get_categories_test;
import 'unit/usecases/get_users_test.dart' as get_users_test;
import 'unit/repositories/product_repository_impl_test.dart' as product_repo_test;
import 'unit/repositories/category_repository_impl_test.dart' as category_repo_test;
import 'unit/repositories/user_repository_impl_test.dart' as user_repo_test;
import 'unit/services/cart_service_test.dart' as cart_service_test;
import 'unit/services/auth_service_test.dart' as auth_service_test;
import 'unit/models/product_model_test.dart' as product_model_test;
import 'unit/models/category_model_test.dart' as category_model_test;
import 'unit/models/user_model_test.dart' as user_model_test;
import 'unit/models/cart_item_test.dart' as cart_item_test;
import 'widget/product_card_test.dart' as product_card_test;
import 'widget/product_list_test.dart' as product_list_test;
import 'widget/category_list_test.dart' as category_list_test;
import 'integration/cart_integration_test.dart' as cart_integration_test;
import 'integration/auth_integration_test.dart' as auth_integration_test;

void main() {
  group('Use Cases Tests', () {
    get_products_test.main();
    get_categories_test.main();
    get_users_test.main();
  });

  group('Repositories Tests', () {
    product_repo_test.main();
    category_repo_test.main();
    user_repo_test.main();
  });

  group('Services Tests', () {
    cart_service_test.main();
    auth_service_test.main();
  });

  group('Models Tests', () {
    product_model_test.main();
    category_model_test.main();
    user_model_test.main();
    cart_item_test.main();
  });

  group('Widget Tests', () {
    product_card_test.main();
    product_list_test.main();
    category_list_test.main();
  });

  group('Integration Tests', () {
    cart_integration_test.main();
    auth_integration_test.main();
  });
}
