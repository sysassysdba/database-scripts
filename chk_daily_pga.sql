   SET ECHO OFF
 --sysassysdba@gmail.com
   
   SET ECHO OFF
   SET VERIFY OFF
   SET FEEDBACK OFF
   SET LINESIZE 300
   SET PAGESIZE 80
   
   COL begin_time FORMAT A22
   COL end_time FORMAT A22
   COL con_id FORMAT 999999
   COL pga_inuse_mb FORMAT 99999.99
   COL pga_allocated_mb FORMAT 99999.99
   COL max_pga_alloc_mb FORMAT 99999.99

ACCEPT DAY  PROMPT 'Day FROM to monitor (DD/MM/RRRR)  DEFAULT SYSDATE -> ' 
   
   SELECT 
    s.snap_id,p.instance_number,
    p.con_id,
  /*  to_date(s.begin_interval_time,'DD-MON-YY HH24:MI') as begin_time,to_date(s.end_interval_time ,'DD-MON-YY HH24:MI')as begin_time, */
    TO_CHAR(s.BEGIN_INTERVAL_TIME,'DD-MON-YY HH24:MI') as BEGIN_TIME,
    TO_CHAR(s.END_INTERVAL_TIME ,'DD-MON-YY HH24:MI') as END_TIME,
    -- Extraemos el 'total PGA inuse' (Uso activo de Work Areas)
    ROUND(SUM(CASE WHEN name = 'total PGA inuse' THEN value END) / 1024 / 1024, 2) AS pga_inuse_mb,
    -- Extraemos el 'total PGA allocated' (Memoria total reclamada al SO)
    ROUND(SUM(CASE WHEN name = 'total PGA allocated' THEN value END) / 1024 / 1024, 2) AS pga_allocated_mb,
    -- Extraemos el 'maximum PGA allocated' (Pico histórico hasta ese momento)
    ROUND(SUM(CASE WHEN name = 'maximum PGA allocated' THEN value END) / 1024 / 1024, 2) AS max_pga_alloc_mb
FROM 
    dba_hist_pgastat p,dba_hist_snapshot s
WHERE 
s.snap_id= p.snap_id
and S.INSTANCE_NUMBER=P.INSTANCE_NUMBER
and s.con_id=p.con_id
and 
    name IN ('total PGA inuse', 'total PGA allocated', 'maximum PGA allocated')
    and 
s.end_interval_time BETWEEN to_date(to_char(cast(NVL('&DAY',SYSDATE) as date),'DD/MM/YYYY' ),'dd/mm/rrrr') 
AND to_date(to_char(cast(NVL('&DAY',SYSDATE) as date),'DD/MM/YYYY' ),'dd/mm/rrrr')+1
GROUP BY 
   s.snap_id,p.instance_number,p.con_id,s.begin_interval_time,s.end_interval_time 
ORDER BY 
       s.snap_id,p.instance_number,p.con_id,s.begin_interval_time;