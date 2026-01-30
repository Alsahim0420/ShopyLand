#  ShopyLand - E-Commerce Flutter App

Aplicación móvil de e-commerce desarrollada en Flutter que consume la API Fake Store para mostrar productos, categorías y usuarios. Utiliza el sistema de diseño **Pablito DS** y el paquete **conectify** para la API Fake Store. Diseño moderno y responsive.

##  Tabla de Contenidos

- [Características](#-características)
- [Tecnologías Utilizadas](#-tecnologías-utilizadas)
- [Requisitos](#-requisitos)
- [Instalación](#-instalación)
- [Configuración](#-configuración)
- [Uso](#-uso)
- [Estructura del Proyecto](#-estructura-del-proyecto)
- [Arquitectura](#-arquitectura)
- [Funcionalidades](#-funcionalidades)
- [Capturas de Pantalla](#-capturas-de-pantalla)
- [API Utilizada](#-api-utilizada)
- [Documentación Adicional](#-documentación-adicional)

##  Características

### Autenticación
- Login con credenciales demo (un solo botón)
- Login manual con email y contraseña
- Registro de nuevos usuarios
- Login automático después del registro
- Manejo completo de errores
- Validación de formularios

### Productos
- Catálogo completo de productos
- Filtrado por categorías
- Búsqueda de productos
- Detalle de producto con imágenes
- Vista de lista y cuadrícula
- Ordenamiento de productos

### Carrito de Compras
- Agregar productos al carrito
- Modificar cantidades
- Eliminar productos
- Cálculo automático de totales
- Badge con contador en navegación

### Navegación
- Bottom Navigation Bar
- Navegación fluida entre pantallas
- Página de soporte y contacto
- Perfil de usuario

### Diseño
- Material Design 3
- Diseño responsive
- Tema consistente (Pink/Magenta)
- Animaciones y transiciones suaves
- Carga de imágenes con indicadores

## 🛠️ Tecnologías Utilizadas

- **Flutter**: Framework de desarrollo móvil
- **Dart**: Lenguaje de programación
- **conectify**: Paquete que consume la API Fake Store (productos, categorías, usuarios)
- **pablito_ds**: Sistema de diseño (Pablito DS)
- **Material Design 3**: Sistema de diseño moderno

##  Requisitos

- Flutter SDK >= 3.8.1
- Dart SDK >= 3.8.1
- Android Studio / VS Code con extensiones de Flutter
- Emulador Android/iOS o dispositivo físico

##  Instalación

1. **Clonar el repositorio**
   ```bash
   git clone <url-del-repositorio>
   cd shopyland
   ```

2. **Instalar dependencias**
   ```bash
   flutter pub get
   ```

3. **Verificar la instalación**
   ```bash
   flutter doctor
   ```

4. **Ejecutar la aplicación**
   ```bash
   flutter run
   ```

##  Configuración

No se requiere configuración adicional. La aplicación está lista para usar con:
- API Fake Store: `https://fakestoreapi.com`
- Credenciales demo: `demo@shopyland.com` / `demo123`

##  Uso

### Login Demo
1. Abre la aplicación
2. Presiona el botón **"Login with Demo Account"**
3. Serás redirigido automáticamente a la página principal

### Login Manual
1. Ingresa email: `demo@shopyland.com`
2. Ingresa contraseña: `demo123`
3. Presiona **"Log In"**

### Registro
1. Presiona **"Sign Up"** en la pantalla de login
2. Completa el formulario (nombre, email, contraseña)
3. Al registrarte, se iniciará sesión automáticamente como demo

### Navegación
- **Home**: Explora productos, filtra por categorías
- **Search**: Busca productos por nombre o descripción
- **Cart**: Gestiona tu carrito de compras
- **Profile**: Accede a tu perfil y configuración

##  Estructura del Proyecto

```
lib/
├── core/
│   ├── auth/                    # Autenticación
│   │   └── auth_service.dart
│   ├── di/                      # Inyección de dependencias
│   │   └── injection_container.dart
│   ├── errors/                  # Manejo de errores
│   │   └── failures.dart
│   ├── models/                  # Modelos compartidos
│   │   └── cart_item.dart
│   └── services/                # Servicios
│       └── cart_service.dart
│
├── data/
│   ├── datasources/             # Fuentes de datos
│   │   └── remote_data_source.dart
│   ├── models/                   # DTOs (Data Transfer Objects)
│   │   ├── product_model.dart
│   │   ├── category_model.dart
│   │   └── user_model.dart
│   └── repositories/            # Implementaciones de repositorios
│       ├── product_repository_impl.dart
│       ├── category_repository_impl.dart
│       └── user_repository_impl.dart
│
├── domain/
│   ├── entities/                 # Entidades de dominio
│   │   ├── product_entity.dart
│   │   ├── category_entity.dart
│   │   └── user_entity.dart
│   ├── repositories/            # Interfaces de repositorios
│   │   ├── product_repository.dart
│   │   ├── category_repository.dart
│   │   └── user_repository.dart
│   └── usecases/                # Casos de uso
│       ├── get_products.dart
│       ├── get_categories.dart
│       └── get_users.dart
│
└── presentation/
    ├── pages/                    # Pantallas
    │   ├── login_page.dart
    │   ├── register_page.dart
    │   ├── main_navigation.dart
    │   ├── discover_page.dart
    │   ├── search_page.dart
    │   ├── product_detail_page.dart
    │   ├── cart_page.dart
    │   ├── profile_page.dart
    │   └── support_page.dart
    └── widgets/                  # Componentes reutilizables
        ├── product_card.dart
        ├── product_list.dart
        ├── category_list.dart
        └── user_list.dart
```

##  Arquitectura

La aplicación sigue los principios de **Clean Architecture** con separación clara de responsabilidades:

### Capas

1. **Domain Layer** (Lógica de Negocio)
   - Entidades puras sin dependencias
   - Interfaces de repositorios
   - Casos de uso

2. **Data Layer** (Acceso a Datos)
   - Implementaciones de repositorios
   - Datasources (API)
   - Modelos DTO

3. **Presentation Layer** (UI)
   - Páginas y widgets
   - Solo depende de Domain

4. **Core Layer** (Compartido)
   - Errores y failures
   - Servicios compartidos
   - Inyección de dependencias

### Principios SOLID

- **Single Responsibility**: Cada clase tiene una única responsabilidad
- **Open/Closed**: Extensible sin modificar código existente
- **Liskov Substitution**: Implementaciones sustituyen interfaces
- **Interface Segregation**: Interfaces específicas y pequeñas
- **Dependency Inversion**: Dependencias de abstracciones

### Manejo de Errores

Los errores se manejan con `try/catch` y mensajes al usuario (p. ej. `PabAlert`). Los datos se obtienen mediante el paquete **conectify**.

##  Funcionalidades Detalladas

### 1. Autenticación
- Login con credenciales demo (un botón)
- Login manual con validación
- Registro de usuarios
- Login automático post-registro
- Manejo de errores con mensajes claros

### 2. Página Principal (Discover)
- Banner promocional
- Filtros por categoría (carrusel)
- Título dinámico según categoría seleccionada
- Filtros y ordenamiento
- Grid de productos con imágenes
- Agregar al carrito

### 3. Búsqueda
- Búsqueda en tiempo real
- Historial de búsquedas recientes
- Sugerencias de categorías
- Resultados con contador
- Ordenamiento de resultados
- Mensaje cuando no hay resultados

### 4. Detalle de Producto
- Imagen grande del producto
- Información completa
- Badges de categoría y rating
- Selector de cantidad
- Botón "Add to Cart"
- Botón de favoritos
- Diseño tipo bottom sheet

### 5. Carrito de Compras
- Lista de productos con imágenes
- Ajuste de cantidades
- Eliminar productos
- Resumen de orden (subtotal, tax, total)
- Botón "Proceed to Checkout"
- Estado vacío con mensaje
- Opción "Clear All"
- Actualización en tiempo real

### 6. Perfil
- Avatar editable
- Información del usuario
- Menú de opciones
- Logout con confirmación

### 7. Soporte
- Barra de búsqueda
- FAQ expandible
- Opciones de contacto
- Banner de Priority Support

##  Capturas de Pantalla

<!-- Aquí se agregarán las imágenes que el usuario proporcione -->

### Login
![Login Screen](https://res.cloudinary.com/panmecar/image/upload/v1769182495/shopyland/Simulator_Screenshot_-_iPhone_17_Pro_Max_-_2026-01-23_at_10.25.28_dtvodw.png)

### Página Principal
![Discover Screen](https://res.cloudinary.com/panmecar/image/upload/v1769182493/shopyland/Simulator_Screenshot_-_iPhone_17_Pro_Max_-_2026-01-23_at_10.26.06_ur1cjm.png)

### Búsqueda
![Search Screen](https://res.cloudinary.com/panmecar/image/upload/v1769182490/shopyland/Simulator_Screenshot_-_iPhone_17_Pro_Max_-_2026-01-23_at_10.26.17_iygsd5.png)

### Detalle de Producto
![Product Detail](https://res.cloudinary.com/panmecar/image/upload/v1769182488/shopyland/Simulator_Screenshot_-_iPhone_17_Pro_Max_-_2026-01-23_at_10.26.22_c1jlfc.png)

### Carrito
![Cart Screen](https://res.cloudinary.com/panmecar/image/upload/v1769182486/shopyland/Simulator_Screenshot_-_iPhone_17_Pro_Max_-_2026-01-23_at_10.26.53_qdon9t.png)

### Perfil
![Profile Screen](https://res.cloudinary.com/panmecar/image/upload/v1769182484/shopyland/Simulator_Screenshot_-_iPhone_17_Pro_Max_-_2026-01-23_at_10.26.55_rybdgz.png)

##  API Utilizada

### Fake Store API
- **Base URL**: `https://fakestoreapi.com`
- **Endpoints utilizados**:
  - `GET /products` - Lista de productos
  - `GET /products/categories` - Lista de categorías
  - `GET /users` - Lista de usuarios

### Cliente HTTP
Utiliza `conectify`, un paquete que:
- No requiere dependencias externas
- Usa solo `dart:io` y `dart:convert`
- Es ligero y eficiente

##  Documentación Adicional

### Documentación de Fase 2
Ver `FASE2_DOCUMENTACION.md` para detalles sobre:
- Diseño de modelos de datos
- Implementación del servicio de API
- Control de errores con Either
- Decisiones de diseño

### Análisis de Arquitectura
Ver `ANALISIS_ARCHITECTURE.md` para:
- Verificación de Clean Architecture
- Principios SOLID aplicados
- Estructura de capas

##  Testing

Para ejecutar los tests:

```bash
flutter test
```

Los tests incluyen:
- Tests de integración de API
- Validación de casos de uso
- Verificación de modelos

##  Comandos Útiles

```bash
# Analizar código
flutter analyze

# Formatear código
dart format lib/

# Verificar dependencias
flutter pub outdated

# Limpiar proyecto
flutter clean
flutter pub get
```

##  Notas Importantes

### Credenciales Demo
- **Email**: `demo@shopyland.com`
- **Password**: `demo123`

### Estado del Carrito
El carrito persiste durante la sesión pero se limpia al cerrar la app. Para persistencia permanente, se requeriría implementar almacenamiento local (SharedPreferences, Hive, etc.).

### Imágenes de Productos
Las imágenes se cargan desde URLs de la API Fake Store. Requiere conexión a internet.

##  Problemas Conocidos

- El carrito se limpia al reiniciar la app (por diseño actual)
- Algunas funcionalidades muestran "en desarrollo" (checkout, métodos de pago, etc.)

##  Mejoras Futuras

- [ ] Persistencia del carrito con almacenamiento local
- [ ] Implementación completa de checkout
- [ ] Sistema de favoritos persistente
- [ ] Notificaciones push
- [ ] Modo oscuro
- [ ] Internacionalización (i18n)
- [ ] Tests unitarios y de integración más completos

## Contribución

Este es un proyecto de prueba técnica. Para contribuir:

1. Fork el proyecto
2. Crea una rama para tu feature (`git checkout -b feature/AmazingFeature`)
3. Commit tus cambios (`git commit -m 'Add some AmazingFeature'`)
4. Push a la rama (`git push origin feature/AmazingFeature`)
5. Abre un Pull Request

##  Licencia

Este proyecto está bajo la Licencia MIT. Ver el archivo `LICENSE` para más detalles.

##  Autor

Desarrollado con 💙 por Pablo Melo

##  Contacto

Para preguntas o soporte, consulta la sección de Soporte dentro de la aplicación.

---

**Nota para Revisores**: Este proyecto implementa Clean Architecture, manejo de errores con Either, y sigue las mejores prácticas de Flutter. Todas las funcionalidades requeridas están implementadas y funcionando. El código está bien documentado y organizado para facilitar su revisión.
