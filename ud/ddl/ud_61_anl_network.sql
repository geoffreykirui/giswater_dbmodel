/*
This file is part of Giswater 2.0
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


-- ----------------------------
-- TOPOLOGY TOOLS
-- ----------------------------

SET search_path = "SCHEMA_NAME", public;


CREATE TABLE "anl_node_sink" (
node_id varchar (16) NOT NULL,
num_arcs integer,
the_geom public.geometry (POINT, SRID_VALUE),
CONSTRAINT anl_sink_pkey PRIMARY KEY (node_id)
);




CREATE INDEX anl_node_sink_index ON anl_node_sink USING GIST (the_geom);
