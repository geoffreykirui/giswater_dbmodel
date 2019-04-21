﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:XXXX

-- Function: SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_inp(text)

-- DROP FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_inp(text);

CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_inp(p_path text)
  RETURNS integer AS

/*
SELECT SCHEMA_NAME.gw_fct_utils_csv2pg_import_epanet_inp(null);
*/
 
$BODY$
	DECLARE
	rpt_rec record;
	epsg_val integer;
	v_point_geom public.geometry;
	v_value text;
	v_config_fields record;
	v_query_text text;
	schemas_array name[];
	v_table_pkey text;
	v_column_type text;
	v_pkey_column_type text;
	v_pkey_value text;
	v_mantablename text;
	v_epatablename text;
	v_fields record;
	v_target text;
	v_count integer=0;
	project_type_aux varchar;
	v_xcoord numeric;
	v_ycoord numeric;
	geom_array public.geometry array;
	v_data record;
	id_last text;
	v_typevalue text;
	v_extend_val public.geometry;
	v_rec_table record;
	v_query_fields text;
	v_num_column integer;
	v_rec_view record;
	v_sql text;
	v_split text;
	v_newproject boolean=TRUE;
	v_csv2pgcat_id integer = 12;
	v_thegeom public.geometry;
	v_node_id text;
	v_node1 text;
	v_node2 text;
	v_elevation float;
	v_arc2node_reverse boolean = TRUE; -- MOST IMPORTANT variable of this function. When true importation will be used making and arc2node reverse transformation for pumps and valves. Only works using Giswater sintaxis of additional pumps
	v_delete_prev boolean = true; -- used on dev mode to
	v_querytext text;
	v_nodecat text;
	i integer=1;
	v_arc_id text;
	v_rules_aux text;
	v_curvetype text;
	
	
BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

    	-- Get schema name
	schemas_array := current_schemas(FALSE);

	-- Get project type
	SELECT wsoftware INTO project_type_aux FROM version LIMIT 1;

	-- Get SRID
	SELECT epsg INTO epsg_val FROM version LIMIT 1;

	IF v_delete_prev THEN
		
		DELETE FROM rpt_cat_result;
		DELETE FROM anl_mincut_selector_valve;

		-- Disable constraints
		PERFORM gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);

		-- Delete system and user catalogs
		DELETE FROM macroexploitation;
		DELETE FROM exploitation;
		DELETE FROM sector;
		DELETE FROM dma;
		DELETE FROM ext_municipality;
		DELETE FROM selector_expl;
		DELETE FROM selector_state;
		
		DELETE FROM arc_type ;
		DELETE FROM node_type ;
		DELETE FROM connec_type ;
		DELETE FROM cat_feature;
		DELETE FROM cat_mat_arc;
		DELETE FROM cat_mat_node;
		DELETE FROM inp_cat_mat_roughness;
		DELETE FROM cat_arc;
		DELETE FROM cat_node;
 
		-- Delete data
		DELETE FROM node;
		DELETE FROM arc;

		DELETE FROM man_tank;
		DELETE FROM man_source;
		DELETE FROM man_junction;
		DELETE FROM man_pipe;
		DELETE FROM man_pump;
		DELETE FROM man_valve ;
		
		DELETE FROM inp_reservoir;
		DELETE FROM inp_junction;
		DELETE FROM inp_pipe;
		DELETE FROM inp_shortpipe;
		DELETE FROM inp_pump;
		DELETE FROM inp_tank;
		DELETE FROM inp_valve;
		DELETE FROM inp_pump_importinp;
		DELETE FROM inp_pump_additional;
		DELETE FROM inp_valve_importinp ;
		
		DELETE FROM inp_tags;
		DELETE FROM inp_demand;
		DELETE FROM inp_pattern;
		DELETE FROM inp_pattern_value;
		DELETE FROM inp_curve_id;
		DELETE FROM inp_curve;
		DELETE FROM inp_controls_x_arc;
		DELETE FROM inp_controls_x_node;
		DELETE FROM inp_rules_x_arc;
		DELETE FROM inp_rules_x_node;
		DELETE FROM inp_emitter;
		DELETE FROM inp_quality;
		DELETE FROM inp_source;
		DELETE FROM inp_reactions_el;
		DELETE FROM inp_reactions_gl;
		DELETE FROM inp_energy_gl;
		DELETE FROM inp_energy_el;
		DELETE FROM inp_mixing;
		DELETE FROM config_param_user;
		DELETE FROM inp_label;
		DELETE FROM inp_backdrop;
		DELETE FROM rpt_inp_arc;
		DELETE FROM rpt_inp_node;
		DELETE FROM rpt_cat_result;
	ELSE 
		-- Disable constraints
		PERFORM gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"}, "data":{"action":"DROP"}}$$);		
	END IF;
	

	-- use the copy function of postgres to import from file in case of file must be provided as a parameter
	IF p_path IS NOT NULL THEN
		EXECUTE 'SELECT gw_fct_utils_csv2pg_import_temp_data('||quote_literal(v_csv2pgcat_id)||','||quote_literal(p_path)||' )';
	END IF;

	-- Harmonize the source table
	FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id order by id
	LOOP
		-- refactor of [OPTIONS] target
		IF rpt_rec.source ='[OPTIONS]' AND lower(rpt_rec.csv1) = 'specific' THEN 
			UPDATE temp_csv2pg SET csv1='SPECIFIC GRAVITY', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND lower(rpt_rec.csv1) = 'demand' 
			THEN UPDATE temp_csv2pg SET csv1='DEMAND MULTIPLIER', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND lower(rpt_rec.csv1) = 'emitter' 
			THEN UPDATE temp_csv2pg SET csv1='EMITTER EXPONENT', csv2=csv3, csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[OPTIONS]' AND lower(rpt_rec.csv1) = 'unbalanced' 
			THEN UPDATE temp_csv2pg SET csv2=concat(csv2,' ',csv3), csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;

		-- refactor of [REPORT] target
		IF rpt_rec.source ='[REPORT]' AND lower(rpt_rec.csv1) = 'f-factor' 
			THEN UPDATE temp_csv2pg SET csv1='f_factor', csv2=concat(csv2,' ',csv3), csv3=NULL WHERE temp_csv2pg.id=rpt_rec.id; END IF;

		-- refactor of [CURVES] target
		IF rpt_rec.source ='[CURVES]' THEN
			IF rpt_rec.csv2 is null THEN
				v_curvetype=replace(replace(rpt_rec.csv1,';',''),':','');
			ELSE
				UPDATE temp_csv2pg SET csv4=v_curvetype WHERE temp_csv2pg.id=rpt_rec.id; 
			END IF;	
		END IF;
			
		-- refactor of [TIMES] target
		IF rpt_rec.source ='[TIMES]' AND lower(rpt_rec.csv2) ='clocktime'  THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,'_',csv2), csv2=concat(csv3,' ',csv4), csv3=null,csv4=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;
		IF rpt_rec.source ='[TIMES]' AND (lower(rpt_rec.csv2) ILIKE 'timestep' OR lower(rpt_rec.csv2) ILIKE 'start' ) 
			THEN UPDATE temp_csv2pg SET csv1=concat(csv1,'_',csv2), csv2=csv3, csv3=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;

		-- refactor of [ENERGY] target
		IF rpt_rec.source ilike '[ENERGY]%' AND lower(rpt_rec.csv1) ILIKE 'pump' THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2,' ',csv3), csv2=csv4, csv3=null,  csv4=null WHERE temp_csv2pg.id=rpt_rec.id;
		ELSIF rpt_rec.source ilike '[ENERGY]%' AND (lower(rpt_rec.csv1) ILIKE 'global' OR  lower(rpt_rec.csv1) ILIKE 'demand') THEN UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2), csv2=csv3, csv3=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;

	
		-- refactor of [CONTROLS] target
		IF rpt_rec.source ='[CONTROLS]'and rpt_rec.csv2 IS NOT NULL THEN 
			UPDATE temp_csv2pg SET csv1=concat(csv1,' ',csv2,' ',csv3,' ',csv4,' ',csv5,' ',csv6,' ',csv7,' ',csv8,' ',csv9,' ',csv10 ), 
			csv2=null, csv3=null, csv4=null,csv5=NULL, csv6=null, csv7=null,csv8=null,csv9=null,csv10=null,csv11=null WHERE temp_csv2pg.id=rpt_rec.id; END IF;
	END LOOP;

	-- MAPZONES
	INSERT INTO macroexploitation(macroexpl_id,name) VALUES(1,'macroexploitation1');
	INSERT INTO exploitation(expl_id,name,macroexpl_id) VALUES(1,'exploitation1',1);
	INSERT INTO sector(sector_id,name) VALUES(1,'sector1');
	INSERT INTO dma(dma_id,name) VALUES(1,'dma1');
	INSERT INTO ext_municipality(muni_id,name) VALUES(1,'municipality1');

	-- SELECTORS
	--insert values into selector
	INSERT INTO selector_expl(expl_id,cur_user) VALUES (1,current_user);
	INSERT INTO selector_state(state_id,cur_user) VALUES (1,current_user);
	
	
	-- CATALOGS
	--cat_feature
	--node
	INSERT INTO cat_feature VALUES ('EPAJUN','JUNCTION','NODE');
	INSERT INTO cat_feature VALUES ('EPATAN','TANK','NODE');
	INSERT INTO cat_feature VALUES ('EPARES','SOURCE','NODE');
	--arc
	INSERT INTO cat_feature VALUES ('EPAPIPE','PIPE','ARC');
	
	--nodarc (AS arc)
	INSERT INTO cat_feature VALUES ('EPACHV','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAFCV','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAGPV','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPBV','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPSV','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPRV','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPATCV','VARC','ARC');
	INSERT INTO cat_feature VALUES ('EPAPUMP','VARC','ARC');
	
	--nodarc (AS node)
	INSERT INTO cat_feature VALUES ('EPACHVA2N','VALVE','NODE');
	INSERT INTO cat_feature VALUES ('EPAFCVA2N','VALVE','NODE');
	INSERT INTO cat_feature VALUES ('EPAGPVA2N','VALVE','NODE');
	INSERT INTO cat_feature VALUES ('EPAPBVA2N','VALVE','NODE');
	INSERT INTO cat_feature VALUES ('EPAPSVA2N','VALVE','NODE');
	INSERT INTO cat_feature VALUES ('EPAPRVA2N','VALVE','NODE');
	INSERT INTO cat_feature VALUES ('EPATCVA2N','VALVE','NODE');
	INSERT INTO cat_feature VALUES ('EPAPUMPA2N','PUMP','NODE');
	
	--arc_type
	--arc
	INSERT INTO arc_type VALUES ('EPAPIPE', 'PIPE', 'PIPE', 'man_pipe', 'inp_pipe',TRUE);
	--nodarc
	INSERT INTO arc_type VALUES ('EPACHV', 'VARC', 'PIPE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAFCV', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAGPV', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPBV', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPSV', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPRV', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPATCV', 'VARC', 'VALVE', 'man_varc', 'inp_valve_importinp',TRUE);
	INSERT INTO arc_type VALUES ('EPAPUMP', 'VARC', 'PIPE', 'man_varc', 'inp_pump_importinp',TRUE);
	--node_type
	--node
	INSERT INTO node_type VALUES ('EPAJUN', 'JUNCTION', 'JUNCTION', 'man_junction', 'inp_junction',TRUE);
	INSERT INTO node_type VALUES ('EPATAN', 'TANK', 'TANK', 'man_tank', 'inp_tank',TRUE);
	INSERT INTO node_type VALUES ('EPARES', 'SOURCE', 'RESERVOIR', 'man_source', 'inp_reservoir',TRUE);
	INSERT INTO node_type VALUES ('EPACHVA2N', 'VALVE', 'SHORTPIPE', 'man_valve', 'inp_shortpipe',TRUE);
	INSERT INTO node_type VALUES ('EPAFCVA2N', 'VALVE', 'VALVE', 'man_valve', 'inp_valve',TRUE);
	INSERT INTO node_type VALUES ('EPAGPVA2N', 'VALVE', 'VALVE', 'man_valve', 'inp_valve',TRUE);
	INSERT INTO node_type VALUES ('EPAPBVA2N', 'VALVE', 'VALVE', 'man_valve', 'inp_valve',TRUE);
	INSERT INTO node_type VALUES ('EPAPSVA2N', 'VALVE', 'VALVE', 'man_valve', 'inp_valve',TRUE);
	INSERT INTO node_type VALUES ('EPATCVA2N', 'VALVE', 'VALVE', 'man_valve', 'inp_valve',TRUE);
	INSERT INTO node_type VALUES ('EPAPRVA2N', 'VALVE', 'VALVE', 'man_valve', 'inp_valve',TRUE);
	INSERT INTO node_type VALUES ('EPAPUMPA2N', 'PUMP', 'PUMP', 'man_pump', 'inp_pump',TRUE);

	--Materials
	INSERT INTO cat_mat_arc 
	SELECT DISTINCT csv6 FROM temp_csv2pg WHERE source='[PIPES]' AND csv6 IS NOT NULL;
	DELETE FROM inp_cat_mat_roughness; -- forcing delete because when new material is inserted on cat_mat_arc automaticly this table is filled
	INSERT INTO cat_mat_node VALUES ('EPAMAT');
	INSERT INTO cat_mat_arc VALUES ('EPAMAT');
	
	--Roughness
	INSERT INTO inp_cat_mat_roughness (matcat_id, period_id, init_age, end_age, roughness)
	SELECT id, 'default period',  0, 999, id::float FROM cat_mat_arc WHERE id !='EPAMAT';
	
	--cat_arc
	--pipe w
	INSERT INTO cat_arc( id, arctype_id, matcat_id,  dint)
	SELECT DISTINCT ON (csv6, csv5) concat(csv6::numeric(10,3),'-',csv5::numeric(10,3))::text, 'EPAPIPE', csv6, csv5::float FROM temp_csv2pg WHERE source='[PIPES]' AND csv1 not like ';%' AND csv5 IS NOT NULL;
	
	INSERT INTO cat_arc VALUES ('EPAPUMP-CAT', 'EPAPUMP', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPACHV-CAT', 'EPACHV', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPAFCV-CAT', 'EPAFCV', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPAGPV-CAT', 'EPAGPV', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPAPBV-CAT', 'EPAPBV', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPAPSV-CAT', 'EPAPSV', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPATCV-CAT', 'EPATCV', 'EPAMAT');
	INSERT INTO cat_arc VALUES ('EPAPRV-CAT', 'EPAPRV', 'EPAMAT');

	--cat_node
	INSERT INTO cat_node VALUES ('EPAJUN-CAT', 'EPAJUN', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPATAN-CAT', 'EPATAN', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPARES-CAT', 'EPARES', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPACHV-CATA2N', 'EPACHVA2N', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPAFCV-CATA2N', 'EPAFCVA2N', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPAGPV-CATA2N', 'EPAGPVA2N', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPAPBV-CATA2N', 'EPAPBVA2N', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPAPSV-CATA2N', 'EPAPSVA2N', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPATCV-CATA2N', 'EPATCVA2N', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPAPRV-CATA2N', 'EPAPRVA2N', 'EPAMAT');
	INSERT INTO cat_node VALUES ('EPAPUMP-CATA2N', 'EPAPUMPA2N', 'EPAMAT');

	-- LOOPING THE EDITABLE VIEWS TO INSERT DATA
	FOR v_rec_table IN SELECT * FROM sys_csv2pg_config WHERE reverse_pg2csvcat_id=v_csv2pgcat_id order by id
	LOOP
		--identifing the humber of fields of the editable view
		FOR v_rec_view IN SELECT row_number() over (order by v_rec_table.tablename) as rid, column_name, data_type from information_schema.columns where table_name=v_rec_table.tablename AND table_schema='SCHEMA_NAME'
		LOOP	

			IF v_rec_view.rid=1 THEN
				--insert of fields which are concatenation 
				v_query_fields = concat ('csv',v_rec_view.rid,'::',v_rec_view.data_type);
				
			ELSE
				v_query_fields = concat (v_query_fields,' , csv',v_rec_view.rid,'::',v_rec_view.data_type);
				
			END IF;
		END LOOP;
		
		--inserting values on editable view

		raise notice 'v_query_fields %,%', v_query_fields,v_rec_table.fields;
		
		v_sql = 'INSERT INTO '||v_rec_table.tablename||' SELECT '||v_query_fields||' FROM temp_csv2pg where source='||quote_literal(v_rec_table.target)||' 
		AND csv2pgcat_id='||v_csv2pgcat_id||'  AND (csv1 NOT LIKE ''[%'' AND csv1 NOT LIKE '';%'') AND user_name='||quote_literal(current_user)||' ORDER BY id';;

		raise notice 'v_sql %', v_sql;
		EXECUTE v_sql;		
	END LOOP;

	IF v_arc2node_reverse THEN -- manage pumps & valves as a reverse nod2arc. It means transforming lines into points reversing sintaxis applied on Giswater exportation
	
		FOR v_data IN SELECT * FROM arc WHERE epa_type IN ('VALVE','PUMP')
		 
		LOOP
			-- getting man_table to work with
			SELECT man_table, epa_table INTO v_mantablename, v_epatablename FROM node_type WHERE epa_default=v_data.epa_type;

			-- defining new node parameters
			v_node_id = replace(v_data.arc_id, '_n2a', '');
			v_nodecat = concat(v_data.arccat_id, 'A2N');
					
			-- defining geometry of new node
			SELECT array_agg(the_geom) INTO geom_array FROM node WHERE v_data.node_1=node_id;
			FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id and source='[VERTICES]' AND csv1=v_data.arc_id order by id 
			LOOP	
				v_point_geom=ST_SetSrid(ST_MakePoint(rpt_rec.csv2::numeric,rpt_rec.csv3::numeric),epsg_val);
				geom_array=array_append(geom_array,v_point_geom);
			END LOOP;
	
			geom_array=array_append(geom_array,(SELECT the_geom FROM node WHERE v_data.node_2=node_id));

			--line geometry
			v_thegeom=ST_MakeLine(geom_array);

			UPDATE arc SET the_geom=v_thegeom WHERE arc_id=v_data.arc_id;

			-- point geometry
			v_thegeom=ST_LineInterpolatePoint(v_thegeom, 0.5);

			-- Introducing new node transforming line into point
			INSERT INTO node (node_id, nodecat_id, epa_type, sector_id, dma_id, expl_id, state, state_type,the_geom) VALUES (v_node_id, v_nodecat, v_data.epa_type,1,1,1,1,
			(SELECT id FROM value_state_type WHERE state=1 LIMIT 1), v_thegeom) ;
			EXECUTE 'INSERT INTO '||v_mantablename||' VALUES ('||quote_literal(v_node_id)||')';

			IF v_epatablename = 'inp_pump' THEN
				INSERT INTO inp_pump (node_id, power, curve_id, speed, pattern, status,energyparam, energyvalue)
				SELECT v_node_id, power, curve_id, speed, pattern, status, energyparam, energyvalue FROM inp_pump_importinp WHERE arc_id=v_data.arc_id;
				DELETE FROM inp_pump_importinp WHERE arc_id=v_data.arc_id;

			ELSIF v_epatablename = 'inp_valve' THEN
				INSERT INTO inp_valve (node_id, valv_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status)
				SELECT v_node_id, valv_type, pressure, diameter, flow, coef_loss, curve_id, minorloss, status FROM inp_valve_importinp WHERE arc_id=v_data.arc_id;
			END IF;
				
			-- get old nodes
			SELECT node_1, node_2 INTO v_node1, v_node2 FROM arc WHERE arc_id=v_data.arc_id;

			-- calculate elevation from old nodes
			v_elevation = ((SELECT elevation FROM node WHERE node_id=v_node1) + (SELECT elevation FROM node WHERE node_id=v_node2))/2;

			-- downgrade to obsolete arcs and nodes
			UPDATE arc SET state=0,state_type=(SELECT id FROM value_state_type WHERE state=1 LIMIT 1) WHERE arc_id=v_data.arc_id;
			UPDATE node SET state=0,state_type=(SELECT id FROM value_state_type WHERE state=1 LIMIT 1) WHERE node_id IN (v_node1, v_node2);

			-- reconnect topology
			UPDATE arc SET node_1=v_node_id WHERE node_1=v_node1 OR node_1=v_node2;
			UPDATE arc SET node_2=v_node_id WHERE node_2=v_node1 OR node_2=v_node2;
					
			-- update elevation of new node
			UPDATE node SET elevation = v_elevation WHERE node_id=v_node_id;

		END LOOP;	
		
		-- transform pump additional from node to inp_pump_additional table		
		FOR v_data IN SELECT node_1 as nodarc_id, count 
		from (select node_1, count(node_1) FROM ( SELECT node_1 FROM arc where state=0 AND epa_type='PUMP')a group by node_1 order by 2 desc)b where count>1
		LOOP
			-- migrate additional from inp_pump to inp_pump_additional
			LOOP
				-- nodarc_id: 
				INSERT INTO inp_pump_additional (node_id, order_id, power, curve_id, speed, pattern, status)
				SELECT v_data.nodarc_id, i, power, curve_id, speed, pattern, status FROM inp_pump WHERE node_id=concat(v_data.nodarc_id,i);
				DELETE FROM node WHERE node_id=concat(v_data.nodarc_id,i);
				DELETE FROM man_pump WHERE node_id=concat(v_data.nodarc_id,i);
				DELETE FROM inp_pump WHERE node_id=concat(v_data.nodarc_id,i);
				i=i+1;
				EXIT WHEN i = v_data.count;
			END LOOP;
		END LOOP;

		DELETE FROM inp_valve_importinp;
		DELETE FROM inp_pump_importinp;
		
	
	END IF;
	
	-- Create arc geom
	IF v_arc2node_reverse THEN
		v_querytext = 'SELECT * FROM arc WHERE epa_type=''PIPE''';
	ELSE 
		v_querytext = 'SELECT * FROM arc ';
	END IF;
	
	FOR v_data IN EXECUTE v_querytext
	LOOP
		--Insert start point, add vertices if exist, add end point
		SELECT array_agg(the_geom) INTO geom_array FROM node WHERE v_data.node_1=node_id;
		FOR rpt_rec IN SELECT * FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_csv2pgcat_id and source='[VERTICES]' AND csv1=v_data.arc_id order by id 
		LOOP	
			v_point_geom=ST_SetSrid(ST_MakePoint(rpt_rec.csv2::numeric,rpt_rec.csv3::numeric),epsg_val);
			geom_array=array_append(geom_array,v_point_geom);
		END LOOP;

		geom_array=array_append(geom_array,(SELECT the_geom FROM node WHERE v_data.node_2=node_id));

		UPDATE arc SET the_geom=ST_MakeLine(geom_array) where arc_id=v_data.arc_id;

	END LOOP;

	--update toarc field
	IF v_arc2node_reverse THEN
		FOR v_data IN SELECT * FROM arc WHERE state=0
		LOOP
			v_node_id = replace(v_data.arc_id,'_n2a','');
			v_arc_id = (SELECT arc_id FROM arc WHERE state=1 AND ST_DWithin (the_geom, st_endpoint(v_data.the_geom), 0.01));
			UPDATE inp_pump SET to_arc=v_arc_id WHERE node_id=v_node_id;
			UPDATE inp_shortpipe SET to_arc=v_arc_id WHERE node_id=v_node_id;
			UPDATE inp_valve SET to_arc=v_arc_id WHERE node_id=v_node_id;
		END LOOP;
	END IF;

	--mapzones
	EXECUTE 'SELECT ST_Multi(ST_ConvexHull(ST_Collect(the_geom))) FROM arc;'
	into v_extend_val;
	update exploitation SET the_geom=v_extend_val;
	update sector SET the_geom=v_extend_val;
	update dma SET the_geom=v_extend_val;
	update ext_municipality SET the_geom=v_extend_val;

	INSERT INTO inp_pattern SELECT DISTINCT pattern_id FROM inp_pattern_value;

	-- Enable constraints
	PERFORM gw_fct_admin_schema_manage_ct($${"client":{"lang":"ES"},"data":{"action":"ADD"}}$$);


	IF v_arc2node_reverse THEN -- Reconnect those arcs connected to dissapeared nodarcs to the new node
	
		-- set nodearc variable as a max length/2+0.01 of arcs with state=0 (only are nod2arcs)
		UPDATE config_param_system SET value = ((SELECT max(st_length(the_geom)) FROM arc WHERE state=0)/2+0.01) WHERE parameter='arc_searchnodes';

		-- delete old nodes
		UPDATE arc SET node_1=null where node_1 IN (SELECT node_id FROM node WHERE state=0);
		UPDATE arc SET node_2=null where node_2 IN (SELECT node_id FROM node WHERE state=0);
		DELETE FROM node WHERE state=0;
			
		-- repair arcs
		PERFORM gw_fct_repair_arc (arc_id, null, null) FROM arc;

		-- restore default default values
		UPDATE config_param_system SET value=0.1 where parameter = 'arc_searchnodes';
		
	END IF;

RETURN v_count;
	
END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
