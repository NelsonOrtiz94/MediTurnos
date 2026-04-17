# MediTurnos

MediTurnos es un sistema de gestión de turnos para consultorios médicos, diseñado para organizar pacientes, médicos, especialidades y citas de manera eficiente.

## Problema que resuelve

Muchos consultorios pequeños aún gestionan sus citas de forma manual o en herramientas no especializadas, lo que provoca errores en la agenda, duplicidad de turnos, poca trazabilidad y demoras en la atención al paciente.

## Solución propuesta

MediTurnos permite:
- Registrar y gestionar **pacientes** y **médicos**
- Administrar **especialidades** médicas
- **Agendar** citas médicas evitando conflictos de horario
- **Reprogramar** o **cancelar** turnos con motivo registrado
- Consultar la **agenda diaria** por fecha
- Ver el **historial** de citas por paciente
- Generar **reportes** de citas por estado en un rango de fechas

## Stack tecnológico

| Capa | Tecnología |
|---|---|
| Frontend | React 18 + Vite + React Router |
| Backend | Spring Boot 3.3 + Spring Data JPA |
| Base de datos | PostgreSQL 16 |
| Validaciones | Bean Validation (backend) |
| HTTP Client | Axios |
| Contenedores | Docker + Docker Compose |
| Control de versiones | Git + GitHub |

## Estructura del proyecto

```
MediTurnos/
├── backend/                    # Spring Boot (Java 21)
│   ├── src/main/java/com/mediturnos/
│   │   ├── model/              # Especialidad, Medico, Paciente, Cita
│   │   ├── repository/         # Interfaces JPA
│   │   ├── service/            # Lógica de negocio
│   │   ├── controller/         # REST Controllers + GlobalExceptionHandler
│   │   └── config/             # CorsConfig
│   ├── src/main/resources/
│   │   └── application.properties
│   ├── Dockerfile
│   └── pom.xml
├── frontend/                   # React + Vite
│   ├── src/
│   │   ├── api/index.js        # Cliente Axios centralizado
│   │   ├── components/         # Layout + CSS global
│   │   └── pages/              # especialidades, medicos, pacientes, citas
│   ├── Dockerfile
│   └── nginx.conf
└── docker-compose.yml
```

## Fases del proyecto

### Épica 1 — Gestión base del sistema (hasta 25/04/2026)
Configuración inicial, CRUD de especialidades, médicos y pacientes, búsqueda por nombre/documento.

### Épica 2 — Gestión de citas y agenda (hasta 10/05/2026)
Agendamiento, reprogramación, cancelación, agenda diaria e historial de citas por paciente.

### Épica 3 — Reportes, validaciones y despliegue (hasta 25/05/2026)
Reporte de citas por estado, validaciones frontend/backend, Dockerfile y docker-compose.

## Ejecución local

### Opción 1 — Con Docker (recomendado)
```bash
docker-compose up --build
```
- Frontend: http://localhost:5173
- Backend: http://localhost:8080
- PostgreSQL: localhost:5432

### Opción 2 — Sin Docker
**Requisitos:** JDK 21, Maven 3.9+, Node 18+, PostgreSQL 16

1. Crear base de datos:
```sql
CREATE DATABASE mediturnos;
CREATE USER mediturnos WITH PASSWORD 'mediturnos123';
GRANT ALL PRIVILEGES ON DATABASE mediturnos TO mediturnos;
```

2. Backend:
```bash
cd backend
mvn spring-boot:run
```

3. Frontend:
```bash
cd frontend
npm install
npm run dev
```

## API REST — Endpoints principales

| Método | Endpoint | Descripción |
|---|---|---|
| GET | /api/especialidades | Listar especialidades |
| POST | /api/especialidades | Crear especialidad |
| GET | /api/medicos?q= | Listar / buscar médicos |
| POST | /api/medicos | Crear médico |
| GET | /api/pacientes?q= | Listar / buscar pacientes |
| POST | /api/pacientes | Crear paciente |
| POST | /api/citas | Agendar cita |
| PUT | /api/citas/{id}/reprogramar | Reprogramar cita |
| PUT | /api/citas/{id}/cancelar | Cancelar cita |
| GET | /api/citas/agenda?fecha= | Agenda diaria |
| GET | /api/citas/historial/{pacienteId} | Historial paciente |
| GET | /api/citas/reporte?desde=&hasta= | Reporte por estado |

## Tablero GitHub Projects

[Ver tablero Kanban →](https://github.com/users/NelsonOrtiz94/projects/1/views/1)

## Video de Presentación

[Agregar aquí el enlace de YouTube no listado o Google Drive]
