
   SET ECHO OFF
 --sysassysdba@gmail.com

   SET VERIFY OFF
   SET FEEDBACK OFF
   SET LINESIZE 300
   SET PAGESIZE 80

   col module format a35
   col PROGRAM format a35
   col machine format a30
   col info format a38
   col pga_mb format 99999.99
   COL SQL_ID FORMAT A15
   
   ACCEPT DAY  PROMPT 'Day FROM to monitor (DD/MM/RRRR)  DEFAULT SYSDATE -> ' 

WITH pga_per_session AS (
    -- 1. Extraemos los picos de PGA y el programa/SQL_ID asociado en ese instante
    SELECT 
        h.snap_id,
        h.instance_number,
        h.session_id,
		H.SESSION_SERIAL#,
		h.machine,
        MAX(h.sql_id) KEEP (DENSE_RANK LAST ORDER BY h.pga_allocated) AS peak_sql_id,
        MAX(h.program) KEEP (DENSE_RANK LAST ORDER BY h.pga_allocated) AS peak_program,
        MAX(h.module) KEEP (DENSE_RANK LAST ORDER BY h.pga_allocated) AS peak_module,
        MAX(h.pga_allocated) AS max_pga_allocated
    FROM 
        dba_hist_active_sess_history h
    WHERE 
        h.snap_id IN (SELECT SNAP_ID FROM DBA_HIST_SNAPSHOT WHERE end_interval_time BETWEEN to_date(to_char(cast(NVL('&DAY',SYSDATE) as date),'DD/MM/YYYY' ),'dd/mm/rrrr') 
AND to_date(to_char(cast(NVL('&DAY',SYSDATE) as date),'DD/MM/YYYY' ),'dd/mm/rrrr')+1)
        AND h.instance_number = 1              -- Filtro por Instancia (Default 1)
        AND h.pga_allocated IS NOT NULL
    GROUP BY 
        h.snap_id,
        h.instance_number,
        h.session_id,
		h.session_serial#,
		h.machine
),
ranked_sessions AS (
    -- 2. Creamos el ranking del 1 al 10 por cada Snapshot
    SELECT 
        p.snap_id,
        p.instance_number,
        p.session_id,
		p.session_serial#,
        p.peak_program AS program,
        p.peak_module AS module,
		p.machine,
        p.peak_sql_id AS sql_id,
        ROUND(p.max_pga_allocated / 1024 / 1024, 2) AS pga_mb,
        ROW_NUMBER() OVER (PARTITION BY p.snap_id ORDER BY p.max_pga_allocated DESC) AS rank_pos
    FROM 
        pga_per_session p
)
-- 3. Cruzamos con la vista de Snapshots y formateamos la salida
SELECT 
    CASE 
        WHEN r.rank_pos = 1 THEN 
            (s.snap_id - 1) || '-' || s.snap_id || '(' || 
            TO_CHAR(s.begin_interval_time, 'DD-MM-YYYY HH24:MI') || '-' || 
            TO_CHAR(s.end_interval_time, 'HH24:MI') || ')'
        ELSE ' ' 
    END AS INFO,r.instance_number,R.SESSION_ID,r.session_serial#,
    NVL(SUBSTR(r.program, 1, 35), 'UNKNOWN') AS PROGRAM ,
    NVL(SUBSTR(r.module, 1, 38), 'N/A')      AS MODULE,
	r.machine,
    NVL(r.sql_id, 'N/A')                     AS SQL_ID,
    r.pga_mb                                 AS PGA_MB 
FROM 
    ranked_sessions r
JOIN 
    dba_hist_snapshot s 
    ON r.snap_id = s.snap_id 
    AND r.instance_number = s.instance_number
    AND s.dbid = (SELECT dbid FROM v$database)
WHERE 
    r.rank_pos <= 10
ORDER BY 
    s.snap_id, 
    r.rank_pos;

SET FEEDBACK ON
SET VERIFY ON
SET ECHO ON