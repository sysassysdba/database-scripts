
set echo off
set feedback off
set linEsize 300
col  execution_name   FORMAT A28
col  action_id format 9999
col sql_id      FORMAT A20 
col plan_hash_value format 9999999999
COL command         FORMAT A28 
col statement format a40

SELECT 
    execution_name,
    action_id,
   sql_id,
    plan_hash_value,
    command,
    statement,
    start_time,
    end_time,
    error# 
FROM 
    dba_auto_index_sql_actions
ORDER BY 
    execution_name DESC
FETCH FIRST 15 ROWS ONLY;
