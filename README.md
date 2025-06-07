## Proyecto Final - Inventario iOS

Aplicación móvil iOS desarrollada en Swift que permite gestionar un inventario de productos mediante una interfaz moderna, con autenticación de usuarios usando Firebase y operaciones CRUD conectadas a una API REST externa.

🛠️ Tecnologías utilizadas

- Swift 5
- UIKit
- Firebase Auth
- API REST (Render)
- Storyboard + AutoLayout
- MVC Architecture
- Xcode (entorno de desarrollo)

## Funcionalidades principales

👤 Autenticación
- Registro e inicio de sesión de usuarios con Firebase Authentication.
- Visualización de datos del perfil del usuario autenticado.
- Cierre de sesión y registro de logs.

## Gestión de productos
- Consulta de productos desde API externa: https://api-inventory-5ogw.onrender.com/inventory
- Agregar nuevos productos (nombre, cantidad, precio, descripción, imagen).
- Modificación de cantidad de producto.
- Eliminación de productos con confirmación.
- Visualización de detalles individuales.

## Registro de actividad
- Logs automáticos para acciones de login, logout, modificaciones y eliminaciones.

## Estructura de carpetas
```
ProyectoFinal/
│
├── Controllers/         # Controladores de vista (Home, Login, Registro, Productos, Logs)
├── Models/              # Modelo de datos 'Product' y lógica de conexión con API
├── Views/               # Celdas personalizadas y vistas auxiliares
├── Menu/                # Lógica y diseño del menú lateral
├── Assets/              # Recursos visuales y colores
├── Main.storyboard      # Interfaz principal
├── AppDelegate.swift    # Configuración de Firebase
├── GoogleService-Info.plist  # Configuración de Firebase
```
## Cómo ejecutar el proyecto

1. Abre ProyectoFinal.xcodeproj o .xcworkspace en Xcode.
2. Asegúrate de tener CocoaPods instalados si tu proyecto lo requiere.
3. Instala dependencias si es necesario:
   pod install
4. Configura tu archivo GoogleService-Info.plist para conectar Firebase (ya incluido).
5. Conecta un simulador o dispositivo real.
6. Ejecuta el proyecto (Cmd + R).

## API REST utilizada

Se utiliza una API REST desplegada en Render para manejar productos del inventario.

Endpoints principales:
```
- GET /inventory - Obtener todos los productos
- POST /inventory - Agregar un producto
- PUT /inventory/:id - Modificar cantidad
- DELETE /inventory/:id - Eliminar producto
```
## Firebase Authentication

- Maneja autenticación segura con email y contraseña.
- Incluye recuperación del usuario actual y validaciones.
- Configuración lista para usar desde GoogleService-Info.plist.


