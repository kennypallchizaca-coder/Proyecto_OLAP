# ============================================================
#  GUIA RAPIDA DE BACKUP RMAN - COMISARIATO
# ============================================================

# Colores para mejor visualizacion
$colors = @{
    Title   = "Cyan"
    Success = "Green"
    Warning = "Yellow"
    Info    = "White"
    Step    = "Magenta"
}

# Variable para controlar la animacion inicial
$script:firstRun = $true

function Show-Banner {
    Clear-Host

    # Ocultar cursor para animacion limpia
    [Console]::CursorVisible = $false

    try {
        # Definir banner con colores gradiente MORADO estilo Linux
        $bannerLines = @(
            @{ Text = ""; Color = "White" },
            @{ Text = "  ╔══════════════════════════════════════════════════════════╗"; Color = "DarkMagenta" },
            @{ Text = "  ║                                                          ║"; Color = "DarkMagenta" },
            @{ Text = "  ║   ██████╗  █████╗  ██████╗██╗  ██╗██╗   ██╗██████╗       ║"; Color = "Magenta" },
            @{ Text = "  ║   ██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██║   ██║██╔══██╗      ║"; Color = "Magenta" },
            @{ Text = "  ║   ██████╔╝███████║██║     █████╔╝ ██║   ██║██████╔╝      ║"; Color = "White" },
            @{ Text = "  ║   ██╔══██╗██╔══██║██║     ██╔═██╗ ██║   ██║██╔═══╝       ║"; Color = "Magenta" },
            @{ Text = "  ║   ██████╔╝██║  ██║╚██████╗██║  ██╗╚██████╔╝██║           ║"; Color = "Magenta" },
            @{ Text = "  ║   ╚═════╝ ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝           ║"; Color = "DarkMagenta" },
            @{ Text = "  ║                                                          ║"; Color = "DarkMagenta" },
            @{ Text = "  ║              SISTEMA DE RESPALDO RMAN                    ║"; Color = "Yellow" },
            @{ Text = "  ║           COMISARIATO  BY LEXIS-TEAM                     ║"; Color = "Yellow" },
            @{ Text = "  ║                                                          ║"; Color = "DarkMagenta" },
            @{ Text = "  ╚══════════════════════════════════════════════════════════╝"; Color = "DarkMagenta" },
            @{ Text = ""; Color = "White" }
        )

        if ($script:firstRun) {
            # PRIMERA VEZ: Animacion completa con typing + barra de carga
            $script:firstRun = $false

            foreach ($line in $bannerLines) {
                if ($line.Text -eq "") {
                    Write-Host ""
                    continue
                }

                # Efecto de escritura rapido
                $chars = $line.Text.ToCharArray()
                foreach ($char in $chars) {
                    Write-Host $char -ForegroundColor $line.Color -NoNewline
                }
                Write-Host ""
                Start-Sleep -Milliseconds 15
            }

            # Efecto de "carga" estilo Linux (rapido)
            Write-Host ""
            $loadingText = "  [ Inicializando Sistema de Respaldo... ]"
            foreach ($char in $loadingText.ToCharArray()) {
                Write-Host $char -ForegroundColor Magenta -NoNewline
                Start-Sleep -Milliseconds 5
            }

            # Barra de progreso animada (rapida)
            Write-Host ""
            Write-Host "  [" -ForegroundColor DarkGray -NoNewline
            for ($i = 0; $i -lt 40; $i++) {
                Write-Host "█" -ForegroundColor Magenta -NoNewline
                Start-Sleep -Milliseconds 3
            }
            Write-Host "]" -ForegroundColor DarkGray

            Write-Host "  ✓ Sistema listo" -ForegroundColor Magenta
            Start-Sleep -Milliseconds 200
            Clear-Host

            # Mostrar banner final
            foreach ($line in $bannerLines) {
                Write-Host $line.Text -ForegroundColor $line.Color
            }

        } else {
            # SIGUIENTES VECES: Banner estatico instantaneo (sin animacion)
            foreach ($line in $bannerLines) {
                Write-Host $line.Text -ForegroundColor $line.Color
            }
        }
    }
    finally {
        # Restaurar cursor SIEMPRE (aunque ocurra un error)
        [Console]::CursorVisible = $true
    }
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
    Read-Host | Out-Null
}

# ============================================================
# RUTA DEL PROYECTO (corregido: auto-detecta la raiz que contiene \scripts)
# ============================================================
$PROJECT_PATH = $PSScriptRoot
if (-not (Test-Path (Join-Path $PROJECT_PATH "scripts"))) {
    $parent = Split-Path -Parent $PSScriptRoot
    if (Test-Path (Join-Path $parent "scripts")) {
        $PROJECT_PATH = $parent
    }
}

# Directorio de logs
$LOG_DIR = "C:\oracle\backup\logs"
if (-not (Test-Path $LOG_DIR)) {
    New-Item -ItemType Directory -Path $LOG_DIR -Force | Out-Null
}

function Get-LogFile {
    param([string]$Prefix)
    $timestamp = Get-Date -Format "yyyyMMdd_HHmmss"
    return (Join-Path $LOG_DIR ("{0}_{1}.log" -f $Prefix, $timestamp))
}

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
                $logFile = Get-LogFile -Prefix "RESPALDO_COMPLETO"
                $cmdFile = Join-Path $PROJECT_PATH "scripts\respaldos\respaldo_completo_nivel0.rman"

                Write-Host ""
                Write-Host "  Ejecutando respaldo completo..." -ForegroundColor Green
                Write-Host "  Log: $logFile" -ForegroundColor Cyan
                Write-Host ""

                & rman TARGET / cmdfile="$cmdFile" log="$logFile"

                if (Test-Path $logFile) {
                    Write-Host ""
                    Write-Host "  ✓ Log guardado en: $logFile" -ForegroundColor Green
                    Write-Host ""
                    $verLog = Read-Host "  Desea ver el log? (S/N)"
                    if ($verLog -eq "S" -or $verLog -eq "s") {
                        Write-Host ""
                        Get-Content -Path $logFile
                    }
                }
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
                $logFile = Get-LogFile -Prefix "RESPALDO_INCREMENTAL"
                $cmdFile = Join-Path $PROJECT_PATH "scripts\respaldos\respaldo_incremental_nivel1.rman"

                Write-Host ""
                Write-Host "  Ejecutando respaldo incremental..." -ForegroundColor Green
                Write-Host "  Log: $logFile" -ForegroundColor Cyan
                Write-Host ""

                & rman TARGET / cmdfile="$cmdFile" log="$logFile"

                if (Test-Path $logFile) {
                    Write-Host ""
                    Write-Host "  ✓ Log guardado en: $logFile" -ForegroundColor Green
                    Write-Host ""
                    $verLog = Read-Host "  Desea ver el log? (S/N)"
                    if ($verLog -eq "S" -or $verLog -eq "s") {
                        Write-Host ""
                        Get-Content -Path $logFile
                    }
                }
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
                $logFile = Get-LogFile -Prefix "VALIDACION"
                $cmdFile = Join-Path $PROJECT_PATH "scripts\respaldos\validar_respaldos.rman"

                Write-Host ""
                Write-Host "  Validando respaldos..." -ForegroundColor Green
                Write-Host "  Log: $logFile" -ForegroundColor Cyan
                Write-Host ""

                & rman TARGET / cmdfile="$cmdFile" log="$logFile"

                if (Test-Path $logFile) {
                    Write-Host ""
                    Write-Host "  ✓ Log guardado en: $logFile" -ForegroundColor Green
                    Write-Host ""
                    $verLog = Read-Host "  Desea ver el log? (S/N)"
                    if ($verLog -eq "S" -or $verLog -eq "s") {
                        Write-Host ""
                        Get-Content -Path $logFile
                    }
                }
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
                $sqlFile = Join-Path $PROJECT_PATH "scripts\monitoreo\monitorear_respaldos.sql"
                & sqlplus / as sysdba "@$sqlFile"
            }

            Pause-Script
        }
        "0" {
            Write-Host ""
            Write-Host "  Gracias por usar el Sistema de Respaldo RMAN" -ForegroundColor Magenta
            Write-Host "  BY LEXIS-TEAM" -ForegroundColor DarkMagenta
            Write-Host ""
            break
        }
        "" {
            # Si presiona Enter sin escribir nada, simplemente refrescar el menu
            continue
        }
        default {
            Write-Host ""
            Write-Host "  ⚠ Opcion no valida. Intente de nuevo." -ForegroundColor Red
            Start-Sleep -Seconds 1
        }
    }
} while ($option -ne "0")
