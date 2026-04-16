$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

$TOKEN = & gh auth token
$HEADERS = @{ Authorization = "Bearer $TOKEN"; "Content-Type" = "application/json"; Accept = "application/vnd.github+json" }
$BASE = "https://api.github.com/repos/NelsonOrtiz94/MediTurnos"

# Obtener milestones
$ms = Invoke-RestMethod -Uri "$BASE/milestones?state=all&per_page=10" -Headers $HEADERS
Write-Host "Milestones encontrados:"
$ms | ForEach-Object { Write-Host "  #$($_.number) - $($_.title)" }

$m1 = ($ms | Where-Object { $_.title -like "Epica 1*" }).number
$m2 = ($ms | Where-Object { $_.title -like "Epica 2*" }).number
$m3 = ($ms | Where-Object { $_.title -like "Epica 3*" }).number
Write-Host "M1=$m1  M2=$m2  M3=$m3"

# Mapa issue -> milestone
$map = @{
    1=$m1; 2=$m1; 3=$m1; 4=$m1; 5=$m1;
    6=$m2; 7=$m2; 8=$m2; 9=$m2; 10=$m2;
    11=$m3; 12=$m3; 13=$m3; 14=$m3; 15=$m3
}

Write-Host "`nAsignando milestones a issues..."
foreach ($issue in $map.Keys) {
    $body = ConvertTo-Json @{ milestone = $map[$issue] }
    $r = Invoke-RestMethod -Uri "$BASE/issues/$issue" -Method PATCH -Headers $HEADERS -Body $body
    Write-Host "  Issue #$issue -> Milestone #$($map[$issue]) OK"
}

Write-Host "`nListo! Verifica en: https://github.com/NelsonOrtiz94/MediTurnos/issues"

