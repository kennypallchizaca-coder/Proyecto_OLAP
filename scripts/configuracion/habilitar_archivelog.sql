-- ========================================================================
-- SCRIPT: Habilitar Modo ARCHIVELOG
-- ========================================================================
-- Proyecto: Plan de Recuperacion - Comisariato
-- Base de Datos: Oracle 21c - Proyecto_OLAP
-- Proposito: Activar ARCHIVELOG para respaldos en caliente (Hot Backup)
-- Autor: DBA Senior
-- Fecha: Diciembre 2025
-- ========================================================================

SET ECHO ON
SET SERVEROUTPUT ON
SPOOL enable_archivelog.log

-- ========================================================================
-- PASO 1: Verificar modo actual
-- ========================================================================
PROMPT ========================================
PROMPT VERIFICANDO MODO ACTUAL DE LA BASE DE DATOS
PROMPT ========================================

SELECT 
    name AS "Base de Datos",
    log_mode AS "Modo Actual",
    CASE 
        WHEN log_mode = 'NOARCHIVELOG' THEN 'REQUIERE CONFIGURACION'
        WHEN log_mode = 'ARCHIVELOG' THEN 'YA CONFIGURADO'
    END AS "Estado"
FROM v$database;

-- ========================================================================
-- PASO 2: Verificar ubicacion de Archive Logs
-- ========================================================================
PROMPT ========================================
PROMPT UBICACION DE ARCHIVE LOGS
PROMPT ========================================

SHOW PARAMETER db_recovery_file_dest;

-- ========================================================================
-- PASO 3: Configurar destino de Archive Logs
-- ========================================================================
PROMPT ========================================
PROMPT CONFIGURANDO DESTINO DE ARCHIVE LOGS
PROMPT ========================================

-- Crear directorio si no existe (Windows)
-- En Linux cambiar a: /u01/arch/ORCL/
HOST mkdir C:\oracle\arch 2>nul

-- Configurar parametros de archivado
ALTER SYSTEM SET log_archive_dest_1='LOCATION=C:\oracle\arch' SCOPE=BOTH;
ALTER SYSTEM SET log_archive_format='COMISARIATO_arch_%t_%s_%r.arc' SCOPE=SPFILE;

-- ========================================================================
-- PASO 4: Activar modo ARCHIVELOG
-- ========================================================================
PROMPT ========================================
PROMPT ACTIVANDO MODO ARCHIVELOG
PROMPT ========================================
PROMPT ATENCION: Se requiere reiniciar la base de datos
PROMPT Esta es la UNICA vez que se detiene el servicio
PROMPT Despues de esto, todos los backups seran EN CALIENTE
PROMPT ========================================

-- Cerrar base de datos
SHUTDOWN IMMEDIATE;

-- Montar base de datos (sin abrir)
STARTUP MOUNT;

-- Activar ARCHIVELOG
ALTER DATABASE ARCHIVELOG;

-- Abrir base de datos para operaciones normales
ALTER DATABASE OPEN;

-- ========================================================================
-- PASO 5: Verificacion final
-- ========================================================================
PROMPT ========================================
PROMPT VERIFICACION FINAL
PROMPT ========================================

SELECT 
    name AS "Base de Datos",
    log_mode AS "Modo Actual",
    CASE 
        WHEN log_mode = 'ARCHIVELOG' THEN 'CONFIGURACION EXITOSA - BACKUPS EN CALIENTE HABILITADOS'
        ELSE 'ERROR - CONTACTAR A DBA SENIOR'
    END AS "Resultado"
FROM v$database;

-- Mostrar configuracion de archivado
SELECT dest_name, status, destination 
FROM v$archive_dest 
WHERE status = 'VALID';

PROMPT ========================================
PROMPT CONFIGURACION COMPLETADA
PROMPT A partir de ahora, la base de datos:
PROMPT [OK] Genera Archive Logs automaticamente
PROMPT [OK] Permite backups en caliente con RMAN
PROMPT [OK] Soporta recuperacion point-in-time
PROMPT [OK] Cumple con requisitos de Alta Disponibilidad
PROMPT ========================================

SPOOL OFF
EXIT;
