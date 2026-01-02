# Script de Instalacion Rapida - Plan de Recuperacion Comisariato
# Ejecutar este script en PowerShell como Administrador

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "INSTALACION PLAN DE RECUPERACION" -ForegroundColor Cyan
Write-Host "Comisariato - Oracle RMAN" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Variables
$ORACLE_BACKUP_DIR = "C:\oracle\backup\rman"
$ORACLE_ARCH_DIR = "C:\oracle\arch"
# Auto-detectar ubicacion del proyecto (directorio padre de scripts/)
$PROJECT_PATH = Split-Path -Parent $PSScriptRoot

# Paso 1: Crear directorios
Write-Host "[1/5] Creando directorios de backup..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $ORACLE_BACKUP_DIR -Force | Out-Null
New-Item -ItemType Directory -Path $ORACLE_ARCH_DIR -Force | Out-Null
Write-Host "  [OK] Directorios creados" -ForegroundColor Green
Write-Host ""

# Paso 2: Dar permisos
Write-Host "[2/5] Configurando permisos..." -ForegroundColor Yellow
icacls $ORACLE_BACKUP_DIR /grant Everyone:F /T | Out-Null
icacls $ORACLE_ARCH_DIR /grant Everyone:F /T | Out-Null
Write-Host "  [OK] Permisos configurados" -ForegroundColor Green
Write-Host ""

# Paso 3: Programar Full Backup (Domingos)
Write-Host "[3/5] Programando Full Backup (Domingos 2AM)..." -ForegroundColor Yellow
$actionFull = New-ScheduledTaskAction `
    -Execute "rman" `
    -Argument "TARGET / @`"$PROJECT_PATH\scripts\respaldos\respaldo_completo_nivel0.rman`"" `
    -WorkingDirectory $PROJECT_PATH

$triggerFull = New-ScheduledTaskTrigger -Weekly -DaysOfWeek Sunday -At 2AM

$settingsFull = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName "RMAN_Backup_Full_Comisariato" `
    -Action $actionFull `
    -Trigger $triggerFull `
    -Settings $settingsFull `
    -User "SYSTEM" `
    -RunLevel Highest `
    -Description "Backup Full semanal del Comisariato (Level 0)" `
    -Force | Out-Null

Write-Host "  [OK] Tarea Full Backup programada" -ForegroundColor Green
Write-Host ""

# Paso 4: Programar Incremental Backup (Lun-Sab)
Write-Host "[4/5] Programando Incremental Backup (Lun-Sab 2AM)..." -ForegroundColor Yellow
$actionInc = New-ScheduledTaskAction `
    -Execute "rman" `
    -Argument "TARGET / @`"$PROJECT_PATH\scripts\respaldos\respaldo_incremental_nivel1.rman`"" `
    -WorkingDirectory $PROJECT_PATH

$triggerInc = New-ScheduledTaskTrigger `
    -Weekly `
    -DaysOfWeek Monday,Tuesday,Wednesday,Thursday,Friday,Saturday `
    -At 2AM

$settingsInc = New-ScheduledTaskSettingsSet `
    -AllowStartIfOnBatteries `
    -DontStopIfGoingOnBatteries `
    -StartWhenAvailable

Register-ScheduledTask `
    -TaskName "RMAN_Backup_Incremental_Comisariato" `
    -Action $actionInc `
    -Trigger $triggerInc `
    -Settings $settingsInc `
    -User "SYSTEM" `
    -RunLevel Highest `
    -Description "Backup Incremental diario del Comisariato (Level 1)" `
    -Force | Out-Null

Write-Host "  [OK] Tarea Incremental Backup programada" -ForegroundColor Green
Write-Host ""

# Paso 5: Verificar instalacion
Write-Host "[5/5] Verificando instalacion..." -ForegroundColor Yellow
$tasks = Get-ScheduledTask | Where-Object {$_.TaskName -like "*RMAN*Comisariato*"}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "INSTALACION COMPLETADA" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Directorios creados:" -ForegroundColor White
Write-Host "  - $ORACLE_BACKUP_DIR" -ForegroundColor Gray
Write-Host "  - $ORACLE_ARCH_DIR" -ForegroundColor Gray
Write-Host ""
Write-Host "Tareas programadas:" -ForegroundColor White
foreach ($task in $tasks) {
    Write-Host "  - $($task.TaskName) [$($task.State)]" -ForegroundColor Gray
}
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "PROXIMOS PASOS:" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "1. Habilitar ARCHIVELOG (una sola vez):" -ForegroundColor White
Write-Host "   sqlplus / as sysdba @scripts\configuracion\habilitar_archivelog.sql" -ForegroundColor Gray
Write-Host ""
Write-Host "2. Configurar RMAN (una sola vez):" -ForegroundColor White
Write-Host "   rman TARGET / @scripts\configuracion\configurar_rman.rman" -ForegroundColor Gray
Write-Host ""
Write-Host "3. Ejecutar primer Full Backup manual:" -ForegroundColor White
Write-Host "   rman TARGET / @scripts\respaldos\respaldo_completo_nivel0.rman" -ForegroundColor Gray
Write-Host ""
Write-Host "4. Validar el backup:" -ForegroundColor White
Write-Host "   rman TARGET / @scripts\respaldos\validar_respaldos.rman" -ForegroundColor Gray
Write-Host ""
Write-Host "Para monitoreo diario:" -ForegroundColor White
Write-Host "   sqlplus / as sysdba @scripts\monitoreo\monitorear_respaldos.sql" -ForegroundColor Gray
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Documentacion completa en:" -ForegroundColor White
Write-Host "docs\recovery-plan\README.md" -ForegroundColor Gray
Write-Host "========================================" -ForegroundColor Cyan
