/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2848

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_result(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"gw_check_project","fprocesscatId":127, "dumpSubcatchments":true}}}$$) when is called from go2epa_main from toolbox
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_result($${"data":{"parameters":{"resultId":"gw_check_project"}}}$$) -- when is called from toolbox

*/

DECLARE
v_fprocesscat_id integer;
v_record record;
v_project_type text;
v_count	integer;
v_count_2 integer;
v_infiltration text;
v_scenario text;
v_min_node2arc float;
v_saveondatabase boolean;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_nodearc_real float;
v_nodearc_user float;
v_result_id text;
v_min numeric (12,4);
v_max numeric (12,4);
v_headloss text;
v_demandtype integer;
v_patternmethod integer;
v_period text;
v_networkmode integer;
v_valvemode integer;
v_demandtypeval text;
v_patternmethodval text;
v_periodval text;
v_valvemodeval text;
v_networkmodeval text;
v_hydrologyscenario text;
v_qualitymode text;
v_qualmodeval text;
v_buildupmode int2;
v_buildmodeval text;
v_usenetworkgeom boolean;
v_usenetworkdemand boolean;
v_defaultdemand	float;
v_qmlpointpath text = '';
v_qmllinepath text = '';
v_qmlpolpath text = '';
v_doublen2a integer;
v_curvedefault text;
v_options json;
v_error_context text;

v_dumpsubc boolean;
v_hydroscenario text;
v_checkresult boolean;

v_debug boolean;
v_debugval text;


BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fprocesscat_id := ((p_data ->>'data')::json->>'parameters')::json->>'fprocesscatId';
	v_dumpsubc := ((p_data ->>'data')::json->>'parameters')::json->>'dumpSubcatchments';

	-- get system values
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1 ;

	-- get user values
	v_checkresult = (SELECT (value::json->>'debug')::json->>'checkResult' FROM config_param_user 
	WHERE parameter='inp_options_settings' AND cur_user=current_user)::boolean;

	
	-- manage no found results
	IF (SELECT result_id FROM rpt_cat_result WHERE result_id=v_result_id) IS NULL THEN
		v_result  = (SELECT array_to_json(array_agg(row_to_json(row))) FROM (SELECT 1::integer as id, 'No result found whith this name....' as  message)row);
		v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
		RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"No result found"}, "version":"'||v_version||'"'||
			',"body":{"form":{}, "data":{"info":'||v_result_info||',"setVisibleLayers":[] }}}')::json;		
	END IF; 
		
	-- init variables
	v_count=0;
	IF v_fprocesscat_id is null THEN
		v_fprocesscat_id = 14;
	END IF;
	
	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id = 14 AND user_name=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id IN (59) AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fprocesscat_id IN (3) AND cur_user=current_user;

	-- get user parameters
	v_hydroscenario = (SELECT hydrology_id FROM inp_selector_hydrology WHERE cur_user = current_user);

	-- get settings values
	v_debug = (SELECT value::json->>'showLog' FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);
	v_debugval = (SELECT value FROM config_param_user WHERE parameter = 'inp_options_debug' AND cur_user=current_user);
	

	-- Header
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('CHECK RESULT WITH CURRENT USER-OPTIONS ACORDING EPA RULES'));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, '---------------------------------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 1, '-------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Result id: ', v_result_id));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Created by: ', current_user, ', on ', to_char(now(),'YYYY-MM-DD HH-MM-SS')));
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Hidrology scenario:', v_hydroscenario));	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Dump subcatchments: ',v_dumpsubc::text));		
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Default values: ', 'Values from options dialog have been choosed'));
	

	IF v_checkresult THEN
		
		IF v_debug::boolean THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, concat('Debug: ', v_defaultval));
		END IF;
		
		RAISE NOTICE '1- Check subcatchments';
		SELECT count(*) INTO v_count FROM v_edit_subcatchment WHERE outlet_id is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column outlet_id column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column oulet_id on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where rg_id is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column rg_id column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column rg_id on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where area is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column area column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column area on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where width is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column width column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column width on subcatchment table have been checked without any values missed.'));
		END IF;
		
		SELECT count(*) INTO v_count FROM v_edit_subcatchment where slope is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column slope column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column slope on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where clength is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column clength column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column clength on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where nimp is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column nimp column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column nimp on subcatchment table have been checked without any values missed.'));
		END IF;
		
		SELECT count(*) INTO v_count FROM v_edit_subcatchment where nperv is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column nperv column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column nperv on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where simp is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column simp column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column simp on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where sperv is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column sperv column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column sperv on subcatchment table have been checked without any values missed.'));
		END IF;
		
		SELECT count(*) INTO v_count FROM v_edit_subcatchment where zero is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column zero column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column zero on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT count(*) INTO v_count FROM v_edit_subcatchment where routeto is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column routeto column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column routeto on subcatchment table have been checked without any values missed.'));
		END IF;

		
		SELECT count(*) INTO v_count FROM v_edit_subcatchment where rted is null;
		IF v_count > 0 THEN
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory column rted column.'));
			v_count=0;
		ELSE
			INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
			VALUES (14, v_result_id, 1, concat('INFO: Column rted on subcatchment table have been checked without any values missed.'));
		END IF;

		SELECT infiltration INTO v_infiltration FROM cat_hydrology JOIN inp_selector_hydrology
		ON inp_selector_hydrology.hydrology_id=cat_hydrology.hydrology_id WHERE cur_user=current_user;
		
		IF v_infiltration='CURVE_NUMBER' THEN
		
			SELECT count(*) INTO v_count FROM v_edit_subcatchment where (curveno is null) 
			OR (conduct_2 is null) OR (drytime_2 is null);
			
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,	' subcatchment(s) with null values on mandatory columns of curve number infiltartion method (curveno, conduct_2, drytime_2).'));
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat(' Acording EPA SWMM user''s manual, conduct_2 is deprecated, but anywat need to be informed. Any value is valid because always will be ignored by SWMM.'));
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 	
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory columns for ''CURVE_NUMBER'' infiltration method on subcatchment table (curveno, conduct_2, drytime_2) have been checked without any values missed.'));
			END IF;
		
		ELSIF v_infiltration='GREEN_AMPT' THEN
		
			SELECT count(*) INTO v_count FROM v_edit_subcatchment where (suction is null) 
			OR (conduct_ยก is null) OR (initdef is null);
			
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory columns of Green-Apt infiltartion method (suction, conduct, initdef).'));
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory columns for ''GREEN_AMPT'' infiltration method on subcatchment table (suction, conduct, initdef) have been checked without any values missed.'));
			END IF;
		
		
		ELSIF v_infiltration='HORTON' OR v_infiltration='MODIFIED_HORTON' THEN
		
			SELECT count(*) INTO v_count FROM v_edit_subcatchment where (maxrate is null) 
			OR (minrate is null) OR (decay is null) OR (drytime is null) OR (maxinfil is null);
			
			IF v_count > 0 THEN
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 3, concat('ERROR: There is/are ',v_count,' subcatchment(s) with null values on mandatory columns of Horton/Horton modified infiltartion method (maxrate, minrate, decay, drytime, maxinfil).'));
				v_count=0;
			ELSE
				INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
				VALUES (14, v_result_id, 1, concat('INFO: All mandatory columns for ''MODIFIED_HORTON'' infiltration method on subcatchment table (maxrate, minrate, decay, drytime, maxinfil) have been checked without any values missed.'));
			END IF;
			
		END IF;
	
	END IF;
	
	-- insert spacers for log
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 1, '');	

	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id=v_fprocesscat_id 
	order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	-- control nulls
	v_options := COALESCE(v_options, '{}'); 
	v_result_info := COALESCE(v_result_info, '{}'); 

	--points
	v_result = null;
	
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	SELECT jsonb_build_object(
	 'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT id, node_id, nodecat_id, state, expl_id, descript,fprocesscat_id, the_geom 
	FROM  anl_node WHERE cur_user="current_user"() AND fprocesscat_id = 999) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "qmlPath":"',v_qmlpointpath,'", "features":',v_result, '}'); 

	IF v_fprocesscat_id::text = 127::text THEN
		v_result_point = '{}';
	END IF;
	
	-- Control nulls
	v_result_point := COALESCE(v_result_point, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"options":'||v_options||','||
				'"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"setVisibleLayers":[] }'||
			'}'||
		'}')::json;

	-- Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;