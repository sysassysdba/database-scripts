SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 200
SET TRIMOUT ON
SET TRIMSPOOL ON
SET TAB OFF
SET COLSEP ' | '

-- =====================================================================
-- 2. Formateo de Columnas para DBA_AUTO_INDEX_CONFIG
-- =====================================================================
COLUMN parameter_name   FORMAT A40   HEADING 'AUTO_INDEX_PARAMETER'
COLUMN parameter_value  FORMAT A60   HEADING 'CURRENT_VALUE' WORD_WRAPPED
COLUMN last_modified    FORMAT A25   HEADING 'LAST_MODIFIED_DATE'
COLUMN modified_by      FORMAT A20   HEADING 'MODIFIED_BY'

-- =====================================================================
-- 3. Consulta de Auditoria DMA (ANSI SQL-86)
-- =====================================================================
SELECT 
    parameter_name,
    parameter_value,
    TO_CHAR(last_modified, 'YYYY-MM-DD HH24:MI:SS') AS last_modified,
    modified_by
FROM 
    dba_auto_index_config
ORDER BY 
    parameter_name ASC;

-- Restaurar el comportamiento por defecto de la sesion
SET FEEDBACK ON
