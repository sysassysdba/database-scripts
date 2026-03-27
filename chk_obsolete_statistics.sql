--chk_obsolete_statistics.sql
--sia 2026/03/27

SET LINESIZE 300
SET PAGESIZE 400
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
COLUMN owner           FORMAT A15  HEADING 'OWNER'
COLUMN table_name      FORMAT A30  HEADING 'TABLE_NAME'
COLUMN partition_name  FORMAT A20  HEADING 'PARTITION_NAME'
COLUMN stale_stats     FORMAT A11  HEADING 'STALE_STATS'
COLUMN stale_percent   FORMAT A18  HEADING 'STALE_PERCENT'
COLUMN last_analyzed   FORMAT A19  HEADING 'LAST_ANALYZED'
COLUMN global_stats    FORMAT A12  HEADING 'GLOBAL_STATS'
COLUMN user_stats      FORMAT A10  HEADING 'USER_STATS'
COLUMN stattype_locked FORMAT A12  HEADING 'STATS_LOCKED'


SELECT 
    t.owner,
    t.table_name,
    t.partition_name,
    t.num_rows,
    t.stale_stats,
    NVL(p.preference_value, DBMS_STATS.GET_PREFS('STALE_PERCENT') || ' (GLOBAL)') AS stale_percent,
    TO_CHAR(t.last_analyzed, 'DD/MM/YYYY HH24:MI:SS') AS last_analyzed,
    t.global_stats,
    t.user_stats,
    NVL(t.stattype_locked, 'NONE') AS stattype_locked
FROM   
    dba_tab_statistics t,
    dba_tab_stat_prefs p
WHERE  
    t.owner = p.owner(+)
    AND t.table_name = p.table_name(+)
    AND p.preference_name(+) = 'STALE_PERCENT'
    AND t.stale_stats = 'YES'
    AND t.owner NOT IN ('SYS', 'SYSTEM', 'SYSMAN', 'DBSNMP', 'OUTLN')
ORDER BY 
    t.owner, 
    t.table_name, 
    t.partition_name;

SET FEEDBACK ON