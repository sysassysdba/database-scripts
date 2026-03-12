set echo off
--sysassysdba@gmail.com 2026/03/12
set verify off
SET FEEDBACK OFF
SET LINESIZE 300
SET PAGESIZE 100



COL job_name        FORMAT A30 
COL state           FORMAT A10 
COL schedule_type   FORMAT A14 
COL next_run_date   FORMAT A29 HEAD 'NEXT_RUN_DATE (WITH TIMEZONE)'
COL repeat_interval   FORMAT A70 HEAD 'REPEAT_INTERVAL'
COL dst_risk_reason FORMAT A35 HEAD 'RISK_DETECTED'
COL OWNER FORMAT A15
COL JOB_CREATOR FORMAT A15

-- Consulta para detectar Jobs vulnerables al DST o a la Deriva de Tiempo
SELECT OWNER,JOB_CREATOR,job_name,
       state,
       schedule_type,
       TO_CHAR(next_run_date, 'YYYY-MM-DD HH24:MI:SS TZR') AS next_run_date,
       repeat_interval,
       CASE 
           -- Detecta si usa "SYSTIMESTAMP + 1" (Deriva temporal)
           WHEN schedule_type = 'PLSQL' THEN 'CRITICAL: PL/SQL Drift Risk'
           -- Detecta si la zona horaria es desconocida (Fallo arquitectonico)
           WHEN EXTRACT(TIMEZONE_REGION FROM next_run_date) = 'UNKNOWN' THEN 'CRITICAL: No Time Zone (DST Risk)' 
           -- Detecta si usa offsets a pelo como +02:00 en lugar de IANA (Fallo de DST)
           WHEN EXTRACT(TIMEZONE_REGION FROM next_run_date) LIKE '+%' 
             OR EXTRACT(TIMEZONE_REGION FROM next_run_date) LIKE '-%' THEN 'HIGH: Static Offset (DST Risk)'
           ELSE 'SAFE'
       END AS dst_risk_reason
FROM dba_scheduler_jobs
WHERE OWNER='SCOTT' 
AND state NOT IN ('DISABLED', 'BROKEN', 'COMPLETED') -- Auditamos solo los que pueden fallar
  AND (
       schedule_type = 'PLSQL'
       OR EXTRACT(TIMEZONE_REGION FROM next_run_date) = 'UNKNOWN'
       OR EXTRACT(TIMEZONE_REGION FROM next_run_date) LIKE '+%'
       OR EXTRACT(TIMEZONE_REGION FROM next_run_date) LIKE '-%'
  )
ORDER BY job_name;