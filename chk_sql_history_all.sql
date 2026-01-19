   set echo off
   set verify off
   set feedback off
   COMPUTE SUM OF "Elap [s]" ON "day"
   COMPUTE SUM OF "Cpu [s]" ON "day"
   COMPUTE SUM OF "Execs"  ON "day"
   set linesize 500
   col snaps for a15
   col interval for a15
   col "Execs" for  999,999,999,999
   BREAK on  "day"  skip page on instance_number skip 1
   set pages 200 
   col pschema for a10 trun
   col sql_profile for a30
   col SQL_ADAPTIVE_PLAN_RESOLVED for 9
   col FORCE_MATCHING_SIGNATURE for 9999999999999999999999999
   col occurrences for 999999
   col "Buffer Gets" for 999,999,999,999
   col "Physical I/O" for 999,999,999,999
   col  "day" noprint
   col order_snap noprint
   UNDEFINE DAY
   UNDEFINE SQL_ID
   ACCEPT SQLID PROMPT 'SQLID TO MONITORING --> '

   
   SELECT
   trunc(hist.end_interval_time) "day",
   hist.snap_id-1 order_snap,
   sqls.instance_number,
   to_char(hist.snap_id-1) || '-'  || to_char(hist.snap_id) "Snaps",
   to_char(hist.end_interval_time,'dd-mm-rr hh24:mi') "Interval",
   sqls.parsing_schema_name pschema,
   sqls.EXECUTIONS_DELTA "Execs",
   round(sqls.ELAPSED_TIME_DELTA/1000000,2) "Elap [s]",	
   round((sqls.ELAPSED_TIME_DELTA/1000000)/sqls.EXECUTIONS_DELTA,3) "Elap By Execution",
   round(sqls.CPU_TIME_DELTA/1000000,2)  "Cpu [s]",
   sqls.BUFFER_GETS_DELTA "Buffer Gets",
   sqls.DISK_READS_DELTA "Physical I/O",
   sqls.sql_profile,
   --sqls.FORCE_MATCHING_SIGNATURE ,
   occurrences,
   SQL_ADAPTIVE_PLAN_RESOLVED,
   sqls.PLAN_HASH_VALUE PLAN
   FROM sys.DBA_HIST_SQLSTAT sqls, 
   DBA_HIST_SNAPSHOT hist,
   (select count(*) occurrences,snap_id, instance_number,sql_id,sql_plan_hash_value,SQL_ADAPTIVE_PLAN_RESOLVED from DBA_HIST_ACTIVE_SESS_HISTORY 
   where sql_id='&sqlid' 
   GROUP BY SNAP_ID,INSTANCE_NUMBER,SQL_ID,SQL_PLAN_HASH_VALUE,SQL_ADAPTIVE_PLAN_RESOLVED)se
   WHERE
   hist.snap_id = sqls.snap_id 
   AND HIST.CON_ID=SQLS.CON_ID
   and  sqls.snap_id=se.snap_id 
   and sqls.SQL_ID= se.sql_id
   and sqls.plan_hash_value=se.sql_plan_hash_value
   AND hist.instance_number = sqls.instance_number
   and se.instance_number=sqls.instance_number
   AND  sqls.EXECUTIONS_DELTA  <> 0
   and sqls.SNAP_ID IN (SELECT SNAP_ID from DBA_HIST_SNAPSHOT where end_interval_time >= trunc(sysdate)-30
   and end_interval_time < trunc(sysdate)+1)
   AND sqls.SQL_ID = '&sqlid'
   order by "day",instance_number asc,order_snap ;
   
   UNDEFINE DAY
   UNDEFINE SQL_ID
   set feedback on
   set verify on
   set echo on
   