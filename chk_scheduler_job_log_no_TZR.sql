SET ECHO OFF
--sysassysdba@gmail.com 2026/03/12
SET FEEDBACK OFF
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 400
SET TRIMOUT ON
SET TRIMSPOOL ON

COLUMN log_id                  FORMAT 99999
COLUMN owner                   FORMAT A12 
COLUMN job_name                FORMAT A23 
COLUMN status                  FORMAT A12
COLUMN log_date                FORMAT A35 
COLUMN log_date_region         FORMAT A18 
COLUMN log_date_offset         FORMAT A30 
COLUMN req_start_date          FORMAT A33 
COLUMN req_start_date_region   FORMAT A23 
COLUMN req_start_date_offset   FORMAT A30 


SELECT 
    log_id,
    owner,
    job_name,
    status,
    TO_CHAR(log_date, 'YYYY-MM-DD HH24:MI:SS.FF TZR') AS log_date,
    EXTRACT(TIMEZONE_REGION FROM log_date) AS log_date_region,
    EXTRACT(TIMEZONE_OFFSET FROM log_date) AS log_date_offset,
    TO_CHAR(req_start_date, 'YYYY-MM-DD HH24:MI:SS.FF TZR') AS req_start_date,
    EXTRACT(TIMEZONE_REGION FROM req_start_date) AS req_start_date_region,
    EXTRACT(TIMEZONE_OFFSET FROM req_start_date) AS req_start_date_offset 
FROM 
    dba_scheduler_job_run_details 
WHERE 
    EXTRACT(TIMEZONE_OFFSET FROM log_date) != EXTRACT(TIMEZONE_OFFSET FROM req_start_date)
ORDER BY 
    log_id DESC;