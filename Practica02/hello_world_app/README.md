ñ# Bitácora de Aprendizaje: Flutter + OpenAI Codex + Archify

**Proyecto:** `hello_world_app`  
**Asignatura:** Desarrollo Móvil Integral  
**Fecha:** 14 de Septiembre de 2026  

---

## 🚀 Resumen del Día
En esta sesión se configuró un entorno de desarrollo asistido por IA mediante **Codex CLI** y **Archify**, logrando la generación automática de diagramas de arquitectura interactivos a partir del árbol de widgets de una aplicación en **Flutter**.

---

## 🛠️ Tecnologías y Herramientas Utilizadas
* **Flutter & Dart:** Desarrollo de la interfaz móvil y lógica de componentes.
* **OpenAI Codex CLI:** Agente de IA en terminal para análisis e inspección del código fuente.
* **Archify:** Herramienta de visualización de arquitectura de software.
* **VS Code & Windows CMD:** Entorno de ejecución y gestión de terminales.

---

## 📚 Conceptos y Aprendizajes Clave

### 1. Desarrollo e Integración en Flutter
* **Componentes Personalizados:** Creación y estructuración de widgets reutilizables como `CustomButton`.
* **Manejo de Pantallas:** Organización de vistas en la capa de presentación (`CounterFunctionsScreen`).
* **Servicios del Dispositivo:** Implementación de retroalimentación física y auditiva mediante `SystemSound.play()` y `HapticFeedback.vibrate()`.

### 2. Automatización con Agentes de IA (Codex)
* **Autenticación e Instalación:** Vinculación de la cuenta de ChatGPT con la interfaz de consola (`codex login`).
* **Gestión de Sandbox y Permisos:** Control de accesos de lectura/escritura y ejecución en entornos seguros no administrativos (*non-admin sandbox*).
* **Prompts Estructurados:** Adaptación de instrucciones para limitar el alcance del análisis únicamente a la capa de UI (`lib/`) sin dependencias externas innecesarias.

### 3. Modelado de Arquitectura con Archify
* Generación de mapas de arquitectura en formato **HTML interactivo** (`architecture-diagram.html`).
* Mapeo visual de flujo de interacciones: **UI / Eventos de Usuario ➔ Componentes ➔ Servicios del Sistema**.

---

## 💻 Comandos Clave Utilizados

```cmd
:: Instalación de herramientas globales
npm install -g archify
npm install -g @openai/codex

:: Vinculación con cuenta de ChatGPT
codex login

:: Generación de diagrama interactivo
codex "Use Archify to create an interactive architecture diagram of this Flutter application based on its lib/ folder structure. Output as interactive HTML."