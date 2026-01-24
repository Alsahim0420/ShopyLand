# Análisis de Cobertura - Estado Actual

## Cobertura Actual: 77.3% (1203 de 1557 líneas)
## Objetivo: 80% (1245 líneas)
## Faltan: ~42 líneas más

## Directorios en ROJO (prioridad alta)

### 1. `presentation/pages/` - 69.0% (561 de 813 líneas)
**Faltan: ~252 líneas**

#### Archivos principales a cubrir:
- `discover_page.dart` - Filtros, ordenamiento, banner, error handling
- `search_page.dart` - Búsqueda sin resultados, filtros, ordenamiento
- `cart_page.dart` - Diálogos, error en imágenes, listeners
- `product_detail_page.dart` - Error en imágenes, badge, descuentos
- `login_page.dart` - Error handling, forgot password, loading states
- `register_page.dart` - Error handling, social login, loading states
- `home_page.dart` - Cambio de tabs, gradiente

### 2. `domain/entities/` - 71.4% (40 de 56 líneas)
**Faltan: ~16 líneas**

#### Tests agregados:
- ✅ Comparaciones con tipos diferentes
- ✅ Comparaciones de todos los campos
- ✅ Tests para `NameEntity.fullName`
- ✅ Tests para todos los casos edge de `==` y `hashCode`

## Tests Creados Recientemente

### Tests Comprehensivos:
1. `discover_page_comprehensive_test.dart` - 10 tests
2. `search_page_comprehensive_test.dart` - 10 tests
3. `cart_page_comprehensive_test.dart` - 8 tests
4. `product_detail_comprehensive_test.dart` - 8 tests
5. `login_page_edge_cases_test.dart` - 8 tests
6. `register_page_edge_cases_test.dart` - 9 tests
7. `home_page_comprehensive_test.dart` - 6 tests

**Total: 59 nuevos tests**

## Estrategia para Llegar al 80%

### Paso 1: Ejecutar tests y generar reporte HTML
```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage
open coverage/html/index.html
```

### Paso 2: Identificar líneas específicas no cubiertas
El reporte HTML muestra exactamente qué líneas están en rojo (no cubiertas).

### Paso 3: Crear tests específicos para esas líneas
Enfocarse en:
- Condicionales que no se ejecutan (`if`, `else`, `switch`)
- Manejo de errores (`catch`, `errorBuilder`)
- Estados específicos (`_isLoading`, `_errorMessage != null`)
- Navegación y diálogos
- Listeners y callbacks

### Paso 4: Verificar cobertura después de cada batch de tests
```bash
flutter test --coverage
lcov --summary coverage/lcov.info
```

## Código Probablemente No Cubierto

### En `discover_page.dart`:
- Línea 36-40: Manejo de error en `_loadProducts`
- Línea 54: Filtrado por categoría específica (no "All")
- Línea 343: `if (_products == null) return;` en `_sortProducts`
- Línea 353-355: Caso default en switch de ordenamiento

### En `search_page.dart`:
- Línea 64-68: Búsqueda vacía
- Línea 82-89: Agregar a búsquedas recientes
- Línea 228-262: Vista de "No results found"
- Línea 285: TODO de ordenamiento (no implementado)

### En `cart_page.dart`:
- Línea 126-133: `errorBuilder` en imagen
- Línea 186-194: Decrementar cuando cantidad > 1
- Línea 297-322: Diálogo de limpiar carrito

### En `login_page.dart`:
- Línea 36: `if (!mounted) return;`
- Línea 46-49: Manejo de error en login
- Línea 67: `if (!mounted) return;`
- Línea 189-195: Forgot password
- Línea 204-224: Mostrar mensaje de error

### En `register_page.dart`:
- Línea 38-42: Validación de contraseñas no coinciden
- Línea 56: `if (!mounted) return;`
- Línea 228-230: Validación de confirmación de contraseña
- Línea 309-315: Google sign up
- Línea 329-335: Apple sign up

## Comandos Útiles

```bash
# Ver cobertura por directorio
lcov --summary coverage/lcov.info

# Ver cobertura por archivo
lcov --list coverage/lcov.info | grep "presentation/pages"

# Generar reporte HTML detallado
genhtml coverage/lcov.info -o coverage/html --no-function-coverage --no-branch-coverage

# Ver archivos con menor cobertura
genhtml coverage/lcov.info -o coverage/html 2>&1 | grep -E "Processing file|lines="
```

## Notas Importantes

1. **Los tests deben ejecutarse**: Asegúrate de que todos los tests se ejecuten correctamente
2. **Cobertura se calcula sobre líneas ejecutadas**: No importa si el test pasa o falla, solo si ejecuta el código
3. **Algunos tests pueden fallar**: Eso está bien, lo importante es que ejecuten el código
4. **Enfocarse en código rojo**: El reporte HTML muestra exactamente qué código no está cubierto

---

**Última actualización**: Enero 2026
**Total de archivos de test**: 50+
**Tests creados en esta sesión**: 59 nuevos tests
