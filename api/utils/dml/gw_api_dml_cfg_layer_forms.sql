/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


INSERT INTO config_web_forms VALUES (211, 'arc_x_element', 'SELECT arc.workcat_id AS sys_id, ''v_ui_workcat_polygon'' AS sys_table_id, ''workcat_id'' AS sys_idname, code, workcat_id_end, arc.descript, arc.dma_id, arc.workcat_id  FROM v_ui_workcat_polygon JOIN arc ON v_ui_workcat_polygon.workcat_id=arc.workcat_id', 1);
INSERT INTO config_web_forms VALUES (212, 'arc_x_element', 'SELECT arc.workcat_id AS sys_id, ''v_ui_workcat_polygon'' AS sys_table_id, ''workcat_id'' AS sys_idname, code, workcat_id_end, arc.descript, arc.dma_id, arc.workcat_id  FROM v_ui_workcat_polygon JOIN arc ON v_ui_workcat_polygon.workcat_id=arc.workcat_id', 2);
INSERT INTO config_web_forms VALUES (213, 'arc_x_element', 'SELECT arc.workcat_id AS sys_id, ''v_ui_workcat_polygon'' AS sys_table_id, ''workcat_id'' AS sys_idname, code, workcat_id_end, arc.descript, arc.dma_id, arc.workcat_id  FROM v_ui_workcat_polygon JOIN arc ON v_ui_workcat_polygon.workcat_id=arc.workcat_id', 3);
INSERT INTO config_web_forms VALUES (142, 'node_x_connect_downstream', 'SELECT feature_id as sys_id, arccat_id AS "CANONADA", ''arc_id'' AS sys_idname, ''v_edit_arc'' AS  sys_table_id  FROM v_ui_node_x_connection_downstream', 2);
INSERT INTO config_web_forms VALUES (143, 'node_x_connect_downstream', 'SELECT feature_id as sys_id, arccat_id AS "CANONADA", ''arc_id'' AS sys_idname, ''v_edit_arc'' AS  sys_table_id  FROM v_ui_node_x_connection_downstream', 3);
INSERT INTO config_web_forms VALUES (511, 'workcat_x_element', 'SELECT feature_id as sys_id, concat (''v_edit_'', lower(feature_type)) as sys_table_id, concat(lower(feature_type),''_id'') AS sys_idname, feature_id, feature_type FROM v_ui_workcat_x_feature', 1);
INSERT INTO config_web_forms VALUES (512, 'workcat_x_element', 'SELECT feature_id as sys_id, concat (''v_edit_'', lower(feature_type)) as sys_table_id, concat(lower(feature_type),''_id'') AS sys_idname, feature_id, feature_type FROM v_ui_workcat_x_feature', 2);
INSERT INTO config_web_forms VALUES (513, 'workcat_x_element', 'SELECT feature_id as sys_id, concat (''v_edit_'', lower(feature_type)) as sys_table_id, concat(lower(feature_type),''_id'') AS sys_idname, feature_id, feature_type FROM v_ui_workcat_x_feature', 3);
INSERT INTO config_web_forms VALUES (532, 'workcat_x_hydro', 'SELECT feature_id as sys_id, concat (''v_edit_'', lower(feature_type)) as sys_table_id, concat(lower(feature_type),''_id'') AS sys_idname, feature_id, feature_type FROM v_ui_workcat_x_feature_end', 2);
INSERT INTO config_web_forms VALUES (531, 'workcat_x_hydro', 'SELECT feature_id as sys_id, concat (''v_edit_'', lower(feature_type)) as sys_table_id, concat(lower(feature_type),''_id'') AS sys_idname, feature_id, feature_type FROM v_ui_workcat_x_feature_end', 1);
INSERT INTO config_web_forms VALUES (533, 'workcat_x_hydro', 'SELECT feature_id as sys_id, concat (''v_edit_'', lower(feature_type)) as sys_table_id, concat(lower(feature_type),''_id'') AS sys_idname, feature_id, feature_type FROM v_ui_workcat_x_feature_end', 3);
INSERT INTO config_web_forms VALUES (161, 'node_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_node', 1);
INSERT INTO config_web_forms VALUES (162, 'node_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_node', 2);
INSERT INTO config_web_forms VALUES (163, 'node_x_doc', 'SELECT doc_id as sys_id, doc_id, doc_type, path as sys_link FROM v_ui_doc_x_node', 3);
INSERT INTO config_web_forms VALUES (231, 'arc_x_hydro', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_arc', 1);
INSERT INTO config_web_forms VALUES (232, 'arc_x_hydro', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_arc', 2);
INSERT INTO config_web_forms VALUES (156, 'node_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 3);
INSERT INTO config_web_forms VALUES (261, 'arc_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 1);
INSERT INTO config_web_forms VALUES (256, 'arc_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 3);
INSERT INTO config_web_forms VALUES (233, 'arc_x_hydro', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_arc', 3);
INSERT INTO config_web_forms VALUES (262, 'arc_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 2);
INSERT INTO config_web_forms VALUES (311, 'connec_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_connec', 1);
INSERT INTO config_web_forms VALUES (354, 'connec_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 1);
INSERT INTO config_web_forms VALUES (263, 'arc_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_arc', 3);
INSERT INTO config_web_forms VALUES (355, 'connec_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 2);
INSERT INTO config_web_forms VALUES (361, 'connec_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 1);
INSERT INTO config_web_forms VALUES (312, 'connec_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_connec', 2);
INSERT INTO config_web_forms VALUES (362, 'connec_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 2);
INSERT INTO config_web_forms VALUES (363, 'connec_x_doc', 'SELECT doc_id as sys_id, doc_id, path as sys_link FROM v_ui_doc_x_connec', 3);
INSERT INTO config_web_forms VALUES (313, 'connec_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_connec', 3);
INSERT INTO config_web_forms VALUES (141, 'node_x_connect_downstream', 'SELECT feature_id as sys_id, arccat_id AS "CANONADA", ''arc_id'' AS sys_idname, ''v_edit_arc'' AS  sys_table_id  FROM v_ui_node_x_connection_downstream', 1);
INSERT INTO config_web_forms VALUES (154, 'node_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 1);
INSERT INTO config_web_forms VALUES (356, 'connec_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_connec', 3);
INSERT INTO config_web_forms VALUES (352, 'connec_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_connec', 2);
INSERT INTO config_web_forms VALUES (251, 'arc_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_arc', 1);
INSERT INTO config_web_forms VALUES (252, 'arc_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_arc', 2);
INSERT INTO config_web_forms VALUES (253, 'arc_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_arc', 3);
INSERT INTO config_web_forms VALUES (351, 'connec_x_visit', 'SELECT visit_id AS sys_visit_id, event_id AS sys_id, parameter_id, parameter_type, value as valor, descript, visit_start::date::text  as date FROM v_ui_om_visit_x_connec', 1);
INSERT INTO config_web_forms VALUES (353, 'connec_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_connec', 3);
INSERT INTO config_web_forms VALUES (111, 'node_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_node', 1);
INSERT INTO config_web_forms VALUES (112, 'node_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_node', 2);
INSERT INTO config_web_forms VALUES (113, 'node_x_element', 'SELECT element_id as sys_id, ''v_ui_element'' as sys_table_id, ''element_id'' AS sys_idname, element_id, elementcat_id FROM v_ui_element_x_node', 3);
INSERT INTO config_web_forms VALUES (333, 'connec_x_hydro', 'SELECT hydrometer_id as sys_id, hydrometer_id as sys_idname, ''v_ui_hydrometer'' AS sys_table_id,  hydrometer_customer_code as "Codi abonat"  FROM v_rtc_hydrometer', 3);
INSERT INTO config_web_forms VALUES (242, 'arc_x_connect', 'SELECT feature_id as sys_id, catalog AS "ESCOMESA", ''connec_id'' AS sys_idname, ''v_edit_connec'' AS  sys_table_id  FROM v_ui_arc_x_relations', 2);
INSERT INTO config_web_forms VALUES (144, 'node_x_connect_upstream', 'SELECT feature_id as sys_id, arccat_id AS "CANONADA", ''arc_id'' AS sys_idname, ''v_edit_arc'' AS  sys_table_id  FROM v_ui_node_x_connection_upstream', 1);
INSERT INTO config_web_forms VALUES (243, 'arc_x_connect', 'SELECT feature_id as sys_id, catalog AS "ESCOMESA", ''connec_id'' AS sys_idname, ''v_edit_connec'' AS  sys_table_id  FROM v_ui_arc_x_relations', 3);
INSERT INTO config_web_forms VALUES (145, 'node_x_connect_upstream', 'SELECT feature_id as sys_id, arccat_id AS "CANONADA", ''arc_id'' AS sys_idname, ''v_edit_arc'' AS  sys_table_id  FROM v_ui_node_x_connection_upstream', 2);
INSERT INTO config_web_forms VALUES (146, 'node_x_connect_upstream', 'SELECT feature_id as sys_id, arccat_id AS "CANONADA", ''arc_id'' AS sys_idname, ''v_edit_arc'' AS  sys_table_id  FROM v_ui_node_x_connection_upstream', 3);
INSERT INTO config_web_forms VALUES (332, 'connec_x_hydro', 'SELECT hydrometer_id as sys_id, hydrometer_id as sys_idname, ''v_ui_hydrometer'' AS sys_table_id,  hydrometer_customer_code as "Codi abonat"  FROM v_rtc_hydrometer', 2);
INSERT INTO config_web_forms VALUES (153, 'node_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_id, visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_node', 3);
INSERT INTO config_web_forms VALUES (152, 'node_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_node', 2);
INSERT INTO config_web_forms VALUES (151, 'node_x_visit', 'SELECT event_id AS sys_id,  descript AS "Event", descript AS "sys_parameter_name", parameter_type AS sys_parameter_type, value as "Valor", visit_start::date::text  as "Data", visit_start::date AS sys_date, parameter_id AS sys_parameter_id  FROM v_ui_om_visit_x_node', 1);
INSERT INTO config_web_forms VALUES (241, 'arc_x_connect', 'SELECT feature_id as sys_id, catalog AS "ESCOMESA", ''connec_id'' AS sys_idname, ''v_edit_connec'' AS  sys_table_id  FROM v_ui_arc_x_relations', 1);
INSERT INTO config_web_forms VALUES (155, 'node_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_node', 2);
INSERT INTO config_web_forms VALUES (254, 'arc_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 1);
INSERT INTO config_web_forms VALUES (255, 'arc_x_visit_manager', 'SELECT visit_id AS sys_id, visitcat_name, visit_start, visit_end, user_name FROM v_ui_om_visitman_x_arc', 2);
INSERT INTO config_web_forms VALUES (331, 'connec_x_hydro', 'SELECT hydrometer_id as sys_id, hydrometer_id as sys_idname, ''v_ui_hydrometer'' AS sys_table_id,  hydrometer_customer_code as "Codi abonat"  FROM v_rtc_hydrometer', 1);

