
set linesize 300
col log_id format 999999
col log_date format a36
col owner format a8
col job_name format a30
col job_class format a20
col operation format a5
col status format a9


SELECT log_id,log_date,owner,job_name,job_class,operation,status FROM DBA_SCHEDULER_JOB_LOG WHERE job_name=UPPER('&NOMBRE_JOB') ORDER BY LOG_ID DESC;