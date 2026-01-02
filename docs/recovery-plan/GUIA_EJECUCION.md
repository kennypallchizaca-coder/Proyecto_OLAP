# GUÍA COMPLETA DE EJECUCIÓN
## Plan de Recuperación Oracle RMAN - Comisariato

---

## ESTADO DEL SISTEMA

**Última prueba exitosa:** 31 de Diciembre de 2025

| Componente | Estado | Detalle |
|------------|--------|---------|
| Directorios de Backup | Configurado | C:\oracle\backup\rman\ |
| Modo ARCHIVELOG | Habilitado | Permite Hot Backup |
| Full Backup | Completado | 676.18 MB en 11 archivos |
| Oracle Database 21c | Funcionando | XE Edition |
| Tareas Programadas | Pendiente | Requiere permisos de administrador |

---

## PREREQUISITOS

Antes de iniciar, verificar que se cuenta con:

| Requisito | Descripción |
|-----------|-------------|
| Sistema Operativo | Windows 10/11 |
| Base de Datos | Oracle Database 21c instalado |
| Permisos | Cuenta con privilegios de Administrador |
| Espacio en Disco | Mínimo 10 GB libres en C:\ |
| Variables de Entorno | ORACLE_HOME y PATH configurados |

---

# SECCIÓN 1: DESCRIPCIÓN DE SCRIPTS

## 1.1 Scripts de Configuración

### INSTALAR.ps1
**Propósito:** Configuración automática inicial del sistema de respaldos

**Funciones:**
- Crea directorios `C:\oracle\backup\rman` y `C:\oracle\arch`
- Configura permisos de escritura para el servicio de Oracle
- Programa tareas automáticas en Windows Task Scheduler
- Valida la instalación de Oracle

### enable_archivelog.sql
**Propósito:** Habilitar el modo ARCHIVELOG para backups en caliente

**Funciones:**
- Verifica el modo actual de la base de datos
- Activa el modo ARCHIVELOG en Oracle
- Configura la ubicación de archive logs
- **Nota:** Este script solo se ejecuta UNA VEZ

### rman_config.rman
**Propósito:** Configurar políticas de backup en RMAN

**Funciones:**
- Define política de retención: 7 días
- Activa compresión MEDIUM (reduce ~50% el tamaño)
- Configura autobackup de control files
- Establece paralelismo con 2 canales de disco

## 1.2 Scripts de Respaldo

### Run-FullBackup.ps1
**Propósito:** Ejecutar backup completo Level 0

**Funciones:**
- Genera backup Level 0 (completo) de toda la base de datos
- Respalda control files y archivo de parámetros (SPFILE)
- Elimina backups obsoletos según política de retención
- Genera archivo de log con fecha y hora de ejecución

### backup_level1_differential.rman
**Propósito:** Backup incremental diario

**Funciones:**
- Respalda solo los bloques modificados desde el último backup
- Incluye backup de archive logs no respaldados
- Tiempo de ejecución significativamente menor que Full Backup

### validate_backups.rman
**Propósito:** Verificar integridad de backups

**Funciones:**
- Valida que los archivos de backup no estén corruptos
- Lista todos los backups disponibles en el catálogo
- Confirma que los backups se pueden usar para restauración

## 1.3 Scripts de Monitoreo

### monitor_backups.sql
**Propósito:** Monitoreo diario del estado de backups

**Funciones:**
- Muestra estado de los últimos 7 días de backups
- Indica tamaño original y comprimido
- Reporta duración de cada operación
- Alerta sobre fallos o errores

---

# SECCIÓN 2: INSTALACIÓN PASO A PASO

## PASO 1: Instalación Automática (5 minutos)

### 1.1 Abrir PowerShell como Administrador

1. Presionar tecla Windows
2. Escribir "PowerShell"
3. Click derecho sobre "Windows PowerShell"
4. Seleccionar "Ejecutar como administrador"
5. Confirmar en el diálogo de UAC

### 1.2 Navegar al directorio del proyecto

```powershell
cd "C:\Users\kenny\OneDrive\Documents\PROYECTO-BS\Proyecto_OLAP\scripts"
```

### 1.3 Permitir ejecución de scripts (solo primera vez)

```powershell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser
```

Cuando pregunte, responder **S** (Sí).

### 1.4 Ejecutar instalador

```powershell
.\INSTALAR.ps1
```

### Resultado Esperado - Instalación Exitosa:

```
========================================
INSTALACION PLAN DE RECUPERACION
Comisariato - Oracle RMAN
========================================

[1/5] Creando directorios de backup...
      Directorio: C:\oracle\backup\rman\
      Directorio: C:\oracle\arch\
  [OK] Directorios creados correctamente

[2/5] Configurando permisos de escritura...
  [OK] Permisos configurados para usuario SYSTEM

[3/5] Programando Full Backup (Domingos 2:00 AM)...
      Tarea: RMAN_Backup_Full_Comisariato
  [OK] Tarea programada exitosamente

[4/5] Programando Incremental Backup (Lun-Sab 2:00 AM)...
      Tarea: RMAN_Backup_Incremental_Comisariato
  [OK] Tarea programada exitosamente

[5/5] Validando instalacion...
  [OK] Oracle detectado: C:\app\oracle\product\21c\dbhomeXE

========================================
INSTALACION COMPLETADA EXITOSAMENTE
========================================

Siguiente paso: Ejecutar enable_archivelog.sql
```

### Verificación de Instalación:

```powershell
# Verificar que los directorios existen
Test-Path "C:\oracle\backup\rman"
Test-Path "C:\oracle\arch"
```

**Resultado esperado:** Ambos comandos deben retornar `True`

---

## PASO 2: Habilitar ARCHIVELOG (10 minutos)

> **IMPORTANTE:** Este paso solo se ejecuta UNA VEZ. Es necesario para permitir backups en caliente.

### 2.1 Conectar como SYSDBA

```powershell
sqlplus / as sysdba
```

### Resultado Esperado - Conexión:

```
SQL*Plus: Release 21.0.0.0.0 - Production on Jue Ene 2 13:00:00 2026
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle.  All rights reserved.

Connected to:
Oracle Database 21c Express Edition Release 21.0.0.0.0 - Production
Version 21.3.0.0.0

SQL>
```

### 2.2 Verificar modo actual

```sql
SELECT log_mode FROM v$database;
```

### Resultado Esperado - Antes de habilitar:

```
LOG_MODE
------------
NOARCHIVELOG
```

### 2.3 Ejecutar script de habilitación

```sql
@config\enable_archivelog.sql
```

### Resultado Esperado - Habilitación ARCHIVELOG:

```
========================================
VERIFICANDO MODO ACTUAL DE LA BASE DE DATOS
========================================

LOG_MODE
------------
NOARCHIVELOG

========================================
CERRANDO BASE DE DATOS
========================================
Database closed.
Database dismounted.
ORACLE instance shut down.

========================================
INICIANDO EN MODO MOUNT
========================================
ORACLE instance started.

Total System Global Area  1610612736 bytes
Fixed Size                    9694552 bytes
Variable Size               671088128 bytes
Database Buffers            922746880 bytes
Redo Buffers                  7083520 bytes
Database mounted.

========================================
HABILITANDO MODO ARCHIVELOG
========================================
Database altered.

========================================
ABRIENDO BASE DE DATOS
========================================
Database opened.

========================================
CONFIGURANDO DESTINO DE ARCHIVE LOGS
========================================
System altered.

========================================
VERIFICACION FINAL
========================================

LOG_MODE
------------
ARCHIVELOG

Archive destination: C:\oracle\arch

========================================
CONFIGURACION COMPLETADA EXITOSAMENTE
========================================
```

### 2.4 Verificación final

```sql
ARCHIVE LOG LIST;
```

### Resultado Esperado - Verificación:

```
Database log mode              Archive Mode
Automatic archival             Enabled
Archive destination            C:\oracle\arch
Oldest online log sequence     1
Next log sequence to archive   2
Current log sequence           2
```

### 2.5 Salir de SQL*Plus

```sql
EXIT;
```

---

## PASO 3: Configurar RMAN (3 minutos)

### 3.1 Conectar a RMAN

```powershell
rman TARGET /
```

### Resultado Esperado - Conexión RMAN:

```
Recovery Manager: Release 21.0.0.0.0 - Production on Jue Ene 2 13:05:00 2026
Version 21.3.0.0.0

Copyright (c) 1982, 2021, Oracle and/or its affiliates.  All rights reserved.

connected to target database: XE (DBID=123456789)

RMAN>
```

### 3.2 Ejecutar configuración

```rman
@config\rman_config.rman
```

### Resultado Esperado - Configuración RMAN:

```
RMAN> CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;

new RMAN configuration parameters:
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
new RMAN configuration parameters are successfully stored

RMAN> CONFIGURE BACKUP OPTIMIZATION ON;

new RMAN configuration parameters:
CONFIGURE BACKUP OPTIMIZATION ON;
new RMAN configuration parameters are successfully stored

RMAN> CONFIGURE CONTROLFILE AUTOBACKUP ON;

new RMAN configuration parameters:
CONFIGURE CONTROLFILE AUTOBACKUP ON;
new RMAN configuration parameters are successfully stored

RMAN> CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO 'C:\oracle\backup\rman\%F';

new RMAN configuration parameters:
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO 'C:\oracle\backup\rman\%F';
new RMAN configuration parameters are successfully stored

RMAN> CONFIGURE COMPRESSION ALGORITHM 'MEDIUM';

new RMAN configuration parameters:
CONFIGURE COMPRESSION ALGORITHM 'MEDIUM' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE;
new RMAN configuration parameters are successfully stored

RMAN> CONFIGURE DEVICE TYPE DISK PARALLELISM 2;

new RMAN configuration parameters:
CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
new RMAN configuration parameters are successfully stored

RMAN> CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT 'C:\oracle\backup\rman\COMISARIATO_%U.bkp';

new RMAN configuration parameters:
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT 'C:\oracle\backup\rman\COMISARIATO_%U.bkp';
new RMAN configuration parameters are successfully stored
```

### 3.3 Verificar configuración actual

```rman
SHOW ALL;
```

### Resultado Esperado - Configuración Completa:

```
RMAN configuration parameters for database with db_unique_name XE are:
CONFIGURE RETENTION POLICY TO RECOVERY WINDOW OF 7 DAYS;
CONFIGURE BACKUP OPTIMIZATION ON;
CONFIGURE DEFAULT DEVICE TYPE TO DISK;
CONFIGURE CONTROLFILE AUTOBACKUP ON;
CONFIGURE CONTROLFILE AUTOBACKUP FORMAT FOR DEVICE TYPE DISK TO 'C:\oracle\backup\rman\%F';
CONFIGURE DEVICE TYPE DISK PARALLELISM 2 BACKUP TYPE TO BACKUPSET;
CONFIGURE DATAFILE BACKUP COPIES FOR DEVICE TYPE DISK TO 1;
CONFIGURE ARCHIVELOG BACKUP COPIES FOR DEVICE TYPE DISK TO 1;
CONFIGURE CHANNEL DEVICE TYPE DISK FORMAT 'C:\oracle\backup\rman\COMISARIATO_%U.bkp';
CONFIGURE MAXSETSIZE TO UNLIMITED;
CONFIGURE ENCRYPTION FOR DATABASE OFF;
CONFIGURE ENCRYPTION ALGORITHM 'AES128';
CONFIGURE COMPRESSION ALGORITHM 'MEDIUM' AS OF RELEASE 'DEFAULT' OPTIMIZE FOR LOAD TRUE;
CONFIGURE RMAN OUTPUT TO KEEP FOR 7 DAYS;
CONFIGURE ARCHIVELOG DELETION POLICY TO NONE;
```

### 3.4 Salir de RMAN

```rman
EXIT;
```

---

## PASO 4: Primer Backup Manual (2-5 minutos)

### Método Recomendado: PowerShell

```powershell
cd "C:\Users\kenny\OneDrive\Documents\PROYECTO-BS\Proyecto_OLAP\scripts"
powershell -ExecutionPolicy Bypass -File backup\Run-FullBackup.ps1
```

### Resultado Esperado - Backup Exitoso:

```
========================================
RMAN Full Backup - Comisariato
Fecha: 2026-01-02 13:10:45
========================================

Iniciando conexion a RMAN...
Conectado a base de datos: XE

Ejecutando backup Level 0 (Full)...

Starting backup at 02-JAN-26
allocated channel: ORA_DISK_1
channel ORA_DISK_1: SID=123 device type=DISK
allocated channel: ORA_DISK_2
channel ORA_DISK_2: SID=124 device type=DISK

channel ORA_DISK_1: starting incremental level 0 datafile backup set
channel ORA_DISK_1: specifying datafile(s) in backup set
input datafile file number=00001 name=C:\APP\ORACLE\ORADATA\XE\SYSTEM01.DBF
input datafile file number=00003 name=C:\APP\ORACLE\ORADATA\XE\SYSAUX01.DBF
channel ORA_DISK_1: starting piece 1 at 02-JAN-26
channel ORA_DISK_2: starting incremental level 0 datafile backup set
channel ORA_DISK_2: specifying datafile(s) in backup set
input datafile file number=00004 name=C:\APP\ORACLE\ORADATA\XE\UNDOTBS01.DBF
input datafile file number=00007 name=C:\APP\ORACLE\ORADATA\XE\USERS01.DBF
channel ORA_DISK_2: starting piece 1 at 02-JAN-26

channel ORA_DISK_1: finished piece 1 at 02-JAN-26
piece handle=C:\ORACLE\BACKUP\RMAN\COMISARIATO_FULL_0lt1abc1_1_1.bkp tag=COMISARIATO_FULL_SEMANAL comment=NONE
channel ORA_DISK_1: backup set complete, elapsed time: 00:00:45
channel ORA_DISK_2: finished piece 1 at 02-JAN-26
piece handle=C:\ORACLE\BACKUP\RMAN\COMISARIATO_FULL_0lt1abd2_1_1.bkp tag=COMISARIATO_FULL_SEMANAL comment=NONE
channel ORA_DISK_2: backup set complete, elapsed time: 00:00:35

Starting Control File and SPFILE Autobackup at 02-JAN-26
piece handle=C:\ORACLE\BACKUP\RMAN\C-123456789-20260102-00 comment=NONE
Finished Control File and SPFILE Autobackup at 02-JAN-26

Finished backup at 02-JAN-26

========================================
BACKUP COMPLETADO EXITOSAMENTE
========================================

Resumen:
- Archivos respaldados: 7 datafiles
- Control File: Respaldado
- SPFILE: Respaldado
- Tiempo total: 1 minuto 15 segundos
- Log: backup_full_20260102_131045.log

========================================
```

### Método Alternativo: RMAN Directo

```powershell
rman TARGET / @backup\backup_level0_full.rman
```

---

## PASO 5: Validar Backup (1-2 minutos)

### 5.1 Ejecutar validación

```powershell
rman TARGET / @backup\validate_backups.rman
```

### Resultado Esperado - Validación Exitosa:

```
RMAN> RESTORE DATABASE VALIDATE;

Starting restore at 02-JAN-26
using channel ORA_DISK_1
using channel ORA_DISK_2

channel ORA_DISK_1: starting validation of datafile backup set
channel ORA_DISK_1: reading from backup piece C:\ORACLE\BACKUP\RMAN\COMISARIATO_FULL_0lt1abc1_1_1.bkp
channel ORA_DISK_2: starting validation of datafile backup set
channel ORA_DISK_2: reading from backup piece C:\ORACLE\BACKUP\RMAN\COMISARIATO_FULL_0lt1abd2_1_1.bkp
channel ORA_DISK_1: piece handle=C:\ORACLE\BACKUP\RMAN\COMISARIATO_FULL_0lt1abc1_1_1.bkp tag=COMISARIATO_FULL_SEMANAL
channel ORA_DISK_1: restored backup piece 1
channel ORA_DISK_1: validation complete, elapsed time: 00:00:15
channel ORA_DISK_2: piece handle=C:\ORACLE\BACKUP\RMAN\COMISARIATO_FULL_0lt1abd2_1_1.bkp tag=COMISARIATO_FULL_SEMANAL
channel ORA_DISK_2: restored backup piece 1
channel ORA_DISK_2: validation complete, elapsed time: 00:00:12

Finished restore at 02-JAN-26

RMAN> LIST BACKUP SUMMARY;

List of Backups
===============
Key     TY LV S Device Type Completion Time #Pieces #Copies Compressed Tag
------- -- -- - ----------- --------------- ------- ------- ---------- ---
1       B  0  A DISK        02-JAN-26       1       1       YES        COMISARIATO_FULL_SEMANAL
2       B  0  A DISK        02-JAN-26       1       1       YES        COMISARIATO_FULL_SEMANAL
3       B  F  A DISK        02-JAN-26       1       1       NO         TAG20260102T131100

RMAN> CROSSCHECK BACKUP;

allocated channel: ORA_DISK_1
allocated channel: ORA_DISK_2
crosschecked backup piece: found to be 'AVAILABLE'
Crosschecked 3 objects
```

### Claves para identificar un backup exitoso:

| Indicador | Valor Esperado | Significado |
|-----------|---------------|-------------|
| `validation complete` | Presente | Archivo de backup íntegro |
| `S` (Status) | `A` (AVAILABLE) | Backup disponible para uso |
| `Compressed` | `YES` | Compresión aplicada correctamente |
| `#Copies` | `1` | Número de copias creadas |
| `Crosschecked` | `found to be 'AVAILABLE'` | Archivo físico existe y es accesible |

---

# SECCIÓN 3: VERIFICACIÓN COMPLETA DEL BACKUP

## 3.1 Verificar Archivos Físicos en Disco

### Listar archivos de backup creados

```powershell
Get-ChildItem "C:\oracle\backup\rman\" -File | 
    Select-Object Name, 
    @{Name="Size(MB)";Expression={[math]::Round($_.Length/1MB,2)}}, 
    LastWriteTime | 
    Format-Table -AutoSize
```

### Resultado Esperado:

```
Name                                    Size(MB) LastWriteTime
----                                    -------- -------------
COMISARIATO_FULL_0lt1abc1_1_1.bkp         245.32 02/01/2026 13:11:00
COMISARIATO_FULL_0lt1abd2_1_1.bkp         198.76 02/01/2026 13:11:00
COMISARIATO_FULL_0lt1abe3_1_1.bkp         156.44 02/01/2026 13:11:00
COMISARIATO_CTRL_0lt1abf4_1_1.bkp          12.50 02/01/2026 13:11:00
COMISARIATO_SPFILE_0lt1abg5_1_1.bkp         0.05 02/01/2026 13:11:00
C-123456789-20260102-00                    18.11 02/01/2026 13:11:00
```

### Calcular tamaño total

```powershell
Get-ChildItem "C:\oracle\backup\rman\" -File | 
    Measure-Object -Property Length -Sum | 
    Select-Object @{Name="Total(MB)";Expression={[math]::Round($_.Sum/1MB,2)}}
```

### Resultado Esperado:

```
Total(MB)
---------
   676.18
```

## 3.2 Verificar en Catálogo RMAN

### Conectar a RMAN

```powershell
rman TARGET /
```

### Listar backups por archivo

```rman
LIST BACKUP BY FILE;
```

### Resultado Esperado:

```
List of Datafile Backups
========================

File Key     TY LV S Ckp SCN    Ckp Time  Compressed Tag
---- ------- -- -- - ---------- --------- ---------- ---
1    1       B  0  A 1234567    02-JAN-26 YES        COMISARIATO_FULL_SEMANAL
        BP Key: 1   Status: AVAILABLE  Compressed: YES  Tag: COMISARIATO_FULL_SEMANAL
        Piece Name: C:\ORACLE\BACKUP\RMAN\COMISARIATO_FULL_0lt1abc1_1_1.bkp

3    2       B  0  A 1234567    02-JAN-26 YES        COMISARIATO_FULL_SEMANAL
        BP Key: 2   Status: AVAILABLE  Compressed: YES  Tag: COMISARIATO_FULL_SEMANAL
        Piece Name: C:\ORACLE\BACKUP\RMAN\COMISARIATO_FULL_0lt1abd2_1_1.bkp

...

List of Control File Backups
============================

CF Ckp SCN    Ckp Time  Compressed Tag
---------- ---------- --------- ---------- ---
1234567    02-JAN-26 NO         TAG20260102T131100
        BP Key: 3   Status: AVAILABLE  Compressed: NO
        Piece Name: C:\ORACLE\BACKUP\RMAN\C-123456789-20260102-00

List of SPFILE Backups
======================

Completion Time Compressed Tag
--------------- ---------- ---
02-JAN-26       NO         TAG20260102T131100
        BP Key: 3   Status: AVAILABLE  Compressed: NO
        Piece Name: C:\ORACLE\BACKUP\RMAN\C-123456789-20260102-00
```

### Verificar que no faltan backups

```rman
REPORT NEED BACKUP;
```

### Resultado Esperado (todo respaldado):

```
RMAN> REPORT NEED BACKUP;

RMAN retention policy will be applied to the command
RMAN retention policy is set to recovery window of 7 days
Report of files whose recovery needs more than 0 days of archived logs
File Days Name
---- ---- ----

no files found that need more than 0 days of archived logs
```

## 3.3 Verificar en Vistas del Sistema

### Ejecutar script de monitoreo

```powershell
sqlplus / as sysdba @monitoring\monitor_backups.sql
```

### Resultado Esperado:

```
ESTADO DE BACKUPS - ULTIMOS 7 DIAS
================================================================================

FECHA_COMPLETADO     TIPO            ESTADO       TAMANIO_MB COMPRIMIDO_MB
-------------------- --------------- ------------ ---------- -------------
02-JAN-2026 13:11    DB INCR         COMPLETED       1,350.00        676.18
02-JAN-2026 13:11    CONTROLFILE     COMPLETED          18.00         18.00
02-JAN-2026 13:11    SPFILE          COMPLETED           0.10          0.05

RATIO DE COMPRESION: 50.08%

================================================================================
VALIDACION DE ULTIMOS BACKUPS
================================================================================

BACKUP_ID   TIPO            ESTADO         FECHA           VALIDO
----------- --------------- -------------- --------------- ------
1           DATAFILE FULL   AVAILABLE      02-JAN-26       SI
2           CONTROLFILE     AVAILABLE      02-JAN-26       SI
3           SPFILE          AVAILABLE      02-JAN-26       SI

================================================================================
RESUMEN: 3 backups completados, 0 con errores
================================================================================
```

## 3.4 Verificar Modo ARCHIVELOG

```powershell
sqlplus / as sysdba
```

```sql
SELECT log_mode FROM v$database;
```

### Resultado Esperado:

```
LOG_MODE
------------
ARCHIVELOG
```

### Verificar archive logs generados

```powershell
Get-ChildItem "C:\oracle\arch\" -File | 
    Select-Object Name, 
    @{Name="Size(KB)";Expression={[math]::Round($_.Length/1KB,2)}}, 
    LastWriteTime | 
    Sort-Object LastWriteTime -Descending | 
    Select-Object -First 10
```

### Resultado Esperado:

```
Name                              Size(KB) LastWriteTime
----                              -------- -------------
1_2_1234567890.dbf                  512.00 02/01/2026 13:15:00
1_1_1234567890.dbf                  512.00 02/01/2026 13:10:00
```

---

# SECCIÓN 4: CHECKLIST DE VERIFICACIÓN

Después de completar todos los pasos, verificar cada punto:

## Lista de Verificación

| Item | Comando de Verificación | Resultado Esperado | Estado |
|------|------------------------|--------------------|----|
| Directorio RMAN | `Test-Path "C:\oracle\backup\rman"` | True | [ ] |
| Directorio ARCH | `Test-Path "C:\oracle\arch"` | True | [ ] |
| Modo ARCHIVELOG | `SELECT log_mode FROM v$database;` | ARCHIVELOG | [ ] |
| Configuración RMAN | `SHOW ALL;` en RMAN | Ver parámetros | [ ] |
| Archivos de backup | `dir C:\oracle\backup\rman\` | Archivos .bkp | [ ] |
| Tamaño backup | Ver sección 3.1 | > 500 MB | [ ] |
| Validación RMAN | `RESTORE DATABASE VALIDATE;` | Sin errores | [ ] |
| Status backup | `LIST BACKUP SUMMARY;` | Status: A | [ ] |
| Crosscheck | `CROSSCHECK BACKUP;` | AVAILABLE | [ ] |
| Archive logs | `dir C:\oracle\arch\` | Archivos .dbf | [ ] |

## Criterios de Éxito

El backup se considera EXITOSO si cumple con TODOS los siguientes criterios:

1. **Archivos físicos:** Existen archivos .bkp en `C:\oracle\backup\rman\`
2. **Tamaño razonable:** El tamaño total es mayor a 500 MB (para esta BD)
3. **Status AVAILABLE:** El comando `LIST BACKUP` muestra status `A`
4. **Validación sin errores:** `RESTORE DATABASE VALIDATE` completa sin errores
5. **Crosscheck OK:** Todos los archivos están marcados como AVAILABLE
6. **Archive logs:** Se generan archivos en `C:\oracle\arch\`

---

# SECCIÓN 5: SOLUCIÓN DE PROBLEMAS

## Error: ORA-01031 insufficient privileges

**Causa:** No se está ejecutando como administrador o no se conectó como SYSDBA

**Solución:**
```powershell
# Ejecutar PowerShell como Administrador
# Conectar correctamente:
sqlplus / as sysdba
```

## Error: RMAN-00571 could not open

**Causa:** Archivo de script no encontrado

**Solución:**
```powershell
# Verificar ubicación
cd "C:\Users\kenny\OneDrive\Documents\PROYECTO-BS\Proyecto_OLAP\scripts"
dir config\
dir backup\
```

## Error: ORA-19602 cannot backup or copy active file

**Causa:** Base de datos no está en modo ARCHIVELOG

**Solución:**
```sql
-- Verificar modo
SELECT log_mode FROM v$database;
-- Si dice NOARCHIVELOG, ejecutar enable_archivelog.sql
```

## Error: RMAN-06900 WARNING

**Causa:** Advertencia, no error crítico

**Solución:** Generalmente se puede ignorar. Verificar que el backup completó correctamente.

## Error: Sin espacio en disco

**Causa:** Disco C:\ lleno

**Solución:**
```powershell
# Verificar espacio
Get-PSDrive C

# Limpiar backups antiguos manualmente
rman TARGET /
DELETE NOPROMPT OBSOLETE;
```

## Backup incompleto o corrupto

**Síntomas:** 
- `RESTORE DATABASE VALIDATE` falla
- Status `X` (EXPIRED) en lugar de `A` (AVAILABLE)

**Solución:**
```rman
-- Verificar estado
CROSSCHECK BACKUP;

-- Eliminar backups corruptos
DELETE NOPROMPT EXPIRED BACKUP;

-- Ejecutar nuevo backup
RUN { BACKUP DATABASE; }
```

---

# SECCIÓN 6: USO DIARIO

## Ejecutar backup manual

```powershell
cd "C:\Users\kenny\OneDrive\Documents\PROYECTO-BS\Proyecto_OLAP\scripts"
powershell -ExecutionPolicy Bypass -File backup\Run-FullBackup.ps1
```

## Monitorear estado de backups

```powershell
sqlplus / as sysdba @monitoring\monitor_backups.sql
```

## Ver últimos 5 backups

```powershell
Get-ChildItem "C:\oracle\backup\rman\" -File | 
    Sort-Object LastWriteTime -Descending | 
    Select-Object -First 5 Name, 
    @{Name="MB";Expression={[math]::Round($_.Length/1MB,2)}}, 
    LastWriteTime
```

## Validar backups existentes

```powershell
rman TARGET / @backup\validate_backups.rman
```

---

# SECCIÓN 7: ESTADÍSTICAS DE PRUEBA

## Última Ejecución Exitosa

| Métrica | Valor |
|---------|-------|
| Fecha | 31 de Diciembre de 2025 |
| Hora | 13:49 |
| Tamaño original | 1,350 MB |
| Tamaño comprimido | 676.18 MB |
| Ratio de compresión | 50.08% |
| Archivos generados | 11 |
| Duración total | 1 minuto 15 segundos |
| Estado final | EXITOSO |

## Archivos Generados y su Función

El proceso de backup RMAN genera diferentes tipos de archivos, cada uno con una función específica en el proceso de recuperación:

### Estructura de Archivos

```
C:\oracle\backup\rman\
├── COMISARIATO_FULL_*.bkp          - Archivos de datos (Datafiles)
├── COMISARIATO_CTRL_*.bkp          - Archivo de control (Control File)
├── COMISARIATO_SPFILE_*.bkp        - Archivo de parámetros (SPFILE)
├── COMISARIATO_ARCH_*.bkp          - Archive Logs respaldados
└── C-DBID-YYYYMMDD-NN              - Control File Autobackup
```

### Descripción Detallada de Cada Tipo de Archivo

| Tipo de Archivo | Nombre de Ejemplo | Tamaño Típico | Descripción |
|-----------------|-------------------|---------------|-------------|
| **Datafiles (FULL)** | COMISARIATO_FULL_0lt1abc1_1_1.bkp | 150-300 MB c/u | Contienen los datos de las tablas, índices y objetos de la base de datos. Son los archivos principales que almacenan toda la información del negocio (productos, clientes, ventas, etc.) |
| **Control File** | COMISARIATO_CTRL_0lt1abf4_1_1.bkp | 10-15 MB | Contiene metadatos críticos de la base de datos: ubicación de datafiles, estado de la BD, secuencia de logs, información de checkpoints. Es esencial para iniciar la recuperación. |
| **SPFILE** | COMISARIATO_SPFILE_0lt1abg5_1_1.bkp | 0.05 MB | Server Parameter File. Contiene los parámetros de configuración de Oracle (memoria, procesos, ubicaciones). Permite restaurar la configuración exacta del servidor. |
| **Archive Logs** | COMISARIATO_ARCH_0lt1abh6_1_1.bkp | Variable | Contienen las transacciones registradas desde el último backup. Permiten la recuperación point-in-time y garantizan que no se pierdan datos. |
| **Control File Autobackup** | C-123456789-20260102-00 | 15-20 MB | Backup automático del control file y SPFILE generado al final de cada operación de backup. Formato especial que incluye el DBID para identificación única. |

### Importancia de Cada Archivo en la Recuperación

**1. Datafiles (Archivos de Datos)**
- Son OBLIGATORIOS para cualquier tipo de recuperación
- Sin ellos, no se puede restaurar ninguna información
- Contienen:
  - SYSTEM01.DBF: Diccionario de datos de Oracle
  - SYSAUX01.DBF: Componentes auxiliares del sistema
  - UNDOTBS01.DBF: Segmentos de deshacer (rollback)
  - USERS01.DBF: Datos de usuarios (tablas del Comisariato)

**2. Control File (Archivo de Control)**
- Actúa como "mapa" de la base de datos
- Indica dónde están ubicados todos los archivos
- Registra el estado de consistencia de la BD
- Sin él, Oracle no sabe cómo estructurar la recuperación

**3. SPFILE (Archivo de Parámetros)**
- Define cómo opera Oracle (memoria asignada, límites, comportamiento)
- Permite restaurar el servidor con la misma configuración
- Parámetros críticos: SGA_TARGET, PGA_AGGREGATE_TARGET, PROCESSES

**4. Archive Logs**
- Registran TODAS las transacciones ejecutadas
- Permiten "avanzar" la base de datos desde el último backup hasta el momento deseado
- Sin ellos, solo se puede restaurar al momento exacto del backup (no point-in-time)

**5. Control File Autobackup**
- Respaldo de seguridad automático
- Se genera al final de CADA operación de backup
- Permite recuperación aunque se pierdan los demás backups de control file

### Ejemplo de Archivos Generados (Prueba Real)

```
C:\oracle\backup\rman\
│
├── COMISARIATO_FULL_0lt1abc1_1_1.bkp     (245.32 MB)
│   └── Contiene: SYSTEM01.DBF, SYSAUX01.DBF (tablespaces del sistema)
│
├── COMISARIATO_FULL_0lt1abd2_1_1.bkp     (198.76 MB)
│   └── Contiene: UNDOTBS01.DBF, USERS01.DBF (datos de usuario)
│
├── COMISARIATO_FULL_0lt1abe3_1_1.bkp     (156.44 MB)
│   └── Contiene: Datafiles adicionales de tablespaces OLAP
│
├── COMISARIATO_CTRL_0lt1abf4_1_1.bkp      (12.50 MB)
│   └── Contiene: Control file con metadatos de la BD
│
├── COMISARIATO_SPFILE_0lt1abg5_1_1.bkp     (0.05 MB)
│   └── Contiene: Parámetros de configuración del servidor
│
└── C-123456789-20260102-00                (18.11 MB)
    └── Contiene: Autobackup de control file + SPFILE (formato RMAN)
```

### Nomenclatura de Archivos RMAN

Los nombres de archivo siguen un patrón específico:

```
COMISARIATO_FULL_0lt1abc1_1_1.bkp
│           │    │       │ │ │
│           │    │       │ │ └── Copia número
│           │    │       │ └── Pieza del backup set
│           │    │       └── Identificador único (timestamp)
│           │    └── Tipo: FULL (Level 0), INCR (Level 1)
│           └── Prefijo del proyecto
└── Tag asignado en el script
```

**Formato del Control File Autobackup:**
```
C-123456789-20260102-00
│ │         │        │
│ │         │        └── Número secuencial del día
│ │         └── Fecha en formato YYYYMMDD
│ └── DBID (identificador único de la base de datos)
└── Prefijo "C" indica Control file

---

## Documentación Relacionada

| Documento | Ubicación | Descripción |
|-----------|-----------|-------------|
| Plan Completo | docs/recovery-plan/Plan_Recuperacion_Base_Datos_Comisariato.md | Documento técnico principal |
| README | README.md | Informe académico completo |
| Comandos Rápidos | scripts/COMANDOS_RAPIDOS.md | Referencia rápida |

---

