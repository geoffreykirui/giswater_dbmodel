/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/09
ALTER TABLE edit_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
ALTER TABLE inp_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
ALTER TABLE plan_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
ALTER TABLE om_typevalue ENABLE TRIGGER gw_trg_typevalue_config_fk;
 