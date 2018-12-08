﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


CREATE OR REPLACE FUNCTION ws_sample.gw_api_setfeatureinsert(p_data json)
  RETURNS json AS
$BODY$

/* example
visit:
SELECT ws_sample.gw_api_setfeatureinsert('{"client":{"device":3, "infoType":100, "lang":"ES"}, 
	"feature":{"featureType":"arc", "tableName":"ve_visit_multievent_x_arc", "id":null, "idname": "visit_id"}, 
	"data":{"fields":{"class_id":6, "arc_id":"2001", "visitcat_id":1, "ext_code":"testcode", "sediments_arc":10, "desperfectes_arc":1, "neteja_arc":3},
		"deviceTrace":{"xcoord":8597877, "ycoord":5346534, "compass":123}}}')

feature:
SELECT ws_sample.gw_api_setfeatureinsert($${
"client":{"device":9, "infoType":100, "lang":"ES"},
"form":{},
"feature":{"tableName":"ve_node_t", "id":"1251521"},
"data":{"fields":{"macrosector_id": "1", "sector_id": "2", "nodecat_id":"JUNCTION DN63", "dma_id":"2","undelete": "False", "inventory": "False", 
"epa_type": "JUNCTION", "state": "3", "arc_id": "113854", "publish": "False", "verified": "TO REVIEW",
"expl_id": "1", "builtdate": "2018/11/29", "muni_id": "2", "workcat_id": "22", "buildercat_id": "builder1", "enddate": "2018/11/29", 
"soilcat_id": "soil1", "ownercat_id": "owner1", "workcat_id_end": "22", "the_geom":"0101000020E7640000C66DDE79D9961941A771508A59755151"}}}$$)
*/

DECLARE
--    Variables
    v_device integer;
    v_infotype integer;
    v_tablename text;
    v_id  character varying;
    v_fields json;
    v_columntype character varying;
    v_querytext varchar;
    v_columntype_id character varying;
    v_apiversion json;
    v_text text[];
    v_jsonfield json;
    text text;
    i integer=1;
    v_field text;
    v_value text;
    v_return text;
    v_schemaname text;
    v_featuretype text;
    v_epsg integer;
    v_newid text;
    v_idname text;

BEGIN
	--    Set search path to local schema
	SET search_path = "ws_sample", public;
	v_schemaname = 'ws_sample';
	
	-- Get paramters
	EXECUTE 'SELECT epsg FROM version' INTO v_epsg;
	--  get api version
	EXECUTE 'SELECT row_to_json(row) FROM (SELECT value FROM config_param_system WHERE parameter=''ApiVersion'') row'
		INTO v_apiversion;
       
	-- Get input parameters:
	v_device := (p_data ->> 'client')::json->> 'device';
	v_infotype := (p_data ->> 'client')::json->> 'infoType';
	v_featuretype := (p_data ->> 'feature')::json->> 'featureType';
	v_tablename := (p_data ->> 'feature')::json->> 'tableName';
	v_id := (p_data ->> 'feature')::json->> 'id';
	v_idname := (p_data ->> 'feature')::json->> 'idname';
	v_fields := ((p_data ->> 'data')::json->> 'fields')::json;

	select array_agg(row_to_json(a)) into v_text from json_each(v_fields)a;

	-- query text, step1
	v_querytext := 'INSERT INTO ' || quote_ident(v_tablename) ||'(';

	-- query text, step2
	i=1;
	FOREACH text IN ARRAY v_text 
	LOOP
		SELECT v_text [i] into v_jsonfield;
		v_field:= (SELECT (v_jsonfield ->> 'key')) ;
		v_value := (SELECT (v_jsonfield ->> 'value')) ; -- getting v_value in order to prevent null values
		IF v_value !='null' OR v_value !='NULL' THEN 

			--building the query text
			IF i=1 THEN
				v_querytext := concat (v_querytext, quote_ident(v_field));
			ELSIF i>1 THEN
				v_querytext := concat (v_querytext, ', ', quote_ident(v_field));
			END IF;

			i=i+1;
		END IF;
	END LOOP;
	
	-- query text, step3
	v_querytext := concat (v_querytext, ') VALUES (');
	
	-- query text, step4
	i=1;
	FOREACH text IN ARRAY v_text 
	LOOP
		SELECT v_text [i] into v_jsonfield;
		v_field:= (SELECT (v_jsonfield ->> 'key')) ;
		v_value := (SELECT (v_jsonfield ->> 'value')) ;
		-- Get column type
		EXECUTE 'SELECT data_type FROM information_schema.columns  WHERE table_schema = $1 AND table_name = ' || quote_literal(v_tablename) || ' AND column_name = $2'
			USING v_schemaname, v_field
			INTO v_columntype;

		-- control column_type
		IF v_columntype IS NULL THEN
			v_columntype='text';
		END IF;
			
		-- control geometry fields
		IF v_field ='the_geom' OR v_field ='geom' THEN 
			v_columntype='geometry';
		END IF;

		IF v_value !='null' OR v_value !='NULL' THEN 
			
			IF v_field in ('geom', 'the_geom') THEN			
				v_value := (SELECT ST_SetSRID((v_value)::geometry, 25831));				
			END IF;
			--building the query text
			IF i=1 THEN
				v_querytext := concat (v_querytext, quote_literal(v_value),'::',v_columntype);
			ELSIF i>1 THEN
				v_querytext := concat (v_querytext, ', ',  quote_literal(v_value),'::',v_columntype);
			END IF;

			i=i+1;
		END IF;
	END LOOP;

	RAISE NOTICE 'v_querytext %', v_querytext;

	-- query text, final step
	v_querytext := concat (v_querytext,' ) RETURNING ',quote_ident(v_idname));
	
	RAISE NOTICE 'v_querytext %', v_querytext;
	
	-- execute query text
	EXECUTE v_querytext INTO v_newid;

--    Return
    RETURN ('{"status":"Accepted", "message":{"priority":1, "text":"demo message"}, "apiVersion":'|| v_apiversion ||
	    ', "body": {"feature":{"tableName":"'||v_tablename||'", "id":"'||v_newid||'"}}}')::json;    

--    Exception handling
  --  EXCEPTION WHEN OTHERS THEN 
    --    RETURN ('{"status":"Failed","message":' || (to_json(SQLERRM)) || ', "apiVersion":'|| v_apiversion ||',"SQLSTATE":' || to_json(SQLSTATE) || '}')::json;    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION ws_sample.gw_api_setfeatureinsert(json)
  OWNER TO geoadmin;
