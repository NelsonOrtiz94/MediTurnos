$env:JAVA_HOME = "C:\Program Files\Java\jdk-21"
$env:PATH = $env:JAVA_HOME + "\bin;" + [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

$ROOT = "C:\Users\Nelson Ortiz\OneDrive\Escritorio\MediTurnos"
Set-Location $ROOT

Write-Host "=== Verificando Java ===" -ForegroundColor Cyan
java -version 2>&1

# ── 1. Descargar e instalar Maven ─────────────────────────────────────────────
$MAVEN_VERSION = "3.9.9"
$MAVEN_ZIP     = "$ROOT\maven.zip"
$MAVEN_DIR     = "$ROOT\tools\maven"

if (-not (Test-Path $MAVEN_DIR)) {
    Write-Host "`n=== Descargando Maven $MAVEN_VERSION ===" -ForegroundColor Cyan
    Invoke-WebRequest -Uri "https://downloads.apache.org/maven/maven-3/$MAVEN_VERSION/binaries/apache-maven-$MAVEN_VERSION-bin.zip" -OutFile $MAVEN_ZIP
    Expand-Archive -Path $MAVEN_ZIP -DestinationPath "$ROOT\tools" -Force
    Rename-Item "$ROOT\tools\apache-maven-$MAVEN_VERSION" $MAVEN_DIR -ErrorAction SilentlyContinue
    Remove-Item $MAVEN_ZIP -Force
    Write-Host "Maven instalado en $MAVEN_DIR" -ForegroundColor Green
} else {
    Write-Host "Maven ya existe en $MAVEN_DIR" -ForegroundColor Yellow
}
$env:PATH = "$MAVEN_DIR\bin;" + $env:PATH
mvn -version

# ── 2. Generar backend con Spring Initializr ─────────────────────────────────
Write-Host "`n=== Generando proyecto Spring Boot ===" -ForegroundColor Cyan
$backendZip = "$ROOT\backend.zip"
$initUrl = "https://start.spring.io/starter.zip" +
    "?type=maven-project" +
    "&language=java" +
    "&bootVersion=3.4.4" +
    "&baseDir=backend" +
    "&groupId=com.mediturnos" +
    "&artifactId=mediturnos" +
    "&name=mediturnos" +
    "&packageName=com.mediturnos" +
    "&packaging=jar" +
    "&javaVersion=21" +
    "&dependencies=web,data-jpa,postgresql,validation,lombok"

Invoke-WebRequest -Uri $initUrl -OutFile $backendZip
Expand-Archive -Path $backendZip -DestinationPath $ROOT -Force
Remove-Item $backendZip -Force
Write-Host "Backend generado en $ROOT\backend" -ForegroundColor Green

# ── 3. Generar frontend con Vite + React ─────────────────────────────────────
Write-Host "`n=== Creando frontend con Vite + React ===" -ForegroundColor Cyan
Set-Location $ROOT
npm create vite@latest frontend -- --template react --yes 2>&1
Set-Location "$ROOT\frontend"
npm install 2>&1 | Select-String "added|warn|error"
npm install axios react-router-dom @mui/material @mui/icons-material @emotion/react @emotion/styled react-hook-form 2>&1 | Select-String "added|warn|error"
Write-Host "Frontend listo" -ForegroundColor Green

Set-Location $ROOT
Write-Host "`n=== Scaffolding completado ===" -ForegroundColor Green
Write-Host "Backend: $ROOT\backend"
Write-Host "Frontend: $ROOT\frontend"

