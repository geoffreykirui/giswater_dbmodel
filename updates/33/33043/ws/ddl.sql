/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


--2020/03/18
CREATE INDEX node_dqa ON node USING btree (dqa_id);
CREATE INDEX arc_dqa ON arc USING btree (dqa_id);
CREATE INDEX connec_dqa ON connec USING btree (dqa_id);
