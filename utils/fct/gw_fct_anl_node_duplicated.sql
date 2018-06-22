﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2108


CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_fct_anl_node_duplicated() RETURNS void AS $BODY$
DECLARE
    rec_node record;
    node_duplicated_tolerance_aux double precision;

BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    -- Get data from config table
    node_duplicated_tolerance_aux=(SELECT "value" FROM config_param_system WHERE "parameter"='connec_duplicated_tolerance');
    
    -- Reset values
    DELETE FROM anl_node WHERE cur_user="current_user"() AND fprocesscat_id=6;
		
		
    -- Computing process
    INSERT INTO anl_node (node_id, nodecat_id, state, node_id_aux, nodecat_id_aux, state_aux, expl_id, fprocesscat_id, the_geom)
    SELECT DISTINCT t1.node_id, t1.nodecat_id, t1.state, t2.node_id, t2.nodecat_id, t2.state, t1.expl_id, 6, t1.the_geom
    FROM node AS t1 JOIN node AS t2 ON ST_Dwithin(t1.the_geom, t2.the_geom,(node_duplicated_tolerance_aux)) 
    WHERE t1.node_id != t2.node_id  
    ORDER BY t1.node_id;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
  
