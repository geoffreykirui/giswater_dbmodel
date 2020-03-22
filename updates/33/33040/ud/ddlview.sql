/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;

--2020/03/18

SELECT gw_fct_admin_manage_child_views($${"client":{"device":9, "infoType":100, "lang":"ES"}, "form":{}, "feature":{},
"data":{"filterFields":{}, "pageInfo":{}, "action":"MULTI-DELETE" }}$$);


-- independent
CREATE OR REPLACE VIEW v_ext_address AS 
 SELECT ext_address.id,
ext_address.muni_id,
ext_address.postcode,
ext_address.streetaxis_id,
ext_address.postnumber,
ext_address.plot_id,
ext_address.the_geom,
ext_address.expl_id,
ext_streetaxis.name
   FROM selector_expl,  ext_address
   LEFT JOIN ext_streetaxis ON ext_streetaxis.id = ext_address.streetaxis_id
  WHERE ext_address.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text;



-- drop unused views
--------------------
DROP VIEW IF EXISTS v_arc_dattrib;
DROP VIEW IF EXISTS v_node_dattrib;
DROP VIEW IF EXISTS v_connec_dattrib;
DROP VIEW IF EXISTS v_gully_dattrib;
DROP VIEW IF EXISTS vi_parent_node;


-- drop dependence views from arc
---------------------------------
DROP VIEW IF EXISTS v_edit_man_chamber;
DROP VIEW IF EXISTS v_edit_man_chamber_pol;
DROP VIEW IF EXISTS v_edit_man_conduit;
DROP VIEW IF EXISTS v_edit_man_connec;
DROP VIEW IF EXISTS v_edit_man_gully;
DROP VIEW IF EXISTS v_edit_man_gully_pol;
DROP VIEW IF EXISTS v_edit_man_junction;
DROP VIEW IF EXISTS v_edit_man_manhole;
DROP VIEW IF EXISTS v_edit_man_netgully;
DROP VIEW IF EXISTS v_edit_man_netgully_pol;
DROP VIEW IF EXISTS v_edit_man_netelement;
DROP VIEW IF EXISTS v_edit_man_netinit;
DROP VIEW IF EXISTS v_edit_man_outfall;
DROP VIEW IF EXISTS v_edit_man_siphon;
DROP VIEW IF EXISTS v_edit_man_storage;
DROP VIEW IF EXISTS v_edit_man_storage_pol;
DROP VIEW IF EXISTS v_edit_man_valve;
DROP VIEW IF EXISTS v_edit_man_varc;
DROP VIEW IF EXISTS v_edit_man_waccel;
DROP VIEW IF EXISTS v_edit_man_wjump;
DROP VIEW IF EXISTS v_edit_man_wwtp;
DROP VIEW IF EXISTS v_edit_man_wwtp_pol;

DROP VIEW IF EXISTS v_edit_inp_conduit;
DROP VIEW IF EXISTS v_edit_inp_divider;
DROP VIEW IF EXISTS v_edit_inp_junction;
DROP VIEW IF EXISTS v_edit_inp_orifice;
DROP VIEW IF EXISTS v_edit_inp_outfall;
DROP VIEW IF EXISTS v_edit_inp_outlet;
DROP VIEW IF EXISTS v_edit_inp_pump;
DROP VIEW IF EXISTS v_edit_inp_storage;
DROP VIEW IF EXISTS v_edit_inp_virtual;
DROP VIEW IF EXISTS v_edit_inp_weir;

DROP VIEW IF EXISTS ve_inp_conduit;
DROP VIEW IF EXISTS ve_inp_divider;
DROP VIEW IF EXISTS ve_inp_junction;
DROP VIEW IF EXISTS ve_inp_orifice;
DROP VIEW IF EXISTS ve_inp_outfall;
DROP VIEW IF EXISTS ve_inp_outlet;
DROP VIEW IF EXISTS ve_inp_pump;
DROP VIEW IF EXISTS ve_inp_storage;
DROP VIEW IF EXISTS ve_inp_virtual;
DROP VIEW IF EXISTS ve_inp_weir;

DROP VIEW IF EXISTS v_ui_workcat_x_feature;
DROP VIEW IF EXISTS v_ui_workcat_x_feature_end;


DROP VIEW IF EXISTS v_plan_psector;
DROP VIEW IF EXISTS v_plan_current_psector_budget_detail;
DROP VIEW IF EXISTS v_plan_current_psector;
DROP VIEW IF EXISTS v_plan_current_psector_budget;
DROP VIEW IF EXISTS v_plan_psector_x_arc;
DROP VIEW IF EXISTS v_result_arc;
DROP VIEW IF EXISTS v_plan_result_arc;
DROP VIEW IF EXISTS v_ui_plan_arc_cost;
DROP VIEW IF EXISTS v_plan_arc;
DROP VIEW IF EXISTS v_plan_aux_arc_cost;
DROP VIEW IF EXISTS v_plan_aux_arc_ml;
DROP VIEW IF EXISTS v_ui_arc_x_node;

DROP VIEW IF EXISTS vp_basic_arc;
DROP VIEW IF EXISTS vi_parent_arc;

DROP VIEW IF EXISTS v_arc_x_vnode;
DROP VIEW IF EXISTS v_ui_node_x_connection_downstream;
DROP VIEW IF EXISTS v_ui_node_x_connection_upstream;
DROP VIEW IF EXISTS v_ui_arc_x_relations;

DROP VIEW IF EXISTS ve_arc;
DROP VIEW IF EXISTS v_edit_arc;
DROP VIEW IF EXISTS v_arc_x_node;
DROP VIEW IF EXISTS v_arc;
DROP VIEW IF EXISTS v_node_x_arc;
DROP VIEW IF EXISTS vu_arc;


-- drop depedency views from node
-----------------------------------
DROP VIEW IF EXISTS v_inp_lidcontrol;
DROP VIEW IF EXISTS v_inp_subcatch2node;
DROP VIEW IF EXISTS v_inp_subcatchcentroid;

DROP VIEW IF EXISTS vi_groundwater;
DROP VIEW IF EXISTS vi_infiltration;
DROP VIEW IF EXISTS vi_coverages;

DROP VIEW IF EXISTS ve_pol_netgully;
DROP VIEW IF EXISTS ve_pol_chamber;
DROP VIEW IF EXISTS ve_pol_storage;
DROP VIEW IF EXISTS ve_pol_wwtp;


DROP VIEW IF EXISTS v_ui_plan_node_cost;
DROP VIEW IF EXISTS v_plan_result_node;
DROP VIEW IF EXISTS v_plan_psector_x_node;
DROP VIEW IF EXISTS v_plan_node;


DROP VIEW IF EXISTS vp_basic_node;
DROP VIEW IF EXISTS ve_node;
DROP VIEW IF EXISTS v_edit_node;
DROP VIEW IF EXISTS v_node;
DROP VIEW IF EXISTS vu_node;


-- drop depedency views from connec
-----------------------------------
DROP VIEW IF EXISTS v_rtc_period_node;
DROP VIEW IF EXISTS v_rtc_period_pjoint;
DROP VIEW IF EXISTS v_rtc_period_dma;
DROP VIEW IF EXISTS v_rtc_period_hydrometer;

DROP VIEW IF EXISTS v_anl_flow_connec;
DROP VIEW IF EXISTS v_anl_flow_hydrometer;
DROP VIEW IF EXISTS vp_basic_connec;
DROP VIEW IF EXISTS v_edit_connec;
DROP VIEW IF EXISTS ve_connec;
DROP VIEW IF EXISTS v_connec;
DROP VIEW IF EXISTS vu_connec;


-- drop depedency views from gully
-----------------------------------
DROP VIEW IF EXISTS v_anl_flow_gully;
DROP VIEW IF EXISTS vp_basic_gully;
DROP VIEW IF EXISTS v_edit_gully;
DROP VIEW IF EXISTS ve_gully;
DROP VIEW IF EXISTS v_gully;
DROP VIEW IF EXISTS vu_gully;



-- CREACIO DE LES VU
--------------------
CREATE OR REPLACE VIEW vu_node AS 
WITH vu_node as (
 SELECT node.node_id,
    node.code,
    node.top_elev,
    node.custom_top_elev,
        CASE
            WHEN node.custom_top_elev IS NOT NULL THEN node.custom_top_elev
            ELSE node.top_elev
        END AS sys_top_elev,
    node.ymax,
    node.custom_ymax,
        CASE
            WHEN node.custom_ymax IS NOT NULL THEN node.custom_ymax
            ELSE node.ymax
        END AS sys_ymax,
    node.elev,
    node.custom_elev,
        CASE
            WHEN node.elev IS NOT NULL AND node.custom_elev IS NULL THEN node.elev
            WHEN node.custom_elev IS NOT NULL THEN node.custom_elev
            ELSE NULL::numeric(12,3)
        END AS sys_elev,
    node.node_type,
    node_type.type AS sys_type,
    node.nodecat_id,
    cat_node.matcat_id AS cat_matcat_id,
    node.epa_type,
    node.expl_id,
    exploitation.macroexpl_id,
    node.sector_id,
    sector.macrosector_id,
    node.state,
    node.state_type,
    node.annotation,
    node.observ,
    node.comment,
    node.dma_id,
    dma.macrodma_id,
    node.soilcat_id,
    node.function_type,
    node.category_type,
    node.fluid_type,
    node.location_type,
    node.workcat_id,
    node.workcat_id_end,
    node.buildercat_id,
    node.builtdate,
    node.enddate,
    node.ownercat_id,
    node.muni_id,
    node.postcode,
    c.name AS streetname,
    node.postnumber,
    node.postcomplement,
    d.name AS streetname2,
    node.postnumber2,
    node.postcomplement2,
    node.descript,
    cat_node.svg,
    node.rotation,
    concat(node_type.link_path, node.link) AS link,
    node.verified,
    node.the_geom,
    node.undelete,
    cat_node.label,
    node.label_x,
    node.label_y,
    node.label_rotation,
    node.publish,
    node.inventory,
    node.uncertain,
    node.xyz_date,
    node.unconnected,
    node.num_value,
    date_trunc('second'::text, node.tstamp) AS tstamp,
    node.insert_user,
    date_trunc('second'::text, node.lastupdate) AS lastupdate,
    node.lastupdate_user
    FROM ud_sample.node
    LEFT JOIN ud_sample.cat_node ON node.nodecat_id::text = cat_node.id::text
    LEFT JOIN ud_sample.node_type ON node_type.id::text = node.node_type::text
    LEFT JOIN ud_sample.dma ON node.dma_id = dma.dma_id
    LEFT JOIN ud_sample.sector ON node.sector_id = sector.sector_id
    LEFT JOIN ud_sample.exploitation ON node.expl_id = exploitation.expl_id
    LEFT JOIN ud_sample.ext_streetaxis c ON c.id::text = node.streetaxis_id::text
    LEFT JOIN ud_sample.ext_streetaxis d ON d.id::text = node.streetaxis2_id::text)
	SELECT node_id,code,top_elev,custom_top_elev,sys_top_elev,ymax,custom_ymax,sys_ymax,elev,custom_elev,
		CASE WHEN vu_node.sys_elev IS NOT NULL THEN vu_node.sys_elev
		ELSE (vu_node.sys_top_elev - vu_node.sys_ymax)::numeric(12,3) END AS sys_elev,
		node_type,sys_type,nodecat_id,cat_matcat_id,epa_type,expl_id,macroexpl_id,sector_id,macrosector_id,state,state_type,annotation,
		observ,comment,dma_id,macrodma_id,soilcat_id,function_type,category_type,fluid_type,location_type,workcat_id,workcat_id_end,
		buildercat_id,builtdate,enddate,ownercat_id,muni_id,postcode,streetname,postnumber,postcomplement,streetname2,postnumber2,
		postcomplement2,descript,svg,rotation,link,verified,the_geom,undelete,label,label_x,label_y,label_rotation,publish,inventory,
		uncertain,xyz_date,unconnected,num_value,tstamp,insert_user,lastupdate,lastupdate_user
		FROM vu_node;

		
CREATE OR REPLACE VIEW vu_arc AS
 SELECT arc.arc_id,
arc.code,
arc.node_1,
a.node_type AS nodetype_1,
arc.y1,
arc.custom_y1,
arc.elev1,
arc.custom_elev1,
arc.sys_elev1,
a.sys_top_elev - arc.sys_elev1 AS sys_y1,
a.sys_top_elev - arc.sys_elev1 - cat_arc.geom1 AS r1,
CASE
WHEN a.sys_elev IS NOT NULL THEN arc.sys_elev1 - a.sys_elev
ELSE (arc.sys_elev1 - (a.sys_top_elev - a.sys_ymax))::numeric(12,3)
END AS z1, 
arc.node_2,
a.node_type AS nodetype_2,
arc.y2,
arc.custom_y2,
arc.elev2,
arc.custom_elev2,
arc.sys_elev2,
b.sys_top_elev - arc.sys_elev2 AS sys_y2,
b.sys_top_elev - arc.sys_elev2 - cat_arc.geom1 AS r2,
CASE
WHEN b.sys_elev IS NOT NULL THEN arc.sys_elev2 - b.sys_elev
ELSE (arc.sys_elev2 - (b.sys_top_elev - b.sys_ymax))::numeric(12,3)
END AS z2,
arc.sys_slope AS slope,
arc.arc_type,
arc_type.type AS sys_type,
arc.arccat_id,
arc.matcat_id,
cat_arc.shape,
cat_arc.geom1,
cat_arc.geom2,
cat_arc.width,
arc.epa_type,
arc.expl_id,
a.macroexpl_id,
arc.sector_id,
sector.macrosector_id,
arc.state,
arc.state_type,
arc.annotation,
st_length(arc.the_geom) as gis_length,
arc.custom_length,
arc.inverted_slope,
arc.observ,
arc.comment,  
arc.dma_id,
dma.macrodma_id,
arc.soilcat_id,
arc.function_type,
arc.category_type,
arc.fluid_type,
arc.location_type,
arc.workcat_id,
arc.workcat_id_end,
arc.builtdate,
arc.enddate,
arc.buildercat_id,
arc.ownercat_id,
arc.muni_id,
arc.postcode,
a.streetname,
arc.postnumber,
arc.postcomplement,
b.streetname2,
arc.postnumber2,
arc.postcomplement2,
arc.descript,
concat(arc_type.link_path, arc.link) AS link,
arc.verified,
arc.the_geom,
arc.undelete,
cat_arc.label,
arc.label_x,
arc.label_y,
arc.label_rotation,
arc.publish,
arc.inventory,
arc.uncertain,
arc.num_value,
date_trunc('second'::text, arc.tstamp) AS tstamp,
arc.insert_user,
date_trunc('second'::text, arc.lastupdate) AS lastupdate,
arc.lastupdate_user
FROM arc
	JOIN cat_arc ON arc.arccat_id::text = cat_arc.id::text
	LEFT JOIN vu_node a ON a.node_id::text = arc.node_1::text
	LEFT JOIN vu_node b ON b.node_id::text = arc.node_2::text
	JOIN sector ON sector.sector_id = arc.sector_id
	JOIN arc_type ON arc.arc_type::text = arc_type.id::text
	JOIN dma ON arc.dma_id = dma.dma_id
	LEFT JOIN ext_streetaxis c ON c.id = arc.streetaxis_id
	LEFT JOIN ext_streetaxis d ON d.id = arc.streetaxis2_id;


CREATE OR REPLACE VIEW vu_connec AS 
 SELECT connec.connec_id,
connec.code,
connec.customer_code,
connec.top_elev,
connec.y1,
connec.y2,
connec.connecat_id,
connec.connec_type,
connec_type.type AS sys_type,
connec.private_connecat_id,
cat_connec.matcat_id AS cat_matcat_id,
connec.expl_id,
macroexpl_id,
connec.sector_id,
sector.macrosector_id,
connec.demand,
connec.state,
connec.state_type,
connec.connec_depth,
connec.connec_length,
connec.arc_id,
connec.annotation,
connec.observ,
connec.comment,
connec.dma_id,
dma.macrodma_id,
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
c.name as streetname,
connec.postnumber,
connec.postcomplement,
d.name as streetname2,
connec.postnumber2,
connec.postcomplement2,
connec.descript,
cat_connec.svg,
connec.rotation,
concat(connec_type.link_path, connec.link) AS link,
connec.verified,
connec.the_geom,
connec.undelete,
cat_connec.label,
connec.label_x,
connec.label_y,
connec.label_rotation,
connec.accessibility,
connec.diagonal,
connec.publish,
connec.inventory,
connec.uncertain,
connec.num_value,
connec.feature_id,
connec.featurecat_id,
connec.pjoint_id,
connec.pjoint_type,
date_trunc('second'::text, connec.tstamp) AS tstamp,
connec.insert_user,
date_trunc('second'::text, connec.lastupdate) AS lastupdate,
connec.lastupdate_user
FROM connec
 JOIN cat_connec ON connec.connecat_id::text = cat_connec.id::text
 LEFT JOIN ext_streetaxis ON connec.streetaxis_id::text = ext_streetaxis.id::text
 LEFT JOIN dma ON connec.dma_id = dma.dma_id
 LEFT JOIN exploitation ON connec.expl_id = exploitation.expl_id
 LEFT JOIN sector ON connec.sector_id = sector.sector_id
 LEFT JOIN connec_type ON connec.connec_type::text = connec_type.id::text
 LEFT JOIN ext_streetaxis c ON c.id = connec.streetaxis_id
 LEFT JOIN ext_streetaxis d ON d.id = connec.streetaxis2_id;



CREATE OR REPLACE VIEW vu_gully AS 
SELECT gully.gully_id,
gully.code,
gully.top_elev,
gully.ymax,
gully.sandbox,
gully.matcat_id,
gully.gully_type,
gully_type.type AS sys_type,
gully.gratecat_id,
cat_grate.matcat_id AS cat_grate_matcat,
gully.units,
gully.groove,
gully.siphon,
gully.connec_arccat_id,
gully.connec_length,
gully.connec_depth,
gully.arc_id,
gully.expl_id,
macroexpl_id,
gully.sector_id,
sector.macrosector_id,
gully.state,
gully.state_type,
gully.annotation,
gully.observ,
gully.comment,
gully.dma_id,
dma.macrodma_id,
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
c.name as streetname,
gully.postnumber,
gully.postcomplement,
d.name as streetname2,
gully.postnumber2,
gully.postcomplement2,
gully.descript,
cat_grate.svg,
gully.rotation,
concat(gully_type.link_path, gully.link) AS link,
gully.verified,
gully.the_geom,
gully.undelete,
cat_grate.label,
gully.label_x,
gully.label_y,
gully.label_rotation,
gully.publish,
gully.inventory,
gully.uncertain,
gully.num_value,
gully.feature_id,
gully.featurecat_id,
gully.pjoint_id,
gully.pjoint_type,
date_trunc('second'::text, gully.tstamp) AS tstamp,
gully.insert_user,
date_trunc('second'::text, gully.lastupdate) AS lastupdate,
gully.lastupdate_user
   FROM gully
 LEFT JOIN cat_grate ON gully.gratecat_id::text = cat_grate.id::text
 LEFT JOIN ext_streetaxis ON gully.streetaxis_id::text = ext_streetaxis.id::text
 LEFT JOIN dma ON gully.dma_id = dma.dma_id
 LEFT JOIN sector ON gully.sector_id = sector.sector_id
 LEFT JOIN exploitation ON gully.expl_id = exploitation.expl_id
 LEFT JOIN gully_type ON gully.gully_type::text = gully_type.id::text
 LEFT JOIN ext_streetaxis c ON c.id = gully.streetaxis_id
 LEFT JOIN ext_streetaxis d ON d.id = gully.streetaxis2_id;



--creacio de les main
---------------------
CREATE OR REPLACE VIEW v_arc AS 
SELECT * FROM vu_arc	
JOIN v_state_arc USING (arc_id);

CREATE OR REPLACE VIEW vp_basic_arc AS
SELECT v_arc.arc_id AS nid,
v_arc.arc_type AS custom_type
FROM v_arc;

CREATE OR REPLACE VIEW ve_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW v_edit_arc AS 
SELECT * FROM v_arc;

CREATE OR REPLACE VIEW vi_parent_arc AS 
 SELECT v_arc.*
   FROM v_arc,
    inp_selector_sector
  WHERE v_arc.sector_id = inp_selector_sector.sector_id AND inp_selector_sector.cur_user = "current_user"()::text;

CREATE OR REPLACE VIEW v_node AS 
SELECT *
FROM vu_node
JOIN v_state_node USING (node_id);

CREATE OR REPLACE VIEW v_edit_node AS 
SELECT * FROM v_node;

CREATE OR REPLACE VIEW vp_basic_node AS 
SELECT v_node.node_id AS nid,
v_node.node_type AS custom_type
FROM v_node;

CREATE OR REPLACE VIEW ve_node AS 
SELECT * FROM v_node;




CREATE OR REPLACE VIEW v_connec AS 
SELECT connec_id,
code,
customer_code,
top_elev,
y1,
y2,
connecat_id,
connec_type,
sys_type,
private_connecat_id,
cat_matcat_id,
expl_id,
macroexpl_id,
sector_id,
macrosector_id,
demand,
state,
state_type,
connec_depth,
connec_length,
v_state_connec.arc_id,
annotation,
observ,
comment,
dma_id,
macrodma_id,
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
streetname,
postnumber,
postcomplement,
streetname2,
postnumber2,
postcomplement2,
descript,
svg,
rotation,
link,
verified,
the_geom,
undelete,
label,
label_x,
label_y,
label_rotation,
accessibility,
diagonal,
publish,
inventory,
uncertain,
num_value,
feature_id,
featurecat_id,
pjoint_id,
pjoint_type,
tstamp,
insert_user,
lastupdate,
lastupdate_user
FROM vu_connec
JOIN v_state_connec USING (connec_id);


CREATE VIEW v_edit_connec AS
SELECT * FROM v_connec;


CREATE OR REPLACE VIEW ve_connec AS 
SELECT * FROM v_connec;

CREATE OR REPLACE VIEW vp_basic_connec AS 
SELECT v_connec.connec_id AS nid,
v_connec.connec_type AS custom_type
FROM v_connec;



CREATE OR REPLACE VIEW v_gully AS 
SELECT gully_id,
code,
top_elev,
ymax,
sandbox,
matcat_id,
gully_type,
sys_type,
gratecat_id,
cat_grate_matcat,
units,
groove,
siphon,
connec_arccat_id,
connec_length,
connec_depth,
v_state_gully.arc_id,
expl_id,
macroexpl_id,
sector_id,
macrosector_id,
state,
state_type,
annotation,
observ,
comment,
dma_id,
macrodma_id,
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
streetname,
postnumber,
postcomplement,
streetname2,
postnumber2,
postcomplement2,
descript,
svg,
rotation,
link,
verified,
the_geom,
undelete,
label,
label_x,
label_y,
label_rotation,
publish,
inventory,
uncertain,
num_value,
feature_id,
featurecat_id,
pjoint_id,
pjoint_type,
tstamp,
insert_user,
lastupdate,
lastupdate_user
FROM vu_gully
JOIN v_state_gully USING (gully_id);


CREATE VIEW v_edit_gully AS
SELECT * FROM v_gully;

CREATE OR REPLACE VIEW ve_gully AS 
SELECT * FROM v_gully;

CREATE OR REPLACE VIEW vp_basic_gully AS 
SELECT v_gully.gully_id AS nid,
v_gully.gully_type AS custom_type
FROM v_gully;


CREATE OR REPLACE VIEW v_edit_inp_conduit AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.matcat_id AS cat_matcat_id,
    v_arc.shape AS cat_shape,
    v_arc.geom1 AS cat_geom1,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.the_geom,
    inp_conduit.barrels,
    inp_conduit.culvert,
    inp_conduit.kentry,
    inp_conduit.kexit,
    inp_conduit.kavg,
    inp_conduit.flap,
    inp_conduit.q0,
    inp_conduit.qmax,
    inp_conduit.seepage,
    inp_conduit.custom_n
   FROM v_arc
	 JOIN vi_parent_arc USING (arc_id)
     JOIN inp_conduit ON v_arc.arc_id::text = inp_conduit.arc_id::text;
	  


CREATE OR REPLACE VIEW v_edit_inp_divider AS 
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node._sys_elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    a.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_divider.divider_type,
    inp_divider.arc_id,
    inp_divider.curve_id,
    inp_divider.qmin,
    inp_divider.ht,
    inp_divider.cd,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond
   FROM node v_node
     JOIN inp_divider ON v_node.node_id::text = inp_divider.node_id::text
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text
UNION
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node._sys_elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    a.macrosector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    inp_divider.divider_type,
    inp_divider.arc_id,
    inp_divider.curve_id,
    inp_divider.qmin,
    inp_divider.ht,
    inp_divider.cd,
    inp_divider.y0,
    inp_divider.ysur,
    inp_divider.apond
   FROM node v_node
     JOIN inp_divider ON v_node.node_id::text = inp_divider.node_id::text
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text OR a.node_2::text = v_node.node_id::text;

     
CREATE OR REPLACE VIEW v_edit_inp_junction AS 
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    a.macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam
   FROM node v_node
     JOIN inp_junction ON inp_junction.node_id::text = v_node.node_id::text
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text
UNION
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node.elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    a.macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_junction.y0,
    inp_junction.ysur,
    inp_junction.apond,
    inp_junction.outfallparam::text AS outfallparam
   FROM node v_node
     JOIN inp_junction ON inp_junction.node_id::text = v_node.node_id::text
     JOIN vi_parent_arc a ON a.node_2::text = v_node.node_id::text;

     
CREATE OR REPLACE VIEW v_edit_inp_orifice AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.the_geom,
    inp_orifice.ori_type,
    inp_orifice."offset",
    inp_orifice.cd,
    inp_orifice.orate,
    inp_orifice.flap,
    inp_orifice.shape,
    inp_orifice.geom1,
    inp_orifice.geom2,
    inp_orifice.geom3,
    inp_orifice.geom4,
    v_arc.expl_id
   FROM v_arc
	 JOIN vi_parent_arc USING (arc_id)
     JOIN inp_orifice ON v_arc.arc_id::text = inp_orifice.arc_id::text;
  
  
CREATE OR REPLACE VIEW v_edit_inp_outfall AS 
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node._sys_elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    a.macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate
   FROM node v_node
     JOIN inp_outfall ON v_node.node_id::text = inp_outfall.node_id::text
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text
UNION
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node._sys_elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    a.macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_outfall.outfall_type,
    inp_outfall.stage,
    inp_outfall.curve_id,
    inp_outfall.timser_id,
    inp_outfall.gate
   FROM node v_node
     JOIN inp_outfall ON v_node.node_id::text = inp_outfall.node_id::text
     JOIN vi_parent_arc a ON a.node_2::text = v_node.node_id::text;



CREATE OR REPLACE VIEW v_edit_inp_outlet AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.the_geom,
    inp_outlet.outlet_type,
    inp_outlet."offset",
    inp_outlet.curve_id,
    inp_outlet.cd1,
    inp_outlet.cd2,
    inp_outlet.flap,
    v_arc.expl_id
   FROM v_arc
	 JOIN vi_parent_arc USING (arc_id)
     JOIN inp_outlet ON v_arc.arc_id::text = inp_outlet.arc_id::text;
	 
  
CREATE OR REPLACE VIEW v_edit_inp_pump AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.the_geom,
    inp_pump.curve_id,
    inp_pump.status,
    inp_pump.startup,
    inp_pump.shutoff,
    v_arc.expl_id
   FROM v_arc
	 JOIN vi_parent_arc USING (arc_id)
     JOIN inp_pump ON v_arc.arc_id::text = inp_pump.arc_id::text;

  
CREATE OR REPLACE VIEW v_edit_inp_storage AS 
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node._sys_elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    a.macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_storage.storage_type,
    inp_storage.curve_id,
    inp_storage.a1,
    inp_storage.a2,
    inp_storage.a0,
    inp_storage.fevap,
    inp_storage.sh,
    inp_storage.hc,
    inp_storage.imd,
    inp_storage.y0,
    inp_storage.ysur,
    inp_storage.apond
   FROM node v_node
     JOIN inp_storage ON v_node.node_id::text = inp_storage.node_id::text
     JOIN vi_parent_arc a ON a.node_1::text = v_node.node_id::text
UNION
 SELECT v_node.node_id,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
    v_node._sys_elev AS sys_elev,
    v_node.nodecat_id,
    v_node.sector_id,
    a.macrosector_id,
    v_node.state,
    v_node.the_geom,
    v_node.annotation,
    inp_storage.storage_type,
    inp_storage.curve_id,
    inp_storage.a1,
    inp_storage.a2,
    inp_storage.a0,
    inp_storage.fevap,
    inp_storage.sh,
    inp_storage.hc,
    inp_storage.imd,
    inp_storage.y0,
    inp_storage.ysur,
    inp_storage.apond
   FROM node v_node
     JOIN inp_storage ON v_node.node_id::text = inp_storage.node_id::text
     JOIN vi_parent_arc a ON a.node_2::text = v_node.node_id::text;

 
CREATE OR REPLACE VIEW v_edit_inp_virtual AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.the_geom,
    inp_virtual.fusion_node,
    inp_virtual.add_length,
    v_arc.expl_id
   FROM v_arc
	 JOIN vi_parent_arc USING (arc_id)
     JOIN inp_virtual ON v_arc.arc_id::text = inp_virtual.arc_id::text;
	 

CREATE OR REPLACE VIEW v_edit_inp_weir AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.custom_y2,
    v_arc.elev2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.arccat_id,
    v_arc.gis_length,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.annotation,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.the_geom,
    inp_weir.weir_type,
    inp_weir."offset",
    inp_weir.cd,
    inp_weir.ec,
    inp_weir.cd2,
    inp_weir.flap,
    inp_weir.geom1,
    inp_weir.geom2,
    inp_weir.geom3,
    inp_weir.geom4,
    inp_weir.surcharge,
    v_arc.expl_id
   FROM v_arc
     JOIN vi_parent_arc USING (arc_id)
     JOIN inp_weir ON v_arc.arc_id::text = inp_weir.arc_id::text;


-- links

CREATE OR REPLACE VIEW v_ui_node_x_connection_downstream AS 
 SELECT row_number() OVER (ORDER BY v_arc.node_1) + 1000000 AS rid,
    v_arc.node_1 AS node_id,
    v_arc.arc_id AS feature_id,
    v_arc.code AS feature_code,
    v_arc.arc_type AS featurecat_id,
    v_arc.arccat_id,
    v_arc.y2 AS depth,
    st_length2d(v_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS downstream_id,
    node.code AS downstream_code,
    node.node_type AS downstream_type,
    v_arc.y1 AS downstream_depth,
    v_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_arc'::text AS sys_table_id
   FROM v_arc
     JOIN node ON v_arc.node_2::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_arc.arc_type::text
     LEFT JOIN cat_arc ON v_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_arc.state = value_state.id;




     
CREATE OR REPLACE VIEW v_ui_node_x_connection_upstream AS 
 SELECT row_number() OVER (ORDER BY v_arc.node_2) + 1000000 AS rid,
    v_arc.node_2 AS node_id,
    v_arc.arc_id AS feature_id,
    v_arc.code AS feature_code,
    v_arc.arc_type AS featurecat_id,
    v_arc.arccat_id,
    v_arc.y1 AS depth,
    st_length2d(v_arc.the_geom)::numeric(12,2) AS length,
    node.node_id AS upstream_id,
    node.code AS upstream_code,
    node.node_type AS upstream_type,
    v_arc.y2 AS upstream_depth,
    v_arc.sys_type,
    st_x(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS x,
    st_y(st_lineinterpolatepoint(v_arc.the_geom, 0.5::double precision)) AS y,
    cat_arc.descript,
    value_state.name AS state,
    'v_arc'::text AS sys_table_id
   FROM v_arc
     JOIN node ON v_arc.node_1::text = node.node_id::text
     JOIN arc_type ON arc_type.id::text = v_arc.arc_type::text
     LEFT JOIN cat_arc ON v_arc.arccat_id::text = cat_arc.id::text
     JOIN value_state ON v_arc.state = value_state.id
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.node_id,
    v_connec.connec_id AS feature_id,
    v_connec.code::text AS feature_code,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS arccat_id,
    v_connec.y1 AS depth,
    st_length2d(link.the_geom)::numeric(12,2) AS length,
    v_connec.connec_id AS upstream_id,
    v_connec.code AS upstream_code,
    v_connec.connec_type AS upstream_type,
    v_connec.y2 AS upstream_depth,
    v_connec.sys_type,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_connec'::text AS sys_table_id
   FROM v_connec
     JOIN link ON link.feature_id::text = v_connec.connec_id::text AND link.feature_type::text = 'CONNEC'::text
     JOIN node ON v_connec.pjoint_id::text = node.node_id::text AND v_connec.pjoint_type::text = 'NODE'::text
     JOIN connec_type ON connec_type.id::text = v_connec.connec_type::text
     LEFT JOIN cat_connec ON v_connec.connecat_id::text = cat_connec.id::text
     JOIN value_state ON v_connec.state = value_state.id
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 3000000 AS rid,
    node.node_id,
    v_gully.gully_id AS feature_id,
    v_gully.code::text AS feature_code,
    v_gully.gully_type AS featurecat_id,
    v_gully.connec_arccat_id AS arccat_id,
    v_gully.ymax - v_gully.sandbox AS depth,
    v_gully.connec_length AS length,
    v_gully.gully_id AS upstream_id,
    v_gully.code AS upstream_code,
    v_gully.gully_type AS upstream_type,
    v_gully.connec_depth AS upstream_depth,
    v_gully.sys_type,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    cat_connec.descript,
    value_state.name AS state,
    'v_gully'::text AS sys_table_id
   FROM v_gully
     JOIN link ON link.feature_id::text = v_gully.gully_id::text AND link.feature_type::text = 'GULLY'::text
     JOIN node ON v_gully.pjoint_id::text = node.node_id::text AND v_gully.pjoint_type::text = 'NODE'::text
     JOIN gully_type ON gully_type.id::text = v_gully.gully_type::text
     LEFT JOIN cat_connec ON v_gully.connec_arccat_id::text = cat_connec.id::text
     JOIN value_state ON v_gully.state = value_state.id;



CREATE OR REPLACE VIEW v_ui_arc_x_relations AS 
 SELECT row_number() OVER () + 1000000 AS rid,
    v_connec.arc_id,
    v_connec.connec_type AS featurecat_id,
    v_connec.connecat_id AS catalog,
    v_connec.connec_id AS feature_id,
    v_connec.code AS feature_code,
    v_connec.sys_type,
    v_connec.state AS arc_state,
    v_connec.state AS feature_state,
    st_x(v_connec.the_geom) AS x,
    st_y(v_connec.the_geom) AS y,
    v_connec.featurecat_id AS proceed_from,
    v_connec.feature_id AS proceed_from_id
   FROM v_connec
  WHERE v_connec.arc_id IS NOT NULL
UNION
 SELECT row_number() OVER () + 2000000 AS rid,
    v_gully.arc_id,
    v_gully.gully_type AS featurecat_id,
    v_gully.gratecat_id AS catalog,
    v_gully.gully_id AS feature_id,
    v_gully.code AS feature_code,
    v_gully.sys_type,
    v_gully.state AS arc_state,
    v_gully.state AS feature_state,
    st_x(v_gully.the_geom) AS x,
    st_y(v_gully.the_geom) AS y,
    v_gully.featurecat_id AS proceed_from,
    v_gully.feature_id AS proceed_from_id
   FROM v_gully
  WHERE v_gully.arc_id IS NOT NULL;



CREATE OR REPLACE VIEW v_ui_workcat_x_feature AS 
 SELECT row_number() OVER (ORDER BY arc.arc_id) + 1000000 AS rid,
    arc.feature_type,
    arc.arccat_id AS featurecat_id,
    arc.arc_id AS feature_id,
    arc.code,
    exploitation.name AS expl_name,
    arc.workcat_id,
    exploitation.expl_id
   FROM arc
     JOIN exploitation ON exploitation.expl_id = arc.expl_id
  WHERE arc.state = 1
UNION
 SELECT row_number() OVER (ORDER BY node.node_id) + 2000000 AS rid,
    node.feature_type,
    node.nodecat_id AS featurecat_id,
    node.node_id AS feature_id,
    node.code,
    exploitation.name AS expl_name,
    node.workcat_id,
    exploitation.expl_id
   FROM node
     JOIN exploitation ON exploitation.expl_id = node.expl_id
  WHERE node.state = 1
UNION
 SELECT row_number() OVER (ORDER BY connec.connec_id) + 3000000 AS rid,
    connec.feature_type,
    connec.connecat_id AS featurecat_id,
    connec.connec_id AS feature_id,
    connec.code,
    exploitation.name AS expl_name,
    connec.workcat_id,
    exploitation.expl_id
   FROM connec
     JOIN exploitation ON exploitation.expl_id = connec.expl_id
  WHERE connec.state = 1
UNION
 SELECT row_number() OVER (ORDER BY gully.gully_id) + 4000000 AS rid,
    gully.feature_type,
    gully.gratecat_id AS featurecat_id,
    gully.gully_id AS feature_id,
    gully.code,
    exploitation.name AS expl_name,
    gully.workcat_id,
    exploitation.expl_id
   FROM gully
     JOIN exploitation ON exploitation.expl_id = gully.expl_id
  WHERE gully.state = 1
UNION
 SELECT row_number() OVER (ORDER BY element.element_id) + 5000000 AS rid,
    element.feature_type,
    element.elementcat_id AS featurecat_id,
    element.element_id AS feature_id,
    element.code,
    exploitation.name AS expl_name,
    element.workcat_id,
    exploitation.expl_id
   FROM element
     JOIN exploitation ON exploitation.expl_id = element.expl_id
  WHERE element.state = 1;




CREATE OR REPLACE VIEW v_ui_workcat_x_feature_end AS 
 SELECT row_number() OVER (ORDER BY v_arc.arc_id) + 1000000 AS rid,
    'ARC'::character varying AS feature_type,
    v_arc.arccat_id AS featurecat_id,
    v_arc.arc_id AS feature_id,
    v_arc.code,
    exploitation.name AS expl_name,
    v_arc.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_arc
     JOIN exploitation ON exploitation.expl_id = v_arc.expl_id
  WHERE v_arc.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_node.node_id) + 2000000 AS rid,
    'NODE'::character varying AS feature_type,
    v_node.nodecat_id AS featurecat_id,
    v_node.node_id AS feature_id,
    v_node.code,
    exploitation.name AS expl_name,
    v_node.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_node
     JOIN exploitation ON exploitation.expl_id = v_node.expl_id
  WHERE v_node.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_connec.connec_id) + 3000000 AS rid,
    'CONNEC'::character varying AS feature_type,
    v_connec.connecat_id AS featurecat_id,
    v_connec.connec_id AS feature_id,
    v_connec.code,
    exploitation.name AS expl_name,
    v_connec.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_connec
     JOIN exploitation ON exploitation.expl_id = v_connec.expl_id
  WHERE v_connec.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_edit_element.element_id) + 4000000 AS rid,
    'ELEMENT'::character varying AS feature_type,
    v_edit_element.elementcat_id AS featurecat_id,
    v_edit_element.element_id AS feature_id,
    v_edit_element.code,
    exploitation.name AS expl_name,
    v_edit_element.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_edit_element
     JOIN exploitation ON exploitation.expl_id = v_edit_element.expl_id
  WHERE v_edit_element.state = 0
UNION
 SELECT row_number() OVER (ORDER BY v_gully.gully_id) + 4000000 AS rid,
    'GULLY'::character varying AS feature_type,
    v_gully.gratecat_id AS featurecat_id,
    v_gully.gully_id AS feature_id,
    v_gully.code,
    exploitation.name AS expl_name,
    v_gully.workcat_id_end AS workcat_id,
    exploitation.expl_id
   FROM v_gully
     JOIN exploitation ON exploitation.expl_id = v_gully.expl_id
  WHERE v_gully.state = 0;


  
CREATE OR REPLACE VIEW v_plan_aux_arc_ml AS 
 SELECT v_arc.arc_id,
    v_arc.y1,
    v_arc.y2,
        CASE
            WHEN (v_arc.y1 * v_arc.y2) = 0::numeric OR (v_arc.y1 * v_arc.y2) IS NULL THEN v_price_x_catarc.estimated_depth
            ELSE ((v_arc.y1 + v_arc.y2) / 2::numeric)::numeric(12,2)
        END AS mean_y,
    v_arc.arccat_id,
    v_price_x_catarc.geom1,
    v_price_x_catarc.z1,
    v_price_x_catarc.z2,
    v_price_x_catarc.area,
    v_price_x_catarc.width,
    v_price_x_catarc.bulk,
    v_price_x_catarc.cost_unit,
    v_price_x_catarc.cost::numeric(12,2) AS arc_cost,
    v_price_x_catarc.m2bottom_cost::numeric(12,2) AS m2bottom_cost,
    v_price_x_catarc.m3protec_cost::numeric(12,2) AS m3protec_cost,
    v_price_x_catsoil.id AS soilcat_id,
    v_price_x_catsoil.y_param,
    v_price_x_catsoil.b,
    v_price_x_catsoil.trenchlining,
    v_price_x_catsoil.m3exc_cost::numeric(12,2) AS m3exc_cost,
    v_price_x_catsoil.m3fill_cost::numeric(12,2) AS m3fill_cost,
    v_price_x_catsoil.m3excess_cost::numeric(12,2) AS m3excess_cost,
    v_price_x_catsoil.m2trenchl_cost::numeric(12,2) AS m2trenchl_cost,
    v_price_x_catpavement.thickness,
    v_price_x_catpavement.m2pav_cost,
    v_arc.state,
    v_arc.the_geom,
    v_arc.expl_id
   FROM v_arc
     LEFT JOIN v_price_x_catarc ON v_arc.arccat_id::text = v_price_x_catarc.id::text
     LEFT JOIN v_price_x_catsoil ON v_arc.soilcat_id::text = v_price_x_catsoil.id::text
     LEFT JOIN plan_arc_x_pavement ON plan_arc_x_pavement.arc_id::text = v_arc.arc_id::text
     LEFT JOIN v_price_x_catpavement ON v_price_x_catpavement.pavcat_id::text = plan_arc_x_pavement.pavcat_id::text;


     
CREATE OR REPLACE VIEW v_plan_aux_arc_cost AS 
 SELECT v_plan_aux_arc_ml.arc_id,
    v_plan_aux_arc_ml.y1,
    v_plan_aux_arc_ml.y2,
    v_plan_aux_arc_ml.mean_y,
    v_plan_aux_arc_ml.arccat_id,
    v_plan_aux_arc_ml.geom1,
    v_plan_aux_arc_ml.z1,
    v_plan_aux_arc_ml.z2,
    v_plan_aux_arc_ml.area,
    v_plan_aux_arc_ml.width,
    v_plan_aux_arc_ml.bulk,
    v_plan_aux_arc_ml.cost_unit,
    v_plan_aux_arc_ml.arc_cost,
    v_plan_aux_arc_ml.m2bottom_cost,
    v_plan_aux_arc_ml.m3protec_cost,
    v_plan_aux_arc_ml.soilcat_id,
    v_plan_aux_arc_ml.y_param,
    v_plan_aux_arc_ml.b,
    v_plan_aux_arc_ml.trenchlining,
    v_plan_aux_arc_ml.m3exc_cost,
    v_plan_aux_arc_ml.m3fill_cost,
    v_plan_aux_arc_ml.m3excess_cost,
    v_plan_aux_arc_ml.m2trenchl_cost,
    v_plan_aux_arc_ml.thickness,
    v_plan_aux_arc_ml.m2pav_cost,
    v_plan_aux_arc_ml.state,
    v_plan_aux_arc_ml.the_geom,
    v_plan_aux_arc_ml.expl_id,
    (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric)::numeric(12,3) AS m2mlpavement,
    (2::numeric * v_plan_aux_arc_ml.b + v_plan_aux_arc_ml.width)::numeric(12,3) AS m2mlbase,
    (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness)::numeric(12,3) AS calculed_y,
    (v_plan_aux_arc_ml.trenchlining * 2::numeric * (v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness))::numeric(12,3) AS m2mltrenchl,
    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric)::numeric(12,3) AS m3mlexc,
    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric) - v_plan_aux_arc_ml.area)::numeric(12,3) AS m3mlprotec,
    ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) * (2::numeric * ((v_plan_aux_arc_ml.mean_y + v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.bulk - v_plan_aux_arc_ml.thickness) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width) / 2::numeric - (v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlfill,
    ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) * ((2::numeric * ((v_plan_aux_arc_ml.z1 + v_plan_aux_arc_ml.geom1 + v_plan_aux_arc_ml.bulk * 2::numeric + v_plan_aux_arc_ml.z2) / v_plan_aux_arc_ml.y_param) + v_plan_aux_arc_ml.width + v_plan_aux_arc_ml.b * 2::numeric + (v_plan_aux_arc_ml.b * 2::numeric + v_plan_aux_arc_ml.width)) / 2::numeric))::numeric(12,3) AS m3mlexcess
   FROM v_plan_aux_arc_ml;


CREATE OR REPLACE VIEW v_plan_arc AS 
 SELECT v_plan_aux_arc_cost.arc_id,
    arc.node_1,
    arc.node_2,
    arc.arc_type,
    v_plan_aux_arc_cost.arccat_id,
    arc.epa_type,
    arc.sector_id,
    v_plan_aux_arc_cost.state,
    arc.annotation,
    v_plan_aux_arc_cost.soilcat_id,
    v_plan_aux_arc_cost.y1,
    v_plan_aux_arc_cost.y2,
    v_plan_aux_arc_cost.mean_y,
    v_plan_aux_arc_cost.z1,
    v_plan_aux_arc_cost.z2,
    v_plan_aux_arc_cost.thickness,
    v_plan_aux_arc_cost.width,
    v_plan_aux_arc_cost.b,
    v_plan_aux_arc_cost.bulk,
    v_plan_aux_arc_cost.geom1,
    v_plan_aux_arc_cost.area,
    v_plan_aux_arc_cost.y_param,
    (v_plan_aux_arc_cost.calculed_y + v_plan_aux_arc_cost.thickness)::numeric(12,2) AS total_y,
    (v_plan_aux_arc_cost.calculed_y - 2::numeric * v_plan_aux_arc_cost.bulk - v_plan_aux_arc_cost.z1 - v_plan_aux_arc_cost.z2 - v_plan_aux_arc_cost.geom1)::numeric(12,2) AS rec_y,
    (v_plan_aux_arc_cost.geom1 + 2::numeric * v_plan_aux_arc_cost.bulk)::numeric(12,2) AS geom1_ext,
    v_plan_aux_arc_cost.calculed_y,
    v_plan_aux_arc_cost.m3mlexc,
    v_plan_aux_arc_cost.m2mltrenchl,
    v_plan_aux_arc_cost.m2mlbase AS m2mlbottom,
    v_plan_aux_arc_cost.m2mlpavement AS m2mlpav,
    v_plan_aux_arc_cost.m3mlprotec,
    v_plan_aux_arc_cost.m3mlfill,
    v_plan_aux_arc_cost.m3mlexcess,
    v_plan_aux_arc_cost.m3exc_cost,
    v_plan_aux_arc_cost.m2trenchl_cost,
    v_plan_aux_arc_cost.m2bottom_cost,
    v_plan_aux_arc_cost.m2pav_cost::numeric(12,2) AS m2pav_cost,
    v_plan_aux_arc_cost.m3protec_cost,
    v_plan_aux_arc_cost.m3fill_cost,
    v_plan_aux_arc_cost.m3excess_cost,
    v_plan_aux_arc_cost.cost_unit,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
            ELSE v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost
        END::numeric(12,3) AS pav_cost,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
            ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost
        END::numeric(12,3) AS exc_cost,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
            ELSE v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost
        END::numeric(12,3) AS trenchl_cost,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
            ELSE v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost
        END::numeric(12,3) AS base_cost,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
            ELSE v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost
        END::numeric(12,3) AS protec_cost,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
            ELSE v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost
        END::numeric(12,3) AS fill_cost,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::numeric
            ELSE v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost
        END::numeric(12,3) AS excess_cost,
    v_plan_aux_arc_cost.arc_cost::numeric(12,3) AS arc_cost,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
            ELSE v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost
        END::numeric(12,2) AS cost,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN NULL::double precision
            ELSE st_length2d(v_plan_aux_arc_cost.the_geom)
        END::numeric(12,2) AS length,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost
            ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2)
        END::numeric(14,2) AS budget,
    v_plan_aux_arc_connec.connec_total_cost + v_plan_aux_arc_gully.gully_total_cost AS other_budget,
        CASE
            WHEN v_plan_aux_arc_cost.cost_unit::text = 'u'::text THEN v_plan_aux_arc_cost.arc_cost +
            CASE
                WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                ELSE v_plan_aux_arc_connec.connec_total_cost
            END
            ELSE st_length2d(v_plan_aux_arc_cost.the_geom)::numeric(12,2) * (v_plan_aux_arc_cost.m3mlexc * v_plan_aux_arc_cost.m3exc_cost + v_plan_aux_arc_cost.m2mlbase * v_plan_aux_arc_cost.m2bottom_cost + v_plan_aux_arc_cost.m2mltrenchl * v_plan_aux_arc_cost.m2trenchl_cost + v_plan_aux_arc_cost.m3mlprotec * v_plan_aux_arc_cost.m3protec_cost + v_plan_aux_arc_cost.m3mlfill * v_plan_aux_arc_cost.m3fill_cost + v_plan_aux_arc_cost.m3mlexcess * v_plan_aux_arc_cost.m3excess_cost + v_plan_aux_arc_cost.m2mlpavement * v_plan_aux_arc_cost.m2pav_cost + v_plan_aux_arc_cost.arc_cost)::numeric(14,2) +
            CASE
                WHEN v_plan_aux_arc_connec.connec_total_cost IS NULL THEN 0::numeric
                ELSE v_plan_aux_arc_connec.connec_total_cost
            END
        END::numeric(14,2) AS total_budget,
    v_plan_aux_arc_cost.the_geom,
    v_plan_aux_arc_cost.expl_id
   FROM v_plan_aux_arc_cost
     JOIN arc ON v_plan_aux_arc_cost.arc_id::text = arc.arc_id::text
     LEFT JOIN v_plan_aux_arc_connec ON v_plan_aux_arc_connec.arc_id::text = v_plan_aux_arc_cost.arc_id::text
     LEFT JOIN v_plan_aux_arc_gully ON v_plan_aux_arc_gully.arc_id::text = v_plan_aux_arc_cost.arc_id::text;




CREATE OR REPLACE VIEW v_ui_plan_arc_cost AS 
 SELECT arc.arc_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    2 AS orderby,
    'm2bottom'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mlbottom AS measurement,
    v_plan_arc.m2mlbottom * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.m2bottom_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    3 AS orderby,
    'm3protec'::text AS identif,
    cat_arc.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlprotec AS measurement,
    v_plan_arc.m3mlprotec * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_arc ON cat_arc.id::text = arc.arccat_id::text
     JOIN v_price_compost ON cat_arc.m3protec_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    4 AS orderby,
    'm3exc'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlexc AS measurement,
    v_plan_arc.m3mlexc * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3exc_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    5 AS orderby,
    'm3fill'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlfill AS measurement,
    v_plan_arc.m3mlfill * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3fill_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    6 AS orderby,
    'm3excess'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m3mlexcess AS measurement,
    v_plan_arc.m3mlexcess * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m3excess_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    7 AS orderby,
    'm2trenchl'::text AS identif,
    cat_soil.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mltrenchl AS measurement,
    v_plan_arc.m2mltrenchl * v_price_compost.price AS total_cost
   FROM arc
     JOIN cat_soil ON cat_soil.id::text = arc.soilcat_id::text
     JOIN v_price_compost ON cat_soil.m2trenchl_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT arc.arc_id,
    8 AS orderby,
    'pavement'::text AS identif,
    cat_pavement.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    v_plan_arc.m2mlpav * plan_arc_x_pavement.percent AS measurement,
    v_plan_arc.m2mlpav * plan_arc_x_pavement.percent * v_price_compost.price AS total_cost
   FROM arc
     JOIN plan_arc_x_pavement ON plan_arc_x_pavement.arc_id::text = arc.arc_id::text
     JOIN cat_pavement ON cat_pavement.id::text = plan_arc_x_pavement.pavcat_id::text
     JOIN v_price_compost ON cat_pavement.m2_cost::text = v_price_compost.id::text
     JOIN v_plan_arc ON arc.arc_id::text = v_plan_arc.arc_id::text
UNION
 SELECT connec.arc_id,
    9 AS orderby,
    'connec'::text AS identif,
    'Various catalog'::character varying AS catalog_id,
    'Various prices'::character varying AS price_id,
    'ut'::character varying AS unit,
    'Sumatory of connecs cost related to arc. The cost is calculated in combination of parameters depth/length from connec table and catalog price from cat_connec table'::character varying AS descript,
    NULL::numeric AS cost,
    count(connec.connec_id) AS measurement,
    sum(connec.connec_length * (v_price_x_catconnec.cost_mlconnec + v_price_x_catconnec.cost_m3trench * (connec.y1 + connec.y2) * 0.333 / 2::numeric) + v_price_x_catconnec.cost_ut)::numeric(12,2) AS total_cost
   FROM connec
     JOIN v_price_x_catconnec ON v_price_x_catconnec.id::text = connec.connecat_id::text
  GROUP BY connec.arc_id
UNION
 SELECT gully.arc_id,
    10 AS orderby,
    'gully'::text AS identif,
    'Various catalog'::character varying AS catalog_id,
    'Various prices'::character varying AS price_id,
    'ut'::character varying AS unit,
    'Sumatory of gully cost related to arc. The cost is calculated in combination of parameters depth/length from gully table and catalog price from cat_grate table'::character varying AS descript,
    NULL::numeric AS cost,
    count(gully.gully_id) AS measurement,
    (sum(v_price_x_catgrate.price) + sum(gully.connec_length * (v_price_x_catconnec.cost_mlconnec + v_price_x_catconnec.cost_m3trench * gully.connec_depth * 0.5)))::numeric(12,2) AS total_cost
   FROM gully
     LEFT JOIN v_price_x_catconnec ON v_price_x_catconnec.id::text = gully.connec_arccat_id::text
     JOIN v_price_x_catgrate ON v_price_x_catgrate.id::text = gully.gratecat_id::text
  GROUP BY gully.arc_id
  ORDER BY 1, 2;



CREATE OR REPLACE VIEW v_plan_result_arc AS 
 SELECT om_rec_result_arc.arc_id,
    om_rec_result_arc.node_1,
    om_rec_result_arc.node_2,
    om_rec_result_arc.arc_type,
    om_rec_result_arc.arccat_id,
    om_rec_result_arc.epa_type,
    om_rec_result_arc.sector_id,
    om_rec_result_arc.state,
    om_rec_result_arc.annotation,
    om_rec_result_arc.soilcat_id,
    om_rec_result_arc.y1,
    om_rec_result_arc.y2,
    om_rec_result_arc.mean_y,
    om_rec_result_arc.z1,
    om_rec_result_arc.z2,
    om_rec_result_arc.thickness,
    om_rec_result_arc.width,
    om_rec_result_arc.b,
    om_rec_result_arc.bulk,
    om_rec_result_arc.geom1,
    om_rec_result_arc.area,
    om_rec_result_arc.y_param,
    om_rec_result_arc.total_y,
    om_rec_result_arc.rec_y,
    om_rec_result_arc.geom1_ext,
    om_rec_result_arc.calculed_y,
    om_rec_result_arc.m3mlexc,
    om_rec_result_arc.m2mltrenchl,
    om_rec_result_arc.m2mlbottom,
    om_rec_result_arc.m2mlpav,
    om_rec_result_arc.m3mlprotec,
    om_rec_result_arc.m3mlfill,
    om_rec_result_arc.m3mlexcess,
    om_rec_result_arc.m3exc_cost,
    om_rec_result_arc.m2trenchl_cost,
    om_rec_result_arc.m2bottom_cost,
    om_rec_result_arc.m2pav_cost,
    om_rec_result_arc.m3protec_cost,
    om_rec_result_arc.m3fill_cost,
    om_rec_result_arc.m3excess_cost,
    om_rec_result_arc.cost_unit,
    om_rec_result_arc.pav_cost,
    om_rec_result_arc.exc_cost,
    om_rec_result_arc.trenchl_cost,
    om_rec_result_arc.base_cost,
    om_rec_result_arc.protec_cost,
    om_rec_result_arc.fill_cost,
    om_rec_result_arc.excess_cost,
    om_rec_result_arc.arc_cost,
    om_rec_result_arc.cost,
    om_rec_result_arc.length,
    om_rec_result_arc.budget,
    om_rec_result_arc.other_budget,
    om_rec_result_arc.total_budget,
    om_rec_result_arc.the_geom,
    om_rec_result_arc.expl_id
   FROM plan_result_selector,
    om_rec_result_arc
  WHERE om_rec_result_arc.result_id::text = plan_result_selector.result_id::text AND plan_result_selector.cur_user = "current_user"()::text AND om_rec_result_arc.state = 1
UNION
 SELECT v_plan_arc.arc_id,
    v_plan_arc.node_1,
    v_plan_arc.node_2,
    v_plan_arc.arc_type,
    v_plan_arc.arccat_id,
    v_plan_arc.epa_type,
    v_plan_arc.sector_id,
    v_plan_arc.state,
    v_plan_arc.annotation,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.mean_y,
    v_plan_arc.z1,
    v_plan_arc.z2,
    v_plan_arc.thickness,
    v_plan_arc.width,
    v_plan_arc.b,
    v_plan_arc.bulk,
    v_plan_arc.geom1,
    v_plan_arc.area,
    v_plan_arc.y_param,
    v_plan_arc.total_y,
    v_plan_arc.rec_y,
    v_plan_arc.geom1_ext,
    v_plan_arc.calculed_y,
    v_plan_arc.m3mlexc,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.m2mlbottom,
    v_plan_arc.m2mlpav,
    v_plan_arc.m3mlprotec,
    v_plan_arc.m3mlfill,
    v_plan_arc.m3mlexcess,
    v_plan_arc.m3exc_cost,
    v_plan_arc.m2trenchl_cost,
    v_plan_arc.m2bottom_cost,
    v_plan_arc.m2pav_cost,
    v_plan_arc.m3protec_cost,
    v_plan_arc.m3fill_cost,
    v_plan_arc.m3excess_cost,
    v_plan_arc.cost_unit,
    v_plan_arc.pav_cost,
    v_plan_arc.exc_cost,
    v_plan_arc.trenchl_cost,
    v_plan_arc.base_cost,
    v_plan_arc.protec_cost,
    v_plan_arc.fill_cost,
    v_plan_arc.excess_cost,
    v_plan_arc.arc_cost,
    v_plan_arc.cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.the_geom,
    v_plan_arc.expl_id
   FROM v_plan_arc
  WHERE v_plan_arc.state = 2;


CREATE OR REPLACE VIEW v_plan_node AS 
 SELECT v_node.node_id,
    v_node.nodecat_id,
    v_node.sys_type AS node_type,
    v_node.top_elev,
    v_node.elev,
    v_node.epa_type,
    v_node.sector_id,
    v_node.state,
    v_node.annotation,
    v_node.the_geom,
    v_price_x_catnode.cost_unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
        CASE
            WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN 1::numeric
            WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
            CASE
                WHEN v_node.sys_type::text = 'STORAGE'::text THEN man_storage.max_volume
                WHEN v_node.sys_type::text = 'CHAMBER'::text THEN man_chamber.max_volume
                ELSE NULL::numeric
            END
            WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
            CASE
                WHEN v_node.ymax = 0::numeric THEN v_price_x_catnode.estimated_y
                WHEN v_node.ymax IS NULL THEN v_price_x_catnode.estimated_y
                ELSE v_node.ymax
            END
            ELSE NULL::numeric
        END::numeric(12,2) AS measurement,
        CASE
            WHEN v_price_x_catnode.cost_unit::text = 'u'::text THEN v_price_x_catnode.cost
            WHEN v_price_x_catnode.cost_unit::text = 'm3'::text THEN
            CASE
                WHEN v_node.sys_type::text = 'STORAGE'::text THEN man_storage.max_volume * v_price_x_catnode.cost
                WHEN v_node.sys_type::text = 'CHAMBER'::text THEN man_chamber.max_volume * v_price_x_catnode.cost
                ELSE NULL::numeric
            END
            WHEN v_price_x_catnode.cost_unit::text = 'm'::text THEN
            CASE
                WHEN v_node.ymax = 0::numeric THEN v_price_x_catnode.estimated_y * v_price_x_catnode.cost
                WHEN v_node.ymax IS NULL THEN v_price_x_catnode.estimated_y * v_price_x_catnode.cost
                ELSE v_node.ymax * v_price_x_catnode.cost
            END
            ELSE NULL::numeric
        END::numeric(12,2) AS budget,
    v_node.expl_id
   FROM v_node
     LEFT JOIN v_price_x_catnode ON v_node.nodecat_id::text = v_price_x_catnode.id::text
     LEFT JOIN man_chamber ON man_chamber.node_id::text = v_node.node_id::text
     LEFT JOIN man_storage ON man_storage.node_id::text = v_node.node_id::text
     JOIN cat_node ON cat_node.id::text = v_node.nodecat_id::text
     LEFT JOIN v_price_compost ON v_price_compost.id::text = cat_node.cost::text;

  
CREATE OR REPLACE VIEW v_plan_current_psector_budget AS 
 SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    'arc'::text AS feature_type,
    v_plan_arc.arccat_id AS featurecat_id,
    v_plan_arc.arc_id AS feature_id,
    v_plan_arc.length,
    (v_plan_arc.total_budget / v_plan_arc.length)::numeric(14,2) AS unitary_cost,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) + 9999 AS rid,
    plan_psector_x_node.psector_id,
    'node'::text AS feature_type,
    v_plan_node.nodecat_id AS featurecat_id,
    v_plan_node.node_id AS feature_id,
    1 AS length,
    v_plan_node.budget AS unitary_cost,
    v_plan_node.budget AS total_budget
   FROM v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
  WHERE plan_psector_x_node.doable = true
UNION
 SELECT row_number() OVER (ORDER BY v_plan_psector_x_other.id) + 19999 AS rid,
    v_plan_psector_x_other.psector_id,
    'other'::text AS feature_type,
    v_plan_psector_x_other.price_id AS featurecat_id,
    v_plan_psector_x_other.descript AS feature_id,
    v_plan_psector_x_other.measurement AS length,
    v_plan_psector_x_other.price AS unitary_cost,
    v_plan_psector_x_other.total_budget
   FROM v_plan_psector_x_other
  ORDER BY 1, 2, 4;



CREATE OR REPLACE VIEW v_plan_psector_x_arc AS 
 SELECT row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    plan_psector_x_arc.psector_id,
    plan_psector.psector_type,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    v_plan_arc.state,
    plan_psector.expl_id,
    plan_psector.atlas_id,
    v_plan_arc.the_geom
   FROM selector_psector,
    v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_arc.psector_id
  WHERE selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_psector_x_arc.psector_id AND plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id;

CREATE OR REPLACE VIEW v_plan_psector_x_node AS 
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
    plan_psector_x_node.psector_id,
    plan_psector.psector_type,
    v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.cost::numeric(12,2) AS cost,
    v_plan_node.measurement,
    v_plan_node.budget AS total_budget,
    v_plan_node.state,
    v_plan_node.expl_id,
    plan_psector.atlas_id,
    v_plan_node.the_geom
   FROM selector_psector,
    v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id
  WHERE selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_psector_x_node.psector_id AND plan_psector_x_node.doable = true
  ORDER BY plan_psector_x_node.psector_id;




  
CREATE OR REPLACE VIEW v_plan_current_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.sector_id,
    plan_psector.active,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec,
    plan_psector.vat,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    ((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pca,
    plan_psector.the_geom,
    d.suma AS affec_length,
    e.suma AS plan_length,
    f.suma AS current_length
   FROM plan_psector
     JOIN plan_psector_selector ON plan_psector.psector_id = plan_psector_selector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM v_plan_psector_x_arc
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.total_budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM v_plan_psector_x_node
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(st_length2d(arc.the_geom)::numeric(12,2)) AS suma,
            pa.psector_id
           FROM arc
             JOIN plan_psector_x_arc pa USING (arc_id)
          WHERE pa.state = 0 AND pa.doable = false AND ((pa.addparam ->> 'arcDivide'::text) <> 'parent'::text OR (pa.addparam ->> 'arcDivide'::text) IS NULL) OR arc.state_type = ((( SELECT config_param_system.value
                   FROM config_param_system
                  WHERE config_param_system.parameter::text = 'plan_statetype_reconstruct'::text))::smallint)
          GROUP BY pa.psector_id) d ON d.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(st_length2d(arc.the_geom)::numeric(12,2)) AS suma,
            pa.psector_id
           FROM arc
             JOIN plan_psector_x_arc pa USING (arc_id)
          WHERE pa.state = 1 AND pa.doable = true
          GROUP BY pa.psector_id) e ON e.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(st_length2d(arc.the_geom)::numeric(12,2)) AS suma,
            pa.psector_id
           FROM arc
             JOIN plan_psector_x_arc pa USING (arc_id)
          WHERE pa.state = 1 AND pa.doable = false
          GROUP BY pa.psector_id) f ON f.psector_id = plan_psector.psector_id
  WHERE plan_psector_selector.cur_user = "current_user"()::text;


  
CREATE OR REPLACE VIEW v_plan_current_psector_budget_detail AS 
 SELECT v_plan_arc.arc_id,
    plan_psector_x_arc.psector_id,
    v_plan_arc.arccat_id,
    v_plan_arc.soilcat_id,
    v_plan_arc.y1,
    v_plan_arc.y2,
    v_plan_arc.arc_cost AS mlarc_cost,
    v_plan_arc.m3mlexc,
    v_plan_arc.exc_cost AS mlexc_cost,
    v_plan_arc.m2mltrenchl,
    v_plan_arc.trenchl_cost AS mltrench_cost,
    v_plan_arc.m2mlbottom AS m2mlbase,
    v_plan_arc.base_cost AS mlbase_cost,
    v_plan_arc.m2mlpav,
    v_plan_arc.pav_cost AS mlpav_cost,
    v_plan_arc.m3mlprotec,
    v_plan_arc.protec_cost AS mlprotec_cost,
    v_plan_arc.m3mlfill,
    v_plan_arc.fill_cost AS mlfill_cost,
    v_plan_arc.m3mlexcess,
    v_plan_arc.excess_cost AS mlexcess_cost,
    v_plan_arc.cost AS mltotal_cost,
    v_plan_arc.length,
    v_plan_arc.budget AS other_budget,
    v_plan_arc.total_budget
   FROM v_plan_arc
     JOIN plan_psector_x_arc ON plan_psector_x_arc.arc_id::text = v_plan_arc.arc_id::text
  WHERE plan_psector_x_arc.doable = true
  ORDER BY plan_psector_x_arc.psector_id, v_plan_arc.soilcat_id, v_plan_arc.arccat_id;


  
CREATE OR REPLACE VIEW v_plan_psector AS 
 SELECT plan_psector.psector_id,
    plan_psector.name,
    plan_psector.psector_type,
    plan_psector.descript,
    plan_psector.priority,
    a.suma::numeric(14,2) AS total_arc,
    b.suma::numeric(14,2) AS total_node,
    c.suma::numeric(14,2) AS total_other,
    plan_psector.text1,
    plan_psector.text2,
    plan_psector.observ,
    plan_psector.rotation,
    plan_psector.scale,
    plan_psector.sector_id,
    (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::numeric(14,2) AS pem,
    plan_psector.gexpenses,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric)::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec,
    plan_psector.vat,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pec_vat,
    plan_psector.other,
    (((100::numeric + plan_psector.gexpenses) / 100::numeric * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::double precision * (
        CASE
            WHEN a.suma IS NULL THEN 0::numeric
            ELSE a.suma
        END +
        CASE
            WHEN b.suma IS NULL THEN 0::numeric
            ELSE b.suma
        END +
        CASE
            WHEN c.suma IS NULL THEN 0::numeric
            ELSE c.suma
        END)::double precision)::numeric(14,2) AS pca,
    plan_psector.the_geom
   FROM selector_psector,
    plan_psector
     LEFT JOIN ( SELECT sum(v_plan_psector_x_arc.total_budget) AS suma,
            v_plan_psector_x_arc.psector_id
           FROM v_plan_psector_x_arc
          GROUP BY v_plan_psector_x_arc.psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_node.total_budget) AS suma,
            v_plan_psector_x_node.psector_id
           FROM v_plan_psector_x_node
          GROUP BY v_plan_psector_x_node.psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN ( SELECT sum(v_plan_psector_x_other.total_budget) AS suma,
            v_plan_psector_x_other.psector_id
           FROM v_plan_psector_x_other
          GROUP BY v_plan_psector_x_other.psector_id) c ON c.psector_id = plan_psector.psector_id
  WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text;



CREATE OR REPLACE VIEW v_arc_x_vnode AS 
 SELECT a.vnode_id,
    a.arc_id,
    a.feature_type,
    a.feature_id,
    a.node_1,
    a.node_2,
    (a.length * a.locate::double precision)::numeric(12,3) AS vnode_distfromnode1,
    (a.length * (1::numeric - a.locate)::double precision)::numeric(12,3) AS vnode_distfromnode2,
    (a.top_elev1 - a.locate * (a.top_elev1 - a.top_elev2))::numeric(12,3) AS vnode_topelev,
    (a.sys_y1 - a.locate * (a.sys_y1 - a.sys_y2))::numeric(12,3) AS vnode_ymax,
    (a.sys_elev1 - a.locate * (a.sys_elev1 - a.sys_elev2))::numeric(12,3) AS vnode_elev
   FROM ( SELECT vnode.vnode_id,
            v_arc.arc_id,
            a_1.feature_type,
            a_1.feature_id,
            st_length(v_arc.the_geom) AS length,
            st_linelocatepoint(v_arc.the_geom, vnode.the_geom)::numeric(12,3) AS locate,
            v_arc.node_1,
            v_arc.node_2,
            v_arc.sys_elev1,
            v_arc.sys_elev2,
            v_arc.sys_y1,
            v_arc.sys_y2,
            v_arc.sys_elev1 + v_arc.sys_y1 AS top_elev1,
            v_arc.sys_elev2 + v_arc.sys_y2 AS top_elev2
           FROM v_arc,
            vnode
             JOIN v_edit_link a_1 ON vnode.vnode_id = a_1.exit_id::integer
          WHERE st_dwithin(v_arc.the_geom, vnode.the_geom, 0.01::double precision) AND v_arc.state > 0 AND vnode.state > 0) a
  ORDER BY a.arc_id, a.node_2 DESC;

  

CREATE OR REPLACE VIEW v_rtc_period_hydrometer AS 
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    NULL::character varying(16) AS pjoint_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN rpt_inp_arc ON v_connec.arc_id::text = rpt_inp_arc.arc_id::text
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND c.dma_id::integer = v_connec.dma_id
  WHERE ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_arc.result_id::text = ((( SELECT inp_selector_result.result_id
           FROM inp_selector_result
          WHERE inp_selector_result.cur_user = "current_user"()::text))::text)
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    rpt_inp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN rpt_inp_node ON concat('VN', v_connec.pjoint_id) = rpt_inp_node.node_id::text
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_connec.dma_id::text = c.dma_id::text
  WHERE v_connec.pjoint_type::text = 'VNODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_node.result_id::text = ((( SELECT inp_selector_result.result_id
           FROM inp_selector_result
          WHERE inp_selector_result.cur_user = "current_user"()::text))::text)
UNION
 SELECT ext_rtc_hydrometer.id AS hydrometer_id,
    v_connec.connec_id,
    rpt_inp_node.node_id AS pjoint_id,
    NULL::character varying AS node_1,
    NULL::character varying AS node_2,
    ext_cat_period.id AS period_id,
    ext_cat_period.period_seconds,
    c.dma_id,
    c.effc::numeric(5,4) AS effc,
    c.minc,
    c.maxc,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum
            ELSE ext_rtc_hydrometer_x_data.sum
        END AS m3_total_period,
        CASE
            WHEN ext_rtc_hydrometer_x_data.custom_sum IS NOT NULL THEN ext_rtc_hydrometer_x_data.custom_sum * 1000::double precision / ext_cat_period.period_seconds::double precision
            ELSE ext_rtc_hydrometer_x_data.sum * 1000::double precision / ext_cat_period.period_seconds::double precision
        END AS lps_avg,
    ext_rtc_hydrometer_x_data.pattern_id
   FROM ext_rtc_hydrometer
     JOIN ext_rtc_hydrometer_x_data ON ext_rtc_hydrometer_x_data.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     JOIN ext_cat_period ON ext_rtc_hydrometer_x_data.cat_period_id::text = ext_cat_period.id::text
     JOIN rtc_hydrometer_x_connec ON rtc_hydrometer_x_connec.hydrometer_id::bigint = ext_rtc_hydrometer.id::bigint
     LEFT JOIN v_connec ON v_connec.connec_id::text = rtc_hydrometer_x_connec.connec_id::text
     JOIN rpt_inp_node ON v_connec.pjoint_id::text = rpt_inp_node.node_id::text
     JOIN ext_rtc_scada_dma_period c ON c.cat_period_id::text = ext_cat_period.id::text AND v_connec.dma_id::text = c.dma_id::text
  WHERE v_connec.pjoint_type::text = 'NODE'::text AND ext_cat_period.id::text = (( SELECT config_param_user.value
           FROM config_param_user
          WHERE config_param_user.cur_user::name = "current_user"() AND config_param_user.parameter::text = 'inp_options_rtc_period_id'::text)) AND rpt_inp_node.result_id::text = ((( SELECT inp_selector_result.result_id
           FROM inp_selector_result
          WHERE inp_selector_result.cur_user = "current_user"()::text))::text);



CREATE OR REPLACE VIEW v_rtc_period_dma AS 
 SELECT v_rtc_period_hydrometer.dma_id::integer AS dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period,
    a.pattern_id
   FROM v_rtc_period_hydrometer
     JOIN ext_rtc_scada_dma_period a ON a.dma_id::text = v_rtc_period_hydrometer.dma_id::text AND v_rtc_period_hydrometer.period_id::text = a.cat_period_id::text
  GROUP BY v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.period_id, a.pattern_id;


CREATE OR REPLACE VIEW v_rtc_period_pjoint AS 
 SELECT v_rtc_period_hydrometer.pjoint_id,
    v_rtc_period_hydrometer.dma_id,
    v_rtc_period_hydrometer.period_id,
    sum(v_rtc_period_hydrometer.lps_avg) AS lps_avg,
    v_rtc_period_hydrometer.effc,
    sum(v_rtc_period_hydrometer.lps_avg / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
    v_rtc_period_hydrometer.minc,
    sum(v_rtc_period_hydrometer.lps_avg / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
    v_rtc_period_hydrometer.maxc,
    sum(v_rtc_period_hydrometer.lps_avg / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
    sum(v_rtc_period_hydrometer.m3_total_period) AS m3_total_period
   FROM v_rtc_period_hydrometer
  WHERE v_rtc_period_hydrometer.pjoint_id IS NOT NULL
  GROUP BY v_rtc_period_hydrometer.pjoint_id, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc;



  
CREATE OR REPLACE VIEW v_rtc_period_node AS 
 SELECT a.node_id,
    a.dma_id,
    a.period_id,
    sum(a.lps_avg) AS lps_avg,
    a.effc,
    sum(a.lps_avg_real) AS lps_avg_real,
    a.minc,
    sum(a.lps_min) AS lps_min,
    a.maxc,
    sum(a.lps_max) AS lps_max,
    sum(a.m3_total_period) AS m3_total_period
   FROM ( SELECT v_rtc_period_hydrometer.node_1 AS node_id,
            v_rtc_period_hydrometer.dma_id,
            v_rtc_period_hydrometer.period_id,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
            v_rtc_period_hydrometer.effc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
            v_rtc_period_hydrometer.minc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
            v_rtc_period_hydrometer.maxc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
            sum(v_rtc_period_hydrometer.m3_total_period * 0.5::double precision) AS m3_total_period
           FROM v_rtc_period_hydrometer
          WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
          GROUP BY v_rtc_period_hydrometer.node_1, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc
        UNION
         SELECT v_rtc_period_hydrometer.node_2 AS node_id,
            v_rtc_period_hydrometer.dma_id,
            v_rtc_period_hydrometer.period_id,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision) AS lps_avg,
            v_rtc_period_hydrometer.effc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision) AS lps_avg_real,
            v_rtc_period_hydrometer.minc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.minc) AS lps_min,
            v_rtc_period_hydrometer.maxc,
            sum(v_rtc_period_hydrometer.lps_avg * 0.5::double precision / v_rtc_period_hydrometer.effc::double precision * v_rtc_period_hydrometer.maxc) AS lps_max,
            sum(v_rtc_period_hydrometer.m3_total_period * 0.5::double precision) AS m3_total_period
           FROM v_rtc_period_hydrometer
          WHERE v_rtc_period_hydrometer.pjoint_id IS NULL
          GROUP BY v_rtc_period_hydrometer.node_2, v_rtc_period_hydrometer.period_id, v_rtc_period_hydrometer.dma_id, v_rtc_period_hydrometer.effc, v_rtc_period_hydrometer.minc, v_rtc_period_hydrometer.maxc) a
  GROUP BY a.node_id, a.period_id, a.dma_id, a.effc, a.minc, a.maxc;


  CREATE OR REPLACE VIEW v_anl_flow_connec AS 
 SELECT connec.connec_id,
        CASE
            WHEN anl_arc.fprocesscat_id = 120 THEN 'Flow trace'::text
            WHEN anl_arc.fprocesscat_id = 121 THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    connec.the_geom
   FROM anl_arc
     JOIN connec ON anl_arc.arc_id::text = connec.arc_id::text
     JOIN selector_expl ON anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"() AND (anl_arc.fprocesscat_id = 120 OR anl_arc.fprocesscat_id = 121);



CREATE OR REPLACE VIEW v_anl_flow_gully AS 
 SELECT v_gully.gully_id,
        CASE
            WHEN anl_arc.fprocesscat_id = 120 THEN 'Flow trace'::text
            WHEN anl_arc.fprocesscat_id = 121 THEN 'Flow exit'::text
            ELSE NULL::text
        END AS context,
    anl_arc.expl_id,
    v_gully.the_geom
   FROM anl_arc
     JOIN v_gully ON anl_arc.arc_id::text = v_gully.arc_id::text
     JOIN selector_expl ON anl_arc.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND anl_arc.cur_user::name = "current_user"() AND (anl_arc.fprocesscat_id = 120 OR anl_arc.fprocesscat_id = 121);


     
     CREATE OR REPLACE VIEW v_plan_psector_x_node AS 
 SELECT row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
    plan_psector_x_node.psector_id,
    plan_psector.psector_type,
    v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.cost::numeric(12,2) AS cost,
    v_plan_node.measurement,
    v_plan_node.budget AS total_budget,
    v_plan_node.state,
    v_plan_node.expl_id,
    plan_psector.atlas_id,
    v_plan_node.the_geom
   FROM selector_psector,
    v_plan_node
     JOIN plan_psector_x_node ON plan_psector_x_node.node_id::text = v_plan_node.node_id::text
     JOIN plan_psector ON plan_psector.psector_id = plan_psector_x_node.psector_id
  WHERE selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_psector_x_node.psector_id AND plan_psector_x_node.doable = true
  ORDER BY plan_psector_x_node.psector_id;


  
CREATE OR REPLACE VIEW v_plan_result_node AS 
 SELECT om_rec_result_node.node_id,
    om_rec_result_node.nodecat_id,
    om_rec_result_node.node_type,
    om_rec_result_node.top_elev,
    om_rec_result_node.elev,
    om_rec_result_node.epa_type,
    om_rec_result_node.sector_id,
    om_rec_result_node.cost_unit,
    om_rec_result_node.descript,
    om_rec_result_node.measurement,
    om_rec_result_node.cost,
    om_rec_result_node.budget,
    om_rec_result_node.state,
    om_rec_result_node.the_geom,
    om_rec_result_node.expl_id
   FROM selector_expl,
    plan_result_selector,
    om_rec_result_node
  WHERE om_rec_result_node.expl_id = selector_expl.expl_id AND selector_expl.cur_user = "current_user"()::text AND om_rec_result_node.result_id::text = plan_result_selector.result_id::text AND plan_result_selector.cur_user = "current_user"()::text AND om_rec_result_node.state = 1
UNION
 SELECT v_plan_node.node_id,
    v_plan_node.nodecat_id,
    v_plan_node.node_type,
    v_plan_node.top_elev,
    v_plan_node.elev,
    v_plan_node.epa_type,
    v_plan_node.sector_id,
    v_plan_node.cost_unit,
    v_plan_node.descript,
    v_plan_node.measurement,
    v_plan_node.cost,
    v_plan_node.budget,
    v_plan_node.state,
    v_plan_node.the_geom,
    v_plan_node.expl_id
   FROM v_plan_node
  WHERE v_plan_node.state = 2;


  CREATE OR REPLACE VIEW v_ui_plan_node_cost AS 
 SELECT node.node_id,
    1 AS orderby,
    'element'::text AS identif,
    cat_node.id AS catalog_id,
    v_price_compost.id AS price_id,
    v_price_compost.unit,
    v_price_compost.descript,
    v_price_compost.price AS cost,
    1 AS measurement,
    1::numeric * v_price_compost.price AS total_cost
   FROM node
     JOIN cat_node ON cat_node.id::text = node.nodecat_id::text
     JOIN v_price_compost ON cat_node.cost::text = v_price_compost.id::text
     JOIN v_plan_node ON node.node_id::text = v_plan_node.node_id::text;



     
CREATE OR REPLACE VIEW v_edit_man_netelement AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    man_netelement.serial_number
   FROM v_node
     JOIN man_netelement ON man_netelement.node_id::text = v_node.node_id::text;



     CREATE OR REPLACE VIEW ve_pol_netgully AS 
 SELECT man_netgully.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_netgully ON man_netgully.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_netgully.pol_id::text;


     
CREATE OR REPLACE VIEW ve_pol_storage AS 
 SELECT man_storage.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_storage ON man_storage.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_storage.pol_id::text;


CREATE OR REPLACE VIEW ve_pol_wwtp AS 
 SELECT man_wwtp.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_wwtp ON man_wwtp.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_wwtp.pol_id::text;


     CREATE OR REPLACE VIEW ve_pol_chamber AS 
 SELECT man_chamber.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_chamber ON man_chamber.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_chamber.pol_id::text;



     CREATE OR REPLACE VIEW vi_groundwater AS 
 SELECT inp_groundwater.subc_id,
    inp_groundwater.aquif_id,
    inp_groundwater.node_id,
    inp_groundwater.surfel,
    inp_groundwater.a1,
    inp_groundwater.b1,
    inp_groundwater.a2,
    inp_groundwater.b2,
    inp_groundwater.a3,
    inp_groundwater.tw,
    inp_groundwater.h
   FROM v_edit_subcatchment
     JOIN inp_groundwater ON inp_groundwater.subc_id::text = v_edit_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(subcatchment.outlet_id::text[]) AS node_array,
                    subcatchment.subc_id,
                    subcatchment.outlet_id,
                    subcatchment.rg_id,
                    subcatchment.area,
                    subcatchment.imperv,
                    subcatchment.width,
                    subcatchment.slope,
                    subcatchment.clength,
                    subcatchment.snow_id,
                    subcatchment.nimp,
                    subcatchment.nperv,
                    subcatchment.simp,
                    subcatchment.sperv,
                    subcatchment.zero,
                    subcatchment.routeto,
                    subcatchment.rted,
                    subcatchment.maxrate,
                    subcatchment.minrate,
                    subcatchment.decay,
                    subcatchment.drytime,
                    subcatchment.maxinfil,
                    subcatchment.suction,
                    subcatchment.conduct,
                    subcatchment.initdef,
                    subcatchment.curveno,
                    subcatchment.conduct_2,
                    subcatchment.drytime_2,
                    subcatchment.sector_id,
                    subcatchment.hydrology_id,
                    subcatchment.the_geom,
                    subcatchment._parent_id,
                    subcatchment.descript
                   FROM subcatchment
                  WHERE "left"(subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_subcatchment.subc_id::text = b.subc_id::text;


CREATE OR REPLACE VIEW vi_infiltration AS 
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.curveno AS other1,
    v_edit_subcatchment.conduct_2 AS other2,
    v_edit_subcatchment.drytime_2 AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(subcatchment.outlet_id::text[]) AS node_array,
                    subcatchment.subc_id,
                    subcatchment.outlet_id,
                    subcatchment.rg_id,
                    subcatchment.area,
                    subcatchment.imperv,
                    subcatchment.width,
                    subcatchment.slope,
                    subcatchment.clength,
                    subcatchment.snow_id,
                    subcatchment.nimp,
                    subcatchment.nperv,
                    subcatchment.simp,
                    subcatchment.sperv,
                    subcatchment.zero,
                    subcatchment.routeto,
                    subcatchment.rted,
                    subcatchment.maxrate,
                    subcatchment.minrate,
                    subcatchment.decay,
                    subcatchment.drytime,
                    subcatchment.maxinfil,
                    subcatchment.suction,
                    subcatchment.conduct,
                    subcatchment.initdef,
                    subcatchment.curveno,
                    subcatchment.conduct_2,
                    subcatchment.drytime_2,
                    subcatchment.sector_id,
                    subcatchment.hydrology_id,
                    subcatchment.the_geom,
                    subcatchment._parent_id,
                    subcatchment.descript
                   FROM subcatchment
                  WHERE "left"(subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_subcatchment.subc_id::text = b.subc_id::text
  WHERE cat_hydrology.infiltration::text = 'CURVE_NUMBER'::text
UNION
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.suction AS other1,
    v_edit_subcatchment.conduct AS other2,
    v_edit_subcatchment.initdef AS other3,
    NULL::integer AS other4,
    NULL::double precision AS other5
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(subcatchment.outlet_id::text[]) AS node_array,
                    subcatchment.subc_id,
                    subcatchment.outlet_id,
                    subcatchment.rg_id,
                    subcatchment.area,
                    subcatchment.imperv,
                    subcatchment.width,
                    subcatchment.slope,
                    subcatchment.clength,
                    subcatchment.snow_id,
                    subcatchment.nimp,
                    subcatchment.nperv,
                    subcatchment.simp,
                    subcatchment.sperv,
                    subcatchment.zero,
                    subcatchment.routeto,
                    subcatchment.rted,
                    subcatchment.maxrate,
                    subcatchment.minrate,
                    subcatchment.decay,
                    subcatchment.drytime,
                    subcatchment.maxinfil,
                    subcatchment.suction,
                    subcatchment.conduct,
                    subcatchment.initdef,
                    subcatchment.curveno,
                    subcatchment.conduct_2,
                    subcatchment.drytime_2,
                    subcatchment.sector_id,
                    subcatchment.hydrology_id,
                    subcatchment.the_geom,
                    subcatchment._parent_id,
                    subcatchment.descript
                   FROM subcatchment
                  WHERE "left"(subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_subcatchment.subc_id::text = b.subc_id::text
  WHERE cat_hydrology.infiltration::text = 'GREEN_AMPT'::text
UNION
 SELECT v_edit_subcatchment.subc_id,
    v_edit_subcatchment.maxrate AS other1,
    v_edit_subcatchment.minrate AS other2,
    v_edit_subcatchment.decay AS other3,
    v_edit_subcatchment.drytime AS other4,
    v_edit_subcatchment.maxinfil AS other5
   FROM v_edit_subcatchment
     JOIN cat_hydrology ON cat_hydrology.hydrology_id = v_edit_subcatchment.hydrology_id
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(subcatchment.outlet_id::text[]) AS node_array,
                    subcatchment.subc_id,
                    subcatchment.outlet_id,
                    subcatchment.rg_id,
                    subcatchment.area,
                    subcatchment.imperv,
                    subcatchment.width,
                    subcatchment.slope,
                    subcatchment.clength,
                    subcatchment.snow_id,
                    subcatchment.nimp,
                    subcatchment.nperv,
                    subcatchment.simp,
                    subcatchment.sperv,
                    subcatchment.zero,
                    subcatchment.routeto,
                    subcatchment.rted,
                    subcatchment.maxrate,
                    subcatchment.minrate,
                    subcatchment.decay,
                    subcatchment.drytime,
                    subcatchment.maxinfil,
                    subcatchment.suction,
                    subcatchment.conduct,
                    subcatchment.initdef,
                    subcatchment.curveno,
                    subcatchment.conduct_2,
                    subcatchment.drytime_2,
                    subcatchment.sector_id,
                    subcatchment.hydrology_id,
                    subcatchment.the_geom,
                    subcatchment._parent_id,
                    subcatchment.descript
                   FROM subcatchment
                  WHERE "left"(subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_subcatchment.subc_id::text = b.subc_id::text;



             
CREATE OR REPLACE VIEW vi_coverages AS 
 SELECT v_edit_subcatchment.subc_id,
    inp_coverage_land_x_subc.landus_id,
    inp_coverage_land_x_subc.percent
   FROM inp_coverage_land_x_subc
     JOIN v_edit_subcatchment ON inp_coverage_land_x_subc.subc_id::text = v_edit_subcatchment.subc_id::text
     LEFT JOIN ( SELECT DISTINCT ON (a.subc_id) a.subc_id,
            v_node.node_id
           FROM ( SELECT unnest(subcatchment.outlet_id::text[]) AS node_array,
                    subcatchment.subc_id,
                    subcatchment.outlet_id,
                    subcatchment.rg_id,
                    subcatchment.area,
                    subcatchment.imperv,
                    subcatchment.width,
                    subcatchment.slope,
                    subcatchment.clength,
                    subcatchment.snow_id,
                    subcatchment.nimp,
                    subcatchment.nperv,
                    subcatchment.simp,
                    subcatchment.sperv,
                    subcatchment.zero,
                    subcatchment.routeto,
                    subcatchment.rted,
                    subcatchment.maxrate,
                    subcatchment.minrate,
                    subcatchment.decay,
                    subcatchment.drytime,
                    subcatchment.maxinfil,
                    subcatchment.suction,
                    subcatchment.conduct,
                    subcatchment.initdef,
                    subcatchment.curveno,
                    subcatchment.conduct_2,
                    subcatchment.drytime_2,
                    subcatchment.sector_id,
                    subcatchment.hydrology_id,
                    subcatchment.the_geom,
                    subcatchment._parent_id,
                    subcatchment.descript
                   FROM subcatchment
                  WHERE "left"(subcatchment.outlet_id::text, 1) = '{'::text) a
             JOIN v_node ON v_node.node_id::text = a.node_array) b ON v_edit_subcatchment.subc_id::text = b.subc_id::text;


             
CREATE OR REPLACE VIEW vi_subcatch2node AS 
 SELECT s1.subc_id,
        CASE
            WHEN s2.the_geom IS NOT NULL THEN st_makeline(st_centroid(s1.the_geom), st_centroid(s2.the_geom))
            ELSE st_makeline(st_centroid(s1.the_geom), v_node.the_geom)
        END AS the_geom
   FROM v_edit_subcatchment s1
     LEFT JOIN v_edit_subcatchment s2 ON s2.subc_id::text = s1.outlet_id::text
     LEFT JOIN v_node ON v_node.node_id::text = s1.outlet_id::text;


     CREATE OR REPLACE VIEW vi_subcatchcentroid AS 
 SELECT v_edit_subcatchment.subc_id,
    st_centroid(v_edit_subcatchment.the_geom) AS the_geom
   FROM v_edit_subcatchment;

	

CREATE OR REPLACE VIEW v_edit_man_chamber AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
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
     JOIN man_chamber ON man_chamber.node_id::text = v_node.node_id::text;


     CREATE OR REPLACE VIEW v_edit_man_chamber_pol AS 
 SELECT man_chamber.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_chamber ON man_chamber.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_chamber.pol_id::text;


     
CREATE OR REPLACE VIEW v_edit_man_conduit AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.elev2,
    v_arc.custom_y2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.z1,
    v_arc.z2,
    v_arc.r1,
    v_arc.r2,
    v_arc.slope,
    v_arc.arc_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.shape,
    v_arc.geom1 AS cat_geom1,
    v_arc.geom2 AS cat_geom2,
    v_arc.gis_length,
    v_arc.epa_type,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value
   FROM v_arc
     JOIN man_conduit ON man_conduit.arc_id::text = v_arc.arc_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_connec AS 
 SELECT v_edit_connec.connec_id,
    v_edit_connec.code,
    v_edit_connec.customer_code,
    v_edit_connec.top_elev,
    v_edit_connec.y1,
    v_edit_connec.y2,
    v_edit_connec.connecat_id,
    v_edit_connec.connec_type,
    v_edit_connec.sys_type,
    v_edit_connec.private_connecat_id,
    v_edit_connec.cat_matcat_id,
    v_edit_connec.sector_id,
    v_edit_connec.macrosector_id,
    v_edit_connec.demand,
    v_edit_connec.state,
    v_edit_connec.state_type,
    v_edit_connec.connec_depth,
    v_edit_connec.connec_length,
    v_edit_connec.arc_id,
    v_edit_connec.annotation,
    v_edit_connec.observ,
    v_edit_connec.comment,
    v_edit_connec.label,
    v_edit_connec.dma_id,
    v_edit_connec.soilcat_id,
    v_edit_connec.function_type,
    v_edit_connec.category_type,
    v_edit_connec.fluid_type,
    v_edit_connec.location_type,
    v_edit_connec.workcat_id,
    v_edit_connec.workcat_id_end,
    v_edit_connec.buildercat_id,
    v_edit_connec.builtdate,
    v_edit_connec.enddate,
    v_edit_connec.ownercat_id,
    v_edit_connec.muni_id,
    v_edit_connec.postcode,
    v_edit_connec.streetname,
    v_edit_connec.postnumber,
    v_edit_connec.postcomplement,
    v_edit_connec.streetname2,
    v_edit_connec.postnumber2,
    v_edit_connec.postcomplement2,
    v_edit_connec.descript,
    v_edit_connec.svg,
    v_edit_connec.rotation,
    v_edit_connec.link,
    v_edit_connec.verified,
    v_edit_connec.the_geom,
    v_edit_connec.undelete,
    v_edit_connec.featurecat_id,
    v_edit_connec.feature_id,
    v_edit_connec.label_x,
    v_edit_connec.label_y,
    v_edit_connec.label_rotation,
    v_edit_connec.accessibility,
    v_edit_connec.diagonal,
    v_edit_connec.publish,
    v_edit_connec.inventory,
    v_edit_connec.uncertain,
    v_edit_connec.macrodma_id,
    v_edit_connec.expl_id,
    v_edit_connec.num_value
   FROM v_edit_connec;


   
CREATE OR REPLACE VIEW v_edit_man_gully AS 
 SELECT v_edit_gully.gully_id,
    v_edit_gully.code,
    v_edit_gully.top_elev,
    v_edit_gully.ymax,
    v_edit_gully.sandbox,
    v_edit_gully.matcat_id,
    v_edit_gully.gully_type,
    v_edit_gully.sys_type,
    v_edit_gully.gratecat_id,
    v_edit_gully.cat_grate_matcat,
    v_edit_gully.units,
    v_edit_gully.groove,
    v_edit_gully.siphon,
    v_edit_gully.connec_arccat_id,
    v_edit_gully.connec_length,
    v_edit_gully.connec_depth,
    v_edit_gully.arc_id,
    v_edit_gully.sector_id,
    v_edit_gully.macrosector_id,
    v_edit_gully.state,
    v_edit_gully.state_type,
    v_edit_gully.annotation,
    v_edit_gully.observ,
    v_edit_gully.comment,
    v_edit_gully.label,
    v_edit_gully.dma_id,
    v_edit_gully.soilcat_id,
    v_edit_gully.function_type,
    v_edit_gully.category_type,
    v_edit_gully.fluid_type,
    v_edit_gully.location_type,
    v_edit_gully.workcat_id,
    v_edit_gully.workcat_id_end,
    v_edit_gully.buildercat_id,
    v_edit_gully.builtdate,
    v_edit_gully.enddate,
    v_edit_gully.ownercat_id,
    v_edit_gully.muni_id,
    v_edit_gully.postcode,
    v_edit_gully.streetname,
    v_edit_gully.postnumber,
    v_edit_gully.postcomplement,
    v_edit_gully.streetname2,
    v_edit_gully.postnumber2,
    v_edit_gully.postcomplement2,
    v_edit_gully.descript,
    v_edit_gully.svg,
    v_edit_gully.rotation,
    v_edit_gully.link,
    v_edit_gully.verified,
    v_edit_gully.the_geom,
    v_edit_gully.undelete,
    v_edit_gully.featurecat_id,
    v_edit_gully.feature_id,
    v_edit_gully.label_x,
    v_edit_gully.label_y,
    v_edit_gully.label_rotation,
    v_edit_gully.publish,
    v_edit_gully.inventory,
    v_edit_gully.expl_id,
    v_edit_gully.macrodma_id,
    v_edit_gully.uncertain,
    v_edit_gully.num_value
   FROM v_edit_gully;

CREATE OR REPLACE VIEW v_edit_man_gully_pol AS 
 SELECT gully.pol_id,
    gully.gully_id,
    polygon.the_geom
   FROM gully
     JOIN v_state_gully ON gully.gully_id::text = v_state_gully.gully_id::text
     JOIN polygon ON polygon.pol_id::text = gully.pol_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_junction AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value
   FROM v_node
     JOIN man_junction ON man_junction.node_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_manhole AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    man_manhole.length,
    man_manhole.width,
    man_manhole.sander_depth,
    man_manhole.prot_surface,
    man_manhole.inlet,
    man_manhole.bottom_channel,
    man_manhole.accessibility
   FROM v_node
     JOIN man_manhole ON man_manhole.node_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_netgully AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    man_netgully.pol_id,
    man_netgully.sander_depth,
    man_netgully.gratecat_id,
    man_netgully.units,
    man_netgully.groove,
    man_netgully.siphon
   FROM v_node
     JOIN man_netgully ON man_netgully.node_id::text = v_node.node_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_netgully_pol AS 
 SELECT man_netgully.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_netgully ON man_netgully.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_netgully.pol_id::text;


CREATE OR REPLACE VIEW v_edit_man_netinit AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    man_netinit.length,
    man_netinit.width,
    man_netinit.inlet,
    man_netinit.bottom_channel,
    man_netinit.accessibility,
    man_netinit.name,
    man_netinit.sander_depth
   FROM v_node
     JOIN man_netinit ON man_netinit.node_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_outfall AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    man_outfall.name
   FROM v_node
     JOIN man_outfall ON man_outfall.node_id::text = v_node.node_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_siphon AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.elev2,
    v_arc.custom_y2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.z1,
    v_arc.z2,
    v_arc.r1,
    v_arc.r2,
    v_arc.slope,
    v_arc.arc_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.shape,
    v_arc.geom1 AS cat_geom1,
    v_arc.geom2 AS cat_geom2,
    v_arc.gis_length,
    v_arc.epa_type,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value,
    man_siphon.name
   FROM v_arc
     JOIN man_siphon ON man_siphon.arc_id::text = v_arc.arc_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_storage AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
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
     JOIN man_storage ON man_storage.node_id::text = v_node.node_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_storage_pol AS 
 SELECT man_storage.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_storage ON man_storage.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_storage.pol_id::text;


CREATE OR REPLACE VIEW v_edit_man_valve AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    man_valve.name
   FROM v_node
     JOIN man_valve ON man_valve.node_id::text = v_node.node_id::text;


CREATE OR REPLACE VIEW v_edit_man_varc AS 
 SELECT v_arc.arc_id,
    v_arc.code,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.elev2,
    v_arc.custom_y2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.z1,
    v_arc.z2,
    v_arc.r1,
    v_arc.r2,
    v_arc.slope,
    v_arc.arc_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.shape,
    v_arc.geom1 AS cat_geom1,
    v_arc.geom2 AS cat_geom2,
    v_arc.gis_length,
    v_arc.epa_type,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value
   FROM v_arc
     JOIN man_varc ON man_varc.arc_id::text = v_arc.arc_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_waccel AS 
 SELECT v_arc.arc_id,
    v_arc.node_1,
    v_arc.node_2,
    v_arc.y1,
    v_arc.custom_y1,
    v_arc.elev1,
    v_arc.custom_elev1,
    v_arc.sys_elev1,
    v_arc.y2,
    v_arc.elev2,
    v_arc.custom_y2,
    v_arc.custom_elev2,
    v_arc.sys_elev2,
    v_arc.z1,
    v_arc.z2,
    v_arc.r1,
    v_arc.r2,
    v_arc.slope,
    v_arc.arc_type,
    v_arc.arccat_id,
    v_arc.matcat_id,
    v_arc.shape,
    v_arc.geom1 AS cat_geom1,
    v_arc.geom2 AS cat_geom2,
    v_arc.gis_length,
    v_arc.epa_type,
    v_arc.sector_id,
    v_arc.macrosector_id,
    v_arc.state,
    v_arc.state_type,
    v_arc.annotation,
    v_arc.observ,
    v_arc.comment,
    v_arc.inverted_slope,
    v_arc.custom_length,
    v_arc.dma_id,
    v_arc.soilcat_id,
    v_arc.function_type,
    v_arc.category_type,
    v_arc.fluid_type,
    v_arc.location_type,
    v_arc.workcat_id,
    v_arc.workcat_id_end,
    v_arc.buildercat_id,
    v_arc.builtdate,
    v_arc.enddate,
    v_arc.ownercat_id,
    v_arc.muni_id,
    v_arc.postcode,
    v_arc.streetname,
    v_arc.postnumber,
    v_arc.postcomplement,
    v_arc.streetname2,
    v_arc.postnumber2,
    v_arc.postcomplement2,
    v_arc.descript,
    v_arc.link,
    v_arc.verified,
    v_arc.the_geom,
    v_arc.undelete,
    v_arc.label_x,
    v_arc.label_y,
    v_arc.label_rotation,
    v_arc.code,
    v_arc.publish,
    v_arc.inventory,
    v_arc.uncertain,
    v_arc.macrodma_id,
    v_arc.expl_id,
    v_arc.num_value,
    man_waccel.sander_length,
    man_waccel.sander_depth,
    man_waccel.prot_surface,
    man_waccel.name,
    man_waccel.accessibility
   FROM v_arc
     JOIN man_waccel ON man_waccel.arc_id::text = v_arc.arc_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_wjump AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    man_wjump.length,
    man_wjump.width,
    man_wjump.sander_depth,
    man_wjump.prot_surface,
    man_wjump.accessibility,
    man_wjump.name
   FROM v_node
     JOIN man_wjump ON man_wjump.node_id::text = v_node.node_id::text;

     
CREATE OR REPLACE VIEW v_edit_man_wwtp AS 
 SELECT v_node.node_id,
    v_node.code,
    v_node.top_elev,
    v_node.custom_top_elev,
    v_node.ymax,
    v_node.custom_ymax,
    v_node.elev,
    v_node.custom_elev,
        CASE
            WHEN v_node.sys_elev IS NOT NULL THEN v_node.sys_elev
            ELSE (v_node.sys_top_elev - v_node.sys_ymax)::numeric(12,3)
        END AS sys_elev,
    v_node.node_type,
    v_node.nodecat_id,
    v_node.epa_type,
    v_node.sector_id,
    v_node.macrosector_id,
    v_node.state,
    v_node.state_type,
    v_node.annotation,
    v_node.observ,
    v_node.comment,
    v_node.dma_id,
    v_node.soilcat_id,
    v_node.function_type,
    v_node.category_type,
    v_node.fluid_type,
    v_node.location_type,
    v_node.workcat_id,
    v_node.workcat_id_end,
    v_node.buildercat_id,
    v_node.builtdate,
    v_node.enddate,
    v_node.ownercat_id,
    v_node.muni_id,
    v_node.postcode,
    v_node.streetname,
    v_node.postnumber,
    v_node.postcomplement,
    v_node.streetname2,
    v_node.postnumber2,
    v_node.postcomplement2,
    v_node.descript,
    v_node.rotation,
    v_node.svg,
    v_node.link,
    v_node.verified,
    v_node.the_geom,
    v_node.undelete,
    v_node.label_x,
    v_node.label_y,
    v_node.label_rotation,
    v_node.publish,
    v_node.inventory,
    v_node.uncertain,
    v_node.xyz_date,
    v_node.unconnected,
    v_node.macrodma_id,
    v_node.expl_id,
    v_node.num_value,
    man_wwtp.pol_id,
    man_wwtp.name
   FROM v_node
     JOIN man_wwtp ON man_wwtp.node_id::text = v_node.node_id::text;

     CREATE OR REPLACE VIEW v_edit_man_wwtp_pol AS 
 SELECT man_wwtp.pol_id,
    v_node.node_id,
    polygon.the_geom
   FROM v_node
     JOIN man_wwtp ON man_wwtp.node_id::text = v_node.node_id::text
     JOIN polygon ON polygon.pol_id::text = man_wwtp.pol_id::text;

