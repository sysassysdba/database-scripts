col  run_duration format a15
col instance_id format 99
col session_id format a15

col slave_pid format a7
col cpu_used format a16
col errors format a20
col additional_info format a60

SELECT  log_id,log_date,owner,job_name,status,run_duration,instance_id,session_id,slave_pid,cpu_used,additional_info,errors FROM DBA_SCHEDULER_JOB_RUN_DETAILS WHERE job_name=UPPER('&NOMBRE_JOB') ORDER BY LOG_ID DESC;