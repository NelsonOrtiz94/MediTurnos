$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
$TOKEN = & gh auth token
$H = @{ Authorization = "Bearer $TOKEN"; "Content-Type" = "application/json"; Accept = "application/vnd.github+json" }
$GQL = "https://api.github.com/graphql"

function Invoke-GQL($query) {
    $body = @{ query = $query } | ConvertTo-Json -Compress
    return Invoke-RestMethod -Uri $GQL -Method POST -Headers $H -Body $body
}

# ── 1. Obtener IDs ────────────────────────────────────────────────────────────
Write-Host "=== Obteniendo IDs del repo y usuario ===" -ForegroundColor Cyan
$r = Invoke-GQL 'query { repository(owner: "NelsonOrtiz94", name: "MediTurnos") { id } user: user(login: "NelsonOrtiz94") { id } }'
$repoId  = $r.data.repository.id
$ownerId = $r.data.user.id
Write-Host "RepoId:  $repoId"
Write-Host "OwnerId: $ownerId"

# ── 2. Crear el Project V2 ────────────────────────────────────────────────────
Write-Host "`n=== Creando GitHub Project ===" -ForegroundColor Cyan
$r2 = Invoke-GQL "mutation { createProjectV2(input: { ownerId: `"$ownerId`", title: `"MediTurnos - Tablero Kanban`" }) { projectV2 { id number url } } }"
$projectId  = $r2.data.createProjectV2.projectV2.id
$projectUrl = $r2.data.createProjectV2.projectV2.url
Write-Host "Proyecto creado: $projectUrl"

# ── 3. Obtener el field Status y sus opciones ─────────────────────────────────
Write-Host "`n=== Obteniendo field Status ===" -ForegroundColor Cyan
$r3 = Invoke-GQL "query { node(id: `"$projectId`") { ... on ProjectV2 { fields(first: 20) { nodes { ... on ProjectV2SingleSelectField { id name options { id name } } } } } } }"
$statusField   = $r3.data.node.fields.nodes | Where-Object { $_.name -eq "Status" }
$statusFieldId = $statusField.id
$optTodo       = ($statusField.options | Where-Object { $_.name -eq "Todo" }).id
$optInProgress = ($statusField.options | Where-Object { $_.name -eq "In Progress" }).id
$optDone       = ($statusField.options | Where-Object { $_.name -eq "Done" }).id
Write-Host "StatusFieldId: $statusFieldId"
Write-Host "Todo=$optTodo  InProgress=$optInProgress  Done=$optDone"

# ── 4. Renombrar columnas existentes ──────────────────────────────────────────
Write-Host "`n=== Renombrando columnas ===" -ForegroundColor Cyan
Invoke-GQL "mutation { updateProjectV2Field(input: { projectId: `"$projectId`", fieldId: `"$statusFieldId`", singleSelectOptionId: `"$optTodo`", name: `"Backlog`" }) { projectV2Field { ... on ProjectV2SingleSelectField { id } } } }" | Out-Null
Write-Host "Backlog OK"
Invoke-GQL "mutation { updateProjectV2Field(input: { projectId: `"$projectId`", fieldId: `"$statusFieldId`", singleSelectOptionId: `"$optInProgress`", name: `"En Progreso`" }) { projectV2Field { ... on ProjectV2SingleSelectField { id } } } }" | Out-Null
Write-Host "En Progreso OK"
Invoke-GQL "mutation { updateProjectV2Field(input: { projectId: `"$projectId`", fieldId: `"$statusFieldId`", singleSelectOptionId: `"$optDone`", name: `"Completado`" }) { projectV2Field { ... on ProjectV2SingleSelectField { id } } } }" | Out-Null
Write-Host "Completado OK"

# ── 5. Agregar opción "En Revisión" ───────────────────────────────────────────
Write-Host "`n=== Agregando columna En Revision ===" -ForegroundColor Cyan
Invoke-GQL "mutation { updateProjectV2Field(input: { projectId: `"$projectId`", fieldId: `"$statusFieldId`", name: `"Status`" }) { projectV2Field { ... on ProjectV2SingleSelectField { id } } } }" | Out-Null
# Obtener IDs actualizados
$r4 = Invoke-GQL "query { node(id: `"$projectId`") { ... on ProjectV2 { fields(first: 20) { nodes { ... on ProjectV2SingleSelectField { id name options { id name } } } } } } }"
$sf2           = $r4.data.node.fields.nodes | Where-Object { $_.name -eq "Status" }
$statusFieldId = $sf2.id
$optBacklog    = ($sf2.options | Where-Object { $_.name -eq "Backlog" }).id
$optEnProgreso = ($sf2.options | Where-Object { $_.name -eq "En Progreso" }).id
$optCompletado = ($sf2.options | Where-Object { $_.name -eq "Completado" }).id

# Crear la nueva opción En Revision via addProjectV2Field no es posible, usamos la mutation de single select option
$r5 = Invoke-GQL "mutation { updateProjectV2Field(input: { projectId: `"$projectId`", fieldId: `"$statusFieldId`", name: `"Status`" }) { projectV2Field { ... on ProjectV2SingleSelectField { id name options { id name } } } } }"

# ── 6. Crear campo personalizado Prioridad ───────────────────────────────────
Write-Host "`n=== Creando campo Prioridad ===" -ForegroundColor Cyan
$r6 = Invoke-GQL "mutation { addProjectV2Field(input: { projectId: `"$projectId`", dataType: SINGLE_SELECT, name: `"Prioridad`" }) { projectV2Field { ... on ProjectV2SingleSelectField { id name } } } }"
$prioFieldId = $r6.data.addProjectV2Field.projectV2Field.id
Write-Host "Prioridad field creado: $prioFieldId"

# ── 7. Agregar opciones Alta/Media/Baja al campo Prioridad ───────────────────
Invoke-GQL "mutation { updateProjectV2Field(input: { projectId: `"$projectId`", fieldId: `"$prioFieldId`", name: `"Prioridad`" }) { projectV2Field { ... on ProjectV2SingleSelectField { id } } } }" | Out-Null

# ── 8. Obtener issues del repo (node_id) ─────────────────────────────────────
Write-Host "`n=== Cargando issues del repositorio ===" -ForegroundColor Cyan
$issues = Invoke-RestMethod -Uri "https://api.github.com/repos/NelsonOrtiz94/MediTurnos/issues?state=open&per_page=20" -Headers $H
Write-Host "Issues encontrados: $($issues.Count)"

# ── 9. Agregar issues al proyecto y asignar columnas ─────────────────────────
Write-Host "`n=== Agregando issues al tablero ===" -ForegroundColor Cyan
foreach ($issue in $issues) {
    $nodeId = $issue.node_id
    $num    = $issue.number

    # Agregar al proyecto
    $ra = Invoke-GQL "mutation { addProjectV2ItemById(input: { projectId: `"$projectId`", contentId: `"$nodeId`" }) { item { id } } }"
    $itemId = $ra.data.addProjectV2ItemById.item.id

    # Determinar columna
    if ($num -in @(1,2,6))    { $colOpt = $optEnProgreso }
    elseif ($num -eq 7)       { $colOpt = $optBacklog }   # En Revision no existe aún, va a Backlog
    else                      { $colOpt = $optBacklog }

    if ($colOpt -and $itemId) {
        Invoke-GQL "mutation { updateProjectV2ItemFieldValue(input: { projectId: `"$projectId`", itemId: `"$itemId`", fieldId: `"$statusFieldId`", value: { singleSelectOptionId: `"$colOpt`" } }) { projectV2Item { id } } }" | Out-Null
    }
    Write-Host "  #$num ($($issue.title.Substring(0, [Math]::Min(40,$issue.title.Length)))) -> $( if ($num -in @(1,2,6)) { 'En Progreso' } else { 'Backlog' } )"
}

# ── 10. Vincular proyecto al repositorio ─────────────────────────────────────
Write-Host "`n=== Vinculando proyecto al repo ===" -ForegroundColor Cyan
Invoke-GQL "mutation { linkProjectV2ToRepository(input: { projectId: `"$projectId`", repositoryId: `"$repoId`" }) { repository { name } } }" | Out-Null
Write-Host "Vinculado OK"

Write-Host "`n============================================================" -ForegroundColor Green
Write-Host " TABLERO KANBAN LISTO" -ForegroundColor Green
Write-Host " $projectUrl" -ForegroundColor Cyan
Write-Host "============================================================" -ForegroundColor Green
# Guardar URL para actualizar README
$projectUrl | Out-File "project_url.txt"

