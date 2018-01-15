﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = "SCHEMA_NAME", public, pg_catalog;

DROP VIEW IF EXISTS v_edit_macrosector CASCADE;
CREATE VIEW v_edit_macrosector AS SELECT DISTINCT on (macrosector_id)
	sector.macrosector_id,
	macrosector.name,
	macrosector.descript,
	macrosector.the_geom,
	macrosector.undelete
FROM inp_selector_sector, sector 
JOIN macrosector ON macrosector.macrosector_id=sector.macrosector_id;
--WHERE ((sector.sector_id)=(inp_selector_sector.sector_id)
--AND inp_selector_sector.cur_user="current_user"());  



DROP VIEW IF EXISTS v_edit_sector CASCADE;
CREATE VIEW v_edit_sector AS SELECT
	sector.sector_id,
	sector.name,
	sector.macrosector_id,
	sector.descript,
	sector.the_geom,
	sector.undelete
FROM inp_selector_sector,sector 
WHERE ((sector.sector_id)=(inp_selector_sector.sector_id)
AND inp_selector_sector.cur_user="current_user"());  


  
  
DROP VIEW IF EXISTS v_edit_dma CASCADE;
CREATE VIEW v_edit_dma AS SELECT
	dma.dma_id,
	dma.name,
	dma.descript,
	dma.the_geom,
	dma.undelete,
	dma.expl_id
	FROM selector_expl, dma 
WHERE ((dma.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());
  


-- ----------------------------
-- Editing views structure
-- ----------------------------

DROP VIEW IF EXISTS v_edit_node CASCADE;
CREATE VIEW v_edit_node AS
SELECT 
node_id, 
code,
top_elev, 
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
elev AS sys_elev,
node_type,
sys_type,
nodecat_id,
cat_matcat_id,
epa_type,
sector_id, 
macrosector_id,
arc_id,
state, 
state_type,
annotation, 
observ, 
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id ,
postcode,
streetaxis_id,
postnumber,
postcomplement,
postcomplement2,
streetaxis2_id,
postnumber2,
descript,
svg,
rotation,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value
FROM v_node;


  
DROP VIEW IF EXISTS v_edit_arc CASCADE;
CREATE VIEW v_edit_arc AS
SELECT 
arc_id, 
code,
node_1,
node_2,
y1, 
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
custom_y2,
elev2,
custom_elev2,
sys_elev2,
z1,
z2,
r1,
r2,
slope,
arc_type,
sys_type,
arccat_id, 
matcat_id AS "cat_matcat_id",
shape AS "cat_shape",
geom1 AS "cat_geom1",
geom2 AS "cat_geom2",
gis_length,
epa_type,
sector_id, 
macrosector_id,
state, 
state_type,
annotation, 
observ, 
comment,
inverted_slope,
custom_length,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
postcomplement2,
streetaxis2_id,
postnumber2,
descript,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,	
macrodma_id,
expl_id,
num_value
FROM v_arc_x_node;



DROP VIEW IF EXISTS v_edit_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_connec AS
SELECT connec.connec_id, 
connec.code,
connec.customer_code,
connec.top_elev, 
connec.y1,
connec.y2,
connec.connecat_id,
connec.connec_type,
connec_type.type as sys_type,
connec.private_connecat_id,
cat_connec.matcat_id AS "cat_matcat_id",
connec.sector_id,
sector.macrosector_id,
connec.demand,
connec."state", 
connec.state_type,
connec_depth,
connec_length,
connec.arc_id,
connec.annotation, 
connec.observ, 
connec."comment",
connec.dma_id,
connec.soilcat_id,
connec.function_type,
connec.category_type,
connec.fluid_type,
connec.location_type,
connec.workcat_id,
connec.workcat_id_end,
connec.buildercat_id,
connec.builtdate,
connec.enddate,
connec.ownercat_id,
connec.muni_id,
connec.postcode,
connec.streetaxis_id,
connec.postnumber,
connec.postcomplement,
connec.streetaxis2_id,
connec.postnumber2,
connec.postcomplement2,
connec.descript,
cat_connec.svg AS "svg",
connec.rotation,
concat(connec_type.link_path,connec.link) as link,
connec.verified,
connec.the_geom,
connec.undelete,
connec.featurecat_id,
connec.feature_id,
connec.label_x,
connec.label_y,
connec.label_rotation,
connec.accessibility,
connec.diagonal,
connec.publish,
connec.inventory,
connec.uncertain,
dma.macrodma_id,
connec.expl_id,
connec.num_value
FROM connec 
	JOIN v_state_connec ON connec.connec_id=v_state_connec.connec_id
	JOIN cat_connec ON connec.connecat_id = cat_connec.id
	LEFT JOIN ext_streetaxis ON (((connec.streetaxis_id) = (ext_streetaxis.id)))
	LEFT JOIN dma ON connec.dma_id = dma.dma_id
	LEFT JOIN sector ON connec.sector_id = sector.sector_id
	LEFT JOIN connec_type ON connec.connec_type=connec_type.id;




DROP VIEW IF EXISTS v_edit_gully CASCADE;
CREATE OR REPLACE VIEW v_edit_gully AS
SELECT 
gully.gully_id, 
gully.code,
gully.top_elev, 
gully.ymax, 
gully.sandbox,
gully.matcat_id,
gully.gully_type,
gully_type.type as sys_type,
gully.gratecat_id,
cat_grate.matcat_id AS "cat_grate_matcat",
gully.units,
gully.groove,
gully.siphon,
gully.connec_arccat_id,
gully.connec_length,
gully.connec_depth,
gully.arc_id,
gully.sector_id, 
sector.macrosector_id,
gully."state", 
gully.state_type,
gully.annotation, 
gully.observ, 
gully."comment",
gully.dma_id,
gully.soilcat_id,
gully.function_type,
gully.category_type,
gully.fluid_type,
gully.location_type,
gully.workcat_id,
gully.workcat_id_end,
gully.buildercat_id,
gully.builtdate,
gully.enddate,
gully.ownercat_id,
gully.muni_id,
gully.postcode,
gully.streetaxis_id,
gully.postnumber,
gully.postcomplement,
gully.streetaxis2_id,
gully.postnumber2,
gully.postcomplement2,
gully.descript,
cat_grate.svg AS "svg",
gully.rotation,
concat(gully_type.link_path,gully.link) as link,
gully.verified,
gully.the_geom,
gully.undelete,
gully.featurecat_id,
gully.feature_id,
gully.label_x,
gully.label_y,
gully.label_rotation,
gully.publish,
gully.inventory,
gully.expl_id,
dma.macrodma_id,
gully.uncertain,
gully.num_value
FROM gully
	JOIN v_state_gully ON gully.gully_id=v_state_gully.gully_id 
	LEFT JOIN cat_grate ON (((gully.gratecat_id) = (cat_grate.id)))
	LEFT JOIN ext_streetaxis ON gully.streetaxis_id = ext_streetaxis.id
	LEFT JOIN dma ON gully.dma_id = dma.dma_id
	LEFT JOIN sector ON gully.sector_id = sector.sector_id
	LEFT JOIN gully_type ON gully.gully_type=gully_type.id;

	
DROP VIEW IF EXISTS v_edit_link;
CREATE OR REPLACE VIEW v_edit_link AS 
 SELECT link.link_id,
    link.feature_type,
    link.feature_id,
    link.exit_type,
	link.exit_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.sector_id
            WHEN link.feature_type::text = 'GULLY'::text THEN gully.sector_id
            ELSE vnode.sector_id
        END AS sector_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.dma_id
            WHEN link.feature_type::text = 'GULLY'::text THEN gully.dma_id
            ELSE vnode.dma_id
        END AS dma_id,
        CASE
            WHEN link.feature_type::text = 'CONNEC'::text THEN connec.expl_id
            WHEN link.feature_type::text = 'GULLY'::text THEN gully.expl_id
            ELSE vnode.expl_id
        END AS expl_id,
	link.state,
    st_length2d(link.the_geom) AS gis_length,
    link.userdefined_geom,
    link.the_geom
   FROM selector_expl,
    selector_state,
    link
     LEFT JOIN connec ON link.feature_id::text = connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     LEFT JOIN gully ON link.feature_id::text = gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     LEFT JOIN vnode ON link.feature_id::text = vnode.vnode_id::text AND link.feature_type::text = 'VNODE'::text
  WHERE connec.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text  AND connec.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text 
  OR (gully.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND gully.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text)
  OR (vnode.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND vnode.state = selector_state.state_id AND selector_state.cur_user = "current_user"()::text)
  ;


 
  
  
DROP VIEW IF EXISTS v_edit_vnode CASCADE;
CREATE VIEW v_edit_vnode AS SELECT
vnode_id,
vnode_type,
vnode.sector_id,
vnode.dma_id,
vnode.state,
annotation,
vnode.the_geom,
vnode.expl_id
FROM selector_expl, selector_state, vnode
	WHERE 
	vnode.expl_id=selector_expl.expl_id AND selector_expl.cur_user="current_user"() AND
	vnode.state=selector_state.state_id AND selector_state.cur_user="current_user"();


	
DROP VIEW IF EXISTS v_edit_man_junction CASCADE;
CREATE OR REPLACE VIEW v_edit_man_junction AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value
FROM v_node
	JOIN man_junction ON man_junction.node_id = v_node.node_id;
	
	 
DROP VIEW IF EXISTS v_edit_man_outfall CASCADE;
CREATE OR REPLACE VIEW v_edit_man_outfall AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_outfall.name
FROM v_node
	JOIN man_outfall ON man_outfall.node_id = v_node.node_id;
	
	
	 
DROP VIEW IF EXISTS v_edit_man_storage CASCADE;
CREATE OR REPLACE VIEW v_edit_man_storage AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_storage.pol_id,
man_storage.length,
man_storage.width,
man_storage.custom_area,
man_storage.max_volume,
man_storage.util_volume,
man_storage.min_height,
man_storage.accessibility,
man_storage.name
FROM v_node
	JOIN man_storage ON man_storage.node_id = v_node.node_id;
	

	 

DROP VIEW IF EXISTS v_edit_man_storage_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_storage_pol AS 
SELECT 
man_storage.pol_id,
v_node.node_id,
polygon.the_geom
FROM v_node
	JOIN man_storage ON man_storage.node_id = v_node.node_id
	JOIN polygon ON polygon.pol_id = man_storage.pol_id;

	 
	 
	 
DROP VIEW IF EXISTS v_edit_man_valve CASCADE;
CREATE OR REPLACE VIEW v_edit_man_valve AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_valve.name
FROM v_node
	JOIN man_valve ON man_valve.node_id = v_node.node_id;
	
	 
	 
DROP VIEW IF EXISTS v_edit_man_netinit CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netinit AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_netinit.length,
man_netinit.width,
man_netinit.inlet,
man_netinit.bottom_channel,
man_netinit.accessibility,
man_netinit.name,
man_netinit.sander_depth
FROM v_node
	JOIN man_netinit ON man_netinit.node_id = v_node.node_id;


	 
DROP VIEW IF EXISTS v_edit_man_manhole CASCADE;
CREATE OR REPLACE VIEW v_edit_man_manhole AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_manhole.length,
man_manhole.width,
man_manhole.sander_depth,
man_manhole.prot_surface,
man_manhole.inlet,
man_manhole.bottom_channel,
man_manhole.accessibility
FROM v_node
	JOIN man_manhole ON man_manhole.node_id = v_node.node_id;
	

	 
DROP VIEW IF EXISTS v_edit_man_wjump CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wjump AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_wjump.length,
man_wjump.width,
man_wjump.sander_depth,
man_wjump.prot_surface,
man_wjump.accessibility,
man_wjump.name
FROM v_node
	JOIN man_wjump ON man_wjump.node_id = v_node.node_id;


	 
DROP VIEW IF EXISTS v_edit_man_netgully CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netgully AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
v_node.undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_netgully.pol_id,
man_netgully.sander_depth,
man_netgully.gratecat_id,
man_netgully.units,
man_netgully.groove,
man_netgully.siphon
FROM v_node
	JOIN man_netgully ON man_netgully.node_id = v_node.node_id;

	 

DROP VIEW IF EXISTS v_edit_man_netgully_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netgully_pol AS 
SELECT 
man_netgully.pol_id,
v_node.node_id,
polygon.the_geom
FROM v_node
	JOIN man_netgully ON man_netgully.node_id = v_node.node_id
	JOIN polygon ON polygon.pol_id = man_netgully.pol_id;



DROP VIEW IF EXISTS v_edit_man_chamber CASCADE;
CREATE OR REPLACE VIEW v_edit_man_chamber AS 
SELECT 
v_node.node_id,
code ,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_chamber.pol_id,
man_chamber.length,
man_chamber.width,
man_chamber.sander_depth,
man_chamber.max_volume,
man_chamber.util_volume,
man_chamber.inlet,
man_chamber.bottom_channel,
man_chamber.accessibility,
man_chamber.name
FROM v_node
    JOIN man_chamber ON man_chamber.node_id = v_node.node_id;
	 
	 
	 
DROP VIEW IF EXISTS v_edit_man_chamber_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_chamber_pol AS 
SELECT 
man_chamber.pol_id,
v_node.node_id,
polygon.the_geom
FROM v_node
	JOIN man_chamber ON man_chamber.node_id = v_node.node_id
	JOIN polygon ON polygon.pol_id = man_chamber.pol_id;



DROP VIEW IF EXISTS v_edit_man_wwtp CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wwtp AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_wwtp.pol_id,
man_wwtp.name
FROM v_node
	JOIN man_wwtp ON man_wwtp.node_id = v_node.node_id;
	


DROP VIEW IF EXISTS v_edit_man_wwtp_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_wwtp_pol AS 
SELECT 
man_wwtp.pol_id,
v_node.node_id,
polygon.the_geom
FROM v_node
	JOIN man_wwtp ON man_wwtp.node_id = v_node.node_id
	JOIN polygon ON polygon.pol_id = man_wwtp.pol_id;
	


DROP VIEW IF EXISTS v_edit_man_netelement CASCADE;
CREATE OR REPLACE VIEW v_edit_man_netelement AS 
SELECT 
v_node.node_id,
code,
top_elev,
custom_top_elev,
ymax,
custom_ymax,
elev,
custom_elev,
sys_elev,
node_type,
nodecat_id,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
rotation,
svg,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
xyz_date,
unconnected,
macrodma_id,
expl_id,
num_value,
man_netelement.serial_number
FROM v_node
	JOIN man_netelement ON man_netelement.node_id = v_node.node_id;



DROP VIEW IF EXISTS v_edit_man_conduit CASCADE;
CREATE OR REPLACE VIEW v_edit_man_conduit AS 
SELECT 
v_arc_x_node.arc_id,
code,
node_1,
node_2,
y1,
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
elev2,
custom_y2,
custom_elev2,
sys_elev2,
z1,
z2,
r1,
r2,
slope,
arc_type,
arccat_id,
matcat_id,
shape,
geom1,
geom2,
gis_length,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
inverted_slope,
custom_length,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
macrodma_id,
expl_id,
num_value
FROM v_arc_x_node
	JOIN man_conduit ON man_conduit.arc_id = v_arc_x_node.arc_id;



DROP VIEW IF EXISTS v_edit_man_siphon CASCADE;
CREATE OR REPLACE VIEW v_edit_man_siphon AS 
SELECT 
v_arc_x_node.arc_id,
code,
node_1,
node_2,
y1,
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
elev2,
custom_y2,
custom_elev2,
sys_elev2,
z1,
z2,
r1,
r2,
slope,
arc_type,
arccat_id,
matcat_id,
shape,
geom1,
geom2,
gis_length,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
inverted_slope,
custom_length,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
macrodma_id,
expl_id,
num_value,
man_siphon.name
FROM v_arc_x_node
	JOIN man_siphon ON man_siphon.arc_id = v_arc_x_node.arc_id;



DROP VIEW IF EXISTS v_edit_man_waccel CASCADE;
CREATE OR REPLACE VIEW v_edit_man_waccel AS 
SELECT 
v_arc_x_node.arc_id,
node_1,
node_2,
y1,
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
elev2,
custom_y2,
custom_elev2,
sys_elev2,
z1,
z2,
r1,
r2,
slope,
arc_type,
arccat_id,
matcat_id,
shape,
geom1,
geom2,
gis_length,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
inverted_slope,
custom_length,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
code,
publish,
inventory,
uncertain,
macrodma_id,
expl_id,
num_value,
man_waccel.sander_length,
man_waccel.sander_depth,
man_waccel.prot_surface,
man_waccel.name,
man_waccel.accessibility
FROM v_arc_x_node
	JOIN man_waccel ON man_waccel.arc_id = v_arc_x_node.arc_id;



DROP VIEW IF EXISTS v_edit_man_varc CASCADE;
CREATE OR REPLACE VIEW v_edit_man_varc AS 
SELECT 
v_arc_x_node.arc_id,
code,
node_1,
node_2,
y1,
custom_y1,
elev1,
custom_elev1,
sys_elev1,
y2,
elev2,
custom_y2,
custom_elev2,
sys_elev2,
z1,
z2,
r1,
r2,
slope,
arc_type,
arccat_id,
matcat_id,
shape,
geom1,
gis_length,
epa_type,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
inverted_slope,
custom_length,
dma_id,
soilcat_id,
function_type,
category_type,
fluid_type,
location_type,
workcat_id,
workcat_id_end,
buildercat_id,
builtdate,
enddate,
ownercat_id,
muni_id,
postcode,
streetaxis_id,
postnumber,
postcomplement,
streetaxis2_id,
postnumber2,
postcomplement2,
descript,
link,
verified,
the_geom,
undelete,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
macrodma_id,
expl_id,
num_value
FROM v_arc_x_node
	JOIN man_varc ON man_varc.arc_id = v_arc_x_node.arc_id;


DROP VIEW IF EXISTS v_edit_samplepoint CASCADE;
CREATE VIEW v_edit_samplepoint AS SELECT
	samplepoint.sample_id,
	code,
	lab_code,
	feature_id,
	featurecat_id,
	samplepoint.dma_id,
	dma.macrodma_id,
	state,
	builtdate,
	enddate,
	workcat_id,
	workcat_id_end,
	rotation,
	muni_id,
	postcode,
	streetaxis_id,
	postnumber,
	postcomplement
	streetaxis2_id,
	postnumber2,
	postcomplement2,
	place_name,
	cabinet,
	observations,
	verified,
	samplepoint.the_geom,
	samplepoint.expl_id
FROM selector_expl,samplepoint
JOIN v_state_samplepoint ON samplepoint.sample_id=v_state_samplepoint.sample_id
LEFT JOIN dma ON dma.dma_id=samplepoint.dma_id
WHERE ((samplepoint.expl_id)=(selector_expl.expl_id)
AND selector_expl.cur_user="current_user"());




DROP VIEW IF EXISTS v_edit_man_connec CASCADE;
CREATE OR REPLACE VIEW v_edit_man_connec AS
SELECT * FROM v_edit_connec;


DROP VIEW IF EXISTS v_edit_man_gully CASCADE;
CREATE OR REPLACE VIEW v_edit_man_gully AS
SELECT * FROM v_edit_gully;



DROP VIEW IF EXISTS v_edit_man_gully_pol CASCADE;
CREATE OR REPLACE VIEW v_edit_man_gully_pol AS
SELECT
gully.pol_id,
gully.gully_id,
polygon.the_geom
FROM gully
	JOIN v_state_gully ON gully.gully_id=v_state_gully.gully_id 
	JOIN polygon ON polygon.pol_id = gully.pol_id;


