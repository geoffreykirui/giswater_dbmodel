/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/


SET search_path = SCHEMA_NAME, public, pg_catalog;


CREATE OR REPLACE VIEW vi_energy AS 
 SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
    inp_typevalue.idval,
    inp_pump.energyvalue
   FROM inp_selector_result,
    inp_pump
     JOIN rpt_inp_arc ON concat(inp_pump.node_id, '_n2a') = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue ON inp_pump.energyparam::text = inp_typevalue.id::text AND inp_typevalue.typevalue::text = 'inp_value_param_energy'::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND energyparam IS NOT NULL
UNION
 SELECT concat('PUMP ', rpt_inp_arc.arc_id) AS pump_id,
    inp_pump_additional.energyparam AS idval,
    inp_pump_additional.energyvalue
   FROM inp_selector_result,
    inp_pump_additional
     JOIN rpt_inp_arc ON concat(inp_pump_additional.node_id, '_n2a') = rpt_inp_arc.arc_id::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text AND energyparam IS NOT NULL
UNION
 SELECT inp_energy.descript AS pump_id,
    NULL::character varying AS idval,
    NULL::character varying AS energyvalue
   FROM inp_energy;

CREATE OR REPLACE VIEW vi_reactions AS 
 SELECT inp_typevalue.idval,
    inp_pipe.arc_id,
    inp_pipe.reactionvalue
   FROM inp_selector_result,
    inp_pipe
     JOIN rpt_inp_arc ON inp_pipe.arc_id::text = rpt_inp_arc.arc_id::text
     LEFT JOIN inp_typevalue ON upper(inp_pipe.reactionparam::text) = inp_typevalue.id::text AND inp_typevalue.typevalue::text = 'inp_value_reactions'::text
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
  AND idval IS NOT NULL
UNION
 SELECT upper(inp_reactions.descript) AS idval,
    NULL::character varying AS arc_id,
    NULL::character varying AS reactionvalue
   FROM inp_reactions
   order by 1;
   

CREATE OR REPLACE VIEW vi_status AS SELECT rpt_inp_arc.arc_id,
   idval
   FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_valve ON rpt_inp_arc.arc_id::text = concat(inp_valve.node_id, '_n2a')
     JOIN inp_typevalue ON inp_typevalue.id=rpt_inp_arc.status
  WHERE rpt_inp_arc.status::text = 'CLOSED'::text OR rpt_inp_arc.status::text = 'OPEN'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text 
  AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
   idval
    FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
     JOIN inp_typevalue ON inp_typevalue.id=rpt_inp_arc.status
 WHERE inp_pump.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id,
   idval
    FROM inp_selector_result,
    rpt_inp_arc
     JOIN inp_pump_additional ON rpt_inp_arc.arc_id::text = concat(inp_pump_additional.node_id, '_n2a', inp_pump_additional.order_id)
    LEFT JOIN inp_typevalue ON inp_typevalue.id=rpt_inp_arc.status
  WHERE inp_pump_additional.status::text = 'CLOSED'::text AND rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;


  
DROP VIEW vi_curves;
CREATE OR REPLACE VIEW vi_curves AS 
 SELECT
        CASE
            WHEN a.x_value IS NULL THEN a.curve_type::character varying(16)
            ELSE a.curve_id
        END AS curve_id,
    a.x_value::numeric(12,4) AS x_value,
    a.y_value::numeric(12,4) AS y_value,
	null::text as other
   FROM ( SELECT DISTINCT ON (inp_curve.curve_id) ( SELECT min(sub.id) AS min
                   FROM inp_curve sub
                  WHERE sub.curve_id::text = inp_curve.curve_id::text) AS id,
            inp_curve.curve_id,
            concat(';', inp_curve_id.curve_type, ':', inp_curve_id.descript ) AS curve_type,
            NULL::numeric AS x_value,
            NULL::numeric AS y_value
           FROM inp_curve_id
             JOIN inp_curve ON inp_curve.curve_id::text = inp_curve_id.id::text
        UNION
         SELECT inp_curve.id,
            inp_curve.curve_id,
            inp_curve_id.curve_type,
            inp_curve.x_value,
            inp_curve.y_value
           FROM inp_curve
             JOIN inp_curve_id ON inp_curve.curve_id::text = inp_curve_id.id::text
  ORDER BY 1, 4 DESC) a;
  
  
  
  CREATE OR REPLACE VIEW vi_pumps AS
  SELECT rpt_inp_arc.arc_id::text AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ('POWER'::text || ' '::text) || inp_pump.power::text AS power,
    ('HEAD'::text || ' '::text) || inp_pump.curve_id::text AS head,
    ('SPEED'::text || ' '::text) || inp_pump.speed AS speed,
    ('PATTERN'::text || ' '::text) || inp_pump.pattern::text AS pattern
   FROM inp_selector_result,  inp_pump
    JOIN rpt_inp_arc ON rpt_inp_arc.arc_id::text = concat(inp_pump.node_id, '_n2a')
  WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text
UNION
 SELECT rpt_inp_arc.arc_id::text AS arc_id,
    rpt_inp_arc.node_1,
    rpt_inp_arc.node_2,
    ('POWER'::text || ' '::text) || inp_pump_additional.power::text AS power,
    ('HEAD'::text || ' '::text) || inp_pump_additional.curve_id::text AS head,
    ('SPEED'::text || ' '::text) || inp_pump_additional.speed AS speed,
    ('PATTERN'::text || ' '::text) || inp_pump_additional.pattern::text AS pattern
   FROM inp_selector_result, inp_pump_additional
    JOIN rpt_inp_arc ON rpt_inp_arc.flw_code = concat(inp_pump_additional.node_id, '_n2a')
    WHERE rpt_inp_arc.result_id::text = inp_selector_result.result_id::text AND inp_selector_result.cur_user = "current_user"()::text;

