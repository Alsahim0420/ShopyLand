# Plan para Llegar al 80% de Cobertura

## Estado Actual
- **Cobertura**: 77.3% (1203 de 1557 líneas)
- **Objetivo**: 80% (1245 líneas)
- **Faltan**: ~42 líneas más

## Áreas con Menor Cobertura (Según Reporte LCOV)

### 1. domain/entities/ - 48.2% (27 de 56 líneas)
**Faltan**: ~29 líneas

**Tests a agregar**:
- ✅ Tests de métodos `==` con casos `identical` (ya agregados)
- ✅ Tests de `hashCode` (ya agregados)
- ⚠️ Verificar que todos los casos edge de comparación estén cubiertos

### 2. presentation/pages/ - 64.0% (437 de 683 líneas)
**Faltan**: ~246 líneas (pero solo necesitamos ~42 líneas totales)

**Archivos específicos a cubrir**:
- `search_page.dart` - Funcionalidad de búsqueda, ordenamiento, resultados
- `discover_page.dart` - Filtros, ordenamiento, diálogo de filtros
- `product_list.dart` - Vista completa de lista, modal de detalles
- `cart_page.dart` - Diálogos, checkout

### 3. data/datasources/ - 79.3% (23 de 29 líneas)
**Faltan**: ~6 líneas (casi llega)

## Tests Específicos a Crear

### Para search_page.dart
```dart
// Test de limpiar búsqueda con botón clear
// Test de ordenamiento de resultados
// Test de agregar al carrito desde resultados
// Test de búsquedas recientes
// Test de categorías sugeridas
```

### Para discover_page.dart
```dart
// Test de filtros por categoría (todas las categorías)
// Test de ordenamiento (todos los casos)
// Test de diálogo de filtros completo
// Test de banner promocional completo
// Test de agregar al carrito desde grid
```

### Para product_list.dart
```dart
// Test de vista de lista completa (_buildFullCard)
// Test de modal de detalles completo
// Test de manejo de errores de imágenes
// Test de todas las interacciones
```

### Para cart_page.dart
```dart
// Test de diálogo de limpiar completo
// Test de checkout completo
// Test de resumen de orden completo
// Test de todas las interacciones
```

## Comandos para Verificar

```bash
# Ejecutar tests con cobertura
flutter test --coverage

# Ver resumen
lcov --summary coverage/lcov.info

# Ver reporte HTML detallado
open coverage/html/index.html

# Ver archivos con menor cobertura
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage 2>&1 | grep -E "Processing file|lines=" | paste - - | awk '{print $2, $4, $6}'
```

## Estrategia

1. **Revisar reporte HTML**: Abrir `coverage/html/index.html` y ver exactamente qué líneas no están cubiertas
2. **Crear tests específicos**: Para cada línea roja en el reporte, crear un test que la ejecute
3. **Enfocarse en páginas**: `presentation/pages/` tiene 683 líneas y solo 64% de cobertura
4. **Cubrir entidades**: `domain/entities/` tiene solo 48.2% de cobertura

## Notas

- Algunos tests pueden fallar debido a problemas de navegación/mocks, pero eso no afecta la cobertura
- La cobertura se calcula sobre líneas ejecutadas, no sobre tests que pasan
- El reporte HTML muestra exactamente qué código no está siendo ejecutado

---

**Última actualización**: Enero 2026
**Cobertura actual**: 77.3%
**Objetivo**: 80%
