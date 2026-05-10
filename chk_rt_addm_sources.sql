-- =========================================================================================
-- SCRIPT DMA: DETECCIÓN RESILIENTE DE CRISIS CON REAL-TIME ADDM (DBA_HIST_REPORTS)
-- Incluye extracción del disparador exacto (id_desc)
-- =========================================================================================

SET LINESIZE 300
SET PAGESIZE 100
SET ECHO OFF
SET TRIMSPOOL ON
SET VERIFY OFF
SET FEEDBACK OFF

COLUMN report_id       FORMAT 9999999999  HEADING 'REPORT_ID'
COLUMN report_name     FORMAT A15         HEADING 'REPORT_NAME'
COLUMN period_start    FORMAT A20         HEADING 'PERIOD_START'
COLUMN inst            FORMAT 99          HEADING 'I#'
COLUMN trigger_reason  FORMAT A25         HEADING 'TRIGGER_REASON (ID_DESC)'
COLUMN impact          FORMAT A15         HEADING 'IMPACT (AAS)'
COLUMN impact_desc     FORMAT A50         HEADING 'IMPACT_DESCRIPTION' WORD_WRAPPED

PROMPT =================================================================================================================
PROMPT >> REPORTE DE INCIDENCIAS CRITICAS DETECTADAS POR REAL-TIME ADDM (Últimos Eventos)
PROMPT =================================================================================================================

SELECT 
    h.report_id,
    TO_CHAR(h.period_start_time, 'YYYY-MM-DD HH24:MI:SS') AS period_start,
    h.instance_number AS inst,
       REGEXP_SUBSTR(h.report_summary, 'id_desc="([^"]+)"', 1, 1, 'in', 1) AS trigger_reason,
       REGEXP_SUBSTR(h.report_summary, 'impact="([^"]+)"', 1, 1, 'in', 1) AS impact,
       REGEXP_SUBSTR(h.report_summary, 'impact_desc="([^"]+)"', 1, 1, 'in', 1) AS impact_desc
FROM 
    dba_hist_reports h
WHERE 
    h.component_name = 'perf'
ORDER BY 
    h.period_start_time DESC
FETCH FIRST 20 ROWS ONLY;

SET FEEDBACK ON
