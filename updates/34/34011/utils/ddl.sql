/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/05/25
ALTER TABLE config_param_system DROP CONSTRAINT config_param_system_pkey;
ALTER TABLE config_param_system DROP CONSTRAINT config_param_system_parameter_unique;
ALTER TABLE config_param_system ADD CONSTRAINT config_param_system_pkey PRIMARY KEY(parameter);
ALTER TABLE config_param_system DROP COLUMN id;


ALTER TABLE config_param_user DROP CONSTRAINT config_param_user_pkey;
ALTER TABLE config_param_user DROP CONSTRAINT config_param_user_parameter_cur_user_unique;
ALTER TABLE config_param_user ADD CONSTRAINT config_param_user_pkey PRIMARY KEY(parameter, cur_user);
ALTER TABLE config_param_user DROP COLUMN id;


DROP RULE IF EXISTS insert_plan_psector_x_node ON node;
CREATE OR REPLACE RULE insert_plan_psector_x_node AS ON INSERT TO node
WHERE new.state = 2 DO  INSERT INTO plan_psector_x_node (node_id, psector_id, state, doable)
VALUES (new.node_id, ( SELECT config_param_user.value::integer AS value FROM config_param_user
WHERE config_param_user.parameter::text = 'plan_psector_vdefault'::text AND config_param_user.cur_user::name = "current_user"() LIMIT 1), 1, true);

DROP RULE IF EXISTS insert_plan_psector_x_arc ON arc;
CREATE OR REPLACE RULE insert_plan_psector_x_arc AS ON INSERT TO arc
WHERE new.state = 2 DO  INSERT INTO plan_psector_x_arc (arc_id, psector_id, state, doable)
VALUES (new.arc_id, ( SELECT config_param_user.value::integer AS value FROM config_param_user
WHERE config_param_user.parameter::text = 'plan_psector_vdefault'::text AND config_param_user.cur_user::name = "current_user"() LIMIT 1), 1, true);