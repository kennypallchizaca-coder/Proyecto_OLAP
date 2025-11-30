# ============================================================================
# PROYECTO OLAP - Script de Automatizacion
# ============================================================================
# Descripcion: Ejecuta todo el pipeline OLTP -> OLAP -> ETL -> Verificacion
# Requisitos: sqlcmd en PATH, credenciales con permisos de creacion
# Fecha: Noviembre 2025
# ============================================================================

# ============================================================================
# CONFIGURACION - Editar estas variables antes de ejecutar
# ============================================================================
$server = "[tu-servidor].database.windows.net"
$database = "[nombre-base-datos]"
$user = "[usuario-admin]"
$password = "[contraseña]"

# ============================================================================
# NO MODIFICAR A PARTIR DE AQUI
# ============================================================================

# Directorio base del proyecto
$baseDir = Split-Path -Parent $PSScriptRoot

# Funcion para ejecutar archivos SQL
function Run-SqlFile {
    param(
        [string]$Path,
        [string]$Description
    )
    $fullPath = Join-Path $baseDir $Path
    
    if (-not (Test-Path $fullPath)) {
        Write-Host "ERROR: No se encontro el archivo $Path" -ForegroundColor Red
        return $false
    }
    
    Write-Host ""
    Write-Host ">> Ejecutando: $Description" -ForegroundColor Cyan
    Write-Host "   Archivo: $Path" -ForegroundColor Gray
    
    & sqlcmd -S $server -d $database -U $user -P $password -b -i $fullPath
    
    if ($LASTEXITCODE -ne 0) { 
        Write-Host "   FALLO en $Path" -ForegroundColor Red
        return $false
    }
    
    Write-Host "   COMPLETADO" -ForegroundColor Green
    return $true
}

# ============================================================================
# INICIO DEL PIPELINE
# ============================================================================

Clear-Host
Write-Host "============================================================================" -ForegroundColor Yellow
Write-Host "PROYECTO OLAP - PIPELINE DE EJECUCION" -ForegroundColor Yellow
Write-Host "============================================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "Servidor: $server"
Write-Host "Base de Datos: $database"
Write-Host "Usuario: $user"
Write-Host ""
Write-Host "============================================================================" -ForegroundColor Yellow

$inicio = Get-Date
$errores = @()

# [1] Esquema OLTP
if (-not (Run-SqlFile "sql/oltp/Tablas.sql" "[1/7] Creando esquema OLTP")) {
    $errores += "Tablas.sql"
}

# [2] Datos OLTP (100k pedidos) - Este paso toma varios minutos
Write-Host ""
Write-Host "   NOTA: La carga de datos puede tardar varios minutos..." -ForegroundColor Yellow
if (-not (Run-SqlFile "sql/oltp/Datos_Tablas.sql" "[2/7] Cargando datos de prueba (100k pedidos)")) {
    $errores += "Datos_Tablas.sql"
}

# [3] Esquema OLAP (modelo estrella)
if (-not (Run-SqlFile "sql/olap/TablaDatosDim.sql" "[3/7] Creando esquema OLAP (modelo estrella)")) {
    $errores += "TablaDatosDim.sql"
}

# [4] ETL
Write-Host ""
Write-Host "   NOTA: El ETL puede tardar varios minutos..." -ForegroundColor Yellow
if (-not (Run-SqlFile "sql/olap/ETL.sql" "[4/7] Ejecutando proceso ETL")) {
    $errores += "ETL.sql"
}

# [5] Vistas para Power BI
if (-not (Run-SqlFile "sql/olap/VistasOLAP_PowerBI.sql" "[5/7] Creando vistas para Power BI")) {
    $errores += "VistasOLAP_PowerBI.sql"
}

# [6] Usuario OLAP (solo lectura)
if (-not (Run-SqlFile "sql/olap/UsuarioOLAP.sql" "[6/7] Creando usuario de solo lectura")) {
    $errores += "UsuarioOLAP.sql"
}

# [7] Verificaciones
if (-not (Run-SqlFile "sql/olap/VerificacionDatos.sql" "[7/7] Ejecutando verificaciones")) {
    $errores += "VerificacionDatos.sql"
}

# ============================================================================
# RESUMEN FINAL
# ============================================================================

$fin = Get-Date
$duracion = $fin - $inicio

Write-Host ""
Write-Host "============================================================================" -ForegroundColor Yellow

if ($errores.Count -eq 0) {
    Write-Host "PIPELINE COMPLETADO EXITOSAMENTE" -ForegroundColor Green
    Write-Host "============================================================================" -ForegroundColor Green
} else {
    Write-Host "PIPELINE COMPLETADO CON ERRORES" -ForegroundColor Red
    Write-Host "============================================================================" -ForegroundColor Red
    Write-Host ""
    Write-Host "Archivos con errores:" -ForegroundColor Red
    foreach ($err in $errores) {
        Write-Host "  - $err" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Tiempo total: $($duracion.ToString('hh\:mm\:ss'))" -ForegroundColor Cyan
Write-Host ""
Write-Host "============================================================================" -ForegroundColor Yellow
Write-Host "SIGUIENTES PASOS" -ForegroundColor Yellow
Write-Host "============================================================================" -ForegroundColor Yellow
Write-Host ""
Write-Host "1. Abrir Power BI Desktop" -ForegroundColor White
Write-Host "2. Obtener datos -> Azure SQL Database" -ForegroundColor White
Write-Host "3. Conectar con usuario: usuario_olap" -ForegroundColor White
Write-Host "4. Importar las vistas vw_OLAP_* y vw_Dashboard_*" -ForegroundColor White
Write-Host "5. Crear dashboards para los 3 hechos OLAP" -ForegroundColor White
Write-Host ""
Write-Host "Ver guia completa en: docs/PowerBI_Conexion.md" -ForegroundColor Cyan
Write-Host ""
