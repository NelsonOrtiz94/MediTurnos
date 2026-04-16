$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")
gh auth refresh -s project 2>&1 | Out-File "C:\Users\Nelson Ortiz\OneDrive\Escritorio\MediTurnos\auth_result.txt"
gh auth status 2>&1 | Out-File -Append "C:\Users\Nelson Ortiz\OneDrive\Escritorio\MediTurnos\auth_result.txt"

