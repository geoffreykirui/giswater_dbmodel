﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2642

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_api_setvisitmanager(p_data json)
  RETURNS json AS
$BODY$

/*EXAMPLE

--ONLY UPDATE ARE POSSIBLE. 
SELECT "SCHEMA_NAME".gw_api_setvisitmanager($${"client":{"device":3, "infoType":100, "lang":"ES"}, 
"feature":{"featureType":"visit", "tableName":"ve_visit_user_manager", "idName":"user_id", "id":"geoadmin"}, 
"data":{"fields":{"team_id":4, "vehicle_id":2, "starttime":"2019-01-01", "endtime":null},
"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}$$)
*/

DECLARE
	v_tablename text;
	v_apiversion text;
	v_id text;
	v_outputparameter json;
	v_insertresult json;
	v_message json;
	v_feature json;

BEGIN

-- Set search path to local schema
    SET search_path = "SCHEMA_NAME", public;

--  get api version
    EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
        INTO v_apiversion;
		
-- fix diferent ways to say null on client
	p_data = REPLACE (p_data::text, '"NULL"', 'null');
	p_data = REPLACE (p_data::text, '"null"', 'null');
	p_data = REPLACE (p_data::text, '""', 'null');
		
--  get input values
    v_id = ((p_data ->>'feature')::json->>'id')::text;
    v_feature = '{"featureType":"visit", "tableName":"ve_visit_user_manager", "idName":"user_id", "id":"'||current_user||'"}';


-- set output parameter
	v_outputparameter := concat('{"client":',((p_data)->>'client'),', "feature":',v_feature, ', "data":',((p_data)->>'data'),'}')::json;

	RAISE NOTICE '--- UPDATE VISIT MANAGER USING % ---',v_outputparameter;

		--setting the update
		PERFORM gw_api_setfields (v_outputparameter);

		-- getting message
		SELECT gw_api_getmessage(v_feature, 50) INTO v_message;

		RAISE NOTICE '--- UPDATE VISIT gw_api_setfields USING v_id % WITH MESSAGE: % ---', v_id, v_message;

				  
--    Return
    RETURN ('{"status":"Accepted", "message":'||v_message||', "apiVersion":'|| v_apiversion ||
    	    ', "body": {"feature":{"id":"'||v_id||'"}}}')::json;    

--    Exception handling
   -- EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || to_json(SQLERRM) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    

      

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
