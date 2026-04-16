$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
$TOKEN = & gh auth token
$HEADERS = @{ Authorization = "Bearer $TOKEN"; "Content-Type" = "application/json"; Accept = "application/vnd.github+json" }

# Test: obtener repo y user IDs
$q = @{ query = 'query { repository(owner: "NelsonOrtiz94", name: "MediTurnos") { id } user: user(login: "NelsonOrtiz94") { id } }' } | ConvertTo-Json
$r = Invoke-RestMethod -Uri "https://api.github.com/graphql" -Method POST -Headers $HEADERS -Body $q
$r | ConvertTo-Json -Depth 10

