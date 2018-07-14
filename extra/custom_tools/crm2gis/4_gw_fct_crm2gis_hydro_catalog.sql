﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

-- ----------------------------
-- CRM FUNCTIONS
-- ----------------------------


CREATE OR REPLACE FUNCTION crm.gw_fct_crm2gis_hydro_catalog()
  RETURNS void AS
$BODY$DECLARE


BEGIN

    -- Search path
 
	-- period values
	INSERT INTO ws.ext_cat_period (id)
	SELECT id FROM crm.hydro_cat_period WHERE id NOT IN (SELECT id::integer FROM ws.ext_cat_period);

	-- state values
	INSERT INTO ws.ext_rtc_hydrometer_state (id, name, observ)
	SELECT id, code, observ FROM crm.hydro_val_state WHERE id NOT IN (SELECT id FROM ws.ext_rtc_hydrometer_state);
	
	
    RETURN;
        
END;

$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

  