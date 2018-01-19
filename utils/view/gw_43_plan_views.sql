﻿/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET search_path = "SCHEMA_NAME", public, pg_catalog;


	
	
--------------------------------
-- View structure for v_plan_psector views
--------------------------------

DROP VIEW IF EXISTS "v_plan_psector_x_arc" CASCADE;
CREATE VIEW "v_plan_psector_x_arc" AS 
SELECT 
	row_number() OVER (ORDER BY v_plan_arc.arc_id) AS rid,
    v_plan_arc.arc_id,
    v_plan_arc.arccat_id,
    v_plan_arc.cost_unit,
    v_plan_arc.cost::numeric(14,2) AS cost,
    v_plan_arc.length,
    v_plan_arc.budget,
    v_plan_arc.other_budget,
    v_plan_arc.total_budget,
    plan_arc_x_psector.psector_id,
    plan_psector.psector_type,
    v_plan_arc.state,
     plan_psector.expl_id,
    plan_psector.atlas_id,
    v_plan_arc.the_geom
   FROM selector_psector, v_plan_arc
    JOIN plan_arc_x_psector ON plan_arc_x_psector.arc_id::text = v_plan_arc.arc_id::text
    JOIN plan_psector ON plan_psector.psector_id = plan_arc_x_psector.psector_id
    WHERE selector_psector.cur_user = "current_user"()::text AND selector_psector.psector_id = plan_arc_x_psector.psector_id 
	AND v_plan_arc.state = 2 AND plan_arc_x_psector.doable = true;
  
  
  
 
DROP VIEW IF EXISTS "v_plan_psector_x_node" CASCADE;
CREATE VIEW "v_plan_psector_x_node" AS 
SELECT
row_number() OVER (ORDER BY v_plan_node.node_id) AS rid,
v_plan_node.node_id,
v_plan_node.nodecat_id,
v_plan_node.cost::numeric(12,2),
v_plan_node.calculated_depth,
v_plan_node.budget as total_budget,
plan_node_x_psector.psector_id,
plan_psector.psector_type,
v_plan_node."state",
v_plan_node.expl_id,
plan_psector.atlas_id,
v_plan_node.the_geom
FROM selector_psector, v_plan_node
JOIN plan_node_x_psector ON plan_node_x_psector.node_id = v_plan_node.node_id
JOIN plan_psector ON plan_psector.psector_id = plan_node_x_psector.psector_id
WHERE selector_psector.cur_user="current_user"() AND selector_psector.psector_id=plan_node_x_psector.psector_id
AND v_plan_node.state=2;

  

DROP VIEW IF EXISTS "v_plan_psector_x_other";
CREATE VIEW "v_plan_psector_x_other" AS 
SELECT
plan_other_x_psector.id,
plan_other_x_psector.psector_id,
plan_psector.psector_type,
v_price_compost.id AS price_id,
v_price_compost.descript,
v_price_compost.price,
plan_other_x_psector.measurement,
(plan_other_x_psector.measurement*v_price_compost.price)::numeric(14,2) AS total_budget
FROM plan_other_x_psector 
JOIN v_price_compost ON v_price_compost.id = plan_other_x_psector.price_id
JOIN plan_psector ON plan_psector.psector_id = plan_other_x_psector.psector_id
ORDER BY psector_id;



DROP VIEW IF EXISTS "v_plan_psector";
CREATE VIEW "v_plan_psector" AS 
SELECT plan_psector.psector_id,
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
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pem,
gexpenses,

((100::numeric + plan_psector.gexpenses) / 100::numeric)::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pec,

plan_psector.vat,

(((100::numeric + plan_psector.gexpenses) / 100::numeric) * ((100::numeric + plan_psector.vat) / 100::numeric))::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pec_vat,


plan_psector.other,

(((100::numeric + plan_psector.gexpenses) / 100::numeric) * ((100::numeric + plan_psector.vat) / 100::numeric) * ((100::numeric + plan_psector.other) / 100::numeric))::numeric(14,2) * 
((CASE WHEN a.suma IS NULL THEN 0 ELSE a.suma END)+ 
(CASE WHEN b.suma IS NULL THEN 0 ELSE b.suma END)+ 
(CASE WHEN c.suma IS NULL THEN 0 ELSE c.suma END))::numeric(14,2) AS pca,

plan_psector.the_geom
FROM selector_psector, plan_psector
     LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_arc group by psector_id) a ON a.psector_id = plan_psector.psector_id
     LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_node group by psector_id) b ON b.psector_id = plan_psector.psector_id
     LEFT JOIN (select sum(total_budget)as suma,psector_id from v_plan_psector_x_other group by psector_id) c ON c.psector_id = plan_psector.psector_id
     WHERE plan_psector.psector_id = selector_psector.psector_id AND selector_psector.cur_user = "current_user"()::text
