/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE node_type SET isexitupperintro = 0 WHERE type NOT IN ('STORAGE','CHAMBER');
UPDATE node_type SET isexitupperintro = 2 WHERE type IN ('STORAGE','CHAMBER');

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('rpt_selector_timestep', 'Hydraulic selector', 'Selector of an alternative result (to compare with other results)', 'role_epa', 0, 'role_epa', false);

INSERT INTO audit_cat_table(id, context, descript, sys_role_id, sys_criticity, qgis_role_id, isdeprecated) 
VALUES ('rpt_selector_timestep_compare', 'Hydraulic selector', 'Selector of an alternative result (to compare with other results)', 'role_epa', 0, 'role_epa', false);