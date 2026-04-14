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
PROMPT REPORTE 2: TABLAS DENTRO DEL BIG TABLE CACHE (Total o Parcialmente en RAM)
PROMPT =================================================================================

SELECT 
    t.inst_id,
    o.owner AS esquema,
    o.object_name AS tabla,
    t.size_in_blks AS size_in_blocks,
    t.temperature AS obj_temperature,
    t.policy AS cache_policy,
    t.cached_in_mem AS blocks_in_mem,
    ROUND((t.cached_in_mem * TO_NUMBER(p.value)) / 1048576, 2) AS mem_size_mb
FROM 
    gv$bt_scan_obj_temps t,
    dba_objects o,
    gv$parameter p
WHERE 
    t.dataobj# = o.data_object_id
    AND t.inst_id = p.inst_id
    AND p.name = 'db_block_size'
    AND t.cached_in_mem > 0
ORDER BY 
    t.inst_id,
    t.temperature DESC, 
    t.cached_in_mem DESC;
