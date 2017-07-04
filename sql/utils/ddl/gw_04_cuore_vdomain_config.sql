/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/



SET search_path = "SCHEMA_NAME", public, pg_catalog;


-- ----------------------------
-- Records of config system table
-- ----------------------------

INSERT INTO config (id, node_proximity, arc_searchnodes, node2arc, connec_proximity, arc_toporepair, nodeinsert_arcendpoint, nodeinsert_catalog_vdefault, orphannode_delete, vnode_update_tolerance, nodetype_change_enabled, 
	samenode_init_end_control, node_proximity_control, connec_proximity_control, node_duplicated_tolerance, connec_duplicated_tolerance, audit_function_control, arc_searchnodes_control, insert_double_geometry, buffer_value)
  VALUES ('1', 0.10000000000000001, 0.5, 0.5, 0.10000000000000001, NULL, false, NULL, false, 0.5, false, true, true, true, 0.001, 0.001, true, true, true, 1);

INSERT INTO config_param_bool VALUES ('slope_arc_direction', true, NULL, NULL, NULL, NULL);

INSERT INTO config_csv_import VALUES ('inp_pattern', 'Patterns');
INSERT INTO config_csv_import VALUES ('inp_curve', 'Curve');

INSERT INTO config_extract_raster_value VALUES ('1', 'topo', '1', 'v_edit_node', 'elev');

INSERT INTO config_param_text VALUES ('custom_giswater_folder', 'c:/', NULL, NULL, NULL, NULL);
INSERT INTO config_param_text VALUES ('om_visit_absolute_path', 'https://www.', NULL, NULL, NULL, NULL);
INSERT INTO config_param_text VALUES ('doc_absolute_path', 'c:/', NULL, NULL, NULL, NULL);


INSERT INTO config_ui_forms VALUES (3868, NULL, 'v_ui_element_x_gully', NULL, true, 100, 5, NULL);
INSERT INTO config_ui_forms VALUES (3870, NULL, 'v_ui_element_x_gully', NULL, NULL, NULL, 6, NULL);
INSERT INTO config_ui_forms VALUES (3872, NULL, 'v_ui_element_x_gully', NULL, NULL, NULL, 7, NULL);
INSERT INTO config_ui_forms VALUES (3874, NULL, 'v_ui_element_x_gully', NULL, true, 100, 8, NULL);
INSERT INTO config_ui_forms VALUES (3876, NULL, 'v_ui_element_x_gully', NULL, NULL, NULL, 9, NULL);
INSERT INTO config_ui_forms VALUES (3894, NULL, 'v_ui_element_x_connec', NULL, true, 150, 3, NULL);
INSERT INTO config_ui_forms VALUES (3896, NULL, 'v_ui_element_x_connec', NULL, true, 196, 4, NULL);
INSERT INTO config_ui_forms VALUES (3898, NULL, 'v_ui_element_x_connec', NULL, true, 100, 5, NULL);
INSERT INTO config_ui_forms VALUES (3900, NULL, 'v_ui_element_x_connec', NULL, NULL, 150, 6, NULL);
INSERT INTO config_ui_forms VALUES (3902, NULL, 'v_ui_element_x_connec', NULL, NULL, 150, 7, NULL);
INSERT INTO config_ui_forms VALUES (3904, NULL, 'v_ui_element_x_connec', NULL, true, 100, 8, NULL);
INSERT INTO config_ui_forms VALUES (72110, NULL, 'v_price_x_node', NULL, NULL, NULL, 1, NULL);
INSERT INTO config_ui_forms VALUES (72130, NULL, 'v_price_x_node', NULL, true, 30, 3, NULL);
INSERT INTO config_ui_forms VALUES (72120, NULL, 'v_price_x_node', NULL, false, 120, 2, NULL);
INSERT INTO config_ui_forms VALUES (72140, NULL, 'v_price_x_node', NULL, true, 300, 4, NULL);
INSERT INTO config_ui_forms VALUES (72160, NULL, 'v_price_x_node', NULL, true, 50, 6, 'depth');
INSERT INTO config_ui_forms VALUES (72150, NULL, 'v_price_x_node', NULL, true, 60, 5, NULL);
INSERT INTO config_ui_forms VALUES (72170, NULL, 'v_price_x_node', NULL, true, 61, 7, NULL);
INSERT INTO config_ui_forms VALUES (13200, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 12, NULL);
INSERT INTO config_ui_forms VALUES (14200, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 13, NULL);
INSERT INTO config_ui_forms VALUES (16000, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 15, NULL);
INSERT INTO config_ui_forms VALUES (27000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 11, NULL);
INSERT INTO config_ui_forms VALUES (31000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 15, NULL);
INSERT INTO config_ui_forms VALUES (32000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 1, NULL);
INSERT INTO config_ui_forms VALUES (33000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 2, NULL);
INSERT INTO config_ui_forms VALUES (34000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 3, NULL);
INSERT INTO config_ui_forms VALUES (35000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 4, NULL);
INSERT INTO config_ui_forms VALUES (36000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 5, NULL);
INSERT INTO config_ui_forms VALUES (8200, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 7, NULL);
INSERT INTO config_ui_forms VALUES (38000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 7, NULL);
INSERT INTO config_ui_forms VALUES (41000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 10, NULL);
INSERT INTO config_ui_forms VALUES (42000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 11, NULL);
INSERT INTO config_ui_forms VALUES (43000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 12, NULL);
INSERT INTO config_ui_forms VALUES (44000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 13, NULL);
INSERT INTO config_ui_forms VALUES (4120, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 2, NULL);
INSERT INTO config_ui_forms VALUES (3670, NULL, 'v_ui_element_x_arc', NULL, true, 100, 8, NULL);
INSERT INTO config_ui_forms VALUES (3640, NULL, 'v_ui_element_x_arc', NULL, true, 100, 5, NULL);
INSERT INTO config_ui_forms VALUES (3630, NULL, 'v_ui_element_x_arc', NULL, true, 196, 4, NULL);
INSERT INTO config_ui_forms VALUES (3620, NULL, 'v_ui_element_x_arc', NULL, true, 150, 3, NULL);
INSERT INTO config_ui_forms VALUES (3810, NULL, 'v_ui_element_x_node', NULL, true, 196, 4, NULL);
INSERT INTO config_ui_forms VALUES (3800, NULL, 'v_ui_element_x_node', NULL, true, 150, 3, NULL);
INSERT INTO config_ui_forms VALUES (3820, NULL, 'v_ui_element_x_node', NULL, true, 100, 5, NULL);
INSERT INTO config_ui_forms VALUES (3830, NULL, 'v_ui_element_x_node', NULL, NULL, 150, 6, NULL);
INSERT INTO config_ui_forms VALUES (3850, NULL, 'v_ui_element_x_node', NULL, true, 100, 8, NULL);
INSERT INTO config_ui_forms VALUES (4040, NULL, 'v_rtc_scada_value', NULL, NULL, NULL, 2, NULL);
INSERT INTO config_ui_forms VALUES (4080, NULL, 'v_rtc_scada_value', NULL, NULL, NULL, 6, NULL);
INSERT INTO config_ui_forms VALUES (4030, NULL, 'v_rtc_scada_value', NULL, true, 120, 1, NULL);
INSERT INTO config_ui_forms VALUES (4110, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 3, NULL);
INSERT INTO config_ui_forms VALUES (3960, NULL, 'v_rtc_scada', NULL, true, 150, 1, NULL);
INSERT INTO config_ui_forms VALUES (3970, NULL, 'v_rtc_scada', NULL, NULL, 150, 2, NULL);
INSERT INTO config_ui_forms VALUES (3980, NULL, 'v_rtc_scada', NULL, true, 150, 3, NULL);
INSERT INTO config_ui_forms VALUES (4130, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 4, NULL);
INSERT INTO config_ui_forms VALUES (4060, NULL, 'v_rtc_scada_value', NULL, true, 100, 4, NULL);
INSERT INTO config_ui_forms VALUES (4050, NULL, 'v_rtc_scada_value', NULL, true, 130, 3, NULL);
INSERT INTO config_ui_forms VALUES (3990, NULL, 'v_rtc_scada', NULL, true, 224, 4, NULL);
INSERT INTO config_ui_forms VALUES (4200, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 5, NULL);
INSERT INTO config_ui_forms VALUES (4070, NULL, 'v_rtc_scada_value', NULL, true, 174, 5, NULL);
INSERT INTO config_ui_forms VALUES (5200, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 10, NULL);
INSERT INTO config_ui_forms VALUES (7200, NULL, 'v_ui_om_visit_x_arc', NULL, true, 120, 6, NULL);
INSERT INTO config_ui_forms VALUES (9200, NULL, 'v_ui_om_visit_x_arc', NULL, true, 165, 8, NULL);
INSERT INTO config_ui_forms VALUES (10200, NULL, 'v_ui_om_visit_x_arc', NULL, true, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (11200, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 11, NULL);
INSERT INTO config_ui_forms VALUES (22000, NULL, 'v_ui_om_visit_x_node', NULL, true, 120, 6, NULL);
INSERT INTO config_ui_forms VALUES (24000, NULL, 'v_ui_om_visit_x_node', NULL, true, 160, 8, NULL);
INSERT INTO config_ui_forms VALUES (25000, NULL, 'v_ui_om_visit_x_node', NULL, true, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (28000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 12, NULL);
INSERT INTO config_ui_forms VALUES (29000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 13, NULL);
INSERT INTO config_ui_forms VALUES (30000, NULL, 'v_ui_om_visit_x_node', NULL, true, 80, 14, NULL);
INSERT INTO config_ui_forms VALUES (37000, NULL, 'v_ui_om_visit_x_connec', NULL, true, 120, 6, NULL);
INSERT INTO config_ui_forms VALUES (3000, NULL, 'v_ui_doc_x_node', NULL, NULL, 150, 5, NULL);
INSERT INTO config_ui_forms VALUES (2950, NULL, 'v_ui_doc_x_arc', NULL, NULL, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (3100, NULL, 'v_ui_doc_x_connec', NULL, NULL, 150, 6, NULL);
INSERT INTO config_ui_forms VALUES (3130, NULL, 'v_ui_doc_x_connec', NULL, NULL, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (3070, NULL, 'v_ui_doc_x_connec', NULL, true, 300, 3, NULL);
INSERT INTO config_ui_forms VALUES (39000, NULL, 'v_ui_om_visit_x_connec', NULL, true, 171, 8, NULL);
INSERT INTO config_ui_forms VALUES (40000, NULL, 'v_ui_om_visit_x_connec', NULL, true, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (45000, NULL, 'v_ui_om_visit_x_connec', NULL, true, 90, 14, NULL);
INSERT INTO config_ui_forms VALUES (46000, NULL, 'v_ui_om_visit_x_connec', NULL, NULL, NULL, 15, NULL);
INSERT INTO config_ui_forms VALUES (52000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 1, NULL);
INSERT INTO config_ui_forms VALUES (54000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 2, NULL);
INSERT INTO config_ui_forms VALUES (55000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 3, NULL);
INSERT INTO config_ui_forms VALUES (62000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 5, NULL);
INSERT INTO config_ui_forms VALUES (63000, NULL, 'v_ui_om_visit_x_gully', NULL, true, 120, 6, NULL);
INSERT INTO config_ui_forms VALUES (64000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 7, NULL);
INSERT INTO config_ui_forms VALUES (65000, NULL, 'v_ui_om_visit_x_gully', NULL, true, 171, 8, NULL);
INSERT INTO config_ui_forms VALUES (66000, NULL, 'v_ui_om_visit_x_gully', NULL, true, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (67000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 10, NULL);
INSERT INTO config_ui_forms VALUES (68000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 11, NULL);
INSERT INTO config_ui_forms VALUES (69000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 12, NULL);
INSERT INTO config_ui_forms VALUES (70000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 13, NULL);
INSERT INTO config_ui_forms VALUES (71000, NULL, 'v_ui_om_visit_x_gully', NULL, true, 90, 14, NULL);
INSERT INTO config_ui_forms VALUES (72000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 15, NULL);
INSERT INTO config_ui_forms VALUES (730, NULL, 'v_ui_doc_x_gully', NULL, NULL, NULL, 1, NULL);
INSERT INTO config_ui_forms VALUES (740, NULL, 'v_ui_doc_x_gully', NULL, NULL, NULL, 2, NULL);
INSERT INTO config_ui_forms VALUES (750, NULL, 'v_ui_doc_x_gully', NULL, true, 300, 3, NULL);
INSERT INTO config_ui_forms VALUES (760, NULL, 'v_ui_doc_x_gully', NULL, true, 150, 4, NULL);
INSERT INTO config_ui_forms VALUES (770, NULL, 'v_ui_doc_x_gully', NULL, NULL, NULL, 5, NULL);
INSERT INTO config_ui_forms VALUES (780, NULL, 'v_ui_doc_x_gully', NULL, NULL, NULL, 6, NULL);
INSERT INTO config_ui_forms VALUES (790, NULL, 'v_ui_doc_x_gully', NULL, true, 81, 7, NULL);
INSERT INTO config_ui_forms VALUES (800, NULL, 'v_ui_doc_x_gully', NULL, NULL, NULL, 8, NULL);
INSERT INTO config_ui_forms VALUES (810, NULL, 'v_ui_doc_x_gully', NULL, NULL, NULL, 9, NULL);
INSERT INTO config_ui_forms VALUES (3862, NULL, 'v_ui_element_x_gully', NULL, NULL, NULL, 1, NULL);
INSERT INTO config_ui_forms VALUES (3863, NULL, 'v_ui_element_x_gully', NULL, NULL, NULL, 2, NULL);
INSERT INTO config_ui_forms VALUES (3864, NULL, 'v_ui_element_x_gully', NULL, true, 150, 3, NULL);
INSERT INTO config_ui_forms VALUES (3866, NULL, 'v_ui_element_x_gully', NULL, true, 196, 4, NULL);
INSERT INTO config_ui_forms VALUES (3650, NULL, 'v_ui_element_x_arc', NULL, NULL, 150, 6, NULL);
INSERT INTO config_ui_forms VALUES (3840, NULL, 'v_ui_element_x_node', NULL, NULL, 150, 7, NULL);
INSERT INTO config_ui_forms VALUES (3610, NULL, 'v_ui_element_x_arc', NULL, NULL, 150, 2, NULL);
INSERT INTO config_ui_forms VALUES (3790, NULL, 'v_ui_element_x_node', NULL, NULL, 150, 2, NULL);
INSERT INTO config_ui_forms VALUES (3660, NULL, 'v_ui_element_x_arc', NULL, NULL, 150, 7, NULL);
INSERT INTO config_ui_forms VALUES (2890, NULL, 'v_ui_doc_x_arc', NULL, true, 300, 3, NULL);
INSERT INTO config_ui_forms VALUES (3600, NULL, 'v_ui_element_x_arc', NULL, NULL, 150, 1, NULL);
INSERT INTO config_ui_forms VALUES (3780, NULL, 'v_ui_element_x_node', NULL, NULL, 150, 1, NULL);
INSERT INTO config_ui_forms VALUES (3680, NULL, 'v_ui_element_x_arc', NULL, NULL, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (3860, NULL, 'v_ui_element_x_node', NULL, NULL, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (3110, NULL, 'v_ui_doc_x_connec', NULL, true, 81, 7, NULL);
INSERT INTO config_ui_forms VALUES (3080, NULL, 'v_ui_doc_x_connec', NULL, true, 150, 4, NULL);
INSERT INTO config_ui_forms VALUES (3060, NULL, 'v_ui_doc_x_connec', NULL, NULL, 150, 2, NULL);
INSERT INTO config_ui_forms VALUES (3050, NULL, 'v_ui_doc_x_connec', NULL, NULL, 150, 1, NULL);
INSERT INTO config_ui_forms VALUES (2940, NULL, 'v_ui_doc_x_arc', NULL, NULL, 150, 8, NULL);
INSERT INTO config_ui_forms VALUES (3090, NULL, 'v_ui_doc_x_connec', NULL, NULL, 150, 5, NULL);
INSERT INTO config_ui_forms VALUES (3120, NULL, 'v_ui_doc_x_connec', NULL, NULL, 150, 8, NULL);
INSERT INTO config_ui_forms VALUES (3270, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, NULL, 140, 5, NULL);
INSERT INTO config_ui_forms VALUES (3280, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, NULL, 140, 6, NULL);
INSERT INTO config_ui_forms VALUES (3230, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, NULL, 100, 1, NULL);
INSERT INTO config_ui_forms VALUES (3240, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, NULL, 130, 2, NULL);
INSERT INTO config_ui_forms VALUES (3260, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, NULL, 125, 4, NULL);
INSERT INTO config_ui_forms VALUES (2900, NULL, 'v_ui_doc_x_arc', NULL, true, 150, 4, NULL);
INSERT INTO config_ui_forms VALUES (2880, NULL, 'v_ui_doc_x_arc', NULL, NULL, NULL, 2, NULL);
INSERT INTO config_ui_forms VALUES (2870, NULL, 'v_ui_doc_x_arc', NULL, NULL, NULL, 1, NULL);
INSERT INTO config_ui_forms VALUES (2910, NULL, 'v_ui_doc_x_arc', NULL, NULL, 150, 5, NULL);
INSERT INTO config_ui_forms VALUES (2920, NULL, 'v_ui_doc_x_arc', NULL, NULL, 150, 6, NULL);
INSERT INTO config_ui_forms VALUES (2930, NULL, 'v_ui_doc_x_arc', NULL, true, 81, 7, NULL);
INSERT INTO config_ui_forms VALUES (2970, NULL, 'v_ui_doc_x_node', NULL, NULL, 150, 2, NULL);
INSERT INTO config_ui_forms VALUES (2960, NULL, 'v_ui_doc_x_node', NULL, NULL, 150, 1, NULL);
INSERT INTO config_ui_forms VALUES (3250, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, true, 125, 3, NULL);
INSERT INTO config_ui_forms VALUES (3292, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, true, 120, 8, NULL);
INSERT INTO config_ui_forms VALUES (3294, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, true, 120, 9, NULL);
INSERT INTO config_ui_forms VALUES (3290, NULL, 'v_edit_rtc_hydro_data_x_connec', NULL, true, 160, 7, NULL);
INSERT INTO config_ui_forms VALUES (3300, NULL, 'v_rtc_hydrometer', NULL, true, 100, 1, NULL);
INSERT INTO config_ui_forms VALUES (3310, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 2, NULL);
INSERT INTO config_ui_forms VALUES (3330, NULL, 'v_rtc_hydrometer', NULL, NULL, 130, 4, NULL);
INSERT INTO config_ui_forms VALUES (3350, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 6, NULL);
INSERT INTO config_ui_forms VALUES (3370, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 8, NULL);
INSERT INTO config_ui_forms VALUES (3380, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (3390, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 10, NULL);
INSERT INTO config_ui_forms VALUES (3400, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 11, NULL);
INSERT INTO config_ui_forms VALUES (3410, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 12, NULL);
INSERT INTO config_ui_forms VALUES (2990, NULL, 'v_ui_doc_x_node', NULL, true, 150, 4, NULL);
INSERT INTO config_ui_forms VALUES (3420, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 13, NULL);
INSERT INTO config_ui_forms VALUES (3320, NULL, 'v_rtc_hydrometer', NULL, NULL, 150, 3, NULL);
INSERT INTO config_ui_forms VALUES (3430, NULL, 'v_rtc_hydrometer', NULL, NULL, 100, 14, NULL);
INSERT INTO config_ui_forms VALUES (3360, NULL, 'v_rtc_hydrometer', NULL, true, 150, 7, NULL);
INSERT INTO config_ui_forms VALUES (3340, NULL, 'v_rtc_hydrometer', NULL, true, 175, 5, NULL);
INSERT INTO config_ui_forms VALUES (3010, NULL, 'v_ui_doc_x_node', NULL, NULL, 150, 6, NULL);
INSERT INTO config_ui_forms VALUES (3030, NULL, 'v_ui_doc_x_node', NULL, NULL, 150, 8, NULL);
INSERT INTO config_ui_forms VALUES (3040, NULL, 'v_ui_doc_x_node', NULL, NULL, 150, 9, NULL);
INSERT INTO config_ui_forms VALUES (3020, NULL, 'v_ui_doc_x_node', NULL, true, 81, 7, NULL);
INSERT INTO config_ui_forms VALUES (2980, NULL, 'v_ui_doc_x_node', NULL, true, 300, 3, NULL);
INSERT INTO config_ui_forms VALUES (15000, NULL, 'v_ui_om_visit_x_arc', NULL, true, 85, 14, NULL);
INSERT INTO config_ui_forms VALUES (17000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 1, NULL);
INSERT INTO config_ui_forms VALUES (18000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 2, NULL);
INSERT INTO config_ui_forms VALUES (19000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 3, NULL);
INSERT INTO config_ui_forms VALUES (20000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 4, NULL);
INSERT INTO config_ui_forms VALUES (21000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 5, NULL);
INSERT INTO config_ui_forms VALUES (23000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 7, NULL);
INSERT INTO config_ui_forms VALUES (26000, NULL, 'v_ui_om_visit_x_node', NULL, NULL, NULL, 10, NULL);
INSERT INTO config_ui_forms VALUES (60000, NULL, 'v_ui_om_visit_x_gully', NULL, NULL, NULL, 4, NULL);
INSERT INTO config_ui_forms VALUES (3890, NULL, 'v_ui_element_x_connec', NULL, NULL, 150, 1, NULL);
INSERT INTO config_ui_forms VALUES (3892, NULL, 'v_ui_element_x_connec', NULL, NULL, 100, 2, NULL);
INSERT INTO config_ui_forms VALUES (3906, NULL, 'v_ui_element_x_connec', NULL, NULL, 100, 9, NULL);
INSERT INTO config_ui_forms VALUES (4100, NULL, 'v_ui_om_visit_x_arc', NULL, NULL, NULL, 1, NULL);



INSERT INTO config_py_tables VALUES (17, 'v_edit_man_varc', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (18, 'v_edit_man_siphon', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (19, 'v_edit_man_conduit', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (20, 'v_edit_man_waccel', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (21, 'v_edit_man_chamber', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (22, 'v_edit_man_chamber_pol', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (23, 'v_edit_man_netgully', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (24, 'v_edit_man_netgully_pol', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (25, 'v_edit_man_netinit', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (26, 'v_edit_man_wjump', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (27, 'v_edit_man_wwtp', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (28, 'v_edit_man_wwtp_pol', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (29, 'v_edit_man_storage', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (30, 'v_edit_man_storage_pol', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (31, 'v_edit_man_outfall', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (32, 'v_edit_man_junction', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (33, 'v_edit_man_manhole', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (34, 'v_edit_man_valve', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (35, 'v_ui_element_x_gully', 'ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (36, 'v_ui_doc_x_gully', 'ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (37, 'v_ui_event_x_gully', 'ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (38, 'v_edit_gully', 'ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (39, 'v_edit_man_wjoin', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (40, 'v_edit_man_tap', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (41, 'v_edit_man_greentap', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (42, 'v_edit_man_fountain', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (43, 'v_edit_man_tank', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (44, 'v_edit_man_pump', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (45, 'v_edit_man_source', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (46, 'v_edit_man_meter', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (47, 'v_edit_man_junction', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (48, 'v_edit_man_manhole', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (49, 'v_edit_man_reduction', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (50, 'v_edit_man_hydrant', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (51, 'v_edit_man_valve', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (52, 'v_edit_man_waterwell', 'ws', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (1, 'v_ui_element_x_arc', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (2, 'v_ui_doc_x_arc', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (3, 'v_ui_event_x_arc', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (4, 'v_ui_element_x_node', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (5, 'v_ui_doc_x_node', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (6, 'v_ui_event_x_node', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (7, 'v_rtc_scada', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (8, 'v_rtc_scada_value', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (9, 'v_ui_element_x_connec', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (10, 'v_ui_doc_x_connec', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (11, 'v_ui_event_x_connec', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (12, 'v_rtc_hydrometer', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (13, 'v_edit_rtc_hydro_data_x_connec', 'ws&ud', NULL, NULL, NULL, true, false);
INSERT INTO config_py_tables VALUES (14, 'v_edit_arc', 'ws&ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (15, 'v_edit_node', 'ws&ud', NULL, NULL, NULL, true, true);
INSERT INTO config_py_tables VALUES (16, 'v_edit_connec', 'ws&ud', NULL, NULL, NULL, true, true);
