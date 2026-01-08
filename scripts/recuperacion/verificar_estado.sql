-- ========================================================================
-- SCRIPT: Verificacion de Estado Pre-Recuperacion (Health Check)
-- ========================================================================
-- Proposito: Determinar si la BD necesita realmente recuperacion
-- Salida: HEALTHY | NEEDS_RECOVERY | MOUNTED_OR_OTHER
-- ========================================================================

SET SERVEROUTPUT ON
SET FEEDBACK OFF
SET HEADING OFF
SET VERIFY OFF

SET PAGESIZE 0

DECLARE
  v_open_mode VARCHAR2(20);
  v_recover_files NUMBER;
  v_instance_status VARCHAR2(20);
BEGIN
  -- Verificar estado de la instancia
  SELECT status INTO v_instance_status FROM v$instance;
  
  -- Verificar modo de apertura
  SELECT open_mode INTO v_open_mode FROM v$database;
  
  -- Verificar archivos que necesitan recuperacion
  SELECT COUNT(*) INTO v_recover_files FROM v$recover_file;
  
  IF v_open_mode = 'READ WRITE' AND v_recover_files = 0 THEN
      DBMS_OUTPUT.PUT_LINE('STATUS:HEALTHY');
  ELSIF v_recover_files > 0 THEN
      DBMS_OUTPUT.PUT_LINE('STATUS:NEEDS_RECOVERY');
  ELSE
      DBMS_OUTPUT.PUT_LINE('STATUS:MOUNTED_OR_OTHER');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
      -- Si ocurre cualquier error SQL, asumimos que algo anda mal o no esta abierta
      DBMS_OUTPUT.PUT_LINE('STATUS:ERROR_OR_DOWN');
END;
/
EXIT;
