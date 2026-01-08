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
    Write-Host "  │   [7] RECUPERACION (Submenu) ⚠                          │" -ForegroundColor Red
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

function Show-RecoveryMenu {
    Write-Host "  ┌─────────────────────────────────────────────────────────┐" -ForegroundColor Red
    Write-Host "  │                ⚠  MENU DE RECUPERACION  ⚠               │" -ForegroundColor Red
    Write-Host "  ├─────────────────────────────────────────────────────────┤" -ForegroundColor Red
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   ADVERTENCIA: Operaciones destructivas                 │" -ForegroundColor Yellow
    Write-Host "  │   Solo ejecutar bajo supervision de DBA                 │" -ForegroundColor Yellow
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  ├─────────────────────────────────────────────────────────┤" -ForegroundColor Red
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [1] Recuperacion Completa Total                       │" -ForegroundColor Red
    Write-Host "  │       (Restaurar desde ultimo backup disponible)        │" -ForegroundColor Gray
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [2] Recuperacion Point-in-Time (PITR)                 │" -ForegroundColor Red
    Write-Host "  │       (Restaurar a un momento especifico)               │" -ForegroundColor Gray
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [3] Validacion Post-Recuperacion                      │" -ForegroundColor Cyan
    Write-Host "  │       (Verificar integridad tras recuperacion)          │" -ForegroundColor Gray
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  │   [0] Volver al Menu Principal                          │" -ForegroundColor White
    Write-Host "  │                                                         │" -ForegroundColor White
    Write-Host "  └─────────────────────────────────────────────────────────┘" -ForegroundColor Red
    Write-Host ""
}

function Invoke-RecoveryMenu {
    do {
        Show-Banner
        Show-RecoveryMenu
        
        $recoveryOption = Read-Host "  Seleccione una opcion"
        
        switch ($recoveryOption) {
            "1" {
                Show-Banner
                Write-Host "  SEARCHING FOR HEALTH STATUS..." -ForegroundColor Gray
                
                # --- HEALTH CHECK START ---
                $healthStatus = "UNKNOWN"
                try {
                    $checkFile = Join-Path $PROJECT_PATH "scripts\recuperacion\verificar_estado.sql"
                    $checkOutput = sqlplus -s / as sysdba "@$checkFile" 2>&1
                    if ($checkOutput -match "STATUS:HEALTHY") { $healthStatus = "HEALTHY" }
                    elseif ($checkOutput -match "STATUS:NEEDS_RECOVERY") { $healthStatus = "NEEDS_RECOVERY" }
                    elseif ($checkOutput -match "STATUS:MOUNTED_OR_OTHER") { $healthStatus = "MOUNTED" }
                    else { $healthStatus = "DOWN_OR_ERROR" }
                } catch {
                    $healthStatus = "DOWN_OR_ERROR"
                }

                Write-Host "  ANALISIS PREVIO:" -ForegroundColor Cyan
                if ($healthStatus -eq "HEALTHY") {
                    Write-Host "  [✔] BASE DE DATOS ONLINE Y SANA (STATUS: HEALTHY)" -ForegroundColor Green
                    Write-Host ""
                    Write-Host "  ╔══════════════════════════════════════════════════════════╗" -ForegroundColor Red
                    Write-Host "  ║                 ⛔  BLOQUEO DE SEGURIDAD  ⛔             ║" -ForegroundColor Red
                    Write-Host "  ╠══════════════════════════════════════════════════════════╣" -ForegroundColor Red
                    Write-Host "  ║  LA BASE DE DATOS ESTA FUNCIONANDO CORRECTAMENTE.        ║" -ForegroundColor Yellow
                    Write-Host "  ║  RECUPERAR AHORA BORRARA TODOS LOS DATOS ACTUALES.       ║" -ForegroundColor Yellow
                    Write-Host "  ║  NO SE RECOMIENDA PROCEDER.                              ║" -ForegroundColor Yellow
                    Write-Host "  ╚══════════════════════════════════════════════════════════╝" -ForegroundColor Red
                    Write-Host ""
                    $hardConfirm = Read-Host "  Para forzar (PELIGRO), escriba 'SOBRESCRIBIR'"
                    if ($hardConfirm -ne "SOBRESCRIBIR") {
                        Write-Host ""
                        Write-Host "  ✓ Operacion cancelada por seguridad." -ForegroundColor Green
                        Pause-Script
                        continue
                    }
                } elseif ($healthStatus -eq "NEEDS_RECOVERY") {
                    Write-Host "  [⚠] SE DETECTARON ARCHIVOS FALTANTES. RECUPERACION RECOMENDADA." -ForegroundColor Yellow
                } else {
                    Write-Host "  [!] LA INSTANCIA NO RESPONDE O ESTA EN MODO MOUNT." -ForegroundColor Magenta
                }
                # --- HEALTH CHECK END ---

                Show-Banner
                Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Red
                Write-Host "  ║     RECUPERACION COMPLETA TOTAL           ║" -ForegroundColor Red
                Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Red
                Write-Host ""
                Write-Host "  ⚠  ADVERTENCIA CRITICA  ⚠" -ForegroundColor Red
                Write-Host ""
                Write-Host "    Esta operacion:" -ForegroundColor Yellow
                Write-Host "    - SOBRESCRIBIRA la base de datos actual" -ForegroundColor Red
                Write-Host "    - Restaurara desde el ultimo backup disponible" -ForegroundColor White
                Write-Host "    - La BD estara NO DISPONIBLE durante el proceso" -ForegroundColor Yellow
                Write-Host "    - Requiere REINICIO de la instancia Oracle" -ForegroundColor Yellow
                Write-Host ""
                Write-Host "    Comando:" -ForegroundColor Gray
                Write-Host "    rman TARGET / @recuperacion\recuperar_base_completa.rman" -ForegroundColor Yellow
                Write-Host ""
                
                $confirm1 = Read-Host "  Esta SEGURO que desea continuar? (S/N)"
                if ($confirm1 -eq "S" -or $confirm1 -eq "s") {
                    Write-Host ""
                    Write-Host "  CONFIRMACION FINAL:" -ForegroundColor Red
                    $confirm2 = Read-Host "  Escriba 'RECUPERAR' para confirmar"
                    
                    if ($confirm2 -eq "RECUPERAR") {
                        $logFile = Get-LogFile -Prefix "RECUPERACION_COMPLETA"
                        $cmdFile = Join-Path $PROJECT_PATH "scripts\recuperacion\recuperar_base_completa.rman"
                        
                        Write-Host ""
                        Write-Host "  Ejecutando recuperacion completa..." -ForegroundColor Red
                        Write-Host "  Log: $logFile" -ForegroundColor Cyan
                        Write-Host ""
                        
                        & rman TARGET / cmdfile="$cmdFile" log="$logFile"
                        
                        if (Test-Path $logFile) {
                            Write-Host ""
                            Write-Host "  ✓ Log guardado en: $logFile" -ForegroundColor Green
                            Write-Host ""
                            Write-Host "  IMPORTANTE: Ejecute la validacion post-recuperacion (opcion 3)" -ForegroundColor Yellow
                        }
                    } else {
                        Write-Host ""
                        Write-Host "  ✗ Operacion cancelada" -ForegroundColor Yellow
                    }
                }
                
                Pause-Script
            }
            "2" {
                Show-Banner
                # --- HEALTH CHECK START (Simplified for Option 2) ---
                $healthStatus = "UNKNOWN"
                try {
                    $checkFile = Join-Path $PROJECT_PATH "scripts\recuperacion\verificar_estado.sql"
                    $checkOutput = sqlplus -s / as sysdba "@$checkFile" 2>&1
                    if ($checkOutput -match "STATUS:HEALTHY") { $healthStatus = "HEALTHY" }
                } catch {}

                if ($healthStatus -eq "HEALTHY") {
                     Write-Host "  ╔══════════════════════════════════════════════════════════╗" -ForegroundColor Red
                     Write-Host "  ║  ⛔ ALERTA: LA BASE DE DATOS ESTA SANA (ONLINE)          ║" -ForegroundColor Yellow
                     Write-Host "  ║  Realizar un Point-in-Time Recovery hara que pierda      ║" -ForegroundColor Yellow
                     Write-Host "  ║  todos los datos generados despues de la fecha elegida.  ║" -ForegroundColor Yellow
                     Write-Host "  ╚══════════════════════════════════════════════════════════╝" -ForegroundColor Red
                     Write-Host ""
                     $hardConfirm = Read-Host "  Para ignorar y continuar, escriba 'PERDER DATOS'"
                     if ($hardConfirm -ne "PERDER DATOS") {
                         Write-Host "  ✓ Cancelado." -ForegroundColor Green
                         Pause-Script
                         continue
                     }
                }
                # --- HEALTH CHECK END ---
                Write-Host ""
                Write-Host "    1. Abrir el archivo:" -ForegroundColor White
                Write-Host "       recuperacion\recuperar_punto_tiempo.rman" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "    2. Editar la LINEA 19 con la fecha/hora deseada:" -ForegroundColor White
                Write-Host "       SET UNTIL TIME `'TO_DATE('YYYY-MM-DD HH24:MI:SS', ...)`'" -ForegroundColor Gray
                Write-Host ""
                Write-Host "    3. Guardar el archivo" -ForegroundColor White
                Write-Host ""
                Write-Host "    Comando:" -ForegroundColor Gray
                Write-Host "    rman TARGET / @recuperacion\recuperar_punto_tiempo.rman" -ForegroundColor Yellow
                Write-Host ""
                
                $edited = Read-Host "  Ya edito el archivo con la fecha correcta? (S/N)"
                if ($edited -eq "S" -or $edited -eq "s") {
                    $confirm1 = Read-Host "  Esta SEGURO que desea ejecutar la recuperacion? (S/N)"
                    
                    if ($confirm1 -eq "S" -or $confirm1 -eq "s") {
                        Write-Host ""
                        Write-Host "  CONFIRMACION FINAL:" -ForegroundColor Red
                        $confirm2 = Read-Host "  Escriba 'RECUPERAR' para confirmar"
                        
                        if ($confirm2 -eq "RECUPERAR") {
                            $logFile = Get-LogFile -Prefix "RECUPERACION_PITR"
                            $cmdFile = Join-Path $PROJECT_PATH "scripts\recuperacion\recuperar_punto_tiempo.rman"
                            
                            Write-Host ""
                            Write-Host "  Ejecutando recuperacion point-in-time..." -ForegroundColor Red
                            Write-Host "  Log: $logFile" -ForegroundColor Cyan
                            Write-Host ""
                            
                            & rman TARGET / cmdfile="$cmdFile" log="$logFile"
                            
                            if (Test-Path $logFile) {
                                Write-Host ""
                                Write-Host "  ✓ Log guardado en: $logFile" -ForegroundColor Green
                                Write-Host ""
                                Write-Host "  IMPORTANTE: Ejecute la validacion post-recuperacion (opcion 3)" -ForegroundColor Yellow
                            }
                        } else {
                            Write-Host ""
                            Write-Host "  ✗ Operacion cancelada" -ForegroundColor Yellow
                        }
                    }
                } else {
                    Write-Host ""
                    Write-Host "  ✗ Operacion cancelada - Edite el archivo primero" -ForegroundColor Yellow
                }
                
                Pause-Script
            }
            "3" {
                Show-Banner
                Write-Host "  ╔═══════════════════════════════════════════╗" -ForegroundColor Cyan
                Write-Host "  ║      VALIDACION POST-RECUPERACION         ║" -ForegroundColor Cyan
                Write-Host "  ╚═══════════════════════════════════════════╝" -ForegroundColor Cyan
                Write-Host ""
                Write-Host "    Verifica:" -ForegroundColor White
                Write-Host "    - Estado de la base de datos" -ForegroundColor Gray
                Write-Host "    - Integridad de tablespaces" -ForegroundColor Gray
                Write-Host "    - Conteo de registros en tablas criticas" -ForegroundColor Gray
                Write-Host "    - Integridad referencial" -ForegroundColor Gray
                Write-Host "    - Objetos invalidos" -ForegroundColor Gray
                Write-Host ""
                Write-Host "    Comando:" -ForegroundColor Gray
                Write-Host "    sqlplus / as sysdba @recuperacion\validacion_post_recuperacion.sql" -ForegroundColor Yellow
                Write-Host ""
                Write-Host "    El script generara: post_recovery_validation.log" -ForegroundColor Cyan
                Write-Host ""
                
                $confirm = Read-Host "  Desea ejecutar ahora? (S/N)"
                if ($confirm -eq "S" -or $confirm -eq "s") {
                    Write-Host ""
                    Write-Host "  Ejecutando validacion..." -ForegroundColor Green
                    Write-Host ""
                    
                    $sqlFile = Join-Path $PROJECT_PATH "scripts\recuperacion\validacion_post_recuperacion.sql"
                    & sqlplus / as sysdba "@$sqlFile"
                    
                    Write-Host ""
                    Write-Host "  ✓ Validacion completada" -ForegroundColor Green
                    Write-Host "  ✓ Revisar archivo: post_recovery_validation.log" -ForegroundColor Cyan
                }
                
                Pause-Script
            }
            "0" {
                # Volver al menu principal
                return
            }
            "" {
                # Enter sin escribir nada - refrescar menu
                continue
            }
            default {
                Write-Host ""
                Write-Host "  ⚠ Opcion no valida. Intente de nuevo." -ForegroundColor Red
                Start-Sleep -Seconds 1
            }
        }
    } while ($recoveryOption -ne "0")
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
        "7" {
            # Invocar submenu de recuperacion
            Invoke-RecoveryMenu
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
