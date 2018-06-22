﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE: 2124

DROP FUNCTION IF EXISTS "SCHEMA_NAME".gw_fct_connect_to_network(character varying[], character varying);



CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_connect_to_network(
    connec_array character varying[],
    feature_type_aux character varying)
  RETURNS void AS
$BODY$

DECLARE
    connect_id_aux  varchar;
    arc_geom       public.geometry;
    candidate_line integer;
    connect_geom   public.geometry;
    link_geom           public.geometry;
    vnode_geom          public.geometry;
    vnode_id_aux   integer;
    link_id_aux   integer;
    arc_id_aux	varchar;
    arcrec record;
    userDefined    boolean;
    sector_aux     integer;
	expl_id_int integer;
	link_id integer;
	state_aux integer;
	dma_aux integer;
	expl_aux integer;
	state_connec integer;
	v_link_geom public.geometry;
	v_exit_type text;
	v_vnode_type text;	
	v_exit_id text;
	point_aux public.geometry;
	node_proximity_aux double precision;
	
BEGIN

    -- Search path
    SET search_path = "SCHEMA_NAME", public;

    node_proximity_aux=(SELECT "value" FROM config_param_system WHERE "parameter"='node_proximity');

    -- Main loop
    IF connec_array IS NOT NULL THEN
	
    FOREACH connect_id_aux IN ARRAY connec_array
    LOOP

        -- Get data from link (in case of exists)
	SELECT userdefined_geom, the_geom, exit_type, exit_id INTO userDefined, v_link_geom, v_exit_type, v_exit_id FROM link WHERE feature_id = connect_id_aux AND feature_type=feature_type_aux;

	IF v_exit_type='VNODE' THEN
		SELECT vnode_type INTO v_vnode_type FROM vnode WHERE vnode_id::text=v_exit_id;
	END IF;

	IF (v_exit_type!='VNODE') THEN
		RETURN;
	END IF;


        -- Get connec or gully geometry and arc_id  (if it has)
	IF feature_type_aux ='CONNEC' THEN          
		SELECT state, the_geom INTO state_connec, connect_geom FROM connec WHERE connec_id = connect_id_aux;
		SELECT arc_id INTO arc_id_aux FROM connec WHERE connec_id = connect_id_aux;

	ELSIF feature_type_aux ='GULLY' THEN 
		SELECT state, the_geom INTO state_connec, connect_geom FROM gully WHERE gully_id = connect_id_aux;
		SELECT arc_id INTO arc_id_aux FROM gully WHERE gully_id = connect_id_aux;

	END IF;

	IF (arc_id_aux is null) OR (v_link_geom IS NOT NULL AND v_exit_type='VNODE' AND v_vnode_type!='CUSTOM') THEN
		-- Improved version for curved lines (not perfect!)
		WITH index_query AS
		(
			SELECT ST_Distance(the_geom, connect_geom) as d, arc_id FROM v_edit_arc ORDER BY the_geom <-> connect_geom LIMIT 10
		)
		SELECT arc_id INTO arc_id_aux FROM index_query ORDER BY d limit 1;

	END IF;

	-- Get v_edit_arc geometry
	SELECT * INTO arcrec FROM v_edit_arc WHERE arc_id = arc_id_aux;

	-- Compute link
	IF arcrec.the_geom IS NOT NULL THEN

	        IF userDefined IS TRUE THEN
	        -- update only last point

			-- Reverse (if it's need) the existing link geometry
			IF (SELECT link.link_id FROM link WHERE st_dwithin (st_startpoint(link.the_geom), connect_geom, 0.01) LIMIT 1) IS NULL THEN
				point_aux := St_closestpoint(arcrec.the_geom, St_startpoint(v_link_geom));
				link_geom = ST_SetPoint(v_link_geom, 0, point_aux) ; 
			ELSE
				point_aux := St_closestpoint(arcrec.the_geom, St_endpoint(v_link_geom));
				link_geom = ST_SetPoint(v_link_geom, (ST_NumPoints(v_link_geom) - 1),point_aux); 
			END IF;

		ELSE	
		-- make the whole link
			link_geom := ST_ShortestLine(connect_geom, arcrec.the_geom);
			userDefined:=FALSE;
			
		END IF;

		-- Line end point
		vnode_geom := ST_EndPoint(link_geom);
                
		-- Delete old link
		SELECT exit_id INTO vnode_id_aux FROM link WHERE feature_id = connect_id_aux AND feature_type=feature_type_aux;
		DELETE FROM vnode WHERE vnode_id=vnode_id_aux ;
		DELETE FROM link WHERE feature_id = connect_id_aux AND feature_type=feature_type_aux;

		--Checking if there is vnode exiting
		SELECT vnode_id INTO vnode_id_aux FROM vnode WHERE ST_DWithin(vnode_geom, vnode.the_geom, node_proximity_aux) LIMIT 1;

		IF vnode_id_aux IS NULL THEN

			--Get values state, sector, dma, expl_id from arc
			state_aux:= arcrec.state;
			sector_aux:= arcrec.sector_id;
			dma_aux:= arcrec.dma_id;
			expl_aux:= arcrec.expl_id;
			vnode_id_aux := (SELECT nextval('vnode_vnode_id_seq'));

			-- Insert new vnode
			INSERT INTO vnode (vnode_id, vnode_type, state, sector_id, dma_id, expl_id, the_geom) 
			VALUES (vnode_id_aux, 'AUTO',state_aux, sector_aux, dma_aux, expl_aux, vnode_geom);
		END IF;
  
		-- Insert new link
		link_id_aux := (SELECT nextval('link_link_id_seq'));
                
		INSERT INTO link (link_id, the_geom, feature_id, feature_type, exit_id, exit_type, userdefined_geom, state, expl_id) 
		VALUES (link_id_aux, link_geom, connect_id_aux, feature_type_aux, vnode_id_aux, 'VNODE', userDefined, state_connec, arcrec.expl_id);

		-- Update connec or gully arc_id
		IF feature_type_aux ='CONNEC' THEN          
			UPDATE connec SET arc_id=arcrec.arc_id WHERE connec_id = connect_id_aux;
		ELSIF feature_type_aux ='GULLY' THEN 
			UPDATE gully SET arc_id=arcrec.arc_id WHERE gully_id = connect_id_aux;
		END IF;
			               
        END IF;

    END LOOP;

    END IF;

    --PERFORM audit_function(0,2124);
    RETURN;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
