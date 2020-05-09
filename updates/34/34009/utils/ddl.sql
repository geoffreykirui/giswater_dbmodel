/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = ws_sample, public, pg_catalog;

-- 2020/05/09
ALTER TABLE sys_csv2pg_config RENAME TO config_csv_param;
ALTER TABLE sys_fprocess_cat RENAME TO sys_fprocess;
ALTER TABLE sys_typevalue_cat RENAME TO sys_typevalue;
ALTER TABLE sys_csv2pg_cat RENAME TO config_csv;
ALTER TABLE audit_cat_function RENAME TO sys_function;


CREATE TABLE config_toolbox (
id integer PRIMARY KEY,
alias text,
isparametric boolean,
functionparams json,
inputparams json,
observ text
);


INSERT INTO config_toolbox
SELECT id, alias, isparametric, input_params::json, return_type::json, context FROM sys_function WHERE istoolbox IS TRUE;

SELECT * FROM audit_log_data
SELECT * FROM audit_check_data


SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"istoolbox"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"isparametric"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"context"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"sys_function", "column":"alias"}}$$);

SELECT gw_fct_admin_manage_fields($${"data":{"action":"DROP","table":"config_csv", "column":"name_i18n"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"config_csv", "column":"name", "newName":"alias"}}$$);

ALTER TABLE audit_check_feature RENAME to _audit_check_feature_ ;
ALTER TABLE audit_log_feature RENAME to _audit_log_feature_ ;
ALTER TABLE audit_log_project RENAME to _audit_log_project_ ;
ALTER TABLE audit_log_csv2pg RENAME to _audit_log_csv2pg_ ;
ALTER TABLE audit_log_arc_traceability RENAME to audit_arc_traceability;


--harmonize audit_log_data
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_log_data", "column":"table_id", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_log_data", "column":"column_id", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_log_data", "column":"addparam", "dataType":"json"}}$$);

--harmonize audit_check_data
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_check_data", "column":"feature_type", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_check_data", "column":"feature_id", "dataType":"text"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"ADD","table":"audit_check_data", "column":"addparam", "dataType":"json"}}$$);

-- harmonize cur_user
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"audit_log_data", "column":"user_name", "newName":"cur_user"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"audit_check_project", "column":"user_name", "newName":"cur_user"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"audit_check_project", "column":"user_name", "newName":"cur_user"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"temp_table", "column":"user_name", "newName":"cur_user"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"audit_log_arc_traceability", "column":"user", "newName":"cur_user"}}$$);
SELECT gw_fct_admin_manage_fields($${"data":{"action":"RENAME","table":"temp_csv2pg", "column":"user_name", "newName":"cur_user"}}$$);
