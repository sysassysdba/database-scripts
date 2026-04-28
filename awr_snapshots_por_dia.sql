-- =====================================================================================
-- awr_snapshots_por_dia.sql 
-- Objetivo: Listar los SNAP_ID de AWR y sus intervalos de tiempo para un día concreto.
-- =====================================================================================
SET ECHO OFF
SET LINESIZE 300
SET PAGESIZE 200
SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF
SET HEADING ON
SET TRIMS ON
SET TRIMOUT ON
SET TRIMSPOOL ON
SET TAB OFF
SET COLSEP '|'

ACCEPT v_day PROMPT 'Day to monitor (DD/MM/RRRR) DEFAULT SYSDATE -> ' DEFAULT TO_CHAR(SYSDATE,'DD/MM/RRRR')
ACCEPT v_inst PROMPT 'Instance ID -> default 1 -> ' DEFAULT '1'

COLUMN begin_snap_id   FORMAT 999999999999 HEADING 'BEGIN_SNAP_ID'
COLUMN end_snap_id     FORMAT 9999999999 HEADING 'END_SNAP_ID'
COLUMN snap_begin_time FORMAT A20        HEADING 'SNAP_BEGIN_TIME'
COLUMN snap_end_time   FORMAT A20        HEADING 'SNAP_END_TIME'


SELECT
  s.snap_id - 1                                                                    AS begin_snap_id,
  s.snap_id                                                                        AS end_snap_id,
  TO_CHAR(s.begin_interval_time, 'DD-MON-RR HH24:MI') AS snap_begin_time,
  TO_CHAR(s.end_interval_time, 'DD-MON-RR HH24:MI')   AS snap_end_time
FROM 
  dba_hist_snapshot s
WHERE 
  s.instance_number = TO_NUMBER('&v_inst')
  AND s.end_interval_time >= TO_DATE(NVL('&v_day', TO_CHAR(SYSDATE, 'DD/MM/RRRR')), 'DD/MM/RRRR')
  AND s.end_interval_time <  TO_DATE(NVL('&v_day', TO_CHAR(SYSDATE, 'DD/MM/RRRR')), 'DD/MM/RRRR') + 1
ORDER BY 
  s.snap_id;

SET COLSEP ' '
SET FEEDBACK ON
SET ECHO ON
SET VERIFY ON
