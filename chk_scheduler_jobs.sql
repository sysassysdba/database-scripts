
set linesize 300
col job_name format a30
col job_type format a10 
col job_action format a40 
col start_date format a20 
col repeat_interval format a30 
col job_class format a19
col state format a15
col owner format a12


SELECT owner, job_name,job_type,job_action,start_date,repeat_interval,job_class,state,run_count FROM DBA_SCHEDULER_JOBS where job_type='EXECUTABLE' ORDER BY OWNER,start_date,repeat_interval;