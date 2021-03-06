/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_repair_epatype(p_data json)
  RETURNS json AS
$BODY$

/* example

SELECT SCHEMA_NAME.gw_fct_pg2epa_repair_epatype($${"client":{"device":4, "infoType":1, "lang":"ES"}}$$);

SELECT * FROM SCHEMA_NAME.audit_check_data where fid = 214 AND criticity  > 1 order by id

*/

DECLARE
v_version text;
v_error_context text;
v_projecttype text;
v_affectrow integer;
v_fid integer = 214;
v_criticity integer = 0;

rec_feature record;

BEGIN


	-- Set search path to local schema
	SET search_path = "SCHEMA_NAME", public;
	
	--  get version
	SELECT project_type, giswater INTO v_projecttype, v_version FROM sys_version;

	-- delete auxiliar tables
	DELETE FROM audit_check_data WHERE fid = v_fid;
	
	IF v_projecttype  = 'WS' THEN
	
		-- remove possible mistakes for epa_table on cat_feature
		UPDATE cat_feature_node SET epa_table = 'inp_reservoir' WHERE epa_default  ='RESERVOIR';
		UPDATE cat_feature_node SET epa_table = 'inp_tank' WHERE epa_default  ='TANK';
		UPDATE cat_feature_node SET epa_table = 'inp_inlet' WHERE epa_default  ='INLET';
		UPDATE cat_feature_node SET epa_table = 'inp_valve' WHERE epa_default  ='VALVE';
		UPDATE cat_feature_node SET epa_table = 'inp_junction' WHERE epa_default  ='JUNCTION';
		UPDATE cat_feature_node SET epa_table = 'inp_pump' WHERE epa_default  ='PUMP';
		UPDATE cat_feature_node SET epa_table = 'inp_shortpipe' WHERE epa_default  ='SHORTPIPE';

		UPDATE cat_feature_arc SET epa_table = 'inp_pipe' WHERE epa_default  ='PIPE';
		UPDATE cat_feature_arc SET epa_table = 'inp_virtualvalve' WHERE epa_default  ='VIRTUALVALVE';
		UPDATE cat_feature_arc SET epa_table = 'inp_pump_importinp' WHERE epa_default  ='PUMP-IMPORTINP';
		UPDATE cat_feature_arc SET epa_table = 'inp_valve_importinp' WHERE epa_default  ='VALVE-IMPORTINP';

		FOR rec_feature IN 
		SELECT DISTINCT ON (cat_feature_node.id) cat_feature_node.*, cat_node.id as nodecat_id FROM cat_node JOIN cat_feature_node ON cat_node.nodetype_id = cat_feature_node.id 
		JOIN cat_feature ON cat_feature_node.id = cat_feature.id
		WHERE epa_default != 'NOT DEFINED' AND cat_feature.active = true
		LOOP

			-- check if exists features with this cat_feature
			UPDATE node SET epa_type = epa_type FROM cat_node WHERE nodetype_id = rec_feature.id AND state > 0 AND cat_node.id = nodecat_id;
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow = 0 THEN 
				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (v_fid, 2, concat(rec_feature.id,': No features are on inventory with this cat_feature. If you do not uses, we recommend to disable it (cat_feature.active = false)'));
			END IF;
		
			-- update epa_type
			UPDATE node SET epa_type = rec_feature.epa_default FROM cat_node WHERE nodetype_id = rec_feature.id AND state > 0 AND cat_node.id = nodecat_id AND epa_type != rec_feature.epa_default;
			
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': UPDATE node SET epa_type = ',quote_literal(rec_feature.epa_default),' WHERE nodecat_id = ''', rec_feature.id,''' AND state > 0 - ',v_affectrow, ' ROWS' ));
		
			-- insert missed features on inp tables
			EXECUTE 'INSERT INTO '||quote_ident(rec_feature.epa_table)||' (node_id)   
				SELECT node_id FROM node LEFT JOIN (SELECT node_id FROM '||quote_ident(rec_feature.epa_table)||' ) b USING (node_id)
				WHERE nodecat_id = '||quote_literal(rec_feature.nodecat_id)||'  AND b.node_id IS NULL AND state >0	
				ON CONFLICT (node_id) DO NOTHING';
				
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': INSERT INTO ',rec_feature.epa_table, ' - ', v_affectrow, ' ROWS'));

		END LOOP;

		-- delete
		FOR rec_feature IN 
		SELECT DISTINCT ON (epa_default) * FROM cat_feature_node
		LOOP
			-- delete wrong features on inp tables
			EXECUTE 'DELETE FROM '||quote_ident(rec_feature.epa_table)||' WHERE node_id NOT IN (SELECT node_id FROM node WHERE epa_type = '||quote_literal(rec_feature.epa_default)||' AND state >0)';
		
			GET DIAGNOSTICS v_affectrow = row_count;

			RAISE NOTICE 'rec_feature % afected row %', rec_feature, v_affectrow;

			
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': DELETE FROM ',rec_feature.epa_table,' - ',v_affectrow, ' ROWS'));
			
		END LOOP;

		FOR rec_feature IN 
		SELECT DISTINCT ON (cat_feature_arc.id) cat_feature_arc.*, cat_arc.id as arccat_id FROM cat_arc JOIN cat_feature_arc ON cat_arc.arctype_id = cat_feature_arc.id 
		JOIN cat_feature ON cat_feature_arc.id = cat_feature.id
		WHERE epa_default != 'NOT DEFINED' AND cat_feature.active = true
		LOOP

			-- check if exists features with this cat_feature
			UPDATE arc SET epa_type = epa_type FROM cat_arc WHERE arctype_id = rec_feature.id AND state > 0 AND cat_arc.id = arccat_id;
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow = 0 THEN 
				INSERT INTO audit_check_data (fid,  criticity, error_message)
				VALUES (v_fid, 2, concat(rec_feature.id,': No features are on inventory with this cat_feature. If you do not uses, we recommend to disable it (cat_feature.active = false)'));
			END IF;
		
			-- update epa_type
			UPDATE arc SET epa_type = rec_feature.epa_default FROM cat_arc WHERE arctype_id = rec_feature.id AND state > 0 AND cat_arc.id = arccat_id AND epa_type != rec_feature.epa_default;
			
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': UPDATE arc SET epa_type = ',quote_literal(rec_feature.epa_default),' WHERE arccat_id = ''', rec_feature.id,''' AND state > 0 - ',v_affectrow, ' ROWS' ));
		
			-- insert missed features on inp tables
			EXECUTE 'INSERT INTO '||quote_ident(rec_feature.epa_table)||' (arc_id)   
				SELECT arc_id FROM arc LEFT JOIN (SELECT arc_id FROM '||quote_ident(rec_feature.epa_table)||' ) b USING (arc_id)
				WHERE arccat_id = '||quote_literal(rec_feature.arccat_id)||'  AND b.arc_id IS NULL AND state >0	
				ON CONFLICT (arc_id) DO NOTHING';
				
			GET DIAGNOSTICS v_affectrow = row_count;
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': INSERT INTO ',rec_feature.epa_table, ' - ', v_affectrow, ' ROWS'));

		END LOOP;

		-- delete
		FOR rec_feature IN 
		SELECT DISTINCT ON (epa_default) * FROM cat_feature_arc
		LOOP
			-- delete wrong features on inp tables
			EXECUTE 'DELETE FROM '||quote_ident(rec_feature.epa_table)||' WHERE arc_id NOT IN (SELECT arc_id FROM arc WHERE epa_type = '||quote_literal(rec_feature.epa_default)||' AND state >0)';
		
			GET DIAGNOSTICS v_affectrow = row_count;

			RAISE NOTICE 'rec_feature % afected row %', rec_feature, v_affectrow;

			
			IF v_affectrow > 0 THEN v_criticity = 2; ELSE v_criticity = 1; END IF;
			INSERT INTO audit_check_data (fid,  criticity, error_message)
			VALUES (v_fid, v_criticity, concat(rec_feature.id,': DELETE FROM ',rec_feature.epa_table,' - ',v_affectrow, ' ROWS'));
			
		END LOOP;

		-- connec
		INSERT INTO inp_connec
		SELECT connec_id FROM connec WHERE state > 0 
		ON CONFLICT (connec_id) DO NOTHING;

	ELSE 









	
		
	END IF;
	     
	-- Return
	RETURN '{"status":"Accepted"}';


	-- Exception handling
	--EXCEPTION WHEN OTHERS THEN
	--GET STACKED DIAGNOSTICS v_error_context = PG_EXCEPTION_CONTEXT;
	--RETURN ('{"status":"Failed","NOSQLERR":' || to_json(SQLERRM) || ',"SQLSTATE":' || to_json(SQLSTATE) ||',"SQLCONTEXT":' || to_json(v_error_context) || '}')::json;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


