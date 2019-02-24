/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_arc_insp
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent('arc');
  
  
  CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_arc_singlevent
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('arc');
   
    
  CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_connec_insp
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent('connec');
  
 
  CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_connec_singlevent
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('connec');
   
   
  CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_node_insp
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent('node');
  
  CREATE TRIGGER gw_trg_om_visit_singlevent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_node_singlevent
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_singlevent('node');
  
  
  CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_noinfra_typea
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent('noinfra');

  
  CREATE TRIGGER gw_trg_om_visit_multievent
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_noinfra_typeb
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_om_visit_multievent('noinfra');

  CREATE TRIGGER gw_trg_visit_user_manager
  INSTEAD OF INSERT OR UPDATE OR DELETE
  ON SCHEMA_NAME.ve_visit_user_manager
  FOR EACH ROW
  EXECUTE PROCEDURE SCHEMA_NAME.gw_trg_visit_user_manager();


  