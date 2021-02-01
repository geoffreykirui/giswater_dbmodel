/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/09/30

ALTER TABLE cat_mat_roughness DROP CONSTRAINT IF EXISTS inp_cat_mat_roughness_unique;
ALTER TABLE cat_mat_roughness
  ADD CONSTRAINT cat_mat_roughness_unique UNIQUE(matcat_id, init_age, end_age);

ALTER TABLE cat_mat_roughness DROP CONSTRAINT IF EXISTS inp_cat_mat_roughness_matcat_id_fkey;
ALTER TABLE cat_mat_roughness
  ADD CONSTRAINT cat_mat_roughness_matcat_id_fkey FOREIGN KEY (matcat_id)
      REFERENCES cat_mat_arc (id) MATCH SIMPLE
      ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE cat_mat_roughness DROP CONSTRAINT IF EXISTS inp_cat_mat_roughness_pkey;

ALTER TABLE cat_mat_roughness ADD CONSTRAINT cat_mat_roughness_pkey PRIMARY KEY(id);

-- 2020/01/07
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_cat_type", "oldName":"anl_mincut_cat_type_pkey", "newName":"om_mincut_cat_type_pkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut", "oldName":"anl_mincut_result_cat_pkey", "newName":"om_mincut_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut", "oldName":"anl_mincut_result_cat_anl_assigned_to_fkey", "newName":"om_mincut_assigned_to_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut", "oldName":"anl_mincut_result_cat_feature_type_fkey", "newName":"om_mincut_feature_type_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut", "oldName":"anl_mincut_result_cat_mincut_type_fkey", "newName":"om_mincut_mincut_type_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_arc", "oldName":"anl_mincut_result_arc_pkey", "newName":"om_mincut_arc_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_arc", "oldName":"anl_mincut_result_arc_result_id_fkey", "newName":"om_mincut_arc_result_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_arc", "oldName":"anl_mincut_result_arc_unique_result_arc", "newName":"om_mincut_arc_unique_result_arc"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_node", "oldName":"anl_mincut_result_node_pkey", "newName":"om_mincut_node_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_node", "oldName":"anl_mincut_result_node_result_id_fkey", "newName":"om_mincut_node_result_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_node", "oldName":"anl_mincut_result_arc_unique_result_node", "newName":"om_mincut_node_unique_result_node"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_hydrometer", "oldName":"anl_mincut_result_hydrometer_pkey", "newName":"om_mincut_hydrometer_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_hydrometer", "oldName":"anl_mincut_result_hydrometer_result_id_fkey", "newName":"om_mincut_hydrometer_result_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_hydrometer", "oldName":"anl_mincut_result_hydrometer_unique_result_hydrometer", "newName":"om_mincut_hydrometer_unique_result_hydrometer"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_polygon", "oldName":"anl_mincut_result_polygon_pkey", "newName":"om_mincut_polygon_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_polygon", "oldName":"anl_mincut_result_polygon_result_id_fkey", "newName":"om_mincut_polygon_result_id_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_valve", "oldName":"anl_mincut_result_valve_pkey", "newName":"om_mincut_valve_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_valve", "oldName":"anl_mincut_result_valve_result_id_fkey", "newName":"om_mincut_valve_result_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_valve", "oldName":"anl_mincut_result_valve_unique_result_node", "newName":"om_mincut_valve_unique_result_node"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_valve_unaccess", "oldName":"anl_mincut_result_valve_unaccess_pkey", "newName":"om_mincut_valve_unaccess_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_valve_unaccess", "oldName":"anl_mincut_result_valve_unaccess_result_id_fkey", "newName":"om_mincut_valve_unaccess_result_id_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_graf_inlet", "oldName":"anl_mincut_inlet_x_exploitation_expl_id_fkey", "newName":"config_graf_inlet_expl_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_graf_inlet", "oldName":"anl_mincut_inlet_x_exploitation_node_id_fkey", "newName":"config_graf_inlet_node_id_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_checkvalve", "oldName":"anl_mincut_checkvalve_pkey", "newName":"config_checkvalve_pkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_connec", "oldName":"anl_mincut_result_connec_pkey", "newName":"om_mincut_connec_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_connec", "oldName":"anl_mincut_result_connec_result_id_fkey", "newName":"om_mincut_connec_result_id_fkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"om_mincut_connec", "oldName":"anl_mincut_result_connec_unique_result_connec", "newName":"om_mincut_connec_unique_result_connec"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_valve", "oldName":"anl_mincut_selector_valve_pkey", "newName":"config_valve_pkey"}}$$);
SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"config_valve", "oldName":"anl_mincut_selector_valve_id_fkey", "newName":"config_valve_valve_id_fkey"}}$$);

SELECT gw_fct_admin_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"RENAME", "table":"selector_mincut_result", "oldName":"anl_mincut_result_selector_id_fkey", "newName":"selector_mincut_result_selector_id_fkey"}}$$);

