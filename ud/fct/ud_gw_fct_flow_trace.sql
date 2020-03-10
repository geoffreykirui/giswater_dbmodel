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
"client":{"device":3, "infoType":100, "lang":"ES"},
"feature":{"id":["20607"]},
"data":{}}$$)
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
    DELETE FROM anl_flow_node WHERE cur_user="current_user"() AND context='Flow trace';
    DELETE FROM anl_flow_arc WHERE cur_user="current_user"() AND context='Flow trace' ; 
    DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id = 120; 
    
    -- select version
    SELECT giswater INTO v_version FROM version order by 1 desc limit 1;

    --select default geometry style
    SELECT regexp_replace(row(value)::text, '["()"]', '', 'g') INTO v_qmllinepath FROM config_param_user 
    WHERE parameter='qgis_qml_linelayer_path' AND cur_user=current_user;

    SELECT regexp_replace(row(value)::text, '["()"]', '', 'g') INTO v_qmlpointpath FROM config_param_user 
    WHERE parameter='qgis_qml_pointlayer_path' AND cur_user=current_user;

   -- Compute the tributary area using recursive function
    EXECUTE 'SELECT gw_fct_flow_trace_recursive($$'||p_data||'$$);'
    INTO v_result_json;
    
    IF (v_result_json->>'status')::TEXT = 'Accepted' THEN

IF v_audit_result is null THEN
        v_status = 'Accepted';
        v_level = 3;
        v_message = 'Arc fusion done successfully';
    ELSE

        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'status')::text INTO v_status; 
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'level')::integer INTO v_level;
        SELECT ((((v_audit_result::json ->> 'body')::json ->> 'data')::json ->> 'info')::json ->> 'message')::text INTO v_message;

    END IF;

      v_result_info := COALESCE(v_result, '{}'); 
      v_result_info = concat ('{"geometryType":"", "values":',v_result_info, '}');

      --points
      v_result = null;
      SELECT jsonb_agg(features.feature)  INTO v_result
      FROM (
      SELECT jsonb_build_object(
       'type',       'Feature',
      'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
      'properties', to_jsonb(row) - 'the_geom'
      ) AS feature
      FROM (SELECT id, node_id, node_type, expl_id, context, cur_user, the_geom
      FROM  anl_flow_node WHERE cur_user="current_user"() AND context='Flow trace'
      UNION
      SELECT id, node_id, nodecat_id, expl_id, 'Flow trace', cur_user, the_geom
      FROM  anl_node WHERE cur_user="current_user"() AND fprocesscat_id = 120) row) features;
      
      v_result := COALESCE(v_result, '{}'); 
      v_result_point = concat ('{"geometryType":"Point", "qmlPath":"',v_qmlpointpath,'", "features":',v_result,',"category_field":"node_type","size":2}'); 

      v_result = null;
      
      SELECT jsonb_agg(features.feature) INTO v_result
      FROM (
      SELECT jsonb_build_object(
       'type',       'Feature',
      'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
      'properties', to_jsonb(row) - 'the_geom'
      ) AS feature
      FROM (SELECT id, arc_id, arc_type, expl_id, context, cur_user, the_geom
      FROM  anl_flow_arc WHERE cur_user="current_user"() AND context='Flow trace' ) row) features;

      v_result := COALESCE(v_result, '{}'); 
      v_result_line = concat ('{"geometryType":"Point", "qmlPath":"',v_qmllinepath,'", "features":',v_result,'}'); 
      v_result_polygon = '{"geometryType":"", "features":[]}';

  --  Return
      RETURN ('{"status":"'||v_status||'", "message":{"level":'||v_level||', "text":"'||v_message||'"}, "version":"'||v_version||'"'||
               ',"body":{"form":{}'||
               ',"data":{ "info":'||v_result_info||','||
                  '"setVisibleLayers":[]'||','||
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

