-- SQL*Plus helper to generate a Compare Period ADDM report using
-- DBMS_ADDM.COMPARE_INSTANCES (HTML Active Report or XML).
--
-- Usage (example):
--   sqlplus / as sysdba @compare_instances_report.sql

SET ECHO OFF
SET VERIFY OFF
SET FEEDBACK OFF
SET HEADING OFF
SET PAGESIZE 0
SET TRIMSPOOL ON
SET TRIMOUT ON
SET LINESIZE 32767
SET LONG 10000000
SET LONGCHUNKSIZE 10000000

PROMPT
PROMPT DBMS_ADDM.COMPARE_INSTANCES - input parameters
PROMPT (Use DBID=0 to mean "current database" i.e. NULL parameter.)
PROMPT

ACCEPT base_dbid   NUMBER DEFAULT 0 PROMPT 'Base DBID (0=current): '
ACCEPT base_inst   NUMBER           PROMPT 'Base INSTANCE_NUMBER: '
ACCEPT base_bsnap  NUMBER           PROMPT 'Base BEGIN SNAP_ID: '
ACCEPT base_esnap  NUMBER           PROMPT 'Base END   SNAP_ID: '

ACCEPT comp_dbid   NUMBER DEFAULT 0 PROMPT 'Comp DBID (0=current): '
ACCEPT comp_inst   NUMBER           PROMPT 'Comp INSTANCE_NUMBER: '
ACCEPT comp_bsnap  NUMBER           PROMPT 'Comp BEGIN SNAP_ID: '
ACCEPT comp_esnap  NUMBER           PROMPT 'Comp END   SNAP_ID: '

ACCEPT report_type CHAR   DEFAULT 'HTML' PROMPT 'Report type (HTML|XML) [HTML]: '
ACCEPT out_file    CHAR   DEFAULT 'addm_compare_instances_report.out' PROMPT 'Output file [addm_compare_instances_report.out]: '

COLUMN rpt_type NEW_VALUE rpt_type NOPRINT
SELECT UPPER('&&report_type') AS rpt_type FROM dual;

SET TERMOUT OFF
SPOOL &&out_file

SELECT DBMS_ADDM.COMPARE_INSTANCES(
         base_dbid          => CASE WHEN &&base_dbid = 0 THEN NULL ELSE &&base_dbid END,
         base_instance_id   => &&base_inst,
         base_begin_snap_id => &&base_bsnap,
         base_end_snap_id   => &&base_esnap,
         comp_dbid          => CASE WHEN &&comp_dbid = 0 THEN NULL ELSE &&comp_dbid END,
         comp_instance_id   => &&comp_inst,
         comp_begin_snap_id => &&comp_bsnap,
         comp_end_snap_id   => &&comp_esnap,
         report_type        => '&&rpt_type'
       )
FROM dual;

SPOOL OFF
SET TERMOUT ON

PROMPT
PROMPT Report written to: &&out_file
PROMPT
