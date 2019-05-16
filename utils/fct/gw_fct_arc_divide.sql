/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2114



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_arc_divide(node_id_arg character varying)
  RETURNS smallint AS

$BODY$
/*
SELECT "SCHEMA_NAME".gw_fct_arc_divide('1079');
*/
DECLARE
    node_geom    geometry;
    arc_id_aux    varchar;
    arc_geom    geometry;
    line1        geometry;
    line2        geometry;
    rec_aux        record;
    rec_aux1	"SCHEMA_NAME".v_edit_arc;
    rec_aux2    "SCHEMA_NAME".v_edit_arc;
    intersect_loc    double precision;
    numArcs    integer;
    rec_doc record;
    rec_visit record;
    project_type_aux text;
    state_aux integer;
    state_node_arg integer;
    gully_id_aux varchar;
    connec_id_aux varchar;
    count_aux1 smallint;
    count_aux2 smallint;
    return_aux smallint;
	arc_divide_tolerance_aux float =0.05;
	plan_arc_vdivision_dsbl_aux boolean;
	array_agg_connec varchar [];
	array_agg_gully varchar [];
	v_arc_searchnodes float;
    rec_node record;
    v_newarc varchar;



	
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;
	
	-- Get project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;
    
    -- Get node values
    SELECT the_geom INTO node_geom FROM node WHERE node_id = node_id_arg;
	SELECT state INTO state_node_arg FROM node WHERE node_id=node_id_arg;

    -- Get parameters from configs table
	SELECT value::boolean INTO plan_arc_vdivision_dsbl_aux FROM config_param_user WHERE "parameter"='plan_arc_vdivision_dsbl' AND cur_user=current_user; -- deprecated variable	  
	SELECT ((value::json)->>'value') INTO v_arc_searchnodes FROM config_param_system WHERE parameter='arc_searchnodes';

	-- State control
	IF state_aux=0 THEN
		PERFORM audit_function(1050,2114);
	ELSIF state_node_arg=0 THEN
		PERFORM audit_function(1052,2114);
	END IF;

	-- Check if it's a end/start point node in case of wrong topology without start or end nodes
	SELECT arc_id INTO arc_id_aux FROM v_edit_arc WHERE ST_DWithin(ST_startpoint(the_geom), node_geom, v_arc_searchnodes) OR ST_DWithin(ST_endpoint(the_geom), node_geom, v_arc_searchnodes) LIMIT 1;
	IF arc_id_aux IS NOT NULL THEN
		-- force trigger of topology in order to reconnect extremal nodes (in case of null's)
		UPDATE arc SET the_geom=the_geom WHERE arc_id=arc_id_aux;
		-- get another arc if exists
		SELECT arc_id INTO arc_id_aux FROM v_edit_arc WHERE ST_DWithin(the_geom, node_geom, v_arc_searchnodes) AND arc_id != arc_id_aux;
	END IF;

	-- For the specificic case of extremal node not reconnected due topology issues (i.e. arc state (1) and node state (2)

	-- Find closest arc inside tolerance
	SELECT arc_id, state, the_geom INTO arc_id_aux, state_aux, arc_geom  FROM v_edit_arc AS a 
	WHERE ST_DWithin(node_geom, a.the_geom, arc_divide_tolerance_aux) AND node_1 != node_id_arg AND node_2 != node_id_arg
	ORDER BY ST_Distance(node_geom, a.the_geom) LIMIT 1;

	IF arc_id_aux IS NOT NULL THEN 

		--  Locate position of the nearest point
		intersect_loc := ST_LineLocatePoint(arc_geom, node_geom);
		
		-- Compute pieces
		line1 := ST_LineSubstring(arc_geom, 0.0, intersect_loc);
		line2 := ST_LineSubstring(arc_geom, intersect_loc, 1.0);
	
		-- Check if any of the 'lines' are in fact a point
		IF (ST_GeometryType(line1) = 'ST_Point') OR (ST_GeometryType(line2) = 'ST_Point') THEN
			RETURN 1;
		END IF;
	
		-- Get arc data
		SELECT * INTO rec_aux1 FROM v_edit_arc WHERE arc_id = arc_id_aux;
		SELECT * INTO rec_aux2 FROM v_edit_arc WHERE arc_id = arc_id_aux;

		-- Update values of new arc_id (1)
		rec_aux1.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
		rec_aux1.code := rec_aux1.arc_id;
		rec_aux1.node_2 := node_id_arg ;-- rec_aux1.node_1 take values from original arc
		rec_aux1.the_geom := line1;

		-- Update values of new arc_id (2)
		rec_aux2.arc_id := nextval('SCHEMA_NAME.urn_id_seq');
		rec_aux2.code := rec_aux2.arc_id;
		rec_aux2.node_1 := node_id_arg; -- rec_aux2.node_2 take values from original arc
		rec_aux2.the_geom := line2;
		
		-- In function of states and user's variables proceed.....
		IF (state_aux=1 AND state_node_arg=1) THEN 
		
			-- Insert new records into arc table
			INSERT INTO v_edit_arc SELECT rec_aux1.*;
			INSERT INTO v_edit_arc SELECT rec_aux2.*;

			-- update node_1 and node_2 because it's not possible to pass using parameters
			UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
			UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;
			
			--Copy addfields from old arc to new arcs	
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
			SELECT 
			rec_aux2.arc_id,
			parameter_id,
			value_param
			FROM man_addfields_value WHERE feature_id=arc_id_aux;
			
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
			SELECT 
			rec_aux1.arc_id,
			parameter_id,
			value_param
			FROM man_addfields_value WHERE feature_id=arc_id_aux;
			
			-- update arc_id of disconnected nodes linked to old arc
			FOR rec_node IN SELECT node_id, the_geom FROM node WHERE arc_id=arc_id_aux
			LOOP
				UPDATE node SET arc_id=(SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(rec_node.the_geom, 
				v_edit_arc.the_geom,0.001) AND arc_id != arc_id_aux LIMIT 1) 
				WHERE node_id=rec_node.node_id;
			END LOOP;

			-- Capture linked feature information to redraw (later on this function)
			-- connec
			FOR connec_id_aux IN SELECT connec_id FROM connec JOIN link ON link.feature_id=connec_id WHERE link.feature_type='CONNEC' AND exit_type='VNODE' AND arc_id=arc_id_aux
			LOOP
				array_agg_connec:= array_append(array_agg_connec, connec_id_aux);
				UPDATE connec SET arc_id=NULL WHERE connec_id=connec_id_aux;
			END LOOP;
			
	
			-- gully
			IF project_type_aux='UD' THEN

				FOR gully_id_aux IN SELECT gully_id FROM gully JOIN link ON link.feature_id=gully_id WHERE link.feature_type='GULLY' AND exit_type='VNODE' AND arc_id=arc_id_auxº
				LOOP
					array_agg_gully:= array_append(array_agg_gully, gully_id_aux);
					UPDATE connec SET arc_id=NULL WHERE connec_id=connec_id_aux;
				END LOOP;
			END IF;
					
			-- Insert data into traceability table
			INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
			VALUES ('DIVIDE ARC',  arc_id_aux, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);
		
			-- Update elements from old arc to new arcs
			FOR rec_aux IN SELECT * FROM element_x_arc WHERE arc_id=arc_id_aux  LOOP
				DELETE FROM element_x_arc WHERE arc_id=arc_id_aux;
				INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux1.arc_id);
				INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux2.arc_id);
			END LOOP;
		
			-- Update documents from old arc to the new arcs
			FOR rec_aux IN SELECT * FROM doc_x_arc WHERE arc_id=arc_id_aux  LOOP
				DELETE FROM doc_x_arc WHERE arc_id=arc_id_aux;
				INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux1.arc_id);
				INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux2.arc_id);

			END LOOP;
		
			-- Update visits from old arc to the new arcs
			FOR rec_aux IN SELECT * FROM om_visit_x_arc WHERE arc_id=arc_id_aux  LOOP
				DELETE FROM om_visit_x_arc WHERE arc_id=arc_id_aux;
				INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),rec_aux.visit_id, rec_aux1.arc_id);
				INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),rec_aux.visit_id, rec_aux2.arc_id);

			END LOOP;

			-- Update arc_id on node
			FOR rec_aux IN SELECT * FROM node WHERE arc_id=arc_id_aux  LOOP

				-- find the new arc id
				SELECT arc_id INTO v_newarc FROM v_edit_arc AS a 
				WHERE ST_DWithin(rec_aux.the_geom, a.the_geom, 0.5) AND arc_id !=arc_id_aux ORDER BY ST_Distance(rec_aux.the_geom, a.the_geom) LIMIT 1;

				-- update values
				UPDATE node SET arc_id=v_newarc WHERE node_id=rec_aux.node_id;
					
			END LOOP;
			
			-- delete old arc
			DELETE FROM arc WHERE arc_id=arc_id_aux;

			-- reconnect links
			PERFORM gw_fct_connect_to_network(array_agg_connec, 'CONNEC');
			PERFORM gw_fct_connect_to_network(array_agg_gully, 'GULLY');
					
	
		ELSIF (state_aux=1 AND state_node_arg=2) THEN-- AND plan_arc_vdivision_dsbl_aux IS NOT TRUE) THEN 
			rec_aux1.state=2;
			rec_aux1.state_type=(SELECT value::smallint FROM config_param_system WHERE parameter='plan_statetype_ficticius');
			
			rec_aux2.state=2;
			rec_aux2.state_type=(SELECT value::smallint FROM config_param_system WHERE parameter='plan_statetype_ficticius');
			
			-- Insert new records into arc table
			UPDATE config SET arc_searchnodes_control='false';
			INSERT INTO v_edit_arc SELECT rec_aux1.*;
			INSERT INTO v_edit_arc SELECT rec_aux2.*;
			UPDATE config SET arc_searchnodes_control='true';

			-- update node_1 and node_2 because it's not possible to pass using parameters
			UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
			UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;

			-- Update doability for the new arcs
			UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux1.arc_id;
			UPDATE plan_psector_x_arc SET doable=FALSE where arc_id=rec_aux2.arc_id;
		
			-- Insert existig arc (on service) to the current alternative
			INSERT INTO plan_psector_x_arc (psector_id, arc_id, state, doable) VALUES (
			(SELECT value::smallint FROM config_param_user WHERE "parameter"='psector_vdefault' AND cur_user=current_user), arc_id_aux, 0, FALSE);

		-- deprecated
		--ELSIF (state_aux=1 AND state_node_arg=2) AND plan_arc_vdivision_dsbl_aux IS TRUE THEN
		--	PERFORM audit_function(1054,2114);
				
		ELSIF (state_aux=2 AND state_node_arg=2) THEN 
		
			-- Insert new records into arc table
			UPDATE config SET arc_searchnodes_control='false';
			INSERT INTO v_edit_arc SELECT rec_aux1.*;
			INSERT INTO v_edit_arc SELECT rec_aux2.*;
			UPDATE config SET arc_searchnodes_control='true';

			-- update node_1 and node_2 because it's not possible to pass using parameters
			UPDATE arc SET node_1=rec_aux1.node_1,node_2=rec_aux1.node_2 where arc_id=rec_aux1.arc_id;
			UPDATE arc SET node_1=rec_aux2.node_1,node_2=rec_aux2.node_2 where arc_id=rec_aux2.arc_id;
			
			--Copy addfields from old arc to new arcs	
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
			SELECT 
			rec_aux2.arc_id,
			parameter_id,
			value_param
			FROM man_addfields_value WHERE feature_id=arc_id_aux;
			
			INSERT INTO man_addfields_value (feature_id, parameter_id, value_param)
			SELECT 
			rec_aux1.arc_id,
			parameter_id,
			value_param
			FROM man_addfields_value WHERE feature_id=arc_id_aux;
			
			-- update arc_id of disconnected nodes linked to old arc
			FOR rec_node IN SELECT node_id, the_geom FROM node WHERE arc_id=arc_id_aux
			LOOP
				UPDATE node SET arc_id=(SELECT arc_id FROM v_edit_arc WHERE ST_DWithin(rec_node.the_geom, 
				v_edit_arc.the_geom,0.001) AND arc_id != arc_id_aux LIMIT 1) 
				WHERE node_id=rec_node.node_id;
			END LOOP;
						
			-- Insert data into traceability table
			INSERT INTO audit_log_arc_traceability ("type", arc_id, arc_id1, arc_id2, node_id, "tstamp", "user") 
			VALUES ('DIVIDE PLANIFIED JARC',  arc_id_aux, rec_aux1.arc_id, rec_aux2.arc_id, node_id_arg,CURRENT_TIMESTAMP,CURRENT_USER);
		
			-- Update elements from old arc to new arcs
			FOR rec_aux IN SELECT * FROM element_x_arc WHERE arc_id=arc_id_aux  LOOP
				INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux1.arc_id);
				INSERT INTO element_x_arc (id, element_id, arc_id) VALUES (nextval('element_x_arc_id_seq'),rec_aux.element_id, rec_aux2.arc_id);
				DELETE FROM element_x_arc WHERE arc_id=arc_id_aux;
			END LOOP;
		
			-- Update documents from old arc to the new arcs
			FOR rec_aux IN SELECT * FROM doc_x_arc WHERE arc_id=arc_id_aux  LOOP
				INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux1.arc_id);
				INSERT INTO doc_x_arc (id, doc_id, arc_id) VALUES (nextval('doc_x_arc_id_seq'),rec_aux.doc_id, rec_aux2.arc_id);
				DELETE FROM doc_x_arc WHERE arc_id=arc_id_aux;

			END LOOP;
		
			-- Update visits from old arc to the new arcs
			FOR rec_aux IN SELECT * FROM om_visit_x_arc WHERE arc_id=arc_id_aux  LOOP
				INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),rec_aux.visit_id, rec_aux1.arc_id);
				INSERT INTO om_visit_x_arc (id, visit_id, arc_id) VALUES (nextval('om_visit_x_arc_id_seq'),rec_aux.visit_id, rec_aux2.arc_id);
				DELETE FROM om_visit_x_arc WHERE arc_id=arc_id_aux;

			END LOOP;

			-- Update arc_id on node
			FOR rec_aux IN SELECT * FROM node WHERE arc_id=arc_id_aux  LOOP

				-- find the new arc id
				SELECT arc_id INTO v_newarc FROM v_edit_arc AS a 
				WHERE ST_DWithin(rec_aux.the_geom, a.the_geom, 0.5) AND arc_id !=arc_id_aux ORDER BY ST_Distance(rec_aux.the_geom, a.the_geom) LIMIT 1;

				-- update values
				UPDATE node SET arc_id=v_newarc WHERE node_id=rec_aux.node_id;
					
			END LOOP;
			
			-- delete old arc
			DELETE FROM arc WHERE arc_id=arc_id_aux;		

		ELSIF (state_aux=2 AND state_node_arg=1) THEN
			RETURN return_aux;		
		ELSE  
			PERFORM audit_function(2120,2114); 
			
		END IF;
	ELSE
		RETURN 0;
	END IF;

	
RETURN return_aux;
 

  END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;