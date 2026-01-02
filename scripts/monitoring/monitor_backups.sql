-- ========================================================================
-- Monitoreo Diario de Backups
-- ========================================================================

SET LINESIZE 200
SET PAGESIZE 100

-- Últimos backups realizados
SELECT 
    TO_CHAR(start_time, 'YYYY-MM-DD HH24:MI') AS "Fecha/Hora",
    CASE 
        WHEN incremental_level = 0 THEN 'FULL (Level 0)'
        WHEN incremental_level = 1 THEN 'INCREMENTAL (Level 1)'
        ELSE 'OTRO'
    END AS "Tipo",
    status,
    ROUND(elapsed_seconds/60, 2) AS "Duración (min)",
    ROUND(output_bytes/1024/1024, 2) AS "Tamaño (MB)"
FROM v$backup_set_details
WHERE start_time > SYSDATE - 7
ORDER BY start_time DESC;

-- Espacio usado por backups
SELECT 
    ROUND(SUM(bytes)/1024/1024/1024, 2) AS "Total GB Backups"
FROM v$backup_piece;

-- Verificar si hubo fallos
SELECT 
    session_key,
    TO_CHAR(start_time, 'YYYY-MM-DD HH24:MI') AS "Inicio",
    status,
    input_type,
    output_device_type
FROM v$rman_backup_job_details
WHERE start_time > SYSDATE - 1
AND status != 'COMPLETED'
ORDER BY start_time DESC;
