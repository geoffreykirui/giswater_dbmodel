/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


-- 2019/01/26
DELETE FROM config_client_forms WHERE table_id='v_ui_anl_mincut_result_cat' AND colum_id='macroexpl_id' AND column_index=8
UPDATE  config_client_forms SET status=false WHERE table_id='v_ui_anl_mincut_result_cat' AND column_index=2

-- 2019/02/01
ALTER TABLE anl_mincut_cat_state DROP CONSTRAINT anl_mincut_cat_state_check;
INSERT INTO anl_mincut_cat_state VALUES (3, 'Canceled');