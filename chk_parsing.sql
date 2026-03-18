        set echo off
        set verify off
       SET FEEDBACK OFF
        SET pagesize 20
        --dmoya 20220325
        -- cursor_cache_hits_ratio This metric represents the percentage of soft parses satisfied within the session cursor cache. soft parses/session cursor cache hits
        --The session cursor cache hits Oracle metric is the count of the number of hits in the session cursor cache. 
        
       set linesize 300
        col snap_id format 99999999
        col begin_time format a40
        col total_parses format 999999999
        col  hard format 999999999
        col sess format 9999999999999
        col "session cursor cache hits" format 9999999999
        col cursor_cache_hits_ratio format a25
        col soft_parses_ratio format a20
        col hard_parses_ratio format a20
        
     

          select SN.SNAP_ID,
          sn.instance_number
          ,trunc(SN.BEGIN_INTERVAL_TIME,'MI') BEGIN_TIME,
          TOTAL.CALLS,HARD.HARD,HIT.SESS  ,
           to_char ( sess /( calls -hard), '999999999990.00') || '%' cursor_cache_hits,
      to_char(100 * (calls  - hard)  / calls, '999990.00') || '%' soft_parses,
       to_char(100 * hard / calls, '999990.00') || '%' hard_parses
          from (select SNAP_ID,instance_number,value calls
          from DBA_HIST_SYSSTAT 
         where STAT_NAME = 'parse count (total)') TOTAL,
       (select SNAP_ID,instance_number,value hard
          from DBA_HIST_SYSSTAT
         where STAT_NAME = 'parse count (hard)')HARD,
       (select SNAP_ID,instance_number, value sess
          from DBA_HIST_SYSSTAT
         where STAT_NAME = 'session cursor cache hits') HIT,
         DBA_HIST_SNAPSHOT SN
         WHERE 
         TOTAL.SNAP_ID=HARD.SNAP_ID
         AND TOTAL.SNAP_ID=HIT.SNAP_ID
         AND TOTAL.SNAP_ID=SN.SNAP_ID
         and total.instance_number=hit.instance_number
         and total.instance_number=hard.instance_number
         and total.instance_number=sn.instance_number
         and sn.begin_interval_time>TRUNC(SYSDATE-2)
         ORDER BY 1,2;
         
         
         
         SET FEEDBACK ON
	 
	 set verify on
	 
set echo on 