--sql_compare_plans_awr.sql
--sysassysdba@gmail.com https://sysassysdba.hashnode.dev/

set echo off
set verify off
set feedback off
set linesize 300
SET PAGESIZE 2000

UNDEFINE PLHASHCOMP
UNDEFINE PLHASHREF
UNDEFINE SQL_ID

ACCEPT SQLID PROMPT 'SQLID TO compare --> '
ACCEPT PLHASHREF PROMPT 'PLAN_HASH_VALUE OF REFERENCCE PLAN --> '
ACCEPT PLHASHCOMP PROMPT 'PLAN_HASH_VALUE OF COMPARE PLAN --> '

spool LOGS/compare_sql_'&sqlid'_hashs_'&PLHASHREF'_vs_'&PLHASHCOMP'.txt
VARIABLE v_rep CLOB
  
BEGIN
 :v_rep := DBMS_XPLAN.COMPARE_PLANS(
 reference_plan => awr_object('&sqlid', null, null, &PLHASHREF),
 compare_plan_list => plan_object_list(awr_object('&sqlid', null, null, &PLHASHCOMP)),
 type => 'TEXT',
 level => 'ALL',
 section => 'ALL');
 END;
/ 

set long 10000000
COLUMN report FORMAT a250

SELECT :v_rep REPORT FROM DUAL;
spool off
UNDEFINE PLHASHCOMP
UNDEFINE PLHASHREF
UNDEFINE SQL_ID
set feedback on
set verify on
set echo on
