﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2314

drop function if exists SCHEMA_NAME.gw_fct_pg2epa(character varying, boolean)  ;
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa(result_id_var character varying, p_use_networkgeom boolean, p_isrecursive boolean)  
RETURNS integer AS 
$BODY$

/*EXAMPLE
 SELECT SCHEMA_NAME.gw_fct_pg2epa('test1', false, false, false)  
*/

DECLARE



rec_options 	record;
valve_rec	record;
check_count_aux integer;
v_mandatory_nodarc boolean = false;
      
BEGIN

--  Search path
    SET search_path = "SCHEMA_NAME", public;

	SELECT * INTO rec_options FROM inp_options;

	RAISE NOTICE 'Starting pg2epa process.';
	
	IF p_isrecursive IS TRUE THEN
		-- Modify the contourn conditions to dynamic recursive strategy
		
	END IF;

	-- Upsert on rpt_cat_table
	DELETE FROM rpt_cat_result WHERE result_id=result_id_var;
	INSERT INTO rpt_cat_result (result_id) VALUES (result_id_var);
	
	-- Upsert on node rpt_inp result manager table
	DELETE FROM inp_selector_result WHERE cur_user=current_user;
	INSERT INTO inp_selector_result (result_id, cur_user) VALUES (result_id_var, current_user);

	
	IF p_use_networkgeom IS FALSE THEN
		-- Fill inprpt tables
		PERFORM gw_fct_pg2epa_fill_data(result_id_var);
	END IF;
	
	-- Update demand values filtering by dscenario
	PERFORM gw_fct_pg2epa_dscenario(result_id_var);

	IF p_use_networkgeom IS FALSE THEN
		-- Calling for gw_fct_pg2epa_nod2arc function
		PERFORM gw_fct_pg2epa_nod2arc(result_id_var, v_mandatory_nodarc);
			
		-- Calling for gw_fct_pg2epa_pump_additional function;
		PERFORM gw_fct_pg2epa_pump_additional(result_id_var);

		-- Check data quality
		SELECT gw_fct_pg2epa_check_data(result_id_var) INTO check_count_aux;	
	END IF;

	-- Real values of demand if rtc is enabled;
	IF rec_options.rtc_enabled IS TRUE THEN
		PERFORM gw_fct_pg2epa_rtc(result_id_var);
	END IF;

	-- Calling for modify the valve status
	PERFORM gw_fct_pg2epa_valve_status(result_id_var, v_mandatory_nodarc);
	
	-- Calling for the export function
	PERFORM gw_fct_utils_csv2pg_export_epanet_inp(result_id_var);
	
	IF p_isrecursive IS TRUE THEN
		DELETE FROM temp_csv2pg WHERE csv2pgcat_id=35, source=result_id_var 
			WHERE csv1 IN (SELECT csv1 FROM temp_csv2pg WHERE csv2pgcat_id=35 AND source=result_id_var LIMIT 1); 
		IF (SELECT count(*) FROM temp_csv2pg WHERE csv2pgcat_id=35 AND source=result_id_var)>0 THEN
			RETURN 1;
		ELSE
			RETURN 0;
		END IF;
	END IF;
	
RETURN 0;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;