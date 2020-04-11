/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/
-- The code of this inundation function have been provided by Enric Amat (FISERSA)


--FUNCTION CODE: 2680

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_pg2epa_inlet_flowtrace(text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_network(p_data json)
RETURNS json AS
$BODY$

/*
--EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_network('{"data":{"parameters":{"resultId":"gw_check_project","fprocesscatId":127}}}')::json; -- when is called from toolbox
SELECT SCHEMA_NAME.gw_fct_pg2epa_check_network('{"data":{"parameters":{"resultId":"gw_check_project"}}}')::json; -- when is called from toolbox

--RESULTS
SELECT arc_id FROM anl_arc WHERE fprocesscat_id=39 AND cur_user=current_user
SELECT node_id FROM anl_node WHERE fprocesscat_id=39 AND cur_user=current_user
SELECT * FROM temp_anlgraf;
*/


DECLARE
v_project_type text;
v_affectedrows numeric;
v_cont integer default 0;
v_buildupmode int2;
v_result_id text;
v_result json;
v_result_info json;
v_result_point json;
v_result_line json;
v_boundaryelem text;
v_error_context text;
v_fprocesscat_id integer;
v_querytext text;
v_count integer = 0;
v_min float;
v_max float;
v_qmllinepath text;
v_qmlpointpath text;
v_version text;

BEGIN
	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	--  Get input data
	v_result_id = ((p_data->>'data')::json->>'parameters')::json->>'resultId';
	
	-- get project type
	v_project_type = (SELECT wsoftware FROM version LIMIT 1);
	v_version = (SELECT giswater FROM version LIMIT 1);
	
	-- get user variables
	SELECT value INTO v_qmllinepath FROM config_param_user WHERE parameter='qgis_qml_linelayer_path' AND cur_user=current_user;
	SELECT value INTO v_qmlpointpath FROM config_param_user WHERE parameter='qgis_qml_pointlayer_path' AND cur_user=current_user;
	
	-- manage no results
	IF (SELECT result_id FROM rpt_cat_result LIMIT 1) IS NULL THEN	
		RAISE EXCEPTION 'You need to create a result before';
	END IF;
	
	-- elements
	IF v_project_type  = 'WS' THEN
			v_boundaryelem = 'tank or reservoir';
		ELSIF v_project_type  = 'UD' THEN
			v_boundaryelem = 'outfall';
	END IF;
	
	DELETE FROM temp_anlgraf;
	DELETE FROM anl_arc where cur_user=current_user AND fprocesscat_id IN (131,39);
	DELETE FROM anl_node where cur_user=current_user AND fprocesscat_id IN (128,39);
	DELETE FROM audit_check_data where user_name=current_user AND fprocesscat_id = 39;
		
	IF v_fprocesscat_id is null THEN
		v_fprocesscat_id = 39;
	END IF;
	
	-- Header
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 4, 'CHECK RESULT NETWORK ACORDING EPA RULES');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 4, '-------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 1, '-------');	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 0, 'NETWORK ANALYTICS');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 0, '-------------------------');	


	RAISE NOTICE '1 - Check result orphan nodes on rpt tables (fprocesscat = 128)';
	v_querytext = '(SELECT node_id, nodecat_id, the_geom FROM (
			SELECT node_id FROM rpt_inp_node WHERE sector_id > 0 AND result_id='||quote_literal(v_result_id)||' EXCEPT 
			(SELECT node_1 as node_id FROM rpt_inp_arc WHERE result_id='||quote_literal(v_result_id)||' UNION
			SELECT node_2 FROM rpt_inp_arc WHERE result_id='||quote_literal(v_result_id)||'))a
			JOIN rpt_inp_node USING (node_id)) b';
	
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0  THEN
		EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) 
		SELECT 128, node_id, nodecat_id, ''Orphan node'', the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 3, concat('ERROR: For this result there is/are ',v_count,
		' node''s orphan. Some inconsistency may have been generated because state_type.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 1, 'INFO: For this result no node(s) orphan found.');
	END IF;

	
	RAISE NOTICE '2 - Check result arcs without start/end node (fprocesscat = 131)';
	v_querytext = '	SELECT 131, arc_id, arccat_id, state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arcs without node_1 or node_2.'' FROM rpt_inp_arc 
			WHERE result_id='||quote_literal(v_result_id)||' 
			EXCEPT ( 
			SELECT 131, arc_id, arccat_id, state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arcs without node_1 or node_2.'' FROM rpt_inp_arc JOIN 
			(SELECT node_id FROM rpt_inp_node WHERE result_id='||quote_literal(v_result_id)||') a ON node_1=node_id 
			UNION 
			SELECT 131, arc_id, arccat_id, state, expl_id, the_geom, '||quote_literal(v_result_id)||', ''Arcs without node_1 or node_2.'' FROM rpt_inp_arc JOIN 
			(SELECT node_id FROM rpt_inp_node WHERE result_id='||quote_literal(v_result_id)||') b ON node_2=node_id
			WHERE result_id='||quote_literal(v_result_id)||')';

	EXECUTE 'SELECT count(*) FROM ('||v_querytext ||')a'
		INTO v_count;

	IF v_count > 0 THEN
		EXECUTE 'INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, state, expl_id, the_geom, result_id, descript)'||v_querytext;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: Fort this result there is/are ',v_count,
		' arc(s) without start/end nodes. Some inconsistency may have been generated because state_type.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1,'INFO: For this result there is/are no arcs without start/end nodes.');
	END IF;
	

	RAISE NOTICE '3 - Flow trace from inlets/outlets';	
	
	-- fill the graf table
	INSERT INTO temp_anlgraf (arc_id, node_1, node_2, water, flag, checkf)
	select  arc.arc_id, case when node_1 is null then '00000' else node_1 end, case when node_2 is null then '00000' else node_2 end, 0, 0, 0
	from rpt_inp_arc arc WHERE arc.result_id=v_result_id
	union all
	select  arc.arc_id, case when node_2 is null then '00000' else node_2 end, case when node_1 is null then '00000' else node_1 end, 0, 0, 0
	from rpt_inp_arc arc WHERE arc.result_id=v_result_id
	ON CONFLICT (arc_id, node_1) DO NOTHING;
	
	-- Delete from the graf table all that rows that only exists one time (it means that arc don't have the correct topology)
	DELETE FROM temp_anlgraf WHERE arc_id IN 
	(SELECT a.arc_id FROM (SELECT count(*) AS count, arc_id FROM temp_anlgraf GROUP BY 2 HAVING count(*)=1 ORDER BY 2)a);


	-- set boundary conditions of graf table
	IF v_project_type = 'WS' THEN
		UPDATE temp_anlgraf
			SET flag=1, water=1 
			WHERE node_1 IN (SELECT node_id FROM rpt_inp_node WHERE (epa_type='RESERVOIR' OR epa_type='INLET' OR epa_type='TANK') and result_id=v_result_id);
	ELSIF v_project_type = 'UD' THEN
		UPDATE temp_anlgraf
			SET flag=1, water=1 
			WHERE node_1 IN (SELECT node_id FROM rpt_inp_node WHERE (epa_type='OUTFALL') and result_id=v_result_id);
	END IF;
		
	-- inundation process
	LOOP
		v_cont = v_cont+1;
		update temp_anlgraf n set water= 1, flag=n.flag+1 from v_anl_graf a where n.node_1 = a.node_1 and n.arc_id = a.arc_id;
		GET DIAGNOSTICS v_affectedrows =row_count;
		EXIT WHEN v_affectedrows = 0;
		EXIT WHEN v_cont = 200;
	END LOOP;

	-- insert into result table dry arcs (water=0)
	INSERT INTO anl_arc (fprocesscat_id, result_id, arc_id, the_geom, descript)
	SELECT DISTINCT ON (a.arc_id) 39, v_result, a.arc_id, the_geom, concat('Arc disconnected from any', v_boundaryelem)  
		FROM temp_anlgraf a
		JOIN rpt_inp_arc b ON a.arc_id=b.arc_id
		GROUP BY a.arc_id,the_geom
		having max(water) = 0;
		
	-- insert into result table dry nodes (as they are extremal nodes from disconnected arcs, all it's ok)
	INSERT INTO anl_node (fprocesscat_id, result_id, node_id, the_geom, descript)
	SELECT 39, v_result_id, rpt_inp_arc.node_1, n.the_geom, concat('Node disconnected from any ', v_boundaryelem) FROM rpt_inp_arc JOIN anl_arc USING (arc_id) 
	JOIN rpt_inp_node n ON rpt_inp_arc.node_1=node_id WHERE fprocesscat_id=39 AND n.result_id = v_result_id AND cur_user=current_user UNION
	SELECT 39, v_result_id, rpt_inp_arc.node_2, n.the_geom, concat('Node disconnected from any ', v_boundaryelem) FROM rpt_inp_arc JOIN anl_arc USING (arc_id) 
	JOIN rpt_inp_node n ON rpt_inp_arc.node_2=node_id WHERE fprocesscat_id=39 AND n.result_id = v_result_id AND cur_user=current_user;
	
	SELECT count(*) FROM anl_arc INTO v_count WHERE fprocesscat_id=39 AND cur_user=current_user;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,' arc(s) totally disconnected from any ', v_boundaryelem));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, concat('INFO: No arcs founded disconected from any ', v_boundaryelem));
	END IF;


	RAISE NOTICE '4 - Stats';
	
	IF v_project_type =  'WS' THEN
		SELECT min(elevation), max(elevation) INTO v_min, v_max FROM v_edit_node WHERE sector_id IN (SELECT sector_id FROM inp_selector_sector 
		WHERE cur_user=current_user);
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 0, 
		concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(length), max(length) INTO v_min, v_max FROM vi_pipes;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 0, 
		concat('Data analysis for pipe length. Minimun and maximum values are: (',v_min,' - ',v_max,' ).'));
		
		SELECT min(diameter), max(diameter) INTO v_min, v_max FROM vi_pipes;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 0, 
		concat('Data analysis for pipe diameter. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(roughness), max(roughness) INTO v_min, v_max FROM vi_pipes;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (v_fprocesscat_id, v_result_id, 0, 
		concat('Data analysis for pipe roughness. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
	ELSIF v_project_type  ='UD' THEN
		
		SELECT min(length), max(length) INTO v_min, v_max FROM vi_conduits;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, 
		concat('Data analysis for conduit length. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(n), max(n) INTO v_min, v_max FROM vi_conduits;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, 
		concat('Data analysis for conduit manning roughness coeficient. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));

		SELECT min(z1), max(z1) INTO v_min, v_max FROM vi_conduits;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, 
		concat('Data analysis for conduit z1. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(z2), max(z2) INTO v_min, v_max FROM vi_conduits;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, 
		concat('Data analysis for conduit z2. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
	
		SELECT min(slope), max(slope) INTO v_min, v_max FROM v_edit_arc WHERE sector_id IN 
		(SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user);
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, 
		concat('Data analysis for conduit slope. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));
		
		SELECT min(sys_elev), max(sys_elev) INTO v_min, v_max FROM v_edit_node WHERE sector_id IN 
		(SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user);
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (14, v_result_id, 0, 
		concat('Data analysis for node elevation. Minimun and maximum values are: ( ',v_min,' - ',v_max,' ).'));	
	END IF;
	
	-- insert spacers on log	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (39, v_result_id, 1, '');	
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() AND fprocesscat_id = v_fprocesscat_id order by id) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');

	--points
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom_p'
		) AS feature
		FROM (SELECT id, node_id, arccat_id, state, expl_id, descript, fprocesscat_id, the_geom
			  FROM  anl_arc_x_node WHERE cur_user="current_user"() AND fprocesscat_id=39
			  UNION
			  SELECT id, node_id, nodecat_id, state, expl_id, descript, fprocesscat_id, the_geom
			  FROM  anl_node WHERE cur_user="current_user"() AND fprocesscat_id=128
		) row) features;
  	
	v_result := COALESCE(v_result, '{}'); 
	v_result_point = concat ('{"geometryType":"Point", "qmlPath":"',v_qmlpointpath,'", "features":',v_result, '}');
	
	--lines
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
  	SELECT jsonb_build_object(
		'type',       'Feature',
		'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
		'properties', to_jsonb(row) - 'the_geom'
		) AS feature
		FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript,fprocesscat_id, the_geom
			  FROM  anl_arc_x_node WHERE cur_user="current_user"() AND fprocesscat_id=39
			  UNION
			  SELECT id, arc_id, arccat_id, state, expl_id, descript,fprocesscat_id, the_geom
			  FROM  anl_arc WHERE cur_user="current_user"() AND fprocesscat_id=131
			 ) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "qmlPath":"',v_qmllinepath,'", "features":',v_result, '}'); 
	
	-- Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Analysis done successfully"}, "version":"'||v_version||'"'||
             ',"body":{"form":{}'||
		     ',"data":{ "info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"setVisibleLayers":[]'||
		       '}}'||
	    '}')::json;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
