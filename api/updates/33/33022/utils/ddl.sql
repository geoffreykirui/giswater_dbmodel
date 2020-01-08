/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/01/07
DROP VIEW IF EXISTS ve_config_addfields;
ALTER TABLE config_api_form_fields DROP COLUMN isreload;
ALTER TABLE config_api_form_fields ADD COLUMN reload_field json;
