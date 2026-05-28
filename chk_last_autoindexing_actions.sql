COLUMN index_owner     FORMAT A15 HEADING 'OWNER'
COLUMN index_name      FORMAT A30 HEADING 'INDEX_NAME'
COLUMN table_name      FORMAT A25 HEADING 'TABLE_NAME'
COLUMN command         FORMAT A25 HEADING 'ACTION/COMMAND'

SELECT 
    execution_name,
    index_owner,
    index_name,
    table_name,
    command
FROM 
    dba_auto_index_ind_actions
WHERE 
    index_owner NOT IN ('SYS', 'SYSTEM') -- Aisla los esquemas de aplicacion (Ej. SCOTT)
ORDER BY 
    execution_name DESC
FETCH FIRST 15 ROWS ONLY;
