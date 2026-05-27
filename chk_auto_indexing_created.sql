SET ECHO OFF
SET LINESIZE 300
SET PAGESIZE 400

SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMOUT ON
SET TRIMSPOOL ON
SET TAB OFF
SET COLSEP ' | '

COLUMN owner           FORMAT A15 HEADING 'OWNER'
COLUMN index_name      FORMAT A30 HEADING 'INDEX_NAME'
COLUMN table_name      FORMAT A25 HEADING 'TABLE_NAME'
COLUMN index_type      FORMAT A20 HEADING 'INDEX_TYPE'
COLUMN column_name     FORMAT A20 HEADING 'INDEX_COLUMN'
COLUMN column_position FORMAT 999  HEADING 'POS'
COLUMN last_analyzed   FORMAT A19 HEADING 'LAST_ANALYZED'
COLUMN created         FORMAT A19 HEADING 'CREATED'
COLUMN last_ddl_time   FORMAT A19 HEADING 'LAST_DDL_TIME'
col visibility format a14

SELECT 
    o.owner,
    i.index_name, 
    i.table_name, 
    i.index_type,
    i.visibility,
    c.column_name,
    c.column_position,
    TO_CHAR(i.last_analyzed, 'YYYY-MM-DD HH24:MI:SS') AS last_analyzed,
    TO_CHAR(o.created, 'YYYY-MM-DD HH24:MI:SS') AS created,
    TO_CHAR(o.last_ddl_time, 'YYYY-MM-DD HH24:MI:SS') AS last_ddl_time
FROM 
    dba_indexes i,
    dba_objects o,
    dba_ind_columns c
WHERE 
    i.index_name = o.object_name
    AND i.owner = o.owner
    AND o.object_type = 'INDEX'
    AND i.index_name = c.index_name
    AND i.owner = c.index_owner
    AND i.table_name = c.table_name
    AND i.auto = 'YES'
ORDER BY 
    i.table_name ASC,
    i.index_name ASC, 
    c.column_position ASC;
