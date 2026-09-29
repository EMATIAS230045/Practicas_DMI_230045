# 💬 Yes No App

[![Flutter](https://img.shields.io/badge/FLUTTER-02569B?style=for-the-badge&logo=flutter&logoColor=white)](#)
[![Dart](https://img.shields.io/badge/DART-0175C2?style=for-the-badge&logo=dart&logoColor=white)](#)
[![Provider](https://img.shields.io/badge/PROVIDER-239120?style=for-the-badge&logo=flutter&logoColor=white)](#)
[![Dio](https://img.shields.io/badge/DIO-00599C?style=for-the-badge&logo=flutter&logoColor=white)](#)

---

## 📝 Descripción

**Yes_No_App** es una aplicación de mensajería interactiva estilo chat desarrollada en **Flutter**. La aplicación está diseñada para simular conversaciones en tiempo real y tomar decisiones automáticas desencadenadas por las preguntas del usuario, consumiendo la API REST de `yesno.wtf` y aplicando una lógica probabilística personalizada.

---

## 🎯 Objetivo

* Diseñar e implementar una interfaz de usuario fluida basada en conversaciones estilo chat con scroll automático (`autoscroll`).
* Consumir servicios web externos mediante peticiones HTTP asíncronas con el cliente **Dio**.
* Aplicar arquitectura limpia (**Clean Architecture**) en Flutter, dividiendo responsabilidades en capas claras (*domain*, *infrastructure* y *presentation*).
* Administrar el estado global de la aplicación y el flujo de mensajes utilizando el patrón **Provider**.

---

## ⚙️ Funcionalidades Principales

### 1. Chat Interactivo y UI
* **Burbujas de Mensaje Diferenciadas:** Distinción visual entre los mensajes del usuario (`MyMessageBubble`) y los recibidos (`HerMessageBubble`).
* **Desplazamiento Automático:** La pantalla realiza un *autoscroll* automático al fondo de la vista cada vez que se envía o recibe un mensaje.

### 2. Respuestas Automáticas Inteligentes
* **Detección de Preguntas:** Identifica automáticamente si el mensaje enviado por el usuario finaliza con un signo de interrogación (`?`).
* **Activación Automática:** Dispara la consulta y generación de respuesta simulated al detectar la pregunta.

### 3. Lógica de Decisión Probabilística
El sistema distribuye la probabilidad de respuesta bajo la relación $40 / 40 / 20$:
* **$40\%$ de probabilidad ("Sí"):** Consulta la API externa y presenta un GIF animado afirmando la respuesta.
* **$40\%$ de probabilidad ("No"):** Consulta la API externa y presenta un GIF animado negando la respuesta.
* **$20\%$ de probabilidad ("Tal vez"):** Genera una respuesta puramente textual, omitiendo la carga de GIF.
* **Control de Fallos (Manejo de Errores):** Si la API no responde o no entrega una imagen válida, la app conserva y muestra únicamente la respuesta en texto.

### 4. Marcas de Tiempo y Estados de Lectura
* **Hora Exacta:** Muestra el horario en formato `HH:mm` en la parte inferior de cada mensaje.
* **Simulación de Estados (Palomitas):**
  * $\checkmark$ *Gris:* Mensaje enviado.
  * $\checkmark\checkmark$ *Gris:* Mensaje entregado (transcurrido $1$ segundo).
  * $\checkmark\checkmark$ *Azul:* Mensaje visto (transcurridos $2.5$ segundos).

---

## 📐 Arquitectura del Proyecto

El proyecto implementa **Clean Architecture** para garantizar la escalabilidad, mantenibilidad y desacoplamiento de componentes:

```text
lib/
├── domain/            # Entidades y contratos de negocio puro
│   └── entities/
├── infrastructure/    # Implementaciones, modelos de datos de API y data sources
│   └── models/
└── presentation/      # Capa de UI, widgets reutilizables y gestores de estado (Providers)
    ├── providers/
    ├── screens/
    └── widgets/
```

### Tecnologías Clave Utilizadas
* **Provider:** Gestión de estado reactive global del chat y control programático de scroll.
* **Dio:** Cliente HTTP para la comunicación eficiente con la API de `yesno.wtf`.
* **flutter_launcher_icons:** Personalización del icono nativo de la aplicación.

---

## 📁 Archivos Principales

| Archivo / Carpeta | Descripción / Responsabilidad |
| :--- | :--- |
| `lib/presentation/providers/chat_provider.dart` | Gestor del estado global del chat, manejo de lista de mensajes, scroll y llamadas a servicios. |
| `lib/presentation/widgets/chat/my_message_bubble.dart` | Componente de interfaz para representar las burbujas de mensaje del usuario. |
| `lib/presentation/widgets/chat/her_message_bubble.dart` | Componente para los mensajes recibidos, incluyendo soporte para imágenes/GIFs e indicadores de carga. |
| `lib/infrastructure/models/yes_no_model.dart` | Modelo de datos encargado del mapeo y serialización de las respuestas JSON de la API. |
| `pubspec.yaml` | Configuración de paquetes, assets, fuentes e iconos nativos del proyecto. |

---

## 🔗 Diagrama de Arquitectura

Puedes revisar la estructura interactiva y mapeo de flujo de la aplicación generada con **Archify** en el siguiente enlace:

🔗 [**Ver Diagrama Interactivo de Arquitectura en GitHub Pages**](https://tu-usuario.github.io/tu-repositorio/architecture-diagram.html)

---

## 📸 Evidencias

### 1. Logo de app
![Logo App](../Images/logo.jpeg)

### 2. Respuesta Automatizada con GIF (Sí / No)
*Detección de signo `?`, consulta a la API REST de `yesno.wtf` y renderizado de respuesta con GIF animado.*
*SI*
![Si](../images/S.jpeg)
*NO*
![No](../images/no.jpeg)
### 3. Respuesta Alternativa ("Tal vez") y Fallback
*Respuesta condicional textual ($20\%$ de probabilidad) y comportamiento ante fallos de red.*
![talvez](../images/talvez.jpeg)
---

## 🛠️ Instalación y Ejecución

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/Yes_No_App.git

# Obtener dependencias de Flutter
flutter pub get

# Generar icono nativo de la aplicación
flutter pub run flutter_launcher_icons

# Ejecutar la aplicación
flutter run
```
