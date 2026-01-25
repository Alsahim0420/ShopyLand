# Guía Rápida de Testing

## 🚀 Inicio Rápido

### 1. Instalar Dependencias
```bash
flutter pub get
```

### 2. Generar Mocks
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Ejecutar Tests
```bash
# Todos los tests
flutter test

# Con cobertura
flutter test --coverage

# Usar script automatizado
./scripts/run_tests_with_coverage.sh
```

## 📊 Verificar Cobertura

```bash
# Verificar que cobertura sea >80%
./scripts/check_coverage.sh

# Ver reporte HTML
open coverage/html/index.html  # macOS
xdg-open coverage/html/index.html  # Linux
```

## 📁 Estructura de Tests

```
test/
├── unit/          # Tests unitarios
├── widget/        # Tests de widgets
└── integration/   # Tests de integración

integration_test/  # Tests de integración de UI
```

## 🔧 Comandos Útiles

```bash
# Ejecutar un test específico
flutter test test/unit/services/cart_service_test.dart

# Ejecutar tests de una carpeta
flutter test test/unit/

# Regenerar mocks en modo watch
flutter pub run build_runner watch --delete-conflicting-outputs

# Limpiar y regenerar
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📝 Notas Importantes

1. **Los mocks deben generarse antes de ejecutar tests unitarios**
2. **La cobertura se genera en `coverage/lcov.info`**
3. **El reporte HTML se genera en `coverage/html/`**
4. **Los scripts requieren lcov instalado** (ver scripts para instalación)

## 🐛 Solución de Problemas

### Error: "Mock class not found"
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Error: "lcov not found"
```bash
# macOS
brew install lcov

# Linux
sudo apt-get install lcov
```

### Tests fallan por dependencias
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## 📚 Documentación Completa

Ver `FASE6_DOCUMENTACION.md` para documentación detallada.
