# Solución para Aumentar Cobertura

## Problema Identificado
La cobertura no aumenta porque:
1. `DiscoverPage` y `SearchPage` usan `InjectionContainer()` directamente
2. No podemos inyectar mocks fácilmente para forzar errores
3. Los tests dependen de la API real que puede funcionar o fallar aleatoriamente

## Archivos en ROJO (Según Reporte)
- `discover_page.dart`: **16.8%** (26 de 155 líneas)
- `search_page.dart`: **34.1%** (43 de 126 líneas)

## Tests Creados
1. `discover_page_complete_test.dart` - 30 tests
2. `discover_page_direct_coverage_test.dart` - 5 tests (1 test masivo que ejecuta todo)
3. `search_page_complete_test.dart` - 31 tests
4. `search_page_direct_coverage_test.dart` - 5 tests (1 test masivo que ejecuta todo)

**Total: 71 tests nuevos**

## Solución Práctica

### Opción 1: Verificar que los tests se ejecuten
```bash
flutter test test/widget/discover_page_complete_test.dart --coverage
flutter test test/widget/search_page_complete_test.dart --coverage
flutter test test/widget/discover_page_direct_coverage_test.dart --coverage
flutter test test/widget/search_page_direct_coverage_test.dart --coverage
```

### Opción 2: Ejecutar TODOS los tests y verificar cobertura
```bash
flutter test --coverage
lcov --summary coverage/lcov.info
```

### Opción 3: Generar reporte HTML y verificar líneas específicas
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage
open coverage/html/index.html
```

Luego navegar a:
- `lib/presentation/pages/discover_page.dart`
- `lib/presentation/pages/search_page.dart`

Y ver qué líneas específicas están en rojo.

## Posibles Causas si la Cobertura NO Sube

### 1. Tests no se están ejecutando
- Verificar errores de compilación
- Verificar que los tests pasen

### 2. Código no se ejecuta como esperamos
- Algunas líneas pueden requerir condiciones muy específicas
- Puede haber código muerto o inalcanzable

### 3. Problema con medición de cobertura
- Verificar que `--coverage` esté funcionando
- Verificar que `lcov` esté instalado correctamente

## Código Específico que Probablemente NO está Cubierto

### En `discover_page.dart`:
- Líneas 36-40: Manejo de error (fold Left) - **DIFÍCIL** sin mocks
- Líneas 42-46: Éxito (fold Right) - **SE EJECUTA** si API funciona
- Línea 52: `if (_products == null) return [];` - **SE EJECUTA** al inicio
- Línea 53: `if (_selectedCategory == 'All')` - **SE EJECUTA** por defecto
- Línea 54: Filtrado por categoría - **SE EJECUTA** al seleccionar categoría
- Línea 343: `if (_products == null) return;` - **DIFÍCIL** sin mocks
- Líneas 347-349: Ordenar Low to High - **SE EJECUTA** en tests
- Líneas 350-352: Ordenar High to Low - **SE EJECUTA** en tests
- Líneas 353-355: Caso default - **SE EJECUTA** por defecto

### En `search_page.dart`:
- Líneas 48-52: Manejo de error (fold Left) - **DIFÍCIL** sin mocks
- Líneas 54-58: Éxito (fold Right) - **SE EJECUTA** si API funciona
- Líneas 64-68: Query vacío - **SE EJECUTA** en tests
- Línea 71: `if (_allProducts == null) return;` - **SE EJECUTA** al inicio
- Líneas 73-80: Filtrar productos - **SE EJECUTA** al buscar
- Líneas 82-89: Agregar a recientes - **SE EJECUTA** en tests
- Líneas 85-87: Limitar a 5 - **SE EJECUTA** en tests
- Líneas 228-262: Sin resultados - **SE EJECUTA** con búsqueda inválida

## Recomendación Final

**El problema principal es que no podemos forzar errores fácilmente sin mocks.**

Para cubrir el código de manejo de errores (líneas 36-40 en discover_page y 48-52 en search_page), necesitaríamos:

1. **Modificar el código** para permitir inyección de dependencias (refactorizar)
2. **O usar un enfoque diferente** como interceptar las llamadas de red
3. **O aceptar** que algunas líneas de manejo de error no se pueden cubrir fácilmente

## Comando para Verificar Estado Actual

```bash
# Ejecutar todos los tests
flutter test --coverage

# Ver resumen
lcov --summary coverage/lcov.info

# Ver por archivo específico
lcov --list coverage/lcov.info | grep "discover_page.dart"
lcov --list coverage/lcov.info | grep "search_page.dart"

# Generar HTML y ver líneas exactas
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage
```

---

**Última actualización**: Enero 2026
**Tests creados**: 71 tests nuevos
**Estrategia**: Tests directos que ejecutan código paso a paso
