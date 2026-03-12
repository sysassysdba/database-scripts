set echo off
--sysassysdba@gmail.com 2026/03/12
set verify off
SET FEEDBACK OFF
SET LINESIZE 300
SET PAGESIZE 100

COL owner             FORMAT A10 
COL window_name       FORMAT A16
COL schedule_type     FORMAT A13
COL next_start_date   FORMAT A35 HEAD 'NEXT_START_DATE (WITH TIMEZONE)'
COL repeat_interval   FORMAT A56 HEAD'REPEAT_INTERVAL' 
COL TZ_ABBR FORMAT A7
col duration format a13
COL TZ_REgion format a15

SELECT owner,
       window_name,
       schedule_type,
       TO_CHAR(next_start_date, 'YYYY-MM-DD HH24:MI:SS TZR') AS next_start_date,
       repeat_interval,
       duration,
       EXTRACT(TIMEZONE_REGION FROM next_start_date) TZ_REGION,EXTRACT(TIMEZONE_ABBR FROM next_start_date) TZ_ABBR
FROM dba_scheduler_windows
WHERE enabled = 'TRUE'
ORDER BY window_name;