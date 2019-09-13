/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 24/05/2019

UPDATE config_api_form_fields SET formtype='form' WHERE formname='printGeneric';


UPDATE sys_feature_cat SET shortcut_key = 'P' WHERE id = 'PUMP' AND tablename = 'v_edit_man_pump';
UPDATE cat_feature SET shortcut_key = concat('Alt+',sys_feature_cat.shortcut_key) FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'NODE';
UPDATE cat_feature SET shortcut_key = concat('Ctrl+',sys_feature_cat.shortcut_key) FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'CONNEC';
UPDATE cat_feature SET shortcut_key = sys_feature_cat.shortcut_key FROM sys_feature_cat WHERE sys_feature_cat.id = cat_feature.id and cat_feature.feature_type = 'ARC';


UPDATE config_param_system SET value = '{"sys_table_id":"v_ui_workcat_polygon_all", "sys_id_field":"workcat_id", "sys_search_field":"workcat_id", "sys_geom_field":"the_geom", "filter_text":"code"}' 
	WHERE parameter = 'api_search_workcat';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_node", "sys_id_field":"node_id", "sys_search_field":"code", "alias":"Nodes", "cat_field":"nodecat_id", "orderby":"2", "feature_type":"node_id"}' 
	WHERE parameter = 'api_search_node';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_connec", "sys_id_field":"connec_id", "sys_search_field":"code", "alias":"Connecs", "cat_field":"connecat_id", "orderby":"3", "feature_type":"connec_id"}' 
	WHERE parameter = 'api_search_connec';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_element", "sys_id_field":"element_id", "sys_search_field":"code", "alias":"Elements", "cat_field":"elementcat_id", "orderby":"5", "feature_type":"element_id"}' 
	WHERE parameter = 'api_search_element';

UPDATE config_param_system SET value = '{"sys_table_id":"v_edit_arc", "sys_id_field":"arc_id", "sys_search_field":"code", "alias":"Arcs", "cat_field":"arccat_id", "orderby" :"1", "feature_type":"arc_id"}' 
	WHERE parameter = 'api_search_arc';


UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='arccat_id';

UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='nodecat_id';

UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='connecat_id';

UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='connecat_id';

UPDATE config_api_form_fields set typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='gratecat_id';

UPDATE config_api_form_fields set widgettype='typeahead', typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='workcat_id';

UPDATE config_api_form_fields set widgettype='typeahead', typeahead = '{"fieldToSearch": "id", "threshold": 3, "noresultsMsg": "No results", "loadingMsg": "Searching"}' 
WHERE column_id='workcat_id_end';



UPDATE config_api_form_fields set layout_name = concat('data_',layout_id) WHERE layout_name IS NULL;


-- 28/05/2019

UPDATE cat_feature SET parent_layer = 'v_edit_node' where parent_layer = 've_node';
UPDATE cat_feature SET parent_layer = 'v_edit_arc' where parent_layer = 've_arc';
UPDATE cat_feature SET parent_layer = 'v_edit_connec' where parent_layer = 've_connec';


UPDATE config_api_form_fields SET formname='unexpected_noinfra' WHERE formname='unspected_noinfra';
UPDATE config_api_form_fields SET formname='unexpected_arc' WHERE formname= 'unspected_arc';

UPDATE config_api_visit SET formname='unexpected_arc' WHERE formname= 'unspected_arc';
UPDATE config_api_visit SET formname='unexpected_noinfra' WHERE formname= 'unspected_noinfra';

-- 10/06/2019

UPDATE config_api_form_fields SET dv_querytext = 'SELECT id, id as idval FROM om_visit_lot WHERE active IS TRUE' WHERE formtype='visit' and column_id = 'lot_id';

UPDATE config_api_list SET query_text = 'SELECT DISTINCT ON (a.id) a.id AS sys_id, a.id AS lot_id, ''om_visit_lot'' as sys_table_id, ''id'' as sys_idname FROM om_visit_lot a' WHERE id = 28240;

UPDATE config_api_form_fields SET layout_order = 6 WHERE id = 30040;
UPDATE config_api_form_fields SET layout_order = 7 WHERE id = 30050;

UPDATE config_api_form_fields SET dv_querytext='SELECT id, idval FROM config_api_typevalue WHERE typevalue=''listlimit''' WHERE id='102718';

-- 04/07/2019

INSERT INTO config_api_form_tabs VALUES(570, 'v_edit_node', 'tab_elements', 'Elem', 'Lista de elementos relacionados', 'role_basic', 'Elements', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":" Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false}]', null);
INSERT INTO config_api_form_tabs VALUES(571, 'v_edit_node', 'tab_om', 'OM', 'Lista de eventos del elemento', 'role_basic', 'OM', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false}]', null);
INSERT INTO config_api_form_tabs VALUES(572, 'v_edit_node', 'tab_documents', 'Doc', 'Lista de documentos', 'role_basic', 'Doc', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false}]', null);
INSERT INTO config_api_form_tabs VALUES(573, 'v_edit_node', 'tab_plan', 'Cost', 'Partidas del elemento', 'role_basic', 'Cos', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false},{"actionName":"actionSection", "actionFunction":"", "actionTooltip":"Show Section", "disabled":false}]', null);

INSERT INTO config_api_form_tabs VALUES(680, 'v_edit_connec', 'tab_om', 'OM', 'Lista de eventos del elemento', 'role_basic', 'OM', null,'[{"actionName":"actionEdit", "actionFunction":"", "actionTooltip":"Edit", "disabled":false},{"actionName":"actionZoomIn", "actionFunction":"", "actionTooltip":"Zoom In", "disabled":false},{"actionName":"actionZoomOut", "actionFunction":"", "actionTooltip":"Zoom Out", "disabled":false},{"actionName":"actionCentered", "actionFunction":"", "actionTooltip":"Center", "disabled":false},{"actionName":"actionLink", "actionFunction":"", "actionTooltip":"Open Link", "disabled":false}]', null);

-- 11/07/2019

UPDATE config_api_form_fields SET column_id = 'connec_type' WHERE column_id = 'connectype_id';

-- 12/07/2019

UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'node_type';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'arctype_id';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'connec_type';
UPDATE config_api_form_fields SET isparent = True WHERE column_id = 'muni_id';

UPDATE config_api_form_fields SET dv_parent_id = 'node_type' WHERE dv_parent_id = 'nodetype_id';
UPDATE config_api_form_fields SET dv_parent_id = 'arc_type' WHERE dv_parent_id = 'arctype_id';
UPDATE config_api_form_fields SET dv_parent_id = 'connec_type' WHERE dv_parent_id = 'connectype_id';

DELETE FROM config_api_form_fields WHERE formname='visitManager';
DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_arc';
DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_connec';
DELETE FROM config_api_form_fields WHERE formname='v_ui_om_visitman_x_node';
DELETE FROM config_api_form_fields WHERE formname='lot';
DELETE FROM config_api_form_fields WHERE formname='om_visit';
DELETE FROM config_api_form_fields WHERE formname='om_visit_lot';
DELETE FROM config_api_form_fields WHERE formname='om_visit_event_photo';

DELETE FROM config_api_form_fields WHERE formname='visit_node_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_arc_leak';
DELETE FROM config_api_form_fields WHERE formname='visit_node_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_arc_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_class_0';
DELETE FROM config_api_form_fields WHERE formname='unexpected_noinfra';
DELETE FROM config_api_form_fields WHERE formname='unexpected_arc';
DELETE FROM config_api_form_fields WHERE formname='visit_emb_insp';
DELETE FROM config_api_form_fields WHERE formname='visit_connec_insp_';
DELETE FROM config_api_form_fields WHERE formname='visit_node_insp_';

SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);

INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'acceptbutton', 9, 1, true, NULL, 'button', 'Acceptar', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwSetVisitManager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'startbutton', 1, 3, true, NULL, 'button', 'INICIAR JORNADA', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwSetVisitManagerStart', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'endbutton', 1, 8, true, NULL, 'button', 'FINALITZAR JORNADA', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwSetVisitManagerEnd', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('lot', 'form', 'lot_id', 1, 1, true, 'integer', 'text', 'Ordre treball:', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('lot', 'form', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('lot', 'form', 'descript', 1, 5, true, 'string', 'text', 'Descripció', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('lot', 'form', 'status', 1, 6, true, 'integer', 'combo', 'Estat:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT DISTINCT id,  idval FROM sys_combo_values WHERE sys_combo_cat_id=5 AND id IN (3,4,5)', NULL, NULL, NULL, NULL, 'gwGetLot', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('lot', 'form', 'enddate', 1, 4, false, 'date', 'datepickertime', 'Final:', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('lot', 'form', 'startdate', 1, 3, false, 'date', 'datepickertime', 'Inici:', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('lot', 'form', 'idval', 1, 2, false, 'string', 'text', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols)VALUES('lot', 'lot','visitclass_id', 1, 5, TRUE, 'string', 'combo', 'Classe visita:', NULL, NULL, NULL, NULL, NULL, FALSE, NULL, TRUE, NULL, 'SELECT id, idval FROM om_visit_class WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,NULL,NULL,NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_node', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_connec', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit', 'listHeader', 'startdate', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"2014-01-01" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit_event_photo', 'listHeader', 'filetype', 1, 1, true, NULL, 'combo', 'Tipus fitxer', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT distinct filetype AS id, filetype AS idval FROM om_visit_filetype_x_extension WHERE filetype IS NOT NULL', NULL, true, NULL, NULL, 'gwGetVisit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'lot_id', 1, 7, true, NULL, 'combo', 'Ordre treball:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT id, idval FROM om_visit_lot WHERE active IS TRUE', NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'starttime', 1, 4, false, 'date', 'datepickertime', 'Hora inici', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'date', 1, 2, true, 'date', 'datepickertime', 'Data', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_arc', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_node', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_connec', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'user_id', 1, 1, true, 'string', 'combo', 'Nom:', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, 'SELECT id, name AS idval FROM cat_users WHERE id = current_user', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'backbutton', 9, 2, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'vehicle_id', 1, 6, false, 'string', 'combo', 'Vehicle', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT id, idval FROM cat_vehicle WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('visitManager', 'form', 'team_id', 1, 5, true, 'string', 'combo', 'Equip:', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, 'SELECT id, idval FROM cat_team WHERE id IS NOT NULL', NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_arc', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_arc', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"vdefault":15}', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_node', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('v_ui_om_visitman_x_connec', 'listHeader', 'visit_start', 1, 1, true, 'date', 'datepickertime', 'Des de', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisitManager', NULL, NULL, NULL, NULL, NULL, '{"sign":">","vdefault":"01-01-2014" }', NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit_lot', 'listFooter', 'createlot', 1, 1, true, NULL, 'button', 'CREAR ORDRE TREBALL', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetLot', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit_lot', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrere', NULL, NULL, NULL, NULL, NULL, false, NULL, false, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit_event_photo', 'listHeader', 'limit', 1, 2, true, 'integer', 'text', 'Limit', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'gwGetVisit', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('om_visit_event_photo', 'listFooter', 'backbutton', 9, 1, true, NULL, 'button', 'Enrera', NULL, NULL, NULL, NULL, NULL, false, NULL, true, NULL, NULL, NULL, NULL, NULL, NULL, 'backButtonClicked', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- 22/07/2019

INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'id', 1, 1, true, 'string', 'text', 'id:', NULL, NULL, NULL, NULL, NULL, true, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'distance', 1, 2, true, 'numeric', 'text', 'custom distance:', NULL, NULL, NULL, 12, 4, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'depth', 1, 4, true, 'numeric', 'text', 'custom depth', NULL, NULL, NULL, 12, 4, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'feature_type', 1, 6, true, 'string', 'text', 'feature type:', NULL, NULL, NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'feature_id', 1, 5, true, 'string', 'text', 'feature id:', NULL, NULL, NULL, NULL, NULL, false, false, false, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'x_symbol', 1, 8, true, 'numeric', 'text', 'x symbol:', NULL, NULL, NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'y_symbol', 1, 9, true, 'numeric', 'text', 'y symbol:', NULL, NULL, NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, NULL, NULL, false, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'depth_btn', 1, 3, true, NULL, 'button', 'Circle symbology', NULL, NULL, NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'gw_api_get_coordinates', NULL, true, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);
INSERT INTO config_api_form_fields ( formname, formtype, column_id, layout_id, layout_order, isenabled, datatype, widgettype, label, widgetdim, tooltip, placeholder, field_length, num_decimals, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, widgetfunction, action_function, isreload, stylesheet, isnotupdate, typeahead, listfilterparam, layout_name, editability, widgetcontrols) VALUES ('dimensioning', 'catalog', 'symbol_btn', 1, 7, true, NULL, 'button', 'Capture depth', NULL, NULL, NULL, NULL, NULL, false, false, true, false, NULL, NULL, NULL, NULL, NULL, 'gw_api_get_depth', NULL, true, NULL, NULL, NULL, NULL, 'layout_data_1', NULL, NULL);

DELETE FROM config_api_form_tabs WHERE tabname='tab_connections' AND formname='v_edit_connec';


--2019/08/01
-----------------------
-- value type values
-----------------------

INSERT INTO config_api_typevalue VALUES ('listlimit', '1', '10', NULL);
INSERT INTO config_api_typevalue VALUES ('listlimit', '2', '50', NULL);
INSERT INTO config_api_typevalue VALUES ('listlimit', '3', '100', NULL);
INSERT INTO config_api_typevalue VALUES ('listlimit', '4', '500', NULL);
INSERT INTO config_api_typevalue VALUES ('listlimit', '5', '1000', NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'text', 'text', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'string', 'string', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'date', 'date', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'bytea', 'bytea', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'character varying', 'character varying', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'boolean', 'boolean', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'double', 'double', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'integer', 'integer', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('datatype', 'numeric', 'numeric', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'nowidget', 'nowidget', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'text', 'text', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'button', 'button', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'typeahead', 'typeahead', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'image', 'image', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'datepickertime', 'datepickertime', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'formDivider', 'formDivider', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'label', 'label', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'doubleSpinbox', 'doubleSpinbox', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'check', 'check', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'hyperlink', 'hyperlink', NULL, NULL);
INSERT INTO config_api_typevalue VALUES ('widgettype', 'combo', 'combo', NULL, NULL);

UPDATE config_api_form_fields SET layout_name='top_layout' WHERE formname='dimensioning' AND column_id='id';
UPDATE config_api_form_fields SET layout_name='distance_layout' WHERE formname='dimensioning' AND column_id='distance';
UPDATE config_api_form_fields SET layout_name='depth_layout' WHERE formname='dimensioning' AND (column_id='depth' OR column_id='feature_type' OR column_id='feature_id');
UPDATE config_api_form_fields SET layout_name='symbology_layout' WHERE formname='dimensioning' AND (column_id='x_symbol' OR column_id='y_symbol');

--zones
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_dma','form', 'expl_id', null, null, true, 'integer',  'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_dma','form', 'macrodma_id', null, null, true, 'integer',  'combo', false, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL','macrodma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('exploitation','form', 'macroexpl_id', null, null, true, 'integer',  'combo', false, 'SELECT macroexpl_id as id, name as idval FROM macroexploitation WHERE macroexpl_id IS NOT NULL','macroexpl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_sector','form', 'macrosector_id', null, null, true, 'integer',  'combo', false, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL','macrosector_id');


--link
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'expl_id', null, null, true, 'integer',  'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'dma_id', null, null, true, 'integer',  'combo', true, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', 'dma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'state', null, null, true, 'integer',  'combo', true, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', 'state');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'macrosector_id', null, null, true, 'integer',  'combo', false, 'SELECT macrosector_id as id, name as idval FROM macrosector WHERE macrosector_id IS NOT NULL','macrosector_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'macrodma_id', null, null, true, 'integer',  'combo', false, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL','macrodma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'sector_id', null, null, true, 'integer',  'combo', true, 'SELECT sector_id as id, name as idval FROM sector WHERE sector_id IS NOT NULL','sector_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'feature_type', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', 'feature_type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_link','form', 'exit_type', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM sys_feature_type WHERE id IS NOT NULL', 'exit_type');

--element
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'elementcat_id', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_element WHERE id IS NOT NULL','elementcat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'expl_id', null, null, true, 'integer',  'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'dma_id', null, null, true, 'integer',  'combo', true, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', 'dma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'state', null, null, true, 'integer',  'combo', true, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', 'state');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'state_type', null, null, true, 'integer',  'combo', true, 'SELECT id, name as idval FROM value_state_type WHERE id IS NOT NULL','state_type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'workcat_id', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL','workcat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'workcat_id_end', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL','workcat_id_end');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'ownercat_id', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_owner WHERE id IS NOT NULL','ownercat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'buildercat_id', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_builder WHERE id IS NOT NULL','buildercat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'verified', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM value_verified WHERE id IS NOT NULL', 'verified');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'function_type', null, null, true, 'string',  'combo', true, 'SELECT function_type as id, function_type as idval FROM man_type_function WHERE feature_type = ''ELEMENT''', 'function_type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'category_type', null, null, true, 'string',  'combo', true, 'SELECT category_type as id, category_type as idval FROM man_type_category WHERE feature_type = ''ELEMENT''', 'category_type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'location_type', null, null, true, 'string',  'combo', true, 'SELECT location_type as id, location_type as idval FROM man_type_location WHERE feature_type = ''ELEMENT''', 'location_type');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_element','form', 'fluid_type', null, null, true, 'string',  'combo', true, 'SELECT fluid_type as id, fluid_type as idval FROM man_type_fluid WHERE feature_type = ''ELEMENT''', 'fluid_type');

--samplepoint
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'featurecat_id', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_feature WHERE id IS NOT NULL','featurecat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'expl_id', null, null, true, 'integer',  'combo', true, 'SELECT expl_id as id, name as idval FROM exploitation WHERE expl_id IS NOT NULL', 'expl_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'dma_id', null, null, true, 'integer',  'combo', true, 'SELECT dma_id as id, name as idval FROM dma WHERE dma_id IS NOT NULL', 'dma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label, isparent, isreload)
VALUES ('v_edit_samplepoint','form', 'state', null, null, true, 'integer',  'combo', true, 'SELECT id, name as idval FROM value_state WHERE id IS NOT NULL', 'state', true, true);
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'workcat_id', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL','workcat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'workcat_id_end', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM cat_work WHERE id IS NOT NULL','workcat_id_end');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'presszonecat_id', null, null, true, 'string',  'combo', true, 'SELECT id, descript as idval FROM cat_presszone WHERE id IS NOT NULL','presszonecat_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'muni_id', null, null, true, 'string',  'combo', true, 'SELECT muni_id as id, name as idval FROM ext_municipality WHERE muni_id IS NOT NULL', 'muni_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'streetaxis_id', null, null, true, 'string',  'combo', true, 'SELECT id, name as idval FROM v_ext_streetaxis WHERE id IS NOT NULL','streetaxis_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'streetaxis2_id', null, null, true, 'string',  'combo', true, 'SELECT id, name as idval FROM v_ext_streetaxis WHERE id IS NOT NULL','streetaxis2_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'macrodma_id', null, null, true, 'integer',  'combo', false, 'SELECT macrodma_id as id, name as idval FROM macrodma WHERE macrodma_id IS NOT NULL','macrodma_id');
INSERT INTO config_api_form_fields(formname, formtype, column_id, layout_id, layout_order, isenabled,datatype, widgettype, iseditable, dv_querytext, label)
VALUES ('v_edit_samplepoint','form', 'verified', null, null, true, 'string',  'combo', true, 'SELECT id, id as idval FROM value_verified WHERE id IS NOT NULL', 'verified');
