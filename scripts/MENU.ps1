# ============================================================
#  GUIA RAPIDA DE BACKUP RMAN - COMISARIATO
# ============================================================
#  
#  Este script muestra los comandos para ejecutar el backup
#  de manera interactiva y visualmente atractiva.
#
# ============================================================

# Colores para mejor visualizacion
$colors = @{
    Title   = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Info    = "White"
    Step    = "Magenta"
}

function Show-Banner {
    Clear-Host
    Write-Host ""
    Write-Host "  ╔══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
    Write-Host "  ║                                                          ║" -ForegroundColor Cyan
    Write-Host "  ║   ██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗       ║" -ForegroundColor Cyan
    Write-Host "  ║   ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗      ║" -ForegroundColor Cyan
    Write-Host "  ║   ██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝      ║" -ForegroundColor Cyan
    Write-Host "  ║   ██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝       ║" -ForegroundColor Cyan
    Write-Host "  ║   ██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║           ║" -ForegroundColor Cyan
    Write-Host "  ║   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝           ║" -ForegroundColor Cyan
    Write-Host "  ║                                                          ║" -ForegroundColor Cyan
    Write-Host "  ║              SISTEMA DE RESPALDO RMAN                    ║" -ForegroundColor Yellow
    Write-Host "  ║                   COMISARIATO                            ║" -ForegroundColor Yellow
    Write-Host "  ║                                                          ║" -ForegroundColor Cyan
    Write-Host "  ╚══════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
    Write-Host ""
}

function Show-Menu {
    Write-Host "  ┌─────────────────────────────────────────────────────────┐" -ForegroundColor White
    Write-Host "  │                    MENU PRINCIPAL                       │" -ForegroundColor White
    Write-Host "  ├─────────────────────────────────────────────────────────┤" -ForegroundColor White
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [1] Configuracion Inicial (Solo primera vez)          │" -ForegroundColor Green
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [2] Ejecutar Respaldo Completo (Level 0)              │" -ForegroundColor Yellow
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [3] Ejecutar Respaldo Incremental (Level 1)           │" -ForegroundColor Yellow
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [4] Validar Respaldos Existentes                      │" -ForegroundColor Cyan
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [5] Ver Estado de la Base de Datos                    │" -ForegroundColor Cyan
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [6] Monitorear Respaldos                              │" -ForegroundColor Cyan
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [0] Salir                                             │" -ForegroundColor Red
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  └─────────────────────────────────────────────────────────┘" -ForegroundColor White
    Write-Host ""
}

function Show-Step {
    param([string]$Step, [string]$Description)
    Write-Host ""
    Write-Host "  ► PASO: $Step" -ForegroundColor Magenta
    Write-Host "    $Description" -ForegroundColor White
    Write-Host ""
}

function Pause-Script {
    Write-Host ""
    Write-Host "  Presione ENTER para continuar..." -ForegroundColor Gray
    Read-Host
}

# Obtener ruta del proyecto
$PROJECT_PATH = Split-Path -Parent $PSScriptRoot

# Menu Principal
do {
    Show-Banner
    Show-Menu
    
    $option = Read-Host "  Seleccione una opcion"
    
    switch ($option) {
        "1" {
            Show-Banner
            Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Green
            Write-Host "  ║     CONFIGURACION INICIAL (PRIMERA VEZ)   ║" -ForegroundColor Green
            Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Green
            Write-Host ""
            
            Show-Step "1" "Ejecutar script de instalacion"
            Write-Host "    Comando:" -ForegroundColor Gray
            Write-Host "    .\INSTALAR.ps1" -ForegroundColor Yellow
            Write-Host ""
            
            Show-Step "2" "Habilitar ARCHIVELOG (como SYSDBA)"
            Write-Host "    Comando:" -ForegroundColor Gray
            Write-Host "    sqlplus / as sysdba @configuracion\habilitar_archivelog.sql" -ForegroundColor Yellow
            Write-Host ""
            
            Show-Step "3" "Configurar RMAN"
            Write-Host "    Comando:" -ForegroundColor Gray
            Write-Host "    rman TARGET / @configuracion\configurar_rman.rman" -ForegroundColor Yellow
            
            Pause-Script
        }
        "2" {
            Show-Banner
            Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Yellow
            Write-Host "  ║        RESPALDO COMPLETO (LEVEL 0)        ║" -ForegroundColor Yellow
            Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "    Este backup respalda TODA la base de datos." -ForegroundColor White
            Write-Host "    Frecuencia recomendada: Domingos 2:00 AM" -ForegroundColor Gray
            Write-Host ""
            Write-Host "    Comando:" -ForegroundColor Gray
            Write-Host "    rman TARGET / @respaldos\respaldo_completo_nivel0.rman" -ForegroundColor Yellow
            Write-Host ""
            
            $confirm = Read-Host "  Desea ejecutar ahora? (S/N)"
            if ($confirm -eq "S" -or $confirm -eq "s") {
                Write-Host ""
                Write-Host "  Ejecutando respaldo completo..." -ForegroundColor Green
                rman TARGET / cmdfile="$PROJECT_PATH\scripts\respaldos\respaldo_completo_nivel0.rman"
            }
            
            Pause-Script
        }
        "3" {
            Show-Banner
            Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Yellow
            Write-Host "  ║      RESPALDO INCREMENTAL (LEVEL 1)       ║" -ForegroundColor Yellow
            Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "    Este backup respalda solo los CAMBIOS desde el ultimo backup." -ForegroundColor White
            Write-Host "    Frecuencia recomendada: Lunes a Sabado 2:00 AM" -ForegroundColor Gray
            Write-Host ""
            Write-Host "    Comando:" -ForegroundColor Gray
            Write-Host "    rman TARGET / @respaldos\respaldo_incremental_nivel1.rman" -ForegroundColor Yellow
            Write-Host ""
            
            $confirm = Read-Host "  Desea ejecutar ahora? (S/N)"
            if ($confirm -eq "S" -or $confirm -eq "s") {
                Write-Host ""
                Write-Host "  Ejecutando respaldo incremental..." -ForegroundColor Green
                rman TARGET / cmdfile="$PROJECT_PATH\scripts\respaldos\respaldo_incremental_nivel1.rman"
            }
            
            Pause-Script
        }
        "4" {
            Show-Banner
            Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "  ║        VALIDAR RESPALDOS EXISTENTES       ║" -ForegroundColor Cyan
            Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "    Verifica la integridad de los backups existentes." -ForegroundColor White
            Write-Host ""
            Write-Host "    Comando:" -ForegroundColor Gray
            Write-Host "    rman TARGET / @respaldos\validar_respaldos.rman" -ForegroundColor Yellow
            Write-Host ""
            
            $confirm = Read-Host "  Desea ejecutar ahora? (S/N)"
            if ($confirm -eq "S" -or $confirm -eq "s") {
                Write-Host ""
                Write-Host "  Validando respaldos..." -ForegroundColor Green
                rman TARGET / cmdfile="$PROJECT_PATH\scripts\respaldos\validar_respaldos.rman"
            }
            
            Pause-Script
        }
        "5" {
            Show-Banner
            Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "  ║       ESTADO DE LA BASE DE DATOS          ║" -ForegroundColor Cyan
            Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host ""
            
            Write-Host "  Consultando estado..." -ForegroundColor Yellow
            Write-Host ""
            
            $query = @"
SET PAGESIZE 100
SET LINESIZE 200
SELECT name AS "Base de Datos", open_mode AS "Modo", log_mode AS "Archivelog" FROM v`$database;
EXIT;
"@
            $query | sqlplus -s / as sysdba
            
            Pause-Script
        }
        "6" {
            Show-Banner
            Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Cyan
            Write-Host "  ║          MONITOREAR RESPALDOS             ║" -ForegroundColor Cyan
            Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "    Comando:" -ForegroundColor Gray
            Write-Host "    sqlplus / as sysdba @monitoreo\monitorear_respaldos.sql" -ForegroundColor Yellow
            Write-Host ""
            
            $confirm = Read-Host "  Desea ejecutar ahora? (S/N)"
            if ($confirm -eq "S" -or $confirm -eq "s") {
                Write-Host ""
                sqlplus / as sysdba "@$PROJECT_PATH\scripts\monitoreo\monitorear_respaldos.sql"
            }
            
            Pause-Script
        }
        "0" {
            Write-Host ""
            Write-Host "  Gracias por usar el Sistema de Respaldo RMAN" -ForegroundColor Green
            Write-Host ""
            break
        }
        default {
            Write-Host ""
            Write-Host "  Opcion no valida. Intente de nuevo." -ForegroundColor Red
            Start-Sleep -Seconds 2
        }
    }
} while ($option -ne "0")
