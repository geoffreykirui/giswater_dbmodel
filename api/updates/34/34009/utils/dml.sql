/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

UPDATE om_visit_class SET formname = a.formname, tablename = a.tablename FROM _config_api_visit_ a WHERE om_visit_class.id = a.visitclass_id;

--update audit_cat_param_user with cat_feature vdefaults
UPDATE cat_feature SET id=id;

UPDATE config_typevalue_fk SET target_table = 'config_form_fields' WHERE target_table = 'config_api_form_fields';
UPDATE config_typevalue_fk SET target_table = 'config_info_layer' WHERE target_table = 'config_api_layer';
UPDATE config_typevalue_fk SET target_table = 'config_form_tabs' WHERE target_table = 'config_api_form_tabs';
UPDATE config_typevalue_fk SET target_table = 'config_form_fields' WHERE target_table = 'config_api_form_fields';


COMMENT ON TABLE sys_function
  IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is possible to create own functions. Ids from 10000 to 20000 are reserved to work with. Check true on iscustom column';


COMMENT ON TABLE sys_fprocess
  IS 'INSTRUCTIONS TO WORK WITH THIS TABLE:
It is possible to create own process. Ids from 10000 to 20000 are reserved to work with. Check true on iscustom column';
