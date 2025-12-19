# FASE 2 - Documentación: Lectura de Datos API

## Descripción General

Esta fase implementa el consumo de la API Fake Store utilizando Dart, con modelos de datos inmutables, manejo de errores con `Either` de la biblioteca `dartz`, y presentación de datos en consola.

## Estructura del Proyecto

```
lib/
├── main.dart                 # Punto de entrada de la aplicación
├── models/                   # Modelos de datos inmutables
│   ├── product.dart         # Modelo para productos
│   ├── category.dart        # Modelo para categorías
│   ├── user.dart            # Modelo para usuarios
│   └── models.dart          # Exportación centralizada
└── services/
    └── api_service.dart     # Servicio para consumir la API
```

## Diseño de Modelos de Datos

### 1. Modelo Product (Producto)

El modelo `Product` representa un producto de la tienda en línea. Es completamente inmutable y contiene:

- **Campos principales:**
  - `id`: Identificador único del producto
  - `title`: Título del producto
  - `price`: Precio del producto (double)
  - `description`: Descripción detallada
  - `category`: Categoría a la que pertenece
  - `image`: URL de la imagen del producto
  - `rating`: Objeto `Rating` con la calificación

- **Modelo anidado Rating:**
  - `rate`: Calificación promedio (double)
  - `count`: Número de reseñas (int)

**Características de inmutabilidad:**
- Todos los campos son `final`
- Constructor `const` disponible
- Métodos `fromJson` y `toJson` para serialización

### 2. Modelo Category (Categoría)

El modelo `Category` representa una categoría de productos. Es simple pero inmutable:

- **Campos:**
  - `name`: Nombre de la categoría

**Características:**
- Maneja diferentes formatos de respuesta de la API (string directo o objeto)
- Implementa `==` y `hashCode` para comparación

### 3. Modelo User (Usuario)

El modelo `User` representa un usuario del sistema. Contiene información completa:

- **Campos principales:**
  - `id`: Identificador único
  - `email`: Correo electrónico
  - `username`: Nombre de usuario
  - `name`: Objeto `Name` con nombre y apellido
  - `address`: Objeto `Address` con información de dirección
  - `phone`: Número de teléfono

- **Modelos anidados:**
  - **Name:** `firstname`, `lastname` (con getter `fullName`)
  - **Address:** `city`, `street`, `number`, `zipcode`, `geolocation`
  - **Geolocation:** `lat`, `long`

**Características:**
- Estructura jerárquica que refleja la estructura de la API
- Todos los modelos anidados también son inmutables

## Implementación del Servicio de API

### ApiService

La clase `ApiService` encapsula toda la lógica de comunicación con la API Fake Store.

**Endpoints consumidos:**
1. `GET /products` - Lista de todos los productos
2. `GET /products/categories` - Lista de todas las categorías
3. `GET /users` - Lista de todos los usuarios

**Características:**
- Utiliza el paquete `http` para realizar solicitudes HTTP
- Base URL: `https://fakestoreapi.com`
- Permite inyección de dependencias (cliente HTTP personalizable para testing)

### Métodos del Servicio

Cada método retorna `Future<Either<ApiError, T>>` donde:
- **Left (ApiError):** Representa un error
- **Right (T):** Representa el resultado exitoso

**Métodos implementados:**
- `getProducts()`: Retorna `Either<ApiError, List<Product>>`
- `getCategories()`: Retorna `Either<ApiError, List<Category>>`
- `getUsers()`: Retorna `Either<ApiError, List<User>>`

## Control de Errores con Either

### Clase ApiError

Clase personalizada para representar errores de la API:
- `message`: Mensaje descriptivo del error
- `statusCode`: Código HTTP (opcional)

### Uso de Either

El tipo `Either` de `dartz` permite manejar errores de forma funcional:

```dart
result.fold(
  // Manejo de error (Left)
  (error) => print('Error: ${error.message}'),
  // Manejo de éxito (Right)
  (data) => print('Datos: $data'),
);
```

**Ventajas:**
- Type-safe: El compilador fuerza el manejo de ambos casos
- Funcional: No se lanzan excepciones, se manejan como valores
- Explícito: El tipo de retorno indica claramente que puede fallar

### Tipos de Errores Manejados

1. **Errores de conexión:** Problemas de red o timeout
2. **Errores HTTP:** Códigos de estado diferentes a 200
3. **Errores de parsing:** JSON malformado o estructura inesperada

## Procesamiento y Presentación en Consola

### Función main()

La función `main()` orquesta el consumo de los tres endpoints y la presentación de datos:

1. **Obtiene productos:** Muestra los primeros 5 productos con información detallada
2. **Obtiene categorías:** Lista todas las categorías disponibles
3. **Obtiene usuarios:** Muestra todos los usuarios con información completa

### Formato de Salida

La salida en consola está formateada para ser legible:
- Separadores visuales (`=` y `-`)
- Emojis para identificación rápida (📦, 🏷️, 👥)
- Información estructurada con indentación
- Manejo de errores con mensajes claros (❌, ✅)

### Ejemplo de Salida

```
================================================================================
CONSUMO DE API FAKE STORE - FASE 2
================================================================================

📦 OBTENIENDO PRODUCTOS...
--------------------------------------------------------------------------------
✅ Se obtuvieron 20 productos

Producto 1:
  ID: 1
  Título: Fjallraven - Foldsack No. 1 Backpack
  Precio: $109.95
  Categoría: men's clothing
  Calificación: 3.9 ⭐ (120 reseñas)
  Descripción: Your perfect pack for everyday use and walks in the forest...
...
```

## Decisiones de Diseño

### 1. Inmutabilidad

Todos los modelos son inmutables usando `final` y constructores `const`. Esto garantiza:
- Thread-safety
- Prevención de modificaciones accidentales
- Mejor rendimiento en algunos casos

### 2. Separación de Responsabilidades

- **Modelos:** Solo representan datos
- **Servicio:** Solo maneja comunicación HTTP
- **Main:** Solo orquesta y presenta

### 3. Manejo Funcional de Errores

Uso de `Either` en lugar de excepciones:
- Más predecible
- Type-safe
- Alineado con programación funcional

### 4. Serialización JSON

Cada modelo implementa:
- `fromJson`: Para deserializar desde la API
- `toJson`: Para serializar (útil para testing o persistencia futura)

### 5. Exportación Centralizada

El archivo `models.dart` exporta todos los modelos, facilitando imports:
```dart
import 'package:shopyland/models/models.dart';
```

## Dependencias Utilizadas

- **http (^1.2.0):** Para realizar solicitudes HTTP
- **dartz (^0.10.1):** Para el tipo `Either` y programación funcional

## Ejecución

Para ejecutar la aplicación:

```bash
flutter pub get
dart run lib/main.dart
```

O si se ejecuta como aplicación Flutter:

```bash
flutter run
```

## Pruebas y Validación

La implementación maneja correctamente:
- ✅ Respuestas exitosas de la API
- ✅ Errores de conexión
- ✅ Errores HTTP (códigos 4xx, 5xx)
- ✅ Errores de parsing JSON
- ✅ Datos nulos o inesperados

## Mejoras Futuras Posibles

1. **Caché:** Implementar caché de respuestas para reducir llamadas a la API
2. **Paginación:** Manejar endpoints paginados si la API los soporta
3. **Retry logic:** Reintentos automáticos en caso de fallos temporales
4. **Logging:** Sistema de logging más robusto
5. **Testing:** Unit tests y integration tests
6. **Validación:** Validación más estricta de datos recibidos

## Conclusión

La implementación cumple con todos los requerimientos:
- ✅ Consumo de al menos 3 endpoints diferentes
- ✅ Modelos de datos inmutables bien diseñados
- ✅ Control de errores con Either
- ✅ Presentación legible en consola
- ✅ Código bien estructurado y documentado

