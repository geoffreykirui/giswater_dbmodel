/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

-- 2020/12/07

CREATE TRIGGER gw_trg_vi_coverages
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_coverages
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_coverages');

CREATE TRIGGER gw_trg_vi_groundwater
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_groundwater
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_groundwater');

  CREATE TRIGGER gw_trg_vi_infiltration
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_infiltration
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_infiltration');


CREATE TRIGGER gw_trg_vi_labels
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON vi_labels
  FOR EACH ROW
  EXECUTE PROCEDURE gw_trg_vi('vi_labels');


