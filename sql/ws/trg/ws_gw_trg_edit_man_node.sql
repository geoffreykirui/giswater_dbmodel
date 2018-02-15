﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
*/

--FUNCTION CODE: 1318


-- DROP FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node();

CREATE OR REPLACE FUNCTION "SCHEMA_NAME".gw_trg_edit_man_node()
  RETURNS trigger AS
$BODY$
DECLARE 
    inp_table varchar;
    v_sql varchar;
    v_sql2 varchar;
    man_table varchar;
	man_table_2 varchar;
    new_man_table varchar;
    old_man_table varchar;
    old_nodetype varchar;
    new_nodetype varchar;
    node_id_seq int8;
	rec Record;
	code_autofill_bool boolean;
	rec_aux text;
	node_id_aux text;
	delete_aux text;
	tablename_aux varchar;
	pol_id_aux varchar;
	query_text text;
	count_aux integer;
	promixity_buffer_aux double precision;

BEGIN

    EXECUTE 'SET search_path TO '||quote_literal(TG_TABLE_SCHEMA)||', public';
	man_table:= TG_ARGV[0];
	man_table_2:=man_table;
	
	--Get data from config table
	SELECT * INTO rec FROM config;	
	promixity_buffer_aux = (SELECT "value" FROM config_param_system WHERE "parameter"='proximity_buffer');
	
-- INSERT

    -- Control insertions ID
	IF TG_OP = 'INSERT' THEN
	
		-- Node ID	
		IF (NEW.node_id IS NULL) THEN
			--PERFORM setval('urn_id_seq', gw_fct_urn(),true);
			NEW.node_id:= (SELECT nextval('urn_id_seq'));
		END IF;
	
		-- Node Catalog ID
		IF (NEW.nodecat_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM cat_node) = 0) THEN
				RETURN audit_function(1006,1318);  
			END IF;
			
			IF man_table='man_tank' OR man_table='man_tank_pol' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='tankcat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_hydrant' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='hydrantcat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_junction' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='junctioncat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_pump' THEN		
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='pumpcat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_reduction' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='reductioncat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_valve' THEN	
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='valvecat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_manhole' THEN	
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='manholecat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_meter' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='metercat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_source' THEN	
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='sourcecat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_waterwell' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='waterwellcat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_filter' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='filtercat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_register' OR man_table='man_register_pol' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='registercat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_netwjoin' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='netwjoincat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_expansiontank' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='expansiontankcat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_flexunion' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='flexuioncat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_netelement' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='netelementcat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_netsamplepoint' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='netsamplepointcat_vdefault' AND "cur_user"="current_user"());
			ELSIF man_table='man_wtp' THEN
				NEW.nodecat_id:= (SELECT "value" FROM config_param_user WHERE "parameter"='wtpcat_vdefault' AND "cur_user"="current_user"());
			END IF;

			IF (NEW.nodecat_id IS NULL) THEN
				PERFORM audit_function(1090,1318);
			END IF;				
			IF (NEW.nodecat_id NOT IN (select cat_node.id FROM cat_node JOIN node_type ON cat_node.nodetype_id=node_type.id WHERE node_type.man_table=man_table_2)) THEN 
				PERFORM audit_function(1092,1318);
			END IF;

		END IF;
		
		-- Epa type
		IF (NEW.epa_type IS NULL) THEN
			NEW.epa_type:= (SELECT epa_default FROM cat_node JOIN node_type ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id LIMIT 1)::text;   
		END IF;
		
        -- Sector ID
        IF (NEW.sector_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM sector) = 0) THEN
                RETURN audit_function(1008,1318);  
			END IF;
				SELECT count(*)into count_aux FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001);
			IF count_aux = 1 THEN
				NEW.sector_id = (SELECT sector_id FROM sector WHERE ST_DWithin(NEW.the_geom, sector.the_geom,0.001) LIMIT 1);
			ELSIF count_aux > 1 THEN
				NEW.sector_id =(SELECT sector_id FROM v_edit_node WHERE ST_DWithin(NEW.the_geom, v_edit_node.the_geom, promixity_buffer_aux) 
				order by ST_Distance (NEW.the_geom, v_edit_node.the_geom) LIMIT 1);
			END IF;	
			IF (NEW.sector_id IS NULL) THEN
				NEW.sector_id := (SELECT "value" FROM config_param_user WHERE "parameter"='sector_vdefault' AND "cur_user"="current_user"());
			END IF;
			IF (NEW.sector_id IS NULL) THEN
                RETURN audit_function(1010,1318);          
            END IF;            
        END IF;
        
	-- Dma ID
        IF (NEW.dma_id IS NULL) THEN
			IF ((SELECT COUNT(*) FROM dma) = 0) THEN
                RETURN audit_function(1012,1318);  
            END IF;
				SELECT count(*)into count_aux FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001);
			IF count_aux = 1 THEN
				NEW.dma_id := (SELECT dma_id FROM dma WHERE ST_DWithin(NEW.the_geom, dma.the_geom,0.001) LIMIT 1);
			ELSIF count_aux > 1 THEN
				NEW.dma_id =(SELECT dma_id FROM v_edit_node WHERE ST_DWithin(NEW.the_geom, v_edit_node.the_geom, promixity_buffer_aux) 
				order by ST_Distance (NEW.the_geom, v_edit_node.the_geom) LIMIT 1);
			END IF;
			IF (NEW.dma_id IS NULL) THEN
				NEW.dma_id := (SELECT "value" FROM config_param_user WHERE "parameter"='dma_vdefault' AND "cur_user"="current_user"());
			END IF; 
            IF (NEW.dma_id IS NULL) THEN
                RETURN audit_function(1014,1318);  
            END IF;            
        END IF;
		
		-- Verified
        IF (NEW.verified IS NULL) THEN
            NEW.verified := (SELECT "value" FROM config_param_user WHERE "parameter"='verified_vdefault' AND "cur_user"="current_user"());
            IF (NEW.verified IS NULL) THEN
                NEW.verified := (SELECT id FROM value_verified limit 1);
            END IF;
        END IF;
		
		-- Presszone
        IF (NEW.presszonecat_id IS NULL) THEN
            NEW.presszonecat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='presszone_vdefault' AND "cur_user"="current_user"());
            IF (NEW.presszonecat_id IS NULL) THEN
                NEW.presszonecat_id := (SELECT id FROM cat_presszone limit 1);
            END IF;
        END IF;
		
		--Inventory
		IF (NEW.inventory IS NULL) THEN
			NEW.inventory :='TRUE';
		END IF; 
		
		-- State
        IF (NEW.state IS NULL) THEN
            NEW.state := (SELECT "value" FROM config_param_user WHERE "parameter"='state_vdefault' AND "cur_user"="current_user"());
            IF (NEW.state IS NULL) THEN
                NEW.state := (SELECT id FROM value_state limit 1);
            END IF;
        END IF;
		
		-- State_type
		IF (NEW.state_type IS NULL) THEN
			NEW.state_type := (SELECT "value" FROM config_param_user WHERE "parameter"='state_type_vdefault' AND "cur_user"="current_user"());
			IF (NEW.state_type IS NULL) THEN
                NEW.state_type := (SELECT id FROM value_state_type limit 1);
            END IF;
        END IF;
		
		-- Exploitation
		IF (NEW.expl_id IS NULL) THEN
			NEW.expl_id := (SELECT "value" FROM config_param_user WHERE "parameter"='exploitation_vdefault' AND "cur_user"="current_user"());
			IF (NEW.expl_id IS NULL) THEN
				NEW.expl_id := (SELECT expl_id FROM exploitation WHERE ST_DWithin(NEW.the_geom, exploitation.the_geom,0.001) LIMIT 1);
				IF (NEW.expl_id IS NULL) THEN
					PERFORM audit_function(2012,1318);
				END IF;		
			END IF;
		END IF;

		-- Municipality 
		IF (NEW.muni_id IS NULL) THEN
			NEW.muni_id := (SELECT "value" FROM config_param_user WHERE "parameter"='municipality_vdefault' AND "cur_user"="current_user"());
			IF (NEW.muni_id IS NULL) THEN
				NEW.muni_id := (SELECT muni_id FROM ext_municipality WHERE ST_DWithin(NEW.the_geom, ext_municipality.the_geom,0.001) LIMIT 1);
				IF (NEW.muni_id IS NULL) THEN
					PERFORM audit_function(2012,1318);
				END IF;	
			END IF;
		END IF;

		SELECT code_autofill INTO code_autofill_bool FROM node JOIN cat_node ON cat_node.id =node.nodecat_id JOIN node_type ON node_type.id=cat_node.nodetype_id WHERE cat_node.id=NEW.nodecat_id ;   

		-- Workcat_id
		IF (NEW.workcat_id IS NULL) THEN
			NEW.workcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='workcat_vdefault' AND "cur_user"="current_user"());
			IF (NEW.workcat_id IS NULL) THEN
				NEW.workcat_id := (SELECT id FROM cat_work limit 1);
			END IF;
		END IF;
		
		-- Ownercat_id
        IF (NEW.ownercat_id IS NULL) THEN
            NEW.ownercat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='ownercat_vdefault' AND "cur_user"="current_user"());
            IF (NEW.ownercat_id IS NULL) THEN
                NEW.ownercat_id := (SELECT id FROM cat_owner limit 1);
            END IF;
        END IF;
		
		-- Soilcat_id
        IF (NEW.soilcat_id IS NULL) THEN
            NEW.soilcat_id := (SELECT "value" FROM config_param_user WHERE "parameter"='soilcat_vdefault' AND "cur_user"="current_user"());
            IF (NEW.soilcat_id IS NULL) THEN
                NEW.soilcat_id := (SELECT id FROM cat_soil limit 1);
            END IF;
        END IF;

		--Builtdate
		IF (NEW.builtdate IS NULL) THEN
			NEW.builtdate :=(SELECT "value" FROM config_param_user WHERE "parameter"='builtdate_vdefault' AND "cur_user"="current_user"());
		END IF;

		--Copy id to code field
		IF (NEW.code IS NULL AND code_autofill_bool IS TRUE) THEN 
			NEW.code=NEW.node_id;
		END IF;
		
		-- Parent id
		SELECT substring (tablename from 8 for 30), pol_id INTO tablename_aux, pol_id_aux FROM polygon JOIN sys_feature_cat ON sys_feature_cat.id=polygon.sys_type
		WHERE ST_DWithin(NEW.the_geom, polygon.the_geom, 0.001) LIMIT 1;
	
		IF pol_id_aux IS NOT NULL THEN
			query_text:= 'SELECT node_id FROM '||tablename_aux||' WHERE pol_id::integer='||pol_id_aux||' LIMIT 1';
			EXECUTE query_text INTO node_id_aux;
			NEW.parent_id=node_id_aux;
		END IF;

		-- DEPENDENCES CONTROL
		-- dma
		IF (SELECT expl_id FROM dma WHERE dma_id=NEW.dma_id) != NEW.expl_id THEN
			RETURN audit_function(2042,1318);
		END IF;
		-- presszone
		IF (SELECT expl_id FROM cat_presszone WHERE id=NEW.presszonecat_id) != NEW.expl_id THEN
			RETURN audit_function(2044,1318);
		END IF;
		-- state type
		IF (SELECT state FROM value_state_type WHERE id=NEW.state_type) != NEW.state THEN	
			RETURN audit_function(2046,1318);
		END IF;
	
			
			
		-- FEATURE INSERT      
		INSERT INTO node (node_id, code, elevation, depth, nodecat_id, epa_type, sector_id, arc_id, parent_id, state, state_type, annotation, observ,comment, dma_id, presszonecat_id, soilcat_id, function_type, category_type, fluid_type, location_type, workcat_id, workcat_id_end,
		buildercat_id, builtdate, enddate, ownercat_id, muni_id,streetaxis_id, streetaxis2_id, postcode, postnumber, postnumber2, postcomplement, postcomplement2, descript, rotation,verified,undelete,label_x,label_y,label_rotation, expl_id, publish, inventory, the_geom, hemisphere, num_value) 
		VALUES (NEW.node_id, NEW.code, NEW.elevation, NEW.depth, NEW.nodecat_id, NEW.epa_type, NEW.sector_id, NEW.arc_id, NEW.parent_id, NEW.state, NEW.state_type, NEW.annotation, NEW.observ, NEW.comment,NEW.dma_id, NEW.presszonecat_id,
		NEW.soilcat_id, NEW.function_type, NEW.category_type, NEW.fluid_type, NEW.location_type,NEW.workcat_id, NEW.workcat_id_end, NEW.buildercat_id, NEW.builtdate, NEW.enddate, NEW.ownercat_id, NEW.muni_id, 
		NEW.streetaxis_id, NEW.streetaxis2_id, NEW.postcode,NEW.postnumber,NEW.postnumber2, NEW.postcomplement, NEW.postcomplement2, NEW.descript, NEW.rotation, NEW.verified, NEW.undelete,NEW.label_x,NEW.label_y,NEW.label_rotation, 
		NEW.expl_id, NEW.publish, NEW.inventory, NEW.the_geom,  NEW.hemisphere,NEW.num_value);
		
		IF man_table='man_tank' THEN
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('urn_id_seq'));
					END IF;
					
					INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value))) 
					from "SCHEMA_NAME".node where node_id=NEW.node_id));
					INSERT INTO man_tank (node_id,pol_id, vmax, vutil, area, chlorination,name) VALUES (NEW.node_id, NEW.pol_id, NEW.vmax, NEW.vutil, NEW.area,NEW.chlorination, NEW.name);

			ELSE
				INSERT INTO man_tank (node_id, vmax, vutil, area, chlorination,name) VALUES (NEW.node_id, NEW.vmax, NEW.vutil, NEW.area,NEW.chlorination, NEW.name);
			END IF;
					
		ELSIF man_table='man_hydrant' THEN
			INSERT INTO man_hydrant (node_id, fire_code, communication,valve,valve_diam) VALUES (NEW.node_id,NEW.fire_code, NEW.communication,NEW.valve, NEW.valve_diam);		
		
		ELSIF man_table='man_junction' THEN
			INSERT INTO man_junction (node_id) VALUES(NEW.node_id);
			
		ELSIF man_table='man_pump' THEN		
			INSERT INTO man_pump (node_id, max_flow, min_flow, nom_flow, power, pressure, elev_height,name, pump_number) 
			VALUES(NEW.node_id, NEW.max_flow, NEW.min_flow, NEW.nom_flow, NEW.power, NEW.pressure, NEW.elev_height, NEW.name, NEW.pump_number);
		
		ELSIF man_table='man_reduction' THEN
			INSERT INTO man_reduction (node_id,diam1,diam2) VALUES(NEW.node_id,NEW.diam1, NEW.diam2);
		
		ELSIF man_table='man_valve' THEN	
			INSERT INTO man_valve (node_id,closed, broken, buried,irrigation_indicator,pression_entry, pression_exit, depth_valveshaft,regulator_situation, regulator_location, regulator_observ,lin_meters, exit_type,exit_code,drive_type, cat_valve2) 
			VALUES (NEW.node_id, NEW.closed, NEW.broken, NEW.buried, NEW.irrigation_indicator, NEW.pression_entry, NEW.pression_exit, NEW.depth_valveshaft, NEW.regulator_situation, NEW.regulator_location, NEW.regulator_observ, NEW.lin_meters, 
			NEW.exit_type, NEW.exit_code, NEW.drive_type, NEW.cat_valve2);
		
		ELSIF man_table='man_manhole' THEN	
			INSERT INTO man_manhole (node_id, name) VALUES(NEW.node_id, NEW.name);
		
		ELSIF man_table='man_meter' THEN
			INSERT INTO man_meter (node_id) VALUES(NEW.node_id);
		
		ELSIF man_table='man_source' THEN	
			INSERT INTO man_source (node_id, name) VALUES(NEW.node_id, NEW.name);
		
		ELSIF man_table='man_waterwell' THEN
			INSERT INTO man_waterwell (node_id, name) VALUES(NEW.node_id, NEW.name);
		
		ELSIF man_table='man_filter' THEN
			INSERT INTO man_filter (node_id) VALUES(NEW.node_id);	
		
		ELSIF man_table='man_register' THEN
			IF (rec.insert_double_geometry IS TRUE) THEN
				IF (NEW.pol_id IS NULL) THEN
					NEW.pol_id:= (SELECT nextval('urn_id_seq'));
				END IF;
				INSERT INTO polygon(pol_id,the_geom) VALUES (NEW.pol_id,(SELECT ST_Multi(ST_Envelope(ST_Buffer(node.the_geom,rec.buffer_value))) from "SCHEMA_NAME".node where node_id=NEW.node_id));			
				INSERT INTO man_register (node_id,pol_id) VALUES (NEW.node_id, NEW.pol_id);
			ELSE
				INSERT INTO man_register (node_id) VALUES (NEW.node_id);
			END IF;
			
		ELSIF man_table='man_netwjoin' THEN
			INSERT INTO man_netwjoin (node_id, top_floor,  cat_valve, customer_code) 
			VALUES(NEW.node_id, NEW.top_floor, NEW.cat_valve, NEW.customer_code);
		
		ELSIF man_table='man_expansiontank' THEN
			INSERT INTO man_expansiontank (node_id) VALUES(NEW.node_id);
		
		ELSIF man_table='man_flexunion' THEN
			INSERT INTO man_flexunion (node_id) VALUES(NEW.node_id);
		
		ELSIF man_table='man_netelement' THEN
			INSERT INTO man_netelement (node_id, serial_number) VALUES(NEW.node_id, NEW.serial_number);		
		
		ELSIF man_table='man_netsamplepoint' THEN
			INSERT INTO man_netsamplepoint (node_id, lab_code) VALUES(NEW.node_id, NEW.lab_code);
		
		ELSIF man_table='man_wtp' THEN
			INSERT INTO man_wtp (node_id, name) VALUES(NEW.node_id, NEW.name);
		
		END IF;

								
	-- EPA insert
        IF (NEW.epa_type = 'JUNCTION') THEN 
			INSERT INTO inp_junction (node_id) VALUES (NEW.node_id);

        ELSIF (NEW.epa_type = 'TANK') THEN 
			INSERT INTO inp_tank (node_id) VALUES (NEW.node_id);

        ELSIF (NEW.epa_type = 'RESERVOIR') THEN
			INSERT INTO inp_reservoir (node_id) VALUES (NEW.node_id);
			
        ELSIF (NEW.epa_type = 'PUMP') THEN
			INSERT INTO inp_pump (node_id, status) VALUES (NEW.node_id, 'OPEN');

        ELSIF (NEW.epa_type = 'VALVE') THEN
			INSERT INTO inp_valve (node_id, valv_type, status) VALUES (NEW.node_id, 'PRV', 'ACTIVE');

        ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
			INSERT INTO inp_shortpipe (node_id) VALUES (NEW.node_id);
			
        END IF;

        RETURN NEW;

	-- UPDATE
    ELSIF TG_OP = 'UPDATE' THEN

		-- EPA update
        IF (NEW.epa_type != OLD.epa_type) THEN    
         
            IF (OLD.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';            
            ELSIF (OLD.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';                
            ELSIF (OLD.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';    
            ELSIF (OLD.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (OLD.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (OLD.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'DELETE FROM '||inp_table||' WHERE node_id = '||quote_literal(OLD.node_id);
                EXECUTE v_sql;
            END IF;
			inp_table := NULL;

            IF (NEW.epa_type = 'JUNCTION') THEN
                inp_table:= 'inp_junction';   
            ELSIF (NEW.epa_type = 'TANK') THEN
                inp_table:= 'inp_tank';     
            ELSIF (NEW.epa_type = 'RESERVOIR') THEN
                inp_table:= 'inp_reservoir';  
            ELSIF (NEW.epa_type = 'SHORTPIPE') THEN
                inp_table:= 'inp_shortpipe';    
            ELSIF (NEW.epa_type = 'VALVE') THEN
                inp_table:= 'inp_valve';    
            ELSIF (NEW.epa_type = 'PUMP') THEN
                inp_table:= 'inp_pump';  
            END IF;
            IF inp_table IS NOT NULL THEN
                v_sql:= 'INSERT INTO '||inp_table||' (node_id) VALUES ('||quote_literal(NEW.node_id)||')';
                EXECUTE v_sql;
            END IF;
        END IF;

		-- State
		IF (NEW.state != OLD.state) THEN
			UPDATE node SET state=NEW.state WHERE node_id = OLD.node_id;
		END IF;
		
		-- State_type
		IF NEW.state=0 AND OLD.state=1 THEN
			IF (SELECT state FROM value_state_type WHERE id=NEW.state_type) != NEW.state THEN
			NEW.state_type=(SELECT "value" FROM config_param_user WHERE parameter='statetype_end_vdefault' AND "cur_user"="current_user"());
				IF NEW.state_type IS NULL THEN
				NEW.state_type=(SELECT id from value_state_type WHERE state=0 LIMIT 1);
					IF NEW.state_type IS NULL THEN
					RETURN audit_function(2110,1318);
					END IF;
				END IF;
			END IF;
		END IF;
        
		-- The geom
		IF (NEW.the_geom IS DISTINCT FROM OLD.the_geom) THEN
		
			--the_geom
			UPDATE node SET the_geom=NEW.the_geom WHERE node_id = OLD.node_id;
			
			-- Parent id
			SELECT substring (tablename from 8 for 30), pol_id INTO tablename_aux, pol_id_aux FROM polygon JOIN sys_feature_cat ON sys_feature_cat.id=polygon.sys_type
			WHERE ST_DWithin(NEW.the_geom, polygon.the_geom, 0.001) LIMIT 1;
	
			IF pol_id_aux IS NOT NULL THEN
				query_text:= 'SELECT node_id FROM '||tablename_aux||' WHERE pol_id::integer='||pol_id_aux||' LIMIT 1';
				EXECUTE query_text INTO node_id_aux;
				NEW.parent_id=node_id_aux;
			END IF;
						
		END IF;
	
		--Label rotation
		IF (NEW.rotation != OLD.rotation) THEN
			   UPDATE node SET rotation=NEW.rotation WHERE node_id = OLD.node_id;
		END IF;	

		-- DEPENDENCES CONTROL
		-- dma
		IF (SELECT expl_id FROM dma WHERE dma_id=NEW.dma_id) != NEW.expl_id THEN
			RETURN audit_function(2042,1318);
		END IF;
		-- presszone
		IF (SELECT expl_id FROM cat_presszone WHERE id=NEW.presszonecat_id) != NEW.expl_id THEN
			RETURN audit_function(2044,1318);
		END IF;
		-- state type
		IF (SELECT state FROM value_state_type WHERE id=NEW.state_type) != NEW.state THEN	
			RETURN audit_function(2046,1318);
		END IF;

		
		UPDATE node 
		SET code=NEW.code, elevation=NEW.elevation, "depth"=NEW."depth", nodecat_id=NEW.nodecat_id, epa_type=NEW.epa_type, sector_id=NEW.sector_id, arc_id=NEW.arc_id, parent_id=NEW.parent_id,
		state_type=NEW.state_type, annotation=NEW.annotation, "observ"=NEW."observ", "comment"=NEW."comment", dma_id=NEW.dma_id, presszonecat_id=NEW.presszonecat_id, soilcat_id=NEW.soilcat_id, 
		function_type=NEW.function_type, category_type=NEW.category_type, fluid_type=NEW.fluid_type, location_type=NEW.location_type, workcat_id=NEW.workcat_id, workcat_id_end=NEW.workcat_id_end,  
		buildercat_id=NEW.buildercat_id,builtdate=NEW.builtdate, enddate=NEW.enddate, ownercat_id=NEW.ownercat_id, muni_id=NEW.muni_id, streetaxis_id=NEW.streetaxis_id, postcomplement=NEW.postcomplement, postcomplement2=NEW.postcomplement2, 
		streetaxis2_id=NEW.streetaxis2_id,postcode=NEW.postcode,postnumber=NEW.postnumber,postnumber2=NEW.postnumber2, descript=NEW.descript, verified=NEW.verified, undelete=NEW.undelete, label_x=NEW.label_x, 
		label_y=NEW.label_y, label_rotation=NEW.label_rotation, publish=NEW.publish, inventory=NEW.inventory, expl_id=NEW.expl_id, hemisphere=NEW.hemisphere, num_value=NEW.num_value
		WHERE node_id = OLD.node_id;
		
		IF man_table ='man_junction' THEN
			UPDATE man_junction SET node_id=NEW.node_id	
			WHERE node_id=OLD.node_id;

		ELSIF man_table ='man_tank' THEN
			UPDATE man_tank SET pol_id=NEW.pol_id, vmax=NEW.vmax, vutil=NEW.vutil, area=NEW.area, chlorination=NEW.chlorination, name=NEW.name
			WHERE node_id=OLD.node_id;
	
		ELSIF man_table ='man_pump' THEN
			UPDATE man_pump SET max_flow=NEW.max_flow, min_flow=NEW.min_flow, nom_flow=NEW.nom_flow, "power"=NEW.power, 
			pressure=NEW.pressure, elev_height=NEW.elev_height, name=NEW.name, pump_number=NEW.pump_number
			WHERE node_id=OLD.node_id;
		
		ELSIF man_table ='man_manhole' THEN
			UPDATE man_manhole SET name=NEW.name
			WHERE node_id=OLD.node_id;

		ELSIF man_table ='man_hydrant' THEN
			UPDATE man_hydrant SET fire_code=NEW.fire_code, communication=NEW.communication, valve=NEW.valve, valve_diam=NEW.valve_diam
			WHERE node_id=OLD.node_id;			

		ELSIF man_table ='man_source' THEN
			UPDATE man_source SET name=NEW.name
			WHERE node_id=OLD.node_id;

		ELSIF man_table ='man_meter' THEN
			UPDATE man_meter SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;

		ELSIF man_table ='man_waterwell' THEN
			UPDATE man_waterwell SET name=NEW.name
			WHERE node_id=OLD.node_id;

		ELSIF man_table ='man_reduction' THEN
			UPDATE man_reduction SET diam1=NEW.diam1, diam2=NEW.diam2
			WHERE node_id=OLD.node_id;

		ELSIF man_table ='man_valve' THEN
			UPDATE man_valve 
			SET closed=NEW.closed, broken=NEW.broken, buried=NEW.buried, irrigation_indicator=NEW.irrigation_indicator, pression_entry=NEW.pression_entry, pression_exit=NEW.pression_exit, 
			depth_valveshaft=NEW.depth_valveshaft, regulator_situation=NEW.regulator_situation, regulator_location=NEW.regulator_location, regulator_observ=NEW.regulator_observ, lin_meters=NEW.lin_meters, 
			exit_type=NEW.exit_type, exit_code=NEW.exit_code, drive_type=NEW.drive_type, cat_valve2=NEW.cat_valve2
			WHERE node_id=OLD.node_id;	
		
		ELSIF man_table ='man_register' THEN
			UPDATE man_register	SET pol_id=NEW.pol_id
			WHERE node_id=OLD.node_id;		
	
		ELSIF man_table ='man_netwjoin' THEN			
			UPDATE man_netwjoin
			SET top_floor= NEW.top_floor, cat_valve=NEW.cat_valve, customer_code=NEW.customer_code
			WHERE node_id=OLD.node_id;		
		
		ELSIF man_table ='man_expansiontank' THEN
			UPDATE man_expansiontank SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;		

		ELSIF man_table ='man_flexunion' THEN
			UPDATE man_flexunion SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;				
		
		ELSIF man_table ='man_netelement' THEN
			UPDATE man_netelement SET serial_number=NEW.serial_number
			WHERE node_id=OLD.node_id;	
	
		ELSIF man_table ='man_netsamplepoint' THEN
			UPDATE man_netsamplepoint SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;		
		
		ELSIF man_table ='man_wtp' THEN		
			UPDATE man_wtp SET name=NEW.name
			WHERE node_id=OLD.node_id;			
			
		ELSIF man_table ='man_filter' THEN
			UPDATE man_filter SET node_id=NEW.node_id
			WHERE node_id=OLD.node_id;
		
		END IF;

            
		RETURN NEW;
    

	-- DELETE
    ELSIF TG_OP = 'DELETE' THEN

		PERFORM gw_fct_check_delete(OLD.node_id, 'NODE');
	
		IF man_table='man_tank' THEN
			DELETE FROM node WHERE node_id=OLD.node_id;
			DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_tank WHERE node_id=OLD.node_id );
		ELSIF man_table='man_register' THEN
			DELETE FROM node WHERE node_id=OLD.node_id;
			DELETE FROM polygon WHERE pol_id IN (SELECT pol_id FROM man_register WHERE node_id=OLD.node_id );
		ELSE 
			DELETE FROM node WHERE node_id = OLD.node_id;
		END IF;
		
        RETURN NULL;
   
    END IF;
    
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;


DROP TRIGGER IF EXISTS gw_trg_edit_man_hydrant ON "SCHEMA_NAME".v_edit_man_hydrant;
CREATE TRIGGER gw_trg_edit_man_hydrant INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_hydrant FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_hydrant');

DROP TRIGGER IF EXISTS gw_trg_edit_man_pump ON "SCHEMA_NAME".v_edit_man_pump;
CREATE TRIGGER gw_trg_edit_man_pump INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_pump FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_pump');

DROP TRIGGER IF EXISTS gw_trg_edit_man_manhole ON "SCHEMA_NAME".v_edit_man_manhole;
CREATE TRIGGER gw_trg_edit_man_manhole INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_manhole FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_manhole');

DROP TRIGGER IF EXISTS gw_trg_edit_man_source ON "SCHEMA_NAME".v_edit_man_source;
CREATE TRIGGER gw_trg_edit_man_source INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_source FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_source');

DROP TRIGGER IF EXISTS gw_trg_edit_man_meter ON "SCHEMA_NAME".v_edit_man_meter;
CREATE TRIGGER gw_trg_edit_man_meter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_meter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_meter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_tank ON "SCHEMA_NAME".v_edit_man_tank;
CREATE TRIGGER gw_trg_edit_man_tank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_tank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_tank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_junction ON "SCHEMA_NAME".v_edit_man_junction;
CREATE TRIGGER gw_trg_edit_man_junction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_junction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_junction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_waterwell ON "SCHEMA_NAME".v_edit_man_waterwell;
CREATE TRIGGER gw_trg_edit_man_waterwell INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_waterwell FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_waterwell');

DROP TRIGGER IF EXISTS gw_trg_edit_man_reduction ON "SCHEMA_NAME".v_edit_man_reduction;
CREATE TRIGGER gw_trg_edit_man_reduction INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_reduction FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_reduction');

DROP TRIGGER IF EXISTS gw_trg_edit_man_valve ON "SCHEMA_NAME".v_edit_man_valve;
CREATE TRIGGER gw_trg_edit_man_valve INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_valve FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_valve');

DROP TRIGGER IF EXISTS gw_trg_edit_man_filter ON "SCHEMA_NAME".v_edit_man_filter;
CREATE TRIGGER gw_trg_edit_man_filter INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_filter FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_filter');

DROP TRIGGER IF EXISTS gw_trg_edit_man_register ON "SCHEMA_NAME".v_edit_man_register;
CREATE TRIGGER gw_trg_edit_man_register INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_register FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_register');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netwjoin ON "SCHEMA_NAME".v_edit_man_netwjoin;
CREATE TRIGGER gw_trg_edit_man_netwjoin INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netwjoin FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netwjoin');

DROP TRIGGER IF EXISTS gw_trg_edit_man_expansiontank ON "SCHEMA_NAME".v_edit_man_expansiontank;
CREATE TRIGGER gw_trg_edit_man_expansiontank INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_expansiontank FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_expansiontank');

DROP TRIGGER IF EXISTS gw_trg_edit_man_flexunion ON "SCHEMA_NAME".v_edit_man_flexunion;
CREATE TRIGGER gw_trg_edit_man_flexunion INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_flexunion FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_flexunion');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netsamplepoint ON "SCHEMA_NAME".v_edit_man_netsamplepoint;
CREATE TRIGGER gw_trg_edit_man_netsamplepoint INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netsamplepoint FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netsamplepoint');

DROP TRIGGER IF EXISTS gw_trg_edit_man_netelement ON "SCHEMA_NAME".v_edit_man_netelement;
CREATE TRIGGER gw_trg_edit_man_netelement INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_netelement FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_netelement');

DROP TRIGGER IF EXISTS gw_trg_edit_man_wtp ON "SCHEMA_NAME".v_edit_man_wtp;
CREATE TRIGGER gw_trg_edit_man_wtp INSTEAD OF INSERT OR DELETE OR UPDATE ON "SCHEMA_NAME".v_edit_man_wtp FOR EACH ROW EXECUTE PROCEDURE "SCHEMA_NAME".gw_trg_edit_man_node('man_wtp');
