/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2430

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_epa_check_data(text);
DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_epa_check_data(json);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_check_data(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE
SELECT gw_fct_pg2epa_check_data($${"data":{"parameters":{"fprocesscatId":127}}}$$)-- when is called from go2epa_main
SELECT gw_fct_pg2epa_check_data('{"parameters":{}}')-- when is called from toolbox or from checkproject

*/


DECLARE
v_record record;
v_project_type text;
v_count	integer;
v_result text;
v_version text;
v_result_info json;
v_result_point json;
v_result_line json;
v_result_polygon json;
v_querytext text;
v_result_id text;
v_defaultdemand	float;
v_qmlpointpath text = '';
v_qmllinepath text = '';
v_qmlpolpath text = '';
v_error_context text;
v_fprocesscat_id integer;

BEGIN

	--  Search path	
	SET search_path = "SCHEMA_NAME", public;

	-- getting input data 	
	v_result_id := ((p_data ->>'data')::json->>'parameters')::json->>'resultId'::text;
	v_fprocesscat_id := ((p_data ->>'data')::json->>'parameters')::json->>'fprocesscatId'::text;
	
	-- select config values
	SELECT wsoftware, giswater  INTO v_project_type, v_version FROM version order by 1 desc limit 1 ;

	SELECT value INTO v_qmlpointpath FROM config_param_user WHERE parameter='qgis_qml_pointlayer_path' AND cur_user=current_user;
	SELECT value INTO v_qmllinepath FROM config_param_user WHERE parameter='qgis_qml_linelayer_path' AND cur_user=current_user;
	SELECT value INTO v_qmlpolpath FROM config_param_user WHERE parameter='qgis_qml_pollayer_path' AND cur_user=current_user;

	-- init variables
	v_count=0;
	IF v_fprocesscat_id is null THEN
		v_fprocesscat_id = 125;
	END IF;

	-- delete old values on result table
	DELETE FROM audit_check_data WHERE fprocesscat_id = 125 AND user_name=current_user;
	DELETE FROM anl_node WHERE fprocesscat_id IN (7, 87, 64, 65, 66, 67, 70, 71, 98) AND cur_user=current_user;
	DELETE FROM anl_arc WHERE fprocesscat_id IN (88, 129, 130) AND cur_user=current_user;
	

	-- Header
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 4, 'CHECK GIS DATA QUALITY ACORDING EPA ROLE');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 4, '----------------------------------------------------------');

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 3, 'CRITICAL ERRORS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 3, '----------------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 2, 'WARNINGS');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 2, '--------------');	

	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 1, 'INFO');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 1, '-------');	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 0, 'NETWORK ANALYTICS');
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 0, '-------------------------');	


	RAISE NOTICE '1 - Check orphan nodes (fprocesscat = 7)';
	v_querytext = '(SELECT node_id, nodecat_id, the_geom FROM (SELECT node_id FROM v_edit_node EXCEPT 
			(SELECT node_1 as node_id FROM v_edit_arc UNION SELECT node_2 FROM v_edit_arc))a JOIN v_edit_node USING (node_id)
			JOIN inp_selector_sector USING (sector_id) WHERE cur_user = current_user) b';		
			
	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 7, node_id, nodecat_id, ''Orphan node'', 
		the_geom FROM ', v_querytext);
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 3, concat('ERROR: There is/are ',v_count,' node''s orphan. Take a look on temporal for details.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 1, 'INFO: No node(s) orphan found.');
	END IF;

			
	RAISE NOTICE '2 - Check nodes with state_type isoperative = false (fprocesscat = 87)';
	v_querytext = 'SELECT node_id, nodecat_id, the_geom FROM v_edit_node n JOIN inp_selector_sector USING (sector_id) JOIN value_state_type ON value_state_type.id=state_type 
			WHERE n.state > 0 AND is_operative IS FALSE AND cur_user = current_user';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, descript, the_geom) SELECT 87, node_id, nodecat_id, ''nodes 
		with state_type isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (v_fprocesscat_id, 2, concat('WARNING: There is/are ',v_count,' node(s) with state > 0 and state_type.is_operative on FALSE. Please, check your 
		data before continue. ()'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=87 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 1, 'INFO: No nodes with state > 0 AND state_type.is_operative on FALSE found.');
	END IF;
		
		
	RAISE NOTICE '3 - Check arcs with state_type isoperative = false (fprocesscat = 88)';
	v_querytext = 'SELECT arc_id, arccat_id, the_geom FROM v_edit_arc a JOIN inp_selector_sector USING (sector_id) 
			JOIN value_state_type ON value_state_type.id=state_type WHERE a.state > 0 AND is_operative IS FALSE AND cur_user = current_user';
	
	EXECUTE concat('SELECT count(*) FROM (',v_querytext,')a') INTO v_count;
	IF v_count > 0 THEN
		EXECUTE concat ('INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, descript, the_geom) SELECT 88, arc_id, arccat_id, ''arcs with state_type 
		isoperative = false'', the_geom FROM (', v_querytext,')a');
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 2, concat('WARNING: There is/are ',v_count,' arc(s) with state > 0 and state_type.is_operative on FALSE. Please, check your data before 
		continue'));
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 2, concat('SELECT * FROM anl_arc WHERE fprocesscat_id=88 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 1, 'INFO: No arcs with state > 0 AND state_type.is_operative on FALSE found.');
	END IF;
	
	RAISE NOTICE '4 - Check state_type nulls (arc, node)';
	v_querytext = '(SELECT arc_id, arccat_id, the_geom FROM v_edit_arc JOIN inp_selector_sector USING (sector_id) WHERE state_type IS NULL AND cur_user = current_user
			UNION 
			SELECT node_id, nodecat_id, the_geom FROM v_edit_node JOIN inp_selector_sector USING (sector_id) WHERE state_type IS NULL AND cur_user = current_user) a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (v_fprocesscat_id, 3, concat('ERROR: There is/are ',v_count,' topologic features (arc, node) with state_type with NULL values. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 1, 'INFO: No topologic features (arc, node) with state_type NULL values found.');
	END IF;

	RAISE NOTICE '5 - Check for missed features on inp tables';
	v_querytext = '(SELECT arc_id FROM arc WHERE arc_id NOT IN (SELECT arc_id from inp_pipe UNION SELECT arc_id FROM inp_virtualvalve) AND state > 0 
			AND epa_type !=''NOT DEFINED'' UNION SELECT node_id FROM node WHERE node_id 
			NOT IN (select node_id from inp_shortpipe UNION select node_id from inp_valve UNION select node_id from inp_tank 
			UNION select node_id FROM inp_reservoir UNION select node_id FROM inp_pump UNION SELECT node_id from inp_inlet 
			UNION SELECT node_id from inp_junction) AND state >0 AND epa_type !=''NOT DEFINED'') a';

	EXECUTE concat('SELECT count(*) FROM ',v_querytext) INTO v_count;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id,  criticity, error_message) 
		VALUES (v_fprocesscat_id, 3, concat('ERROR: There is/are ',v_count,' missed features on inp tables. Please, check your data before continue'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, 1, 'INFO: No features missed on inp_tables found.');
	END IF;

	
	RAISE NOTICE '6 - Null elevation control (fprocesscat 64)';
	SELECT count(*) INTO v_count FROM v_edit_node JOIN inp_selector_sector USING (sector_id) WHERE elevation IS NULL AND cur_user = current_user;
		
	IF v_count > 0 THEN
		INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom) 
		SELECT 64, node_id, nodecat_id, the_geom FROM v_edit_node WHERE result_id=v_result_id AND elevation IS NULL;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,' node(s) without elevation. Take a look on temporal table for details.'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: No nodes with null values on field elevation have been found.');
	END IF;

	
	RAISE NOTICE '7 - Elevation control with cero values (fprocesscat 65)';
	SELECT count(*) INTO v_count FROM v_edit_node JOIN inp_selector_sector USING (sector_id) WHERE elevation = 0 AND cur_user = current_user;

	IF v_count > 0 THEN
		INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom, descript) 
		SELECT 65, node_id, nodecat_id, the_geom, 'Elevation with cero' FROM v_edit_node WHERE elevation=0;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ',v_count,' node(s) with elevation=0. For more info you can type:'));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=65 AND cur_user=current_user'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: No nodes with ''0'' on field elevation have been found.');
	END IF;
	

	RAISE NOTICE '8 - Node2arcs with more than two arcs (fprocesscat 66)';
	INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom, descript)
	SELECT 66, a.node_id, a.nodecat_id, a.the_geom, 'Node2arc with more than two arcs' FROM (
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node
		JOIN inp_selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user)
		UNION ALL
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node
		JOIN inp_selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_2 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('SHORTPIPE', 'VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user))a
	GROUP by node_id, nodecat_id, the_geom
	HAVING count(*) >2;
	
	SELECT count(*) INTO v_count FROM anl_node WHERE fprocesscat_id=66 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,' node2arcs with more than two arcs. It''s impossible to continue. For more info you can type:'));
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: No results founded looking for node2arc(s) with more than two arcs.');
	END IF;
	

	RAISE NOTICE '9 - Mandatory node2arcs with less than two arcs (fprocesscat 67)';
	INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom, descript)
	SELECT 67, a.node_id, a.nodecat_id, a.the_geom, 'Node2arc with less than two arcs' FROM (
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node
		JOIN inp_selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user)
		UNION ALL
		SELECT node_id, nodecat_id, v_edit_node.the_geom FROM v_edit_node
		JOIN inp_selector_sector USING (sector_id) 
		JOIN v_edit_arc a1 ON node_id=a1.node_1 WHERE cur_user = current_user
		AND v_edit_node.epa_type IN ('VALVE', 'PUMP') AND a1.sector_id IN (SELECT sector_id FROM inp_selector_sector WHERE cur_user=current_user))a
	GROUP by node_id, nodecat_id, the_geom
	HAVING count(*) < 2;


	SELECT count(*) INTO v_count FROM anl_node WHERE fprocesscat_id=67 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ',
		v_count,' node2arc(s) with less than two arcs. All of them have been transformed to nodarc using only arc joined. For more info you can type: '));
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 2, concat('SELECT * FROM anl_node WHERE fprocesscat_id=67 AND cur_user=current_user'));
	ELSE 
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: No results founded looking for node2arc(s) with less than two arcs.');
	END IF;

	
	RAISE NOTICE '10 - Check sense of cv pipes only to warning to user about the sense of the geometry (69)';
	INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, the_geom)
	SELECT 69, arc_id, arccat_id, the_geom FROM v_edit_inp_pipe WHERE status='CV';

	SELECT count(*) INTO v_count FROM anl_arc WHERE fprocesscat_id=69 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ',
		v_count,' CV pipes. Be carefull with the sense of pipe and check that node_1 and node_2 are on the right direction to prevent reverse flow.'));
	ELSE 
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: No results found for CV pipes');
	END IF;

	
	RAISE NOTICE '11 - Check to arc on valves, at least arc_id exists as closest arc (fprocesscat 70)';
	INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom, descript)
	select 70, node_id, nodecat_id, the_geom, 'To arc is null or does not exists as closest arc for valve' FROM v_edit_inp_valve WHERE node_id NOT IN(
		select node_id FROM v_edit_inp_valve JOIN v_edit_inp_pipe on arc_id=to_arc AND node_id=node_1
		union
		select node_id FROM v_edit_inp_valve JOIN v_edit_inp_pipe on arc_id=to_arc AND node_id=node_2);
	
	SELECT count(*) INTO v_count FROM anl_node WHERE fprocesscat_id=70 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ', v_count,' valve(s) without to_arc value according with the two closest arcs. Take a look on temporal table to know details.'));
	ELSE 
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 
		'INFO: to_arc values checked for valves. It exists and it''s one of  closest arcs.');
	END IF;


	RAISE NOTICE '12 - Valve_type';
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE valv_type IS NULL;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat(
		'ERROR: There is/are ',v_count,' valve(s) with null values on valv_type column.'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Valve type checked. No mandatory values missed.');
	END IF;
	
	RAISE NOTICE '13 - Valve status & others';					
	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE status IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat(
		'ERROR: There is/are ',v_count,' valve(s) with null values at least on mandatory columns for valve (valv_type, status, to_arc).'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Valve status checked. No mandatory values missed.');
	END IF;


	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='PBV' OR valv_type='PRV' OR valv_type='PSV') AND (pressure IS NULL));
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat(
		'ERROR: There is/are ',v_count,' PBV-PRV-PSV valve(s) with null values at least on mandatory on the mandatory column for Pressure valves.'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: PBC-PRV-PSV valves checked. No mandatory values missed.');
	END IF;				

	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='GPV') AND (curve_id IS NULL));
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat(
		'ERROR: There is/are ',v_count,' GPV valve(s) with null values at least on mandatory on the mandatory column for General purpose valves.'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: GPV valves checked. No mandatory values missed.');
	END IF;	

	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='TCV'));
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,' TCV valve(s) with null values at least on mandatory column for Losses Valves.'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: TCV valves checked. No mandatory values missed.');
	END IF;				

	SELECT count(*) INTO v_count FROM v_edit_inp_valve WHERE ((valv_type='FCV') AND (flow IS NULL));
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,' FCV valve(s) with null values at least on mandatory column for Flow Control Valves.'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: FCV valves checked. No mandatory values missed.');
	END IF;		
	

	RAISE NOTICE '14 - Check to arc on pumps, at least arc_id exists as closest arc (fprocesscat 71)';
	INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom, descript)
	select 71, node_id, nodecat_id , the_geom,  'To arc is null or does not exists as closest arc for pump' FROM v_edit_inp_pump WHERE node_id NOT IN(
		select node_id FROM v_edit_inp_pump JOIN v_edit_inp_pipe on arc_id=to_arc AND node_id=node_1
		union
		select node_id FROM v_edit_inp_pump JOIN v_edit_inp_pipe on arc_id=to_arc AND node_id=node_2);
	
	SELECT count(*) INTO v_count FROM anl_node WHERE fprocesscat_id=71 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ', v_count,' pump(s) without to_arc value according with closest arcs. Take a look on temporal table to know details.'));
	ELSE 
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 
		'INFO: to_arc values checked for pumps. It exists and it''s one of the closest arcs.');
	END IF;
	
	
	RAISE NOTICE '15 - pumps. Pump type and others';	

	-- pump type
	SELECT count(*) INTO v_count FROM v_edit_inp_pump WHERE pump_type IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,' pump''s with null values on pump_type column).'));					
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Pumps checked. No mandatory values for pump_type missed.');
	END IF;
	
	--pump curve
	SELECT count(*) INTO v_count FROM v_edit_inp_pump WHERE curve_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat(
		'ERROR: There is/are ',v_count,' pump(s) with null values at least on mandatory column curve_id.'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Pumps checked. No mandatory values for curve_id missed.');
	END IF;	


	--pump additional
	SELECT count(*) INTO v_count FROM inp_pump_additional JOIN v_edit_inp_pump USING (node_id) WHERE inp_pump_additional.curve_id IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, table_id, column_id, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat(
		'ERROR: There is/are ',v_count,' additional pump(s) with null values at least on mandatory column curve_id.'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Additional pumps checked. No mandatory values for curve_id missed.');
	END IF;	
	
	
	RAISE NOTICE '16 - Check pipes with less than 0.2 mts (fprocesscat 129)';
	SELECT count(*) INTO v_count FROM (SELECT st_length(the_geom) AS length FROM v_edit_inp_pipe) a WHERE length < 0.20;

	IF v_count > 0 THEN
		INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, the_geom, descript)
		SELECT 129, arc_id, arcccat_id , the_geom, concat('Length: ', (st_length(the_geom))::numeric (12,3)) where st_length(the_geom) < 0.2;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 2, concat('WARNING: There is/are ',v_count,
		' pipe(s) with length less than 0.2 meters. Check it before continue.'));
		v_count=0;
		
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1,  'INFO: Standard minimun length checked. No values less than 0.2 meters missed.');
	END IF;
	
	
	RAISE NOTICE '17 - Check pipes with less than 0.05 mts (fprocesscat 130)';
	SELECT count(*) INTO v_count FROM (SELECT st_length(the_geom) AS length FROM v_edit_inp_pipe) a WHERE length < 0.05;

	IF v_count > 0 THEN
		INSERT INTO anl_arc (fprocesscat_id, arc_id, arccat_id, the_geom, descript)
		SELECT 130, arc_id, arcccat_id , the_geom, concat('Length: ', (st_length(the_geom))::numeric (12,3)) where st_length(the_geom) < 0.05;
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('WARNING: There is/are ',v_count,
		' pipe(s) with length less than 0.05 meters. Check it before continue.'));
		v_count=0;
		
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1,  'INFO: Crítical minimun length checked. No values less than 0.2 meters missed.');
	END IF;
	
	
	RAISE NOTICE '18 - Check roughness catalog for pipes';
	SELECT count(*) INTO v_count FROM v_edit_inp_pipe JOIN cat_arc ON id = arccat_id JOIN inp_cat_mat_roughness USING  (matcat_id)
	WHERE init_age IS NULL OR end_age IS NULL OR roughness IS NULL;

	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat('ERROR: There is/are ',v_count,
		' pipe(s) with null values for roughness. Check roughness catalog columns (init_age,end_age,roughness) before continue.'));
		v_count=0;
		
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1,  'INFO: Roughness catalog checked. No mandatory values missed.');
	END IF;
	
	
	RAISE NOTICE '19 - Check dint value for catalog of arcs';
	SELECT count(*) INTO v_count FROM cat_arc WHERE dint IS NULL;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat(
		'ERROR: There is/are ',v_count,' register(s) on arc''s catalog with null values on dint column).'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Dint for arc''s catalog checked. No mandatory values missed.');
	END IF;
	
	
	RAISE NOTICE '20 - tanks (fprocesscat 98)';
	INSERT INTO anl_node (fprocesscat_id, node_id, nodecat_id, the_geom, descript)
	select 98, a.node_id, nodecat_id, the_geom, 'Tanks with null mandatory values' FROM v_edit_inp_tank a
	WHERE (initlevel IS NULL) OR (minlevel IS NULL) OR (maxlevel IS NULL) OR (diameter IS NULL) OR (minvol IS NULL);
	
	SELECT count(*) FROM anl_node INTO v_count WHERE fprocesscat_id=98 AND cur_user=current_user;
	IF v_count > 0 THEN
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 3, concat(
		'ERROR: There is/are ',v_count,' tank(s) with null values at least on mandatory columns for tank (initlevel, minlevel, maxlevel, diameter, minvol).Take a look on temporal table to details'));
		v_count=0;
	ELSE
		INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) 
		VALUES (v_fprocesscat_id, v_result_id, 1, 'INFO: Tanks checked. No mandatory values missed.');
	END IF;		
	
	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 4, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 3, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 2, '');	
	INSERT INTO audit_check_data (fprocesscat_id, result_id, criticity, error_message) VALUES (125, v_result_id, 1, '');	
	
	-- get results
	-- info
	SELECT array_to_json(array_agg(row_to_json(row))) INTO v_result 
	FROM (SELECT id, error_message as message FROM audit_check_data WHERE user_name="current_user"() 
	AND fprocesscat_id=v_fprocesscat_id order by criticity desc, id asc) row; 
	v_result := COALESCE(v_result, '{}'); 
	v_result_info = concat ('{"geometryType":"", "values":',v_result, '}');
	
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
	FROM  anl_node WHERE cur_user="current_user"() AND fprocesscat_id IN (7, 64, 65, 66, 67, 70, 71, 87, 98)) row) features;

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
	FROM (SELECT id, arc_id, arccat_id, state, expl_id, descript, the_geom, fprocesscat_id
	FROM  anl_arc WHERE cur_user="current_user"() AND fprocesscat_id IN (88, 129, 130)) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_line = concat ('{"geometryType":"LineString", "qmlPath":"',v_qmllinepath,'", "features":',v_result,'}'); 

	--polygons
	v_result = null;
	SELECT jsonb_agg(features.feature) INTO v_result
	FROM (
	SELECT jsonb_build_object(
	'type',       'Feature',
	'geometry',   ST_AsGeoJSON(the_geom)::jsonb,
	'properties', to_jsonb(row) - 'the_geom'
	) AS feature
	FROM (SELECT id, pol_id, pol_type, state, expl_id, descript, the_geom
	FROM  anl_polygon WHERE cur_user="current_user"() AND fprocesscat_id =14) row) features;

	v_result := COALESCE(v_result, '{}'); 
	v_result_polygon = concat ('{"geometryType":"Polygon","qmlPath":"',v_qmlpolpath,'", "features":',v_result, '}');

	--    Control nulls
	v_result_info := COALESCE(v_result_info, '{}'); 
	v_result_point := COALESCE(v_result_point, '{}'); 
	v_result_line := COALESCE(v_result_line, '{}'); 
	v_result_polygon := COALESCE(v_result_polygon, '{}'); 

	--  Return
	RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"Data quality analysis done succesfully"}, "version":"'||v_version||'"'||
		',"body":{"form":{}'||
			',"data":{"info":'||v_result_info||','||
				'"point":'||v_result_point||','||
				'"line":'||v_result_line||','||
				'"polygon":'||v_result_polygon||','||
				'"setVisibleLayers":[] }'||
			'}'||
		'}')::json;

	--  Exception handling
	EXCEPTION WHEN OTHERS THEN
	GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;