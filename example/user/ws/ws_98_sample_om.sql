/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

INSERT INTO om_visit_cat VALUES (1, 'Test num.1','2017-1-1', '2017-3-31', NULL, FALSE);
INSERT INTO om_visit_cat VALUES (2, 'Test num.2','2017-4-1', '2017-7-31', NULL, FALSE);
INSERT INTO om_visit_cat VALUES (3, 'Test num.3','2017-8-1', '2017-9-30', NULL, TRUE);
INSERT INTO om_visit_cat VALUES (4, 'Test num.4','2017-10-1', '2017-12-31', NULL, TRUE);


INSERT INTO om_visit_class VALUES (6, 'Inspection and clean arc', NULL, true, false, true, 'ARC', 'role_om', 1, null, 'visit_arc_insp', 've_visit_arc_insp');
INSERT INTO om_visit_class VALUES (5, 'Inspection and clean node', NULL, true, false, true, 'NODE', 'role_om', 1, null, 'visit_node_insp', 've_visit_node_insp');
INSERT INTO om_visit_class VALUES (1, 'Leak on pipe', NULL, true, false, false, 'ARC', 'role_om', 1, null, 'visit_arc_leak', 've_visit_arc_singlevent');
INSERT INTO om_visit_class VALUES (0, 'Open visit', NULL, true, true, false, NULL, 'role_om', null,  null,'visit_class_0', 'om_visit');
INSERT INTO om_visit_class VALUES (2, 'Inspection and clean connec', NULL, true, false, true, 'CONNEC', 'role_om', 1, null, 'visit_connec_insp', 've_visit_connec_insp');
INSERT INTO om_visit_class VALUES (4, 'Leak on connec', NULL, true, false, false, 'CONNEC', 'role_om', 1, null, 'visit_connec_leak', 've_visit_connec_singlevent');
INSERT INTO om_visit_class VALUES (3, 'Leak on node', NULL, true, false, false, 'NODE', 'role_om', 1, null, 'visit_node_leak', 've_visit_node_singlevent');


SELECT setval('SCHEMA_NAME.om_visit_class_id_seq', (SELECT max(id) FROM om_visit_class), true);

INSERT INTO om_visit_parameter VALUES ('leak_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'leak on connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_des');
INSERT INTO om_visit_parameter VALUES ('leak_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'leak on arc', 'event_standard', 'defaultvalue', FALSE, 'arc_insp_des');
INSERT INTO om_visit_parameter VALUES ('leak_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'leak on node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_des');

INSERT INTO om_visit_parameter VALUES ('sediments_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Sediments in arc', 'event_standard', 'defaultvalue',FALSE, 'arc_insp_sed');
INSERT INTO om_visit_parameter VALUES ('clean_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Clean of arc', 'event_standard', 'defaultvalue', FALSE, 'arc_cln_exec');
INSERT INTO om_visit_parameter VALUES ('defect_arc', NULL, 'INSPECTION', 'ARC', 'TEXT', NULL, 'Defects of arc', 'event_standard', 'defaultvalue', FALSE, 'arc_defect');

INSERT INTO om_visit_parameter VALUES ('sediments_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Sediments in connec', 'event_standard', 'defaultvalue',FALSE, 'con_insp_sed');
INSERT INTO om_visit_parameter VALUES ('clean_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Clean of connec', 'event_standard', 'defaultvalue',FALSE, 'con_cln_exec');
INSERT INTO om_visit_parameter VALUES ('defect_connec', NULL, 'INSPECTION', 'CONNEC', 'TEXT', NULL, 'Defects of connec', 'event_standard', 'defaultvalue', FALSE, 'connec_defect');

INSERT INTO om_visit_parameter VALUES ('sediments_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Sediments in node', 'event_standard', 'defaultvalue',FALSE, 'node_insp_sed');
INSERT INTO om_visit_parameter VALUES ('clean_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Clean of node', 'event_standard', 'defaultvalue',FALSE, 'node_cln_exec');
INSERT INTO om_visit_parameter VALUES ('defect_node', NULL, 'INSPECTION', 'NODE', 'TEXT', NULL, 'Defects of node', 'event_standard', 'defaultvalue', FALSE, 'node_defect');

INSERT INTO om_visit_parameter VALUES ('incident_comment', NULL, 'INSPECTION', NULL, 'TEXT', NULL, 'incident_comment', 'event_standard', NULL, FALSE, 'incident_comment');
INSERT INTO om_visit_parameter VALUES ('incident_type', NULL, 'INSPECTION', NULL, 'TEXT', NULL, 'incident type', 'event_standard', NULL, FALSE, 'incident_type');


INSERT INTO om_visit_class_x_parameter VALUES (1, 5	, 'sediments_node');
INSERT INTO om_visit_class_x_parameter VALUES (2, 2, 'clean_connec');
INSERT INTO om_visit_class_x_parameter VALUES (4, 6, 'clean_arc');
INSERT INTO om_visit_class_x_parameter VALUES (5, 2, 'sediments_connec');
INSERT INTO om_visit_class_x_parameter VALUES (6, 6, 'sediments_arc');
INSERT INTO om_visit_class_x_parameter VALUES (7, 5, 'defect_node');
INSERT INTO om_visit_class_x_parameter VALUES (8, 5, 'clean_node');
INSERT INTO om_visit_class_x_parameter VALUES (9, 1, 'leak_arc');
INSERT INTO om_visit_class_x_parameter VALUES (10, 3, 'leak_node');
INSERT INTO om_visit_class_x_parameter VALUES (11, 4, 'leak_connec');;
INSERT INTO om_visit_class_x_parameter VALUES (3, 6, 'defect_arc');
INSERT INTO om_visit_class_x_parameter VALUES (14, 2, 'defect_connec');

SELECT setval('SCHEMA_NAME.om_visit_class_x_parameter_id_seq', (SELECT max(id) FROM om_visit_class_x_parameter), true);

CREATE OR REPLACE VIEW ve_visit_noinfra AS 
 SELECT om_visit.id AS visit_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    "left"(date_trunc('second'::text, om_visit.startdate)::text, 19) AS startdate,
    "left"(date_trunc('second'::text, om_visit.enddate)::text, 19) AS enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS incident_type,
    a.param_2 AS incident_comment
   FROM om_visit
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN om_visit_class on om_visit_class.id=om_visit.class_id
      LEFT JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
      where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''incident_type''),(''incident_comment'')'::text) ct(visit_id integer, param_1 text, param_2 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;



DROP VIEW IF EXISTS ve_visit_arc_insp;
CREATE OR REPLACE VIEW ve_visit_arc_insp AS 
 SELECT om_visit_x_arc.id,
    om_visit_x_arc.visit_id,
    om_visit_x_arc.arc_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS sediments_arc,
    a.param_2 AS defect_arc,
    a.param_3 AS clean_arc
   FROM om_visit
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN om_visit_x_arc ON om_visit.id = om_visit_x_arc.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN om_visit_class on om_visit_class.id=om_visit.class_id
      LEFT JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
      where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_arc''),(''defect_arc''),(''clean_arc'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;


DROP VIEW IF EXISTS ve_visit_node_insp;
CREATE OR REPLACE VIEW ve_visit_node_insp AS 
 SELECT om_visit_x_node.id,
    om_visit_x_node.visit_id,
    om_visit_x_node.node_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS sediments_node,
    a.param_2 AS defect_node,
    a.param_3 AS clean_node
   FROM om_visit
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN om_visit_x_node ON om_visit.id = om_visit_x_node.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN om_visit_class on om_visit_class.id=om_visit.class_id
      LEFT JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
      where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_node''),(''defect_node''),(''clean_node'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;


DROP VIEW IF EXISTS ve_visit_connec_insp;
CREATE OR REPLACE VIEW ve_visit_connec_insp AS 
 SELECT om_visit_x_connec.id,
    om_visit_x_connec.visit_id,
    om_visit_x_connec.connec_id,
    om_visit.visitcat_id,
    om_visit.ext_code,
    om_visit.startdate,
    om_visit.enddate,
    om_visit.user_name,
    om_visit.webclient_id,
    om_visit.expl_id,
    om_visit.the_geom,
    om_visit.descript,
    om_visit.is_done,
    om_visit.class_id,
    om_visit.lot_id,
    om_visit.status,
    a.param_1 AS sediments_connec,
    a.param_2 AS defect_connec,
    a.param_3 AS clean_connec
   FROM om_visit
     JOIN om_visit_class ON om_visit_class.id = om_visit.class_id
     JOIN om_visit_x_connec ON om_visit.id = om_visit_x_connec.visit_id
     LEFT JOIN ( SELECT ct.visit_id,
            ct.param_1,
            ct.param_2,
            ct.param_3
           FROM crosstab('SELECT visit_id, om_visit_event.parameter_id, value 
      FROM om_visit LEFT JOIN om_visit_event ON om_visit.id= om_visit_event.visit_id 
      LEFT JOIN om_visit_class on om_visit_class.id=om_visit.class_id
      LEFT JOIN om_visit_class_x_parameter on om_visit_class_x_parameter.parameter_id=om_visit_event.parameter_id 
      where om_visit_class.ismultievent = TRUE ORDER  BY 1,2'::text, ' VALUES (''sediments_connec''),(''defect_connec''),(''clean_connec'')'::text) ct(visit_id integer, param_1 text, param_2 text, param_3 text)) a ON a.visit_id = om_visit.id
  WHERE om_visit_class.ismultievent = true;

INSERT INTO om_typevalue VALUES ('visit_cleaned', 1, 'Yes', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_cleaned', 2, 'No', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_cleaned', 3, 'Half', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_defect', 1, 'Good state', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_defect', 2, 'Some defects', NULL, NULL);
INSERT INTO om_typevalue VALUES ('visit_defect', 3, 'Bad state', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 1, 'Broken cover', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 2, 'Water on the street', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 3, 'Smells', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 4, 'Noisy cover', NULL, NULL);
INSERT INTO om_typevalue VALUES ('incident_type', 5, 'Others', NULL, NULL);

truncate config_api_visit_x_featuretable;
INSERT INTO config_api_visit_x_featuretable VALUES ('v_edit_arc', 1);
INSERT INTO config_api_visit_x_featuretable VALUES ('v_edit_node', 5);
INSERT INTO config_api_visit_x_featuretable VALUES ('v_edit_arc', 6);
INSERT INTO config_api_visit_x_featuretable VALUES ('v_edit_node', 3);
INSERT INTO config_api_visit_x_featuretable VALUES ('v_edit_connec', 4);
INSERT INTO config_api_visit_x_featuretable VALUES ('v_edit_connec', 2);


SELECT setval('SCHEMA_NAME.config_api_form_fields_id_seq', (SELECT max(id) FROM config_api_form_fields), true);


--VISIT_CLASS_0
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'class_id', 1, 'integer', 'text', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type IS NULL AND active IS TRUE AND id > 0 AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'visit_id', 2, 'integer', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'visitcat_id', 3, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'ext_code', 4, 'string', 'text', 'Code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'startdate', 5, 'date', 'datepickertime', 'Start date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'enddate', 6, 'date', 'datepickertime', 'End date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_class_0', 'visit', 'cancelbutton', 2, NULL, 'button', 'Cancel',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);








--UNEXPECTED_NOINFRA
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type IS NULL AND active IS TRUE AND id > 0 AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit' ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'visit_id', 2, 'integer', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'incident_type', 3, 'integer', 'combo', 'Incident type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''incident_type''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'ext_code', 4, 'string', 'text', 'Code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'startdate', 5, 'date', 'datepickertime', 'Start date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'enddate', 6, 'date', 'datepickertime', 'End date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'incident_comment', 7, 'string', 'text', 'Comment:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'status', 8, 'integer', 'combo', 'Status:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM om_typevalue WHERE id IS NOT NULL AND typevalue=''visit_cat_status'' ',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('unexpected_noinfra', 'visit', 'cancelbutton', 2, NULL, 'button', 'Cancel',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);




--VISIT_ARC_INSP
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit',NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'image1', 2, 'bytea', 'image', NULL,
NULL, NULL, NULL, false, false, true, NULL, 'SELECT row_to_json(res) FROM (SELECT encode(image, ''base64'') AS image FROM config_api_images WHERE id=1) res;',
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'arc_id', 4, 'double', 'text', 'Arc_id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'lot_id', 5, 'integer', 'combo', 'Lot id:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id , id as idval FROM om_visit_lot WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'ext_code', 6, 'string', 'text', 'Code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'sediments_arc', 7, 'double', 'text', 'Sediments:',
NULL, NULL, 'Ex.: 10 (en cmts.)', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'defect_arc', 8, 'integer', 'combo', 'Defects:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'clean_arc', 9, 'integer', 'combo', 'Cleaned:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'startdate', 10, 'date', 'datepickertime', 'Start date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'enddate', 11, 'date', 'datepickertime', 'End date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'status', 12, 'integer', 'combo', 'Status:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM om_typevalue WHERE id IS NOT NULL AND typevalue=''visit_cat_status'' ',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'divider', 13, NULL, 'formDivider', NULL,
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_insp', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'backButtonClicked',NULL, NULL, NULL, 'data_9', NULL, FALSE);




--VISIT_CONNEC_INSP
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit' ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'image1', 2, 'bytea', 'image', NULL,
NULL, NULL, NULL, false, false, true, NULL, 'SELECT row_to_json(res) FROM (SELECT encode(image, ''base64'') AS image FROM config_api_images WHERE id=1) res;',
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'connec_id', 4, 'string', 'text', 'Connec id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'visitcat_id', 5, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'visit_code', 6, 'string', 'text', 'Visit code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'defect_connec', 7, 'integer', 'combo', 'Defects:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect'' ',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'clean_connec', 8, 'integer', 'combo', 'Cleaned:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_insp', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);



--VISIT_NODE_INSP
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit', NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'image1', 2, 'bytea', 'image', NULL,
NULL, NULL, NULL, false, false, true, NULL, 'SELECT row_to_json(res) FROM (SELECT encode(image, ''base64'') AS image FROM config_api_images WHERE id=1) res;',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'node_id', 4, 'double', 'text', 'Node_id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'visitcat_id', 5, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'visit_code', 6, 'string', 'text', 'Visit code:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'sediments_node', 7, 'double', 'text', 'Sediments:',
NULL, NULL, 'Ex.: 10 (en cmts.)', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'defect_node', 8, 'integer', 'combo', 'Defects:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_defect''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'clean_node', 9, 'integer', 'combo', 'Cleaned:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_typevalue WHERE typevalue = ''visit_cleaned''',
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_insp', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);




--VISIT_ARC_LEAK
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''ARC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit' ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'event_id', 2, 'double', 'text', 'Event id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'lot_id', 4, 'integer', 'combo', 'Lot id:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id , id as idval FROM om_visit_lot WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'ext_code', 5, 'string', 'text', 'Code:',
NULL, NULL, 'Ex.: Work order code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'parameter_id', 6, 'string', 'combo', 'Parameter:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id AS id, descript AS idval FROM om_visit_parameter WHERE feature_type=''ARC''',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'event_code', 7, 'string', 'text', 'Event code:',
NULL, NULL, 'Ex.: Parameter code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);


INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'sediments_connec', 9, 'string', 'text', 'Sediments:',
NULL, NULL, 'Ex.: 10 (en cmts.)', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'position_value', 10, 'double', 'text', 'Position value:',
NULL, NULL, 'Ex.: 34.57', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'arc_id', 11, 'string', 'text', 'Arc id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'position_id', 8, 'string', 'combo', 'Position id:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT a.id, a.idval FROM (SELECT node_1 AS id, node_1 AS idval FROM arc UNION 
SELECT DISTINCT node_2 AS id, node_2 AS idval FROM arc) a WHERE id IS NOT NULL',
NULL, NULL, 'arc_id', ' AND arc.arc_id.arc_id=', 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'startdate', 11, 'date', 'datepickertime', 'Start date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'enddate', 12, 'date', 'datepickertime', 'End date:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'status', 13, 'integer', 'combo', 'Status:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT (id) AS id,  idval  AS idval FROM om_typevalue WHERE id IS NOT NULL AND typevalue=''visit_cat_status'' ',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_arc_leak', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);




--VISIT_CONNEC_LEAK
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''CONNEC'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit',NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'event_id', 2, 'double', 'text', 'Event id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'visitcat_id', 4, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'ext_code', 5, 'string', 'text', 'Code:',
NULL, NULL, 'Ex.: Work order code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'parameter_id', 6, 'string', 'combo', 'Parameter:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id AS id, descript AS idval FROM om_visit_parameter WHERE feature_type=''CONNEC''',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'event_code', 7, 'string', 'text', 'Event code:',
NULL, NULL, 'Ex.: Parameter code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'connec_id', 8, 'double', 'text', 'Connec id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_connec_leak', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);



--VISIT_NODE_LEAK
INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'class_id', 1, 'integer', 'combo', 'Visit type:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id, idval FROM om_visit_class WHERE feature_type=''NODE'' AND  active IS TRUE AND sys_role_id IN (SELECT rolname FROM pg_roles WHERE  pg_has_role( current_user, oid, ''member''))',
NULL, NULL, NULL, NULL, 
'gwGetVisit' ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'event_id', 2, 'double', 'text', 'Event id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'visit_id', 3, 'double', 'text', 'Visit id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'visitcat_id', 4, 'integer', 'combo', 'Visit catalog:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT DISTINCT id AS id, name AS idval FROM om_visit_cat WHERE active IS TRUE',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'ext_code', 5, 'string', 'text', 'Code:',
NULL, NULL, 'Ex.: Work order code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'parameter_id', 6, 'string', 'text', 'Parameter:',
NULL, NULL, NULL, false, false, true, NULL, 'SELECT id AS id, descript AS idval FROM om_visit_parameter WHERE feature_type=''NODE''',
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'event_code', 7, 'string', 'text', 'Event code:',
NULL, NULL, 'Ex.: Parameter code', false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL, NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'arc_id', 8, 'double', 'text', 'Node id:',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
NULL ,NULL, NULL, NULL, 'data_1', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'acceptbutton', 1, NULL, 'button', 'Accept',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'gwSetVisit' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);

INSERT INTO config_api_form_fields (formname, formtype, column_id, layout_order, datatype, widgettype, label, 
widgetdim, tooltip, placeholder, ismandatory, isparent, iseditable, isautoupdate, dv_querytext, 
dv_orderby_id, dv_isnullvalue, dv_parent_id, dv_querytext_filterc, 
widgetfunction, linkedaction, stylesheet, listfilterparam, layoutname, widgetcontrols, hidden) 
VALUES ('visit_node_leak', 'visit', 'backbutton', 2, NULL, 'button', 'Back',
NULL, NULL, NULL, false, false, true, NULL, NULL,
NULL, NULL, NULL, NULL, 
'backButtonClicked' ,NULL, NULL, NULL, 'data_9', NULL, FALSE);