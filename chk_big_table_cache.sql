-- =====================================================================
-- 1. Ajustes del Entorno del Terminal DMA (Width 300, Silencioso)
-- =====================================================================
SET LINESIZE 300
SET PAGESIZE 400
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET TRIMOUT ON
SET TRIMSPOOL ON
SET TAB OFF
SET COLSEP ' | '

-- =====================================================================
-- 2. Formateo de Columnas 
-- =====================================================================
COLUMN inst_id             FORMAT 9999       HEADING 'NODE'
COLUMN con_id              FORMAT 9999       HEADING 'CON_ID'
COLUMN esquema             FORMAT A15        HEADING 'OWNER'
COLUMN tabla               FORMAT A25        HEADING 'OBJECT_NAME'
COLUMN size_in_blocks      FORMAT 999,999,999 HEADING 'TOTAL_BLOCKS'
COLUMN obj_temperature     FORMAT 999,999,999 HEADING 'TEMPERATURE'
COLUMN cache_policy        FORMAT A15        HEADING 'CACHE_POLICY'
COLUMN blocks_in_mem       FORMAT 999,999,999 HEADING 'BLOCKS_IN_MEM'
COLUMN mem_size_mb         FORMAT 999,999.99 HEADING 'MEM_SIZE_MB'
COLUMN pct_of_btc_alloc    FORMAT 999.99     HEADING 'BTC_PCT_USED'
COLUMN cache_allocated_pct FORMAT 999.99     HEADING 'ALLOC_PCT'
COLUMN bt_cache_alloc_mb   FORMAT 999,999.99 HEADING 'BT_ALLOC_MB'
COLUMN total_btc_buffers   FORMAT 999,999,999 HEADING 'BTC_BUFFERS'
COLUMN memory_buf_alloc_mb FORMAT 999,999.99 HEADING 'BTC_BUFFERS_MB'
COLUMN total_obj_tracked   FORMAT 999999     HEADING 'TRACKED_OBJS'
COLUMN target_pct          FORMAT 999.99     HEADING 'TARGET_PCT'
COLUMN target_mb           FORMAT 999,999.99 HEADING 'TARGET_MB'
COLUMN current_buf_cache_mb FORMAT 999,999.99 HEADING 'BUF_CACHE_MB'
COLUMN used_mb             FORMAT 999,999.99 HEADING 'USED_MB'
COLUMN used_pct            FORMAT 999.99     HEADING 'USED_PCT'


PROMPT =================================================================================
PROMPT REPORTE 3: ESTADO GLOBAL DEL DATABASE BUFFER CACHE (Target, Allocated y Used Ratio)
PROMPT =================================================================================

SELECT 
    c.inst_id,
    c.con_id,
    ROUND(d.current_size / 1048576, 2) AS current_buf_cache_mb,
    c.bt_cache_target AS target_pct,
    ROUND((d.current_size / 1048576) * (c.bt_cache_target / 100), 2) AS target_mb,
    ROUND(((c.memory_buf_alloc * TO_NUMBER(p.value)) / d.current_size) * 100, 2) AS cache_allocated_pct,
    ROUND((c.memory_buf_alloc * TO_NUMBER(p.value)) / 1048576, 2) AS bt_cache_alloc_mb,
    ROUND((NVL((SELECT SUM(t.cached_in_mem) FROM gv$bt_scan_obj_temps t WHERE t.inst_id = c.inst_id), 0) * TO_NUMBER(p.value)) / 1048576, 2) AS used_mb,
        NVL(ROUND((NVL((SELECT SUM(t.cached_in_mem) FROM gv$bt_scan_obj_temps t WHERE t.inst_id = c.inst_id), 0) / NULLIF(c.memory_buf_alloc, 0)) * 100, 2), 0) AS used_pct,
    c.object_count AS total_obj_tracked
FROM 
    gv$bt_scan_cache c,
    gv$parameter p,
    gv$sga_dynamic_components d
WHERE 
    c.inst_id = p.inst_id
    AND p.name = 'db_block_size'
    AND c.inst_id = d.inst_id 
    AND d.component = 'DEFAULT buffer cache'
ORDER BY
    c.inst_id;
    
SET FEEDBACK ON
