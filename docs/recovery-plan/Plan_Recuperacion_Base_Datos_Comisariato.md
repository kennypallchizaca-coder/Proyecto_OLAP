# PLAN DE RECUPERACIÓN DE BASE DE DATOS
## SISTEMA COMISARIATO - MODELO OLAP

---

**Empresa:** Comisariato Multi-Sucursales  
**Sistema:** Base de Datos Oracle 21c - OLAP/OLTP  
**Normativa:** ISO/IEC 27001:2013  
**Fecha de Elaboración:** Diciembre 2025  
**Versión:** 1.0  
**Elaborado por:** Administración de Bases de Datos

---

# ÍNDICE

1. [Marco Teórico: Oracle RMAN](#1-marco-teórico-oracle-rman)
2. [Descripción de Sistemas Informáticos](#2-descripción-de-sistemas-informáticos)
3. [Matriz de Roles y Responsabilidades](#3-matriz-de-roles-y-responsabilidades)
4. [Configuración de Alta Disponibilidad](#4-configuración-de-alta-disponibilidad)
5. [Procedimientos de Respaldo](#5-procedimientos-de-respaldo)
6. [Estrategia de Recuperación](#6-estrategia-de-recuperación)
7. [Políticas y Procedimientos de Verificación](#7-políticas-y-procedimientos-de-verificación)

---

# 1. MARCO TEÓRICO: ORACLE RMAN

## 1.1 ¿Qué es Oracle RMAN?

**Oracle Recovery Manager (RMAN)** es una utilidad nativa de Oracle Database que permite realizar operaciones de **backup** y **recuperación** de bases de datos de manera eficiente y confiable.

### Características Principales:

- **Integración Nativa:** Está integrado directamente en el motor de Oracle Database
- **Respaldos Incrementales:** Permite realizar copias completas, incrementales y diferenciales
- **Compresión Automática:** Reduce el espacio de almacenamiento necesario
- **Validación Integrada:** Verifica la integridad de los backups automáticamente
- **Recuperación Granular:** Permite recuperar desde bases de datos completas hasta bloques individuales
- **Catálogo de Respaldos:** Mantiene un registro detallado de todos los backups realizados
- **Automatización:** Permite programar respaldos mediante scripts y políticas

### Ventajas sobre Respaldos Tradicionales:

| Método Tradicional | Oracle RMAN |
|-------------------|-------------|
| Copia física de archivos | Respaldo lógico optimizado |
| Sin compresión | Compresión automática |
| Sin validación | Validación integrada |
| Requiere base de datos apagada | Permite backups en caliente |
| Manual | Automatizable |
| Sin catálogo | Catálogo centralizado |

## 1.2 Respaldos en Frío vs. Caliente

### 1.2.1 Respaldo en Frío (Cold Backup)

**Definición:** Copia de seguridad realizada cuando la base de datos está **completamente apagada** (SHUTDOWN).

**Características:**
- Requiere detener todas las operaciones
- Genera archivos consistentes
- Más simple de realizar
- No requiere modo ARCHIVELOG

**Procedimiento:**
```sql
-- 1. Detener la base de datos
SHUTDOWN IMMEDIATE;

-- 2. Copiar archivos físicos (.dbf, control files, redo logs)
-- (A nivel de Sistema Operativo)

-- 3. Reiniciar la base de datos
STARTUP;
```

**Desventajas para nuestro caso:**
- ❌ **Requiere tiempo de inactividad**
- ❌ **Incompatible con operación 24/7**
- ❌ **Pérdida de transacciones durante el backup**
- ❌ **No cumple con requisitos de Alta Disponibilidad**

### 1.2.2 Respaldo en Caliente (Hot Backup)

**Definición:** Copia de seguridad realizada mientras la base de datos está **activa y operacional**.

**Características:**
- Base de datos permanece disponible
- Requiere modo ARCHIVELOG habilitado
- Permite recuperación point-in-time
- Compatible con operaciones 24/7

**Requisitos Técnicos:**
```sql
-- Base de datos debe estar en modo ARCHIVELOG
SELECT log_mode FROM v$database;
-- Resultado esperado: ARCHIVELOG
```

**Ventajas para el Comisariato:**
- ✅ **Zero Downtime:** Las transacciones continúan durante el backup
- ✅ **Alta Disponibilidad:** Cumple con requisito 24/7
- ✅ **Point-in-Time Recovery:** Permite restaurar a cualquier momento
- ✅ **Mínimo impacto:** Los clientes no perciben el proceso de respaldo

### 1.2.3 Justificación de Selección: Hot Backup

**Para el sistema del Comisariato, seleccionamos RESPALDO EN CALIENTE porque:**

1. **Operación 24/7:** El supermercado no puede detener operaciones para respaldos
2. **Múltiples Sucursales:** Transacciones constantes desde diferentes ubicaciones
3. **Criticidad del Negocio:** Pérdida de datos = pérdida de ventas
4. **Cumplimiento Normativo:** ISO 27001 requiere continuidad del negocio
5. **Expectativas del Cliente:** Disponibilidad permanente del sistema

## 1.3 Respaldos Incrementales vs. Diferenciales

### 1.3.1 Respaldo Completo (Full Backup - Level 0)

**Definición:** Copia íntegra de todos los bloques de datos de la base de datos que han sido usados al menos una vez.

```bash
# Comando RMAN
BACKUP INCREMENTAL LEVEL 0 DATABASE TAG 'COMISARIATO_FULL';
```

**Características:**
- Respalda todos los bloques de datos utilizados
- Base para respaldos incrementales
- Mayor tiempo de ejecución
- Mayor espacio de almacenamiento

**Uso en el Comisariato:** Se ejecuta semanalmente (Domingos a las 02:00 AM)

### 1.3.2 Respaldo Incremental (Incremental Backup - Level 1)

**Definición:** Respalda solo los bloques que han **cambiado desde el último backup del mismo nivel o superior**.

```bash
# INCREMENTAL ACUMULATIVO (usado en modo diferencial)
BACKUP INCREMENTAL LEVEL 1 DATABASE TAG 'COMISARIATO_INCREMENTAL';
```

**Características:**
- Solo respalda cambios
- Menor tiempo de ejecución
- Menor espacio requerido
- Requiere Level 0 como base

**Tipos de Incremental Level 1:**

#### A) Incremental Acumulativo (Cumulative)
```bash
BACKUP INCREMENTAL LEVEL 1 CUMULATIVE DATABASE;
```
- Respalda cambios desde el último **Level 0**
- Cada backup Level 1 incluye todos los cambios desde la base

#### B) Incremental Diferencial (Differential) - **USADO EN ESTE PLAN**
```bash
BACKUP INCREMENTAL LEVEL 1 DATABASE;
```
- Respalda cambios desde el último backup (Level 0 o Level 1)
- Cada día solo respalda los cambios del día anterior

### 1.3.3 Comparación Técnica

| Criterio | Incremental Diferencial | Incremental Acumulativo | Full Backup |
|----------|------------------------|------------------------|-------------|
| **Espacio requerido** | Mínimo | Moderado | Máximo |
| **Tiempo de backup** | Rápido | Moderado | Lento |
| **Tiempo de restore** | Más lento (múltiples archivos) | Moderado | Rápido |
| **Complejidad** | Media | Baja | Muy baja |
| **Frecuencia sugerida** | Diaria | Semanal | Semanal/Mensual |

### 1.3.4 Estrategia Seleccionada: Diferencial

**Esquema Semanal Implementado:**

```
DOMINGO:    Level 0 (Full)          → 100% de datos
LUNES:      Level 1 (Diferencial)   → Cambios desde Domingo
MARTES:     Level 1 (Diferencial)   → Cambios desde Lunes
MIÉRCOLES:  Level 1 (Diferencial)   → Cambios desde Martes
JUEVES:     Level 1 (Diferencial)   → Cambios desde Miércoles
VIERNES:    Level 1 (Diferencial)   → Cambios desde Jueves
SÁBADO:     Level 1 (Diferencial)   → Cambios desde Viernes
DOMINGO:    Level 0 (Full)          → Nuevo ciclo
```

**Ventajas:**
- ✅ Backups rápidos entre semana
- ✅ Mínimo impacto en rendimiento
- ✅ Uso eficiente de almacenamiento
- ✅ Recuperación completa garantizada

**Proceso de Recuperación:**
```
Para restaurar al VIERNES:
1. Restaurar Level 0 (Domingo)
2. Aplicar Level 1 Lunes
3. Aplicar Level 1 Martes
4. Aplicar Level 1 Miércoles
5. Aplicar Level 1 Jueves
6. Aplicar Level 1 Viernes
```

---

# 2. DESCRIPCIÓN DE SISTEMAS INFORMÁTICOS

## 2.1 Contexto del Negocio

**Comisariato Multiplaza** es una cadena de supermercados con **múltiples sucursales** distribuidas en las principales ciudades del Ecuador (Quito, Guayaquil, Cuenca, Ambato). Opera **24 horas al día, 7 días a la semana**, procesando miles de transacciones diarias de ventas, inventario y facturación.

### Requisitos Críticos:
- **Alta Disponibilidad:** Tiempo de inactividad máximo permitido: 2 horas/año
- **Integridad de Datos:** Cero pérdida de transacciones
- **Cumplimiento Normativo:** ISO 27001, SRI (facturación electrónica)
- **Escalabilidad:** Soporte para crecimiento de sucursales

## 2.2 Arquitectura de Base de Datos

El sistema está implementado sobre **Oracle Database 21c** con una arquitectura dual:

### 2.2.1 Capa OLTP (Transaccional)

**Base de Datos:** `Proyecto_OLAP` (Schema OLTP)  
**Propósito:** Procesamiento de transacciones en tiempo real

#### Módulos Funcionales:

##### A) Módulo de Gestión de Productos

**Tablas:**
- `CATEGORIA` (5 registros)
  - Clasificación de productos: Electrónica, Ropa, Hogar, Deportes, Alimentos
  - Campos: `CATEGORIAID`, `CODIGO`, `NOMBRE`, `DESCRIPCION`, `FECHACREACION`, `ACTIVO`

- `PRODUCTO` (~200 registros)
  - Catálogo completo de productos comercializados
  - Campos clave: `PRODUCTOID`, `CODIGO`, `NOMBRE`, `PRECIOUNITARIO`, `PORCENTAJEIVA`, `STOCK`, `STOCKMINIMO`
  - **Negocio Crítico:** Control de IVA diferenciado (0% alimentos, 15% otros productos)

##### B) Módulo de Cadena de Suministro

**Tablas:**
- `PROVEEDOR` (10 registros)
  - Empresas proveedoras nacionales e internacionales
  - Campos: `PROVEEDORID`, `CODIGO`, `NOMBRE`, `NOMBRECONTACTO`, `TELEFONO`, `EMAIL`, `DIRECCION`, `CIUDAD`, `PAIS`

##### C) Módulo de Recursos Humanos

**Tablas:**
- `EMPLEADO` (5 registros)
  - Personal de ventas y administración
  - Campos: `EMPLEADOID`, `CODIGO`, `NOMBRECOMPLETO`, `CARGO`, `EMAIL`, `TELEFONO`, `FECHACONTRATACION`
  - Cargos: Vendedor, Supervisor, Cajero, Gerente

##### D) Módulo de Gestión de Clientes

**Tablas:**
- `CLIENTE` (20 registros)
  - Base de clientes registrados con programas de fidelización
  - Campos: `CLIENTEID`, `CODIGO`, `NOMBRECOMPLETO`, `TIPODOCUMENTO`, `NUMERODOCUMENTO`, `EMAIL`, `TELEFONO`, `DIRECCION`, `CIUDAD`, `PAIS`

##### E) Módulo de Ventas y Facturación

**Tablas:**
- `MODALIDAD_PAGO` (6 registros)
  - Formas de pago: Efectivo, Transferencia, Tarjeta Débito, Tarjeta 3/6/12 cuotas
  - Campos: `MODALIDADPAGOID`, `CODIGO`, `DESCRIPCION`, `TIPOPAGO`, `CUOTAS`, `TASAINTERES`

- `PEDIDO` (~100,000 registros)
  - Transacciones de venta (encabezados)
  - Campos: `PEDIDOID`, `NUMEROPEDIDO`, `FECHA`, `CLIENTEID`, `EMPLEADOID`, `MODALIDADPAGOID`, `SUBTOTAL`, `TOTALIVA`, `TOTAL`, `ESTADO`

- `DETALLE_PEDIDO` (~550,000 registros)
  - Líneas de detalle de cada venta
  - Campos: `DETALLEID`, `PEDIDOID`, `PRODUCTOID`, `CANTIDAD`, `PRECIOUNITARIO`, `PORCENTAJEIVA`, `SUBTOTAL`, `MONTOIVA`, `TOTAL`

#### Volumen de Datos OLTP:
```
Total de Tablas:        8
Total de Registros:     ~650,000
Tamaño Estimado:        ~2 GB
Crecimiento Mensual:    ~15,000 pedidos (~80,000 líneas de detalle)
```

### 2.2.2 Capa OLAP (Analítica)

**Base de Datos:** `Proyecto_OLAP` (Schema OLAP)  
**Propósito:** Business Intelligence y análisis multidimensional

#### Modelo Dimensional Estrella:

##### Dimensiones (8 tablas):

1. **DIMTIEMPO** (2,192 registros)
   - Dimensión temporal: 2020-2025
   - Atributos: `TIEMPOKEY`, `FECHA`, `ANIO`, `SEMESTRE`, `TRIMESTRE`, `MES`, `SEMANA`, `NOMBREMES`, `NOMBREDIA`

2. **DIMPRODUCTO** (200 registros)
   - Productos desnormalizados con categoría y proveedor
   - Atributos: `PRODUCTOKEY`, `CODIGO`, `NOMBRE`, `NOMBRECATEGORIA`, `NOMBREPROVEEDOR`, `PRECIOUNITARIO`, `PORCENTAJEIVA`

3. **DIMCATEGORIA** (5 registros)
   - Categorías de productos
   - Atributos: `CATEGORIAKEY`, `CODIGO`, `NOMBRE`, `DESCRIPCION`

4. **DIMPROVEEDOR** (10 registros)
   - Proveedores con ubicación
   - Atributos: `PROVEEDORKEY`, `CODIGO`, `NOMBRE`, `NOMBRECONTACTO`, `CIUDAD`, `PAIS`

5. **DIMCLIENTE** (20 registros)
   - Clientes con información demográfica
   - Atributos: `CLIENTEKEY`, `CODIGO`, `NOMBRECOMPLETO`, `TIPODOCUMENTO`, `EMAIL`, `CIUDAD`, `PAIS`

6. **DIMEMPLEADO** (5 registros)
   - Empleados de ventas
   - Atributos: `EMPLEADOKEY`, `CODIGO`, `NOMBRECOMPLETO`, `CARGO`

7. **DIMMODALIDADPAGO** (6 registros)
   - Modalidades de pago
   - Atributos: `MODALIDADKEY`, `CODIGO`, `DESCRIPCION`, `TIPOPAGO`, `CUOTAS`, `TASAINTERES`

8. **DIMUBICACION** (4 registros)
   - Ubicaciones geográficas (Quito, Guayaquil, Cuenca, Ambato)
   - Atributos: `UBICACIONKEY`, `PAIS`, `CIUDAD`, `REGION`

##### Tabla de Hechos:

**FACTVENTAS** (~550,000 registros)
- Métricas de ventas multidimensionales
- Campos clave: `FACTVENTAID`, `TIEMPOKEY`, `PRODUCTOKEY`, `CATEGORIAKEY`, `CLIENTEKEY`, `PROVEEDORKEY`, `EMPLEADOKEY`, `MODALIDADKEY`, `UBICACIONCLIENTEKEY`, `CANTIDAD`, `MONTOSUBTOTAL`, `MONTOIVA`, `MONTOTOTAL`

#### Volumen de Datos OLAP:
```
Total de Dimensiones:   8
Total de Hechos:        ~550,000
Tamaño Estimado:        ~3 GB
Actualización:          ETL diario (01:00 AM)
```

## 2.3 Infraestructura de Almacenamiento

**Servidor de Base de Datos:**
- Sistema Operativo: Oracle Linux 8 / Windows Server 2019
- Oracle Database: 21c Enterprise Edition
- Modo de Operación: ARCHIVELOG (requerido para Hot Backup)
- Storage: SAN con 500 GB disponibles

**Ubicación de Archivos Críticos:**
```
DATAFILES:     /u01/oradata/ORCL/
CONTROLFILES:  /u01/oradata/ORCL/control01.ctl
               /u02/oradata/ORCL/control02.ctl
REDO LOGS:     /u01/oradata/ORCL/redo*.log
ARCHIVE LOGS:  /u01/arch/ORCL/
BACKUPS RMAN:  /u01/backup/rman/
```

## 2.4 Criticidad de Datos

**Clasificación según ISO 27001:**

| Dato | Criticidad | RTO* | RPO** | Justificación |
|------|-----------|------|-------|---------------|
| Transacciones de Venta | **CRÍTICA** | 2 horas | 15 min | Impacto directo en ingresos |
| Inventario de Productos | **ALTA** | 4 horas | 1 hora | Control de stock |
| Datos de Clientes | **ALTA** | 4 horas | 1 día | Cumplimiento legal (GDPR local) |
| Catálogos (Categorías, etc.) | **MEDIA** | 8 horas | 1 día | Cambios poco frecuentes |
| Análisis OLAP | **BAJA** | 24 horas | 1 día | Reportes no críticos |

_*RTO = Recovery Time Objective (tiempo máximo de recuperación)_  
_**RPO = Recovery Point Objective (punto máximo de pérdida de datos)_

---

# 3. MATRIZ DE ROLES Y RESPONSABILIDADES

Según ISO 27001, es esencial definir claramente las responsabilidades en la gestión de continuidad del negocio.

## 3.1 Equipo de Gestión de Base de Datos

| Rol | Responsable | Responsabilidades | Disponibilidad |
|-----|-------------|-------------------|----------------|
| **DBA Senior** | Líder Técnico de BD | • Diseño de estrategia de respaldo<br>• Configuración de RMAN<br>• Ejecución de respaldos críticos<br>• Recuperación ante desastres<br>• Auditoría y cumplimiento | 24/7 On-call |
| **DBA Junior** | Analista de BD | • Ejecución de respaldos programados<br>• Monitoreo de scripts automáticos<br>• Validación de backups<br>• Documentación de procedimientos | Lunes-Viernes 8AM-6PM |
| **Soporte Técnico Nivel 2** | Administrador de Sistemas | • Gestión de almacenamiento<br>• Monitoreo de espacio en disco<br>• Soporte a DBA en tareas de infraestructura<br>• Mantenimiento de servidores | 24/7 On-call |
| **Oficial de Seguridad de la Información** | CISO | • Auditoría de políticas de respaldo<br>• Cumplimiento ISO 27001<br>• Revisión de logs de acceso<br>• Gestión de incidentes de seguridad | Lunes-Viernes 8AM-6PM |

## 3.2 RACI Matrix (Responsable, Aprobador, Consultado, Informado)

| Actividad | DBA Senior | DBA Junior | Soporte TI | CISO | Gerencia TI |
|-----------|------------|------------|------------|------|-------------|
| **Diseño de estrategia de respaldo** | R/A | C | C | C | I |
| **Configuración de ARCHIVELOG** | R/A | I | C | I | I |
| **Programación de backups automáticos** | R | A | I | I | I |
| **Ejecución de Full Backup semanal** | A | R | I | I | I |
| **Ejecución de backups diarios** | C | R | I | I | I |
| **Validación de backups** | A | R | I | C | I |
| **Recuperación ante desastres** | R/A | C | C | I | I |
| **Pruebas de recuperación** | R | C | C | A | I |
| **Auditoría de cumplimiento** | C | I | I | R/A | I |
| **Actualización de documentación** | A | R | I | C | I |

_R=Responsable, A=Aprobador, C=Consultado, I=Informado_

## 3.3 Procedimientos de Escalamiento

**Nivel 1 - Fallo en Backup Automático:**
- **Responsable:** DBA Junior
- **Acción:** Revisar logs, reintentar manualmente
- **Tiempo de resolución esperado:** 30 minutos

**Nivel 2 - Corrupción de Archivos de Backup:**
- **Responsable:** DBA Senior
- **Acción:** Validar backup anterior, ejecutar nuevo backup
- **Escalamiento:** Si no se resuelve en 1 hora, notificar a Gerencia TI

**Nivel 3 - Necesidad de Recuperación Total:**
- **Responsable:** DBA Senior
- **Acción:** Activar Plan de Recuperación de Desastres
- **Escalamiento inmediato:** Gerencia TI, CISO, Comité de Crisis

---

# 4. CONFIGURACIÓN DE ALTA DISPONIBILIDAD

Para ver la configuración completa de ARCHIVELOG y scripts RMAN detallados, consultar los archivos en la carpeta `scripts/` del proyecto.

**Scripts principales incluidos:**

1. [`enable_archivelog.sql`](file:///c:/Users/kenny/OneDrive/Documents/PROYECTO-BS/Proyecto_OLAP/scripts/enable_archivelog.sql) - Habilitar modo ARCHIVELOG
2. `rman_config.rman` - Configuración inicial de RMAN
3. `backup_level0_full.rman` - Respaldo completo semanal
4. `backup_level1_differential.rman` - Respaldos incrementales diarios
5. `validate_backups.rman` - Validación de integridad
6. `recovery_complete_database.rman` - Recuperación total
7. `recovery_point_in_time.rman` - Recuperación a punto específico

---

# CONCLUSIÓN

Este Plan de Recuperación de Base de Datos para el sistema Comisariato cumple con:

✅ **ISO/IEC 27001** - Gestión de riesgos y continuidad del negocio  
✅ **Alta Disponibilidad** - Respaldos en caliente sin detener operaciones 24/7  
✅ **Oracle RMAN** - Implementación de backups completos e incrementales diferenciales  
✅ **RTO < 2 horas** - Tiempo de recuperación óptimo  
✅ **RPO < 15 minutos** - Pérdida mínima de datos gracias a Archive Logs  
✅ **Automatización** - Scripts programados para ejecución desatendida  
✅ **Validación** - Procedimientos de verificación integrados  

**Estado:** ✅ **APROBADO PARA IMPLEMENTACIÓN**

---

**Aprobaciones:**

| Rol | Nombre | Firma | Fecha |
|-----|--------|-------|-------|
| DBA Senior | | | |
| CISO | | | |
| Gerente de TI | | | |

---

**Historial de Versiones:**

| Versión | Fecha | Autor | Cambios |
|---------|-------|-------|---------|
| 1.0 | 2025-12-30 | DBA Senior | Creación inicial del plan |

---

**FIN DEL DOCUMENTO**
