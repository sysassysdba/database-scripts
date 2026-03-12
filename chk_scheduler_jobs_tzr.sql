set echo off
set verify off
SET FEEDBACK OFF
set line 300



col owner format a6
col job_name format a25
col program_name format a26
col enabled format a3 head 'ENA|BLE' 
col start_date format a42 head 'START DATE'
col next_run_date format a42 head 'NEXT RUN DATE'
col last_start_date format a42 head 'LAST START DATE'
col repeat_interval format a26 head 'REPEAT INTERVAL' word_wrapped
col last_run_duration format a14 head 'LAST RUN|DURATION|DD:HH:MM:SS' 
col run_count format 99,999 head 'RUN|COUNT'
col retry_count format 9999 head 'RETRY|COUNT'
col max_runs format 999,999 head 'MAX|RUNS'
col job_action format a33 head 'CODE' word_wrapped
col state format a9



select 
	owner
	, job_name
		,START_DATE
	--, state
	, case enabled
		when 'TRUE' then 'YES'
		when 'FALSE' then 'NO'
		end enabled
	-- last_run_duration is an interval
	, lpad(nvl(extract (day from last_run_duration ),'00'),2,'0')
		|| ':' || lpad(nvl(extract (hour from last_run_duration ),'00'),2,'0')
		|| ':' || lpad(nvl(extract (minute from last_run_duration ),'00'),2,'0')
		|| ':' || ltrim(to_char(nvl(extract (second from last_run_duration ),0),'09.90'))
		last_run_duration
		,next_run_date,
		last_start_date
	, run_count
	--, max_runs
	, retry_count
	/*, job_action*/
	,schedule_type
	, repeat_interval
	--, state
from DBA_SCHEDULER_JOBS
order by OWNER,last_start_date;



set verify on
SET FEEDBACK On
