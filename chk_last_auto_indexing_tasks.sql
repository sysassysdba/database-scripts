-- 1. Ajustes del Entorno del Terminal DMA (Width 300)
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 100
SET TRIMOUT ON
SET TRIMSPOOL ON
SET TAB OFF
SET COLSEP ' | '

-- 2. Formateo de Columnas
COLUMN task_name       FORMAT A25 HEADING 'TASK_NAME'
COLUMN execution_name  FORMAT A30 HEADING 'EXECUTION_NAME'
COLUMN execution_start FORMAT A20 HEADING 'EXEC_START'
COLUMN execution_end   FORMAT A20 HEADING 'EXEC_END'
COLUMN status          FORMAT A15 HEADING 'STATUS'

-- 3. Consulta de Auditoria ANSI SQL-86
SELECT 
    task_name,
    execution_name,
    TO_CHAR(execution_start, 'YYYY-MM-DD HH24:MI:SS') AS execution_start,
    TO_CHAR(execution_end, 'YYYY-MM-DD HH24:MI:SS') AS execution_end,
    status
FROM 
    dba_advisor_executions
WHERE 
    task_name = 'SYS_AUTO_INDEX_TASK'
ORDER BY 
    execution_start DESC
FETCH FIRST 20 ROWS ONLY;

-- 4. Restaurar el comportamiento de la sesion
SET FEEDBACK ON
