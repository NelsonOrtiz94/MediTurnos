# Informe de Progreso — Sprint 1

## 1. Resumen del Sprint

| Campo | Detalle |
|---|---|
| Fecha de inicio | 21/04/2026 |
| Fecha de fin | 25/04/2026 |
| Issues planificados | 5 |
| Issues completados | 2 (HU-01, HU-02) |
| Issues en revisión | 2 (HU-05, HU-07) |
| Issues en progreso | 3 (HU-03, HU-04, HU-06) |

### Issues del Sprint 1

| Issue | Título | Estado |
|---|---|---|
| #1 | HU-01 — Configuración inicial del proyecto | ✅ Completado |
| #2 | HU-02 — Registro de pacientes | ✅ Completado |
| #3 | HU-03 — Gestión de médicos | 🔄 En Progreso |
| #4 | HU-04 — Gestión de especialidades | 🔄 En Progreso |
| #6 | HU-06 — Agendamiento de citas | 🔄 En Progreso |

---

## 2. Estado del Tablero Kanban

### Distribución de issues tras los movimientos del Sprint 1

| Columna | Issues |
|---|---|
| ✅ Completado | #1 HU-01, #2 HU-02 |
| 🔍 En Revisión | #5 HU-05, #7 HU-07 |
| 🔄 En Progreso | #3 HU-03, #4 HU-04, #6 HU-06 |
| 📋 Backlog | #8 HU-08, #9 HU-09, #10 HU-10, #11 HU-11, #12 HU-12, #13 HU-13, #14 HU-14, #15 HU-15 |

**Descripción:** Al inicio del Sprint 1 todos los issues estaban en Backlog. Durante la simulación del sprint se movieron 5 issues a "En Progreso" (HU-01, HU-02, HU-03, HU-04, HU-06), luego 3 avanzaron a "En Revisión" (HU-05, HU-07 y uno adicional), y finalmente HU-01 y HU-02 llegaron a "Completado" al cumplir todos sus criterios de aceptación.

> 📸 **[Captura del tablero antes de iniciar el Sprint]**
> Todos los issues en columna Backlog — ver tablero: https://github.com/users/NelsonOrtiz94/projects/1/views/1

> 📸 **[Captura del tablero al finalizar el Sprint 1]**
> HU-01 y HU-02 en Completado, HU-03/HU-04/HU-06 en Progreso, HU-05/HU-07 en Revisión.

---

## 3. Análisis de GitHub Insights

### 3.1 Pulse

> 📸 **[Captura de la sección Pulse]**
> Ruta: https://github.com/NelsonOrtiz94/MediTurnos/pulse

**Interpretación:**
El Pulse muestra la actividad del repositorio en los últimos 7 días. Se registran commits relacionados con la configuración inicial del proyecto (estructura backend/frontend, application.properties, pom.xml, docker-compose), la creación de entidades base (Paciente, Médico, Especialidad, Cita) y sus controladores REST. Se cerraron 2 issues (HU-01 y HU-02) y se realizaron múltiples commits semánticos con prefijos `feat:`, `docs:` y `chore:`. No hay Pull Requests pendientes ya que es un proyecto individual.

### 3.2 Contributors

> 📸 **[Captura de la sección Contributors]**
> Ruta: https://github.com/NelsonOrtiz94/MediTurnos/graphs/contributors

**Interpretación:**
El único contribuidor es **NelsonOrtiz94**. La gráfica muestra toda la actividad de commits concentrada en el desarrollador principal, lo cual es esperado para un proyecto académico individual. Los commits se distribuyeron en los días de la semana de trabajo del sprint. En un equipo real, aquí se vería la distribución de trabajo entre los miembros y se podría detectar si algún desarrollador está sobrecargado.

### 3.3 Frecuencia de Commits

> 📸 **[Captura del gráfico Commits]**
> Ruta: https://github.com/NelsonOrtiz94/MediTurnos/graphs/commit-activity

**Interpretación:**
La gráfica de commits muestra un pico de actividad concentrado en la semana de inicio del proyecto (semana del 21/04/2026), lo cual es coherente con el arranque del Sprint 1. Este patrón es típico de proyectos nuevos donde se realiza el scaffolding inicial. En un sprint maduro, los commits deberían distribuirse de manera más uniforme a lo largo de los días, evitando el "efecto avalancha" de último momento.

### 3.4 Code Frequency

> 📸 **[Captura de Code Frequency]**
> Ruta: https://github.com/NelsonOrtiz94/MediTurnos/graphs/code-frequency

**Interpretación:**
La gráfica de frecuencia de código muestra un pico alto de líneas agregadas en la semana inicial, correspondiente a la creación de toda la estructura base del proyecto: entidades JPA, repositorios, servicios, controladores REST, componentes React, configuración de Docker y PostgreSQL. Las líneas eliminadas son mínimas, lo que indica que el código fue construido de forma incremental y sin grandes refactorizaciones. A medida que el proyecto avance hacia las épicas 2 y 3, se espera ver ciclos más balanceados de adición y modificación de código.

---

## 4. Reflexión

**¿Qué te dice el tablero sobre el ritmo de avance del Sprint?**
El tablero muestra que el Sprint 1 tuvo un ritmo positivo en la Épica 1: se completaron exitosamente HU-01 (configuración inicial) y HU-02 (registro de pacientes), que son los cimientos del sistema. Sin embargo, HU-03, HU-04 y HU-06 quedaron en progreso, lo que indica que el alcance del sprint fue ligeramente optimista para el tiempo disponible. Para el Sprint 2 se ajustará la cantidad de issues seleccionados.

**¿Qué harías diferente en el Sprint 2?**
- Seleccionar solo 3 o 4 issues para garantizar que todos lleguen a "Completado".
- Definir criterios de "Listo para revisión" más claros antes de mover un issue a En Revisión.
- Realizar commits diarios en lugar de hacerlos por bloques de funcionalidad, para que la gráfica de Insights refleje un ritmo constante.
- Incluir al menos un issue de deuda técnica o mejora de calidad de código.

**¿Qué limitación encontraste al usar GitHub Insights con un repositorio nuevo o individual?**
La principal limitación es que las gráficas de Insights son más informativas cuando hay varios colaboradores y semanas de historia acumulada. En un repositorio nuevo e individual, la sección Contributors solo muestra un contribuidor y la gráfica de frecuencia de commits tiene muy pocos puntos de datos. Además, Pulse no refleja Pull Requests ni Code Reviews porque el flujo de trabajo es directo a la rama principal. En un equipo real estas métricas serían mucho más ricas y reveladoras.

---

## 5. Evidencia de Issues Cerrados

- [Issue #1 — HU-01: Configuración inicial del proyecto](https://github.com/NelsonOrtiz94/MediTurnos/issues/1) — ✅ Cerrado con comentario técnico
- [Issue #2 — HU-02: Registro de pacientes](https://github.com/NelsonOrtiz94/MediTurnos/issues/2) — ✅ Cerrado con comentario técnico

---

## 6. Video de Avance Sprint 1

[Agregar aquí el enlace al video en YouTube (modo no listado) o Google Drive]

> El video cubre: estado del tablero Kanban, recorrido por GitHub Insights (Pulse y Contributors), y reflexión sobre el avance del Sprint 1.

