# setup_project.ps1
# Automatisiert die Installation und Einrichtung von XAMPP und deinem Projekt

$xamppInstallerUrl = "https://www.apachefriends.org/xampp-files/8.2.12/xampp-windows-x64-8.2.12-0-VS16-installer.exe"
$xamppInstallerPath = "$env:TEMP\xampp-installer.exe"
$xamppPath = "C:\xampp"
$htdocsPath = "$xamppPath\htdocs\html"
$projectSource = "C:\html"
$dbName = "dating_app"
$dbUser = "root"
$dbPass = ""

function Install-XAMPP {
    Write-Host "Lade XAMPP herunter..."
    Invoke-WebRequest -Uri $xamppInstallerUrl -OutFile $xamppInstallerPath
    Write-Host "Starte XAMPP-Installer... (bitte Installation abschließen und Apache/MySQL auswählen!)"
    Start-Process -Wait -FilePath $xamppInstallerPath
}

# === XAMPP installieren, falls nicht vorhanden ===
if (!(Test-Path $xamppPath)) {
    Install-XAMPP
    Write-Host "Bitte XAMPP-Installation abschließen und dann dieses Skript erneut ausführen!" -ForegroundColor Yellow
    exit 0
}

# === Apache und MySQL starten ===
Write-Host "Starte Apache und MySQL..."
Start-Process -FilePath "$xamppPath\xampp-control.exe"
Start-Sleep -Seconds 5

# === Projektverzeichnis anlegen und ALLE Dateien kopieren ===
if (!(Test-Path $htdocsPath)) {
    New-Item -Path $htdocsPath -ItemType Directory
}
Copy-Item -Path "$projectSource\*" -Destination $htdocsPath -Recurse -Force

# === Datenbank anlegen ===
Write-Host "Lege Datenbank an (falls nicht vorhanden)..."
$sql = "CREATE DATABASE IF NOT EXISTS $dbName;"
$mysqlExe = "$xamppPath\mysql\bin\mysql.exe"
& $mysqlExe -u$dbUser -e $sql

Write-Host "Fertig! Öffne http://localhost/html/app für die Webseite." 