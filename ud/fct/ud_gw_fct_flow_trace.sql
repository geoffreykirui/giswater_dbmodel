/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2218

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_flow_trace(character varying);
CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_flow_trace(p_data json)  
RETURNS json AS 

$BODY$

/*
example:
SELECT SCHEMA_NAME.gw_fct_flow_trace($${
"client":{"device":4, "infoType":1, "lang":"ES"},
"feature":{"id":["20607"]},
"data":{}}$$)

--fid: 220,221;

*/

DECLARE 

v_result_json json;
v_qmllinepath text;
v_qmlpointpath text;
v_result json;
v_result_info text;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_error_context text;
v_version text;
v_status text;
v_level integer;
v_message text;
v_audit_result text;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	-- Reset values
	DELETE FROM anl_arc WHERE cur_user="current_user"() AND (fid = 221 OR fid = 220);
	DELETE FROM anl_node WHERE cur_user="current_user"() AND (fid = 221 OR fid = 220);

	-- select version
	SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

	-- Compute the tributary area using recursive function
	EXECUTE 'SELECT gw_fct_flow_trace_recursive($$'||p_data||'$$);'
	INTO v_result_json;

	IF (v_result_json->>'status')::TEXT = 'Accepted' THEN

		IF v_audit_result is null THEN
			v_status = 'Accepted';
			v_level = 3;
			v_message = 'Flow trace done successfully';
		ELSE

			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
			SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

		END IF;

		v_result_info := COALESCE(v_result, '{}'); 
		v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

		v_result_polygon = '{"geometryType":"", "features":[]}';
		v_result_line = '{"geometryType":"", "features":[]}';
		v_result_point = '{"geometryType":"", "features":[]}';

		--  Return
		RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
				   ',"body":{"form":{}'||
				   ',"data":{ "info":'||v_result_info||','||
					  '"setVisibleLayers":["v_anl_flow_arc","v_anl_flow_node","v_anl_flow_connec","v_anl_flow_gully"]'||','||
					  '"point":'||v_result_point||','||
					  '"line":'||v_result_line||','||
					  '"polygon":'||v_result_polygon||'}'||
					 '}'
			  '}')::json;
	ELSE 
		RETURN v_result_json;
	END IF;

	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

