$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

$REPO = "NelsonOrtiz94/MediTurnos"
$TOKEN = & gh auth token
$HEADERS = @{ Authorization = "Bearer $TOKEN"; "Content-Type" = "application/json"; Accept = "application/vnd.github+json" }
$BASE = "https://api.github.com/repos/$REPO"

Write-Host "=== CREANDO MILESTONES ===" -ForegroundColor Green

$m1 = Invoke-RestMethod -Uri "$BASE/milestones" -Method POST -Headers $HEADERS -Body (ConvertTo-Json @{title="Epica 1 - Gestion base del sistema"; due_on="2026-04-25T00:00:00Z"; description="Configuracion inicial del proyecto, gestion de pacientes, medicos y especialidades."})
Write-Host "Milestone 1 creado: #$($m1.number)"

$m2 = Invoke-RestMethod -Uri "$BASE/milestones" -Method POST -Headers $HEADERS -Body (ConvertTo-Json @{title="Epica 2 - Gestion de citas y agenda"; due_on="2026-05-10T00:00:00Z"; description="Agendamiento, consulta, cancelacion y reprogramacion de citas."})
Write-Host "Milestone 2 creado: #$($m2.number)"

$m3 = Invoke-RestMethod -Uri "$BASE/milestones" -Method POST -Headers $HEADERS -Body (ConvertTo-Json @{title="Epica 3 - Reportes, validaciones y despliegue"; due_on="2026-05-25T00:00:00Z"; description="Reportes, mejoras visuales, validaciones finales, documentacion y despliegue."})
Write-Host "Milestone 3 creado: #$($m3.number)"

Write-Host "=== CREANDO ISSUES ===" -ForegroundColor Green

function New-Issue($title, $body, $labels, $milestone) {
    $payload = ConvertTo-Json @{ title=$title; body=$body; labels=$labels; milestone=$milestone }
    $r = Invoke-RestMethod -Uri "$BASE/issues" -Method POST -Headers $HEADERS -Body $payload
    Write-Host "Issue creado: #$($r.number) - $title"
}

# EPICA 1
New-Issue "HU-01 - Configuracion inicial del proyecto" `
"**Como** desarrollador, **quiero** configurar la estructura base del proyecto, **para** iniciar el desarrollo de forma organizada.

## Criterios de aceptacion
- [ ] Se crea el repositorio publico en GitHub.
- [ ] El proyecto incluye README inicial.
- [ ] Se define la estructura base de frontend y backend.

## Tareas tecnicas
- [ ] Inicializar repositorio Git.
- [ ] Crear estructura base de frontend y backend." `
@("user-story","backend","frontend","devops") $m1.number

New-Issue "HU-02 - Registro de pacientes" `
"**Como** recepcionista, **quiero** registrar pacientes, **para** mantener actualizada su informacion personal.

## Criterios de aceptacion
- [ ] Se puede registrar nombre, documento, telefono y correo del paciente.
- [ ] El documento del paciente debe ser unico.
- [ ] Se puede consultar la lista de pacientes registrados.

## Tareas tecnicas
- [ ] Crear entidad y tabla de pacientes.
- [ ] Crear formulario de registro y listado." `
@("user-story","backend","frontend","database") $m1.number

New-Issue "HU-03 - Gestion de medicos" `
"**Como** administrador, **quiero** registrar medicos, **para** asociarlos a las citas disponibles.

## Criterios de aceptacion
- [ ] Se puede registrar nombre, documento, especialidad y horario del medico.
- [ ] Se puede editar la informacion del medico.
- [ ] Se puede visualizar la lista de medicos registrados.

## Tareas tecnicas
- [ ] Crear modulo CRUD de medicos.
- [ ] Disenar interfaz para listar y editar medicos." `
@("user-story","backend","frontend","database") $m1.number

New-Issue "HU-04 - Gestion de especialidades" `
"**Como** administrador, **quiero** registrar especialidades medicas, **para** clasificar correctamente a los profesionales.

## Criterios de aceptacion
- [ ] Se puede crear una especialidad medica.
- [ ] Se puede editar el nombre de una especialidad.
- [ ] Cada medico puede asociarse a una especialidad.

## Tareas tecnicas
- [ ] Crear tabla de especialidades.
- [ ] Relacionar medicos con especialidades." `
@("user-story","backend","database") $m1.number

New-Issue "HU-05 - Consulta de informacion de pacientes y medicos" `
"**Como** recepcionista, **quiero** consultar rapidamente pacientes y medicos, **para** agilizar el agendamiento de citas.

## Criterios de aceptacion
- [ ] Existe busqueda por nombre o documento.
- [ ] Se listan resultados filtrados correctamente.
- [ ] La consulta responde sin duplicados.

## Tareas tecnicas
- [ ] Implementar filtro de busqueda.
- [ ] Integrar busqueda en la interfaz." `
@("user-story","backend","frontend") $m1.number

# EPICA 2
New-Issue "HU-06 - Agendamiento de citas" `
"**Como** recepcionista, **quiero** agendar una cita medica, **para** asignar un turno disponible al paciente.

## Criterios de aceptacion
- [ ] Se puede seleccionar paciente, medico, fecha y hora.
- [ ] El sistema evita duplicidad de horarios.
- [ ] La cita queda registrada con estado 'Programada'.

## Tareas tecnicas
- [ ] Crear entidad y tabla de citas.
- [ ] Implementar formulario de agendamiento." `
@("user-story","backend","frontend","database") $m2.number

New-Issue "HU-07 - Visualizacion de agenda diaria" `
"**Como** medico, **quiero** consultar mi agenda diaria, **para** conocer las citas programadas del dia.

## Criterios de aceptacion
- [ ] Se puede filtrar por fecha.
- [ ] Se visualizan pacientes, hora y estado de la cita.
- [ ] La agenda se ordena cronologicamente.

## Tareas tecnicas
- [ ] Crear endpoint de consulta por fecha.
- [ ] Disenar vista de agenda diaria." `
@("user-story","backend","frontend") $m2.number

New-Issue "HU-08 - Reprogramacion de citas" `
"**Como** recepcionista, **quiero** reprogramar una cita existente, **para** ajustar cambios solicitados por el paciente o el medico.

## Criterios de aceptacion
- [ ] Se puede cambiar fecha y hora de la cita.
- [ ] El sistema valida disponibilidad antes de guardar.
- [ ] Se conserva el historial basico de modificacion.

## Tareas tecnicas
- [ ] Implementar actualizacion de cita.
- [ ] Validar conflictos de horario." `
@("user-story","backend","frontend") $m2.number

New-Issue "HU-09 - Cancelacion de citas" `
"**Como** recepcionista, **quiero** cancelar citas, **para** liberar horarios y mantener actualizada la agenda.

## Criterios de aceptacion
- [ ] Se puede cambiar el estado de la cita a 'Cancelada'.
- [ ] La cita cancelada no bloquea el horario.
- [ ] El motivo de cancelacion puede registrarse.

## Tareas tecnicas
- [ ] Agregar estado de cancelacion.
- [ ] Actualizar reglas de disponibilidad." `
@("user-story","backend","frontend","database") $m2.number

New-Issue "HU-10 - Consulta de historial de citas por paciente" `
"**Como** medico, **quiero** consultar el historial de citas de un paciente, **para** dar seguimiento a su atencion.

## Criterios de aceptacion
- [ ] Se visualizan citas anteriores del paciente.
- [ ] Se muestran fecha, medico y estado.
- [ ] El historial puede filtrarse por rango de fechas.

## Tareas tecnicas
- [ ] Crear consulta de historial por paciente.
- [ ] Disenar interfaz de historial." `
@("user-story","backend","frontend") $m2.number

# EPICA 3
New-Issue "HU-11 - Reporte de citas por estado" `
"**Como** administrador, **quiero** ver un reporte de citas por estado, **para** analizar cuantas fueron programadas, canceladas o completadas.

## Criterios de aceptacion
- [ ] El sistema muestra total por estado.
- [ ] El reporte puede filtrarse por rango de fechas.
- [ ] Los datos coinciden con la informacion registrada.

## Tareas tecnicas
- [ ] Crear consulta agregada en backend.
- [ ] Mostrar reporte en pantalla." `
@("user-story","backend","frontend","database") $m3.number

New-Issue "HU-12 - Validacion de datos en formularios" `
"**Como** usuario del sistema, **quiero** que los formularios validen la informacion ingresada, **para** evitar errores de captura.

## Criterios de aceptacion
- [ ] Los campos obligatorios son validados.
- [ ] El correo tiene formato valido.
- [ ] No se permite guardar formularios incompletos.

## Tareas tecnicas
- [ ] Aplicar validaciones frontend.
- [ ] Aplicar validaciones backend." `
@("user-story","backend","frontend") $m3.number

New-Issue "HU-13 - Mejora visual del tablero principal" `
"**Como** usuario, **quiero** una interfaz clara y ordenada, **para** navegar facilmente por las funcionalidades del sistema.

## Criterios de aceptacion
- [ ] El menu principal es visible y entendible.
- [ ] La interfaz mantiene consistencia visual.
- [ ] La navegacion entre modulos funciona correctamente.

## Tareas tecnicas
- [ ] Disenar layout principal.
- [ ] Implementar navegacion entre vistas." `
@("user-story","frontend") $m3.number

New-Issue "HU-14 - Documentacion tecnica del proyecto" `
"**Como** desarrollador, **quiero** documentar el proyecto, **para** facilitar su comprension y mantenimiento.

## Criterios de aceptacion
- [ ] El README describe objetivo, stack y fases.
- [ ] Se documenta la estructura general del sistema.
- [ ] Se incluye enlace al video de presentacion.

## Tareas tecnicas
- [ ] Redactar README final.
- [ ] Agregar enlace del tablero y del video." `
@("user-story","backend","devops") $m3.number

New-Issue "HU-15 - Despliegue inicial con Docker" `
"**Como** desarrollador, **quiero** preparar el despliegue del sistema con Docker, **para** facilitar su ejecucion en diferentes entornos.

## Criterios de aceptacion
- [ ] El sistema cuenta con archivos de configuracion Docker.
- [ ] La aplicacion puede levantarse con contenedores.
- [ ] La documentacion explica como ejecutar el proyecto.

## Tareas tecnicas
- [ ] Crear Dockerfile y docker-compose.
- [ ] Probar arranque de servicios." `
@("user-story","backend","devops","database") $m3.number

Write-Host ""
Write-Host "============================================================" -ForegroundColor Green
Write-Host "CONFIGURACION COMPLETADA EXITOSAMENTE" -ForegroundColor Green
Write-Host "Repositorio: https://github.com/$REPO" -ForegroundColor Cyan
Write-Host "Issues:      https://github.com/$REPO/issues" -ForegroundColor Cyan
Write-Host "Milestones:  https://github.com/$REPO/milestones" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Green
Write-Host ""
Write-Host "PASO MANUAL FINAL:" -ForegroundColor Yellow
Write-Host "Crea el GitHub Project en: https://github.com/$REPO/projects" -ForegroundColor Yellow
Write-Host "Columnas: Backlog | En Progreso | En Revision | Completado" -ForegroundColor Yellow

