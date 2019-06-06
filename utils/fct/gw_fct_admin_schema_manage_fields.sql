/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2700

DROP FUNCTION IF EXISTS SCHEMA_NAME.gw_fct_admin_manage_fields();
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_admin_manage_fields() RETURNS void AS
$BODY$

/*
SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${
"client":{"lang":"ES"}, 
"data":{"action":"ADD","table":"arc", "column":"addvalue", "dataType":"varchar(16)", "isUtils":True}}$$)

SELECT SCHEMA_NAME.gw_fct_admin_manage_fields($${
"client":{"lang":"ES"}, 
"data":{"action":"RENAME","table":"arc", "column":"addvalue", "newName":"_addvalue"}}$$)
*/


DECLARE 
	v_schemaname varchar;
	v_project_type text;
	v_schemautils boolean;
	v_action text;
	v_table text;
	v_column text;
	v_datatype text;
	v_isutils boolean;
	v_newname text;

BEGIN 

	-- search path
	SET search_path = "SCHEMA_NAME", public;
	
	-- Looking for project type
	SELECT wsoftware INTO v_project_type FROM version LIMIT 1;
	
	v_schemaname := "SCHEMA_NAME";
	
	v_action = (p_data->>'data')::json->>'action';
	v_table = (p_data->>'data')::json->>'table';
	v_column = (p_data->>'data')::json->>'column';
	v_datatype = (p_data->>'data')::json->>'dataType';
	v_isutils = (p_data->>'data')::json->>'isUtils';
	v_newname = (p_data->>'data')::json->>'newName';

	IF v_isutils THEN
	
		v_schemautils = (SELECT value::boolean FROM config_param_system WHERE parameter='sys_schema_utils');
	
	END IF;
	
	IF v_action='ADD' THEN
	
		EXECUTE 'ALTER TABLE '|| quote_ident(v_table) ||' ADD COLUMN '||quote_ident(v_column)||' '||v_datatype;
		
	ELSIF v_action='RENAME' THEN
	
		EXECUTE 'ALTER TABLE '|| quote_ident(v_table) ||' RENAME COLUMN '||quote_ident(v_column)||' TO '||quote_ident(v_newname);

	END IF;

RETURN ;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;