/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


ALTER TABLE plan_psector ADD COLUMN status integer;


CREATE TABLE plan_typevalue(
  typevalue text NOT NULL,
  id integer NOT NULL,
  idval text,
  descript text,
  CONSTRAINT om_visit_typevalue_pkey PRIMARY KEY (typevalue, id));
  
 
ALTER TABLE cat_arc ALTER COLUMN id DROP DEFAULT;
ALTER TABLE cat_node ALTER COLUMN id DROP DEFAULT;
  
  
  