/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


INSERT INTO plan_typevalue ('psector_status', 0, 'EXECUTED', 'Psector done');
INSERT INTO plan_typevalue ('psector_status', 1, 'ONGOING', 'Psector on course');
INSERT INTO plan_typevalue ('psector_status', 2, 'PLANNED', 'Psector planned');
INSERT INTO plan_typevalue ('psector_status', 3, 'CANCELED', 'Psector canceled');


INSERT INTO cat_feature VALUES ('CLORINATHOR', 'NETELEMENT', 'NODE');
INSERT INTO node_type  VALUES ('CLORINATHOR', 'NETELEMENT', 'SHORTPIPE', 'man_netelement', 'inp_shortpipe', true, true, 2, true, 'Element to reclorate water', NULL, true, 'DQA');