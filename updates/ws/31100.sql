/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- ----------------------------
-- EXPLOTITATION STRATEGY
-- ----------------------------




-- ANALYSIS




-- mincut





-- ----------------------------
-- REVIEW AND UPDATE DATA ON WEB/MOBILE CLIENT
-- ----------------------------

	
  
   
-------------
-- ALTER TABLES
-------------
ALTER TABLE cat_node ADD COLUMN label varchar(255);
ALTER TABLE cat_arc ADD COLUMN label varchar(255);
ALTER TABLE cat_connec ADD COLUMN label varchar(255);


/* Inserted on i18n file: ws_74_audit_vdomain_error
INSERT INTO audit_cat_error VALUES (3006, 'There are one or more arc(s) with null nodes. Mincut is broken (arc_id=)','Please review your data',2, true, NULL);
*/


----------------------
--04/06/2018
-----------------------
INSERT INTO audit_cat_table VALUES ('anl_mincut_result_cat', 'Mincut', 'Catalog of mincut results', 'role_om', 0, NULL, NULL, 0, NULL, 'anl_mincut_result_cat_seq', 'id');
INSERT INTO audit_cat_table VALUES ('v_edit_cad_auxcircle', 'CAD layer', 'Layer to store circle geometry when CAD tool is used', 'role_edit', 0, NULL, 'role_edit', 0, NULL, NULL, NULL);
INSERT INTO audit_cat_table VALUES ('v_edit_cad_auxpoint', 'CAD layer', 'Layer to store point geometry when CAD tool is used', 'role_edit', 0, NULL, 'role_edit', 0, NULL, NULL, NULL); 
 













