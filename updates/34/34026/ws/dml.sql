/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2020/12/15
UPDATE config_param_system SET value = gw_fct_json_object_set_key(value::json, 'manageConflict', 'false'::text) WHERE parameter = 'utils_grafanalytics_status';

UPDATE config_form_tabs SET tabactions =
'[{"actionName":"actionEdit", "actionTooltip":"Edit",  "disabled":false},
{"actionName":"actionZoom", "actionTooltip":"Zoom In",  "disabled":false},
{"actionName":"actionCentered", "actionTooltip":"Center",  "disabled":false},
{"actionName":"actionZoomOut", "actionTooltip":"Zoom Out",  "disabled":false},
{"actionName":"actionCatalog", "actionTooltip":"Change Catalog",  "disabled":false},
{"actionName":"actionWorkcat", "actionTooltip":"Add Workcat",  "disabled":false},
{"actionName":"actionCopyPaste", "actionTooltip":"Copy Paste",  "disabled":false},
{"actionName":"actionLink", "actionTooltip":"Open Link",  "disabled":false},
{"actionName":"actionHelp", "actionTooltip":"Help",  "disabled":false},
{"actionName":"actionMapZone", "actionTooltip":"Add Mapzone",  "disabled":false},
{"actionName":"actionSetToArc", "actionTooltip":"Set to_arc",  "disabled":false},
{"actionName":"actionGetParentId", "actionTooltip":"Set parent_id",  "disabled":false},
{"actionName":"actionGetArcId", "actionTooltip":"Set arc_id",  "disabled":false},
{"actionName": "actionRotation", "actionTooltip": "Rotation","disabled": false}]' WHERE formname = 'v_edit_node';

DELETE FROM sys_function WHERE id = 2638;

DROP FUNCTION IF EXISTS gw_fct_utils_update_dma_hydroval();

INSERT INTO sys_table (id, descript, sys_role) VALUES ('temp_mincut', 'Temporal table for mincut analysis', 'role_om') ON CONFLICT (id) DO NOTHING;

INSERT INTO sys_param_user VALUES('inp_options_epaversion','hidden', 'EPA version', 'role_epa', null, 'EPA version', null,null, true, 37, 
'ud', false, null, null, null, false, 'text', 'linetext', true, null, '5.0.022', 'lyt_hydraulics_1', true, null, null, null, null, false, 
'{"from":"2.0.12", "to":null,"language":"english"}')
ON CONFLICT (id) DO NOTHING;
