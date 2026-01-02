-- ========================================================================
-- Monitoreo de Archive Logs
-- ========================================================================

-- Verificar generacion de archive logs
SELECT 
    sequence#,
    first_time,
    next_time,
    archived,
    applied,
    deleted,
    name
FROM v$archived_log
WHERE first_time > SYSDATE - 1
ORDER BY first_time DESC;

-- Alertar si el destino esta llegando al 80% de capacidad
SELECT 
    name,
    space_limit/1024/1024 AS "Limite MB",
    space_used/1024/1024 AS "Usado MB",
    number_of_files AS "Qty Archivos",
    ROUND((space_used/space_limit)*100, 2) AS "% Uso"
FROM v$recovery_file_dest;
