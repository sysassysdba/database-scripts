
   SET ECHO OFF
 --sysassysdba@gmail.com

   SET VERIFY OFF
   SET FEEDBACK OFF
   SET LINESIZE 300
   SET PAGESIZE 80
   col sid format 9999999
   col serial# format 9999999
   col username format a30
   col status format a8
   col last_call_et format 999999999
   col module format a45
   col PROGRAM format a45
   col machine format a30
   col info format a38
   col pga_mb format 99999.99
   COL SQL_ID FORMAT A15
   


SELECT s.inst_id,
       s.sid,
       s.serial#,
       s.username,
       s.logon_time,
       s.status,
       s.last_call_et,
       s.program,
       s.machine,
       s.sql_id,
       ROUND(p.pga_alloc_mem / 1024 / 1024, 2) AS pga_allocated_mb,
       ROUND(p.pga_max_mem / 1024 / 1024, 2) AS pga_max_historical_mb
FROM gv$session s
JOIN gv$process p 
  ON s.paddr = p.addr 
  AND s.inst_id = p.inst_id
WHERE s.username IS NOT NULL 
ORDER BY p.pga_alloc_mem DESC
FETCH FIRST 20 ROWS ONLY;