SET ECHO OFF
SET VERIFY OFF
  
SET FEEDBACK OFF

--chk_buffer_cache_ratio.sql

-- Configuración para SQL*Plus

SET LINESIZE 300
SET PAGESIZE 100


-- Formato de columnas
COLUMN inst_id FORMAT 99 HEADING 'Inst|ID'
COLUMN db_block_gets FORMAT 999,999,999,999 HEADING 'DB Block Gets'
COLUMN consistent_gets FORMAT 999,999,999,999 HEADING 'Consistent Gets'
COLUMN physical_reads FORMAT 999,999,999,999 HEADING 'Physical Reads'
COLUMN buffer_cache_hit_ratio FORMAT 999.99 HEADING 'Buffer Cache|Hit Ratio (%)'

-- Consulta para RAC (Segregada por instancia)
SELECT 
    inst_id,
    SUM(CASE WHEN name = 'db block gets' THEN value ELSE 0 END) AS db_block_gets,
    SUM(CASE WHEN name = 'consistent gets' THEN value ELSE 0 END) AS consistent_gets,
    SUM(CASE WHEN name = 'physical reads' THEN value ELSE 0 END) AS physical_reads,
    ROUND(
        (1 - (SUM(CASE WHEN name = 'physical reads' THEN value ELSE 0 END) / 
             (SUM(CASE WHEN name = 'db block gets' THEN value ELSE 0 END) + 
              SUM(CASE WHEN name = 'consistent gets' THEN value ELSE 0 END)))
        ) * 100, 
    2) AS buffer_cache_hit_ratio
FROM 
    gv$sysstat
WHERE 
    name IN ('db block gets', 'consistent gets', 'physical reads')
GROUP BY 
    inst_id
ORDER BY 
    inst_id;


set feedback on
SET VERIFY On
SET ECHO On
