# 📱 Tok Tik

¡Bienvenido al repositorio oficial de **Tok Tik**! Una aplicación moderna e interactiva de videos cortos, diseñada para ofrecer una experiencia de usuario única a través de su interfaz altamente personalizable y sus modos temáticos estacionales.

## 📖 Descripción Alargada

**Tok Tik** no es solo otra plataforma de videos. Es una red social construida pensando en la personalización y el rendimiento. Basada en una arquitectura robusta de fuentes de datos (como se detalla en nuestro diagrama `toktik-data-sources.html`), la aplicación garantiza un flujo de información rápido y seguro entre el cliente y el servidor. 

Nuestra plataforma permite a los creadores de contenido subir, compartir y descubrir videos rápidamente. Lo que realmente diferencia a Tok Tik es su capacidad para transformarse visualmente según la temporada del año, ofreciendo a los usuarios una experiencia inmersiva que se adapta a las festividades más populares. Todo esto respaldado por un sistema backend eficiente que procesa interacciones en tiempo real.

---

## 🎨 Modos Temáticos

Tok Tik cuenta con 4 modos visuales únicos. Aquí puedes ver cómo luce la interfaz en cada uno de ellos:

### ☀️ Modo Normal
El diseño clásico, elegante y enfocado en el contenido. Ideal para el uso diario.
| Feed Principal | Perfil de Usuario |
| :---: | :---: |
| ![Captura Normal 1](/Practica04/toktik/assets/images/normal1.jpeg) <br> *Vista del feed* | ![Captura Normal 2](/Practica04/toktik/assets/images/normal2.jpeg) <br> *Vista del perfil* |

### 🎃 Modo Halloween
¡Un diseño espeluznante! Tonos oscuros, naranjas y animaciones especiales para la temporada de terror.
| Feed Principal | Perfil de Usuario |
| :---: | :---: |
| ![Captura Halloween 1](/Practica04/toktik/assets/images/hallowen.jpeg) <br> *Vista del feed* | ![Captura Halloween 2](/Practica04/toktik/assets/images/hallowen2.jpeg) <br> *Vista del perfil* |

### 🎄 Modo Navidad
Una interfaz acogedora con toques de nieve, luces festivas y colores característicos de las fiestas.
| Feed Principal | Perfil de Usuario |
| :---: | :---: |
| ![Captura Navidad 1](/Practica04/toktik/assets/images/navidad1.jpeg) <br> *Vista del feed* | ![Captura Navidad 2](/Practica04/toktik/assets/images/navidad2.jpeg) <br> *Vista del perfil* |

### 💖 Modo San Valentín
Tonos rosados y rojos con detalles románticos para celebrar el día del amor y la amistad.
| Feed Principal | Perfil de Usuario |
| :---: | :---: |
| ![Captura San Valentin 1](/Practica04/toktik/assets/images/sanvalentin.jpeg) <br> *Vista del feed* | ![Captura San Valentin 2](/Practica04/toktik/assets/images/sanvalentin2.jpeg) <br> *Vista del perfil* |

---

## ⚡ Interacciones Principales

### ❤️ ¿Cómo se dan los Likes?
El sistema de "Me Gusta" está diseñado para ser rápido e intuitivo:
1. **Doble Toque (Double Tap):** Al hacer doble toque sobre cualquier parte del video en reproducción, aparecerá una animación temática (dependiendo del modo activo) y se registrará el like automáticamente.
2. **Botón de Corazón:** En el panel lateral derecho de cada video, puedes tocar el icono del corazón. Al hacerlo, el corazón se llenará de color, el contador se actualizará en tiempo real y la información se enviará a nuestra base de datos.
3. *Nota técnica:* Los likes se procesan de manera optimizada utilizando cachés locales antes de sincronizarse con la base de datos principal para evitar latencia, tal como se ilustra en el diagrama de fuentes de datos.

### 🔖 ¿Cómo funcionan los Guardados (Favoritos)?
Para no perder nunca ese video que te encantó:
1. **Botón de Guardar:** Justo debajo del botón de comentarios en el panel lateral, encontrarás el icono de "Guardar" (marcador).
2. **Confirmación Visual:** Al presionarlo, el icono cambiará de estado (relleno) y mostrará un pequeño mensaje de confirmación "Añadido a Guardados".
3. **Colección Privada:** Todos los videos guardados se envían de forma segura a una colección privada dentro de la pestaña de tu perfil, donde solo tú podrás verlos y organizarlos.

---

## 🛠️ Arquitectura y Datos
Para entender mejor cómo se conectan los microservicios, bases de datos y la interfaz de Tok Tik, por favor consulta el archivo interactivo adjunto en este repositorio:
🔗 [**Ver Diagrama Interactivo de Arquitectura en GitHub Pages**](https://EMATIAS230045.github.io/Practicas_DMI_230045.archify
/architecture-toktik-data-sources-20261023-112609/toktik-data-sources.html)
