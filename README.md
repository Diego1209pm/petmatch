# PetMatch Prolog — Sistema Experto para la Elección y Adopción de Mascotas

**Instituto Politécnico Nacional (IPN) · Escuela Superior de Cómputo (ESCOM)**  
**Unidad de Aprendizaje:** Paradigmas de Programación  
**Paradigma:** Programación Lógica | **Lenguaje Principal:** SWI-Prolog  
**Práctica Integradora 1er Parcial:** Desarrollo y despliegue web de un sistema experto utilizando Prolog  
**Integrantes del Equipo:**
- **Diego Perea Medina** (Diseño de Base de Conocimientos, Reglas de Inferencia, Pruebas en Prolog y Documentación)
- **Cortés Cruz Gerardo** (Servidor HTTP SWI-Prolog, Interfaz Gráfica Web, Contenerización Docker y Despliegue)

---

## 1. Descripción del Problema

La adopción impulsiva o desinformada de perros y gatos es una de las principales causas de abandono y devolución en refugios animales. Muchas personas eligen una mascota únicamente por su apariencia física sin evaluar factores críticos como el espacio de su vivienda, el tiempo libre diario para paseos y estimulación, la presencia de niños pequeños o personas con alergias en el hogar, su experiencia previa en manejo animal y su presupuesto mensual de manutención.

**PetMatch Prolog** es un sistema experto basado en reglas lógicas en **SWI-Prolog** que evalúa las condiciones reales del adoptante y determina, mediante **unificación, inferencia lógica, recursividad sobre listas y retroceso (backtracking)**, qué razas de perros/gatos o perfiles de animales de refugio son compatibles, calculando un porcentaje de afinidad y explicando exactamente qué reglas lógicas sustentan cada recomendación o por qué fueron descartadas las demás opciones.

---

## 2. Cumplimiento de Requisitos Mínimos en Prolog

| Elemento | Requisito Mínimo | Implementado en `prolog/mascotas_kb.pl` |
| :--- | :--- | :--- |
| **Hechos significativos** | 20 hechos | **61 hechos** (`24` perfiles `mascota/12`, `24` listas `cuidados_especificos/2` y `13` hechos de jerarquía `rango_*/2`) |
| **Reglas lógicas no triviales** | 10 reglas | **15 reglas lógicas** de compatibilidad, exclusión estricta, puntaje recursivo y diagnóstico de descarte |
| **Predicados propios** | 5 predicados | **14 predicados propios diferenciados** (`compatible_espacio/2`, `compatible_tiempo/2`, `seguro_alergias/2`, `seguro_ninos/2`, `compatible_experiencia/2`, `compatible_presupuesto/2`, `calcular_puntaje_afinidad/3`, `recomendar_mascota/12`, `diagnosticar_descarte/9`, etc.) |
| **Inferencias distintas** | 3 conclusiones | **4 conclusiones diferenciadas** (`compatibilidad_optima_ideal`, `compatibilidad_alta_recomendada`, `compatibilidad_adecuada_viable` y diagnóstico de incompatibilidad) |
| **Consultas de prueba** | 10 casos | **12 casos de prueba documentados** en `tests/pruebas_consola.pl` y en la interfaz web |
| **Variables, unificación y backtracking** | Obligatorio | Uso de variables lógicas, recursividad (`sumar_factores/2`, `contar_elementos/2`) y recolección exhaustiva con `findall/3` |

---

## 3. Arquitectura del Sistema (Alternativa B: Docker + SWI-Prolog)

```text
[ Navegador Web del Usuario ]
             │
             ▼  HTTP POST /api/consultar (JSON)
[ Contenedor Docker (Imagen oficial swipl:stable) ]
             │
             ├──► prolog/server.pl (Servidor HTTP nativo thread_httpd + Validación de átomos)
             │
             └──► prolog/mascotas_kb.pl (Motor de Inferencia: Hechos, Reglas, Recursión y Backtracking)
```

---

## 4. Estructura del Repositorio

```text
petmatch-prolog/
├── Dockerfile                  # Imagen oficial swipl:stable lista para producción
├── docker-compose.yml          # Orquestación local con un solo comando
├── render.yaml                 # Blueprint para despliegue automático en Render.com
├── .gitignore                  # Exclusión de archivos temporales y secretos
├── .dockerignore               # Optimización del contexto de construcción Docker
├── README.md                   # Documentación técnica y guía de despliegue
├── prolog/
│   ├── mascotas_kb.pl          # Base de conocimientos (61 hechos y 15 reglas lógicas)
│   └── server.pl               # Servidor web HTTP y API JSON en SWI-Prolog
├── frontend/
│   └── index.html              # Interfaz gráfica web responsiva conectada al motor
└── tests/
    └── pruebas_consola.pl      # Batería automatizada de 12 casos de prueba en Prolog
```

---

## 5. Instrucciones de Instalación y Ejecución Local

### Opción 1: Ejecución con Docker (Recomendada - Alternativa B)

1. Construir la imagen Docker:
   ```bash
   docker build -t petmatch-prolog .
   ```
2. Iniciar el contenedor en el puerto `8080`:
   ```bash
   docker run -d -p 8080:8080 --name petmatch petmatch-prolog
   ```
3. Abrir en el navegador:
   ```text
   http://localhost:8080
   ```

### Opción 2: Ejecución Directa con SWI-Prolog Local

1. Ejecutar la batería de 12 casos de prueba en consola:
   ```bash
   swipl -s tests/pruebas_consola.pl -g ejecutar_todas_las_pruebas -t halt
   ```
2. Iniciar el servidor web en `http://localhost:8080`:
   ```bash
   swipl -s prolog/server.pl -g iniciar_servidor
   ```

---

## 6. Procedimiento de Despliegue en Internet (Render / Railway)

1. Sube este repositorio a tu cuenta de **GitHub**.
2. Ingresa a [Render.com](https://render.com) o [Railway.app](https://railway.app) e inicia sesión con tu cuenta de GitHub.
3. Crea un nuevo servicio **Web Service** y selecciona tu repositorio `petmatch-prolog`.
4. En **Runtime / Environment**, selecciona **Docker** (Render detectará automáticamente el `Dockerfile` y el archivo `render.yaml`).
5. Haz clic en **Create Web Service**. En 2 minutos tendrás tu URL pública HTTPS (`https://petmatch-prolog-escom.onrender.com`) conectada en vivo al motor SWI-Prolog.

---

## 7. Declaración de Uso de Herramientas de IA

De acuerdo con los lineamientos de la práctica (Sección 4.2 y Entregable 8), se declara el uso de herramientas de asistencia de IA para:
- Orientación en la arquitectura cliente-servidor con SWI-Prolog HTTP (`thread_httpd`).
- Diseño de la interfaz gráfica responsiva con Tailwind CSS y estructuración de contenedor `Dockerfile`.
- Formato y estructuración de la documentación técnica y casos de prueba.
