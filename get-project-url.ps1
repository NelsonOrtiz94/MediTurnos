$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
$TOKEN = & gh auth token
$H = @{ Authorization = "Bearer $TOKEN"; "Content-Type" = "application/json"; Accept = "application/vnd.github+json" }
$body = @{ query = 'query { user(login: "NelsonOrtiz94") { projectsV2(first: 10) { nodes { id number title url } } } }' } | ConvertTo-Json -Compress
$r = Invoke-RestMethod -Uri "https://api.github.com/graphql" -Method POST -Headers $H -Body $body
$r.data.user.projectsV2.nodes | ForEach-Object { Write-Host "#$($_.number) - $($_.title): $($_.url)" }

