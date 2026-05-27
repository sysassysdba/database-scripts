
SET ECHO OFF
SET FEEDBACK OFF
SET VERIFY OFF
SET LINESIZE 300
SET PAGESIZE 0
SET SERVEROUTPUT ON FORMAT WRAPPED

-- 2. Peticion de variable de entrada
PROMPT ==========================================================================================
ACCEPT v_dias NUMBER DEFAULT 1 PROMPT '>> Ingrese el numero de dias hacia atras a analizar [Por defecto: 1] -> '
PROMPT ==========================================================================================

-- 3. Extraccion del historial dinamico
DECLARE
  report CLOB := NULL;
BEGIN
  -- Usamos la variable de sustitucion &v_dias para el retroceso matematico
  report := DBMS_AUTO_INDEX.REPORT_ACTIVITY(
    activity_start => TO_TIMESTAMP(TO_CHAR(SYSDATE - &v_dias, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS'),
    activity_end   => TO_TIMESTAMP(TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS'), 'YYYY-MM-DD HH24:MI:SS'),
    type           => 'TEXT',
    section        => 'SUMMARY +INDEX_DETAILS +ERRORS',
    level          => 'TYPICAL'
  );
  
  DBMS_OUTPUT.PUT_LINE(report);
END;
/

-- 4. Restaurar entorno
SET PAGESIZE 100
SET FEEDBACK ON
