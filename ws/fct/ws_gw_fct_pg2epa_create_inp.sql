/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2526

DROP FUNCTION IF EXISTS  SCHEMA_NAME.gw_fct_pg2epa_create_inp(character varying, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_create_inp(p_result_id character varying,  p_path text)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_create_inp('result_1', 'D:\dades\test.inp')
*/

DECLARE
rec_table record;
column_number integer;
id_last integer;
num_col_rec record;
num_column text;
result_id_aux varchar;
title_aux varchar;
v_pg2csvcat_id integer=10;
v_demandtype integer;
v_patternmethod	integer;
v_networkmode integer;
v_valvemode integer;
v_demandtypeval text;
v_patternmethodval text;
v_valvemodeval text;
v_networkmodeval text;
v_return json;

BEGIN


	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	--Delete previous
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_pg2csvcat_id;

	-- get parameters to put on header
	SELECT result_id INTO result_id_aux FROM inp_selector_result where cur_user=current_user;
	SELECT title INTO title_aux FROM inp_project_id where author=current_user;
	SELECT value INTO v_demandtype FROM config_param_user WHERE parameter = 'inp_options_demandtype' AND cur_user=current_user;
	SELECT value INTO v_patternmethod FROM config_param_user WHERE parameter = 'inp_options_patternmethod' AND cur_user=current_user;
	SELECT value INTO v_valvemode FROM config_param_user WHERE parameter = 'inp_options_valve_mode' AND cur_user=current_user;
	SELECT value INTO v_networkmode FROM config_param_user WHERE parameter = 'inp_options_networkmode' AND cur_user=current_user;
	SELECT idval INTO v_demandtypeval FROM inp_typevalue WHERE id=v_demandtype::text AND typevalue ='inp_value_demandtype';
	SELECT idval INTO v_patternmethodval FROM inp_typevalue WHERE id=v_patternmethod::text AND typevalue ='inp_value_patternmethod';
	SELECT idval INTO v_valvemodeval FROM inp_typevalue WHERE id=v_valvemode::text AND typevalue ='inp_value_opti_valvemode';
	SELECT idval INTO v_networkmodeval FROM inp_typevalue WHERE id=v_networkmode::text AND typevalue ='inp_options_networkmode';

	--writing the header
	INSERT INTO temp_csv2pg (source, csv1,csv2pgcat_id) VALUES ('header','[TITLE]',v_pg2csvcat_id);
	INSERT INTO temp_csv2pg (source, csv1,csv2pgcat_id) VALUES ('header',';INP file created by Giswater, the water management open source tool',v_pg2csvcat_id);
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Project name: ',title_aux, v_pg2csvcat_id);
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Result name: ',p_result_id,v_pg2csvcat_id); 
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Export mode: ', v_networkmodeval, v_pg2csvcat_id ); 
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Demand type: ', v_demandtypeval, v_pg2csvcat_id); 
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Pattern method: ', v_patternmethodval, v_pg2csvcat_id); 
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Valve mode: ', v_valvemodeval, v_pg2csvcat_id); 
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Datetime: ',left((date_trunc('second'::text, now()))::text, 19),v_pg2csvcat_id); 
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';User: ',current_user, v_pg2csvcat_id); 
	INSERT INTO temp_csv2pg (csv1,csv2pgcat_id) VALUES (NULL,v_pg2csvcat_id); 

	--node
	FOR rec_table IN SELECT * FROM sys_csv2pg_config WHERE pg2csvcat_id=v_pg2csvcat_id AND csvversion::json->>'from'='2.0.12' order by id
	LOOP
		-- insert header
		INSERT INTO temp_csv2pg (csv1,csv2pgcat_id) VALUES (NULL,v_pg2csvcat_id); 
		EXECUTE 'INSERT INTO temp_csv2pg(csv2pgcat_id,csv1) VALUES ('||v_pg2csvcat_id||','''|| rec_table.target||''');';

		-- insert fieldnames
		IF rec_table.tablename = 'vi_patterns' THEN
			INSERT INTO temp_csv2pg (csv2pgcat_id,csv1,csv2) VALUES (10, ';ID', 'Multipliers');
			num_column = 2;
		ELSE 
			INSERT INTO temp_csv2pg (csv2pgcat_id,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13) 
			SELECT v_pg2csvcat_id,rpad(concat(';',c1),20),rpad(c2,20),rpad(c3,20),rpad(c4,20),rpad(c5,20),rpad(c6,20),rpad(c7,20),rpad(c8,20),rpad(c9,20),rpad(c10,20),
			rpad(c11,20),rpad(c12,20),rpad(c13,20)
			FROM crosstab('SELECT table_name::text,  data_type::text, column_name::text FROM information_schema.columns WHERE table_schema =''SCHEMA_NAME'' and table_name='''||
			rec_table.tablename||'''::text') 
			AS rpt(table_name text, c1 text, c2 text, c3 text, c4 text, c5 text, c6 text, c7 text, c8 text, c9 text, c10 text, c11 text, c12 text, c13 text);

			SELECT count(*)::text INTO num_column from information_schema.columns where table_name=rec_table.tablename AND table_schema='SCHEMA_NAME';
		END IF;
	
		INSERT INTO temp_csv2pg (csv2pgcat_id) VALUES (10) RETURNING id INTO id_last;
  
		--add underlines    
		FOR num_col_rec IN 1..num_column
		LOOP
			IF num_col_rec=1 then
				EXECUTE 'UPDATE temp_csv2pg set csv1=rpad('';-------'',20) WHERE id='||id_last||';';
			ELSE
				EXECUTE 'UPDATE temp_csv2pg SET csv'||num_col_rec||'=rpad(''-------'',20) WHERE id='||id_last||';';
			END IF;
		END LOOP;

		-- insert values
		CASE WHEN rec_table.tablename='vi_options' and (SELECT value FROM vi_options WHERE parameter='hydraulics') is null THEN
			EXECUTE 'INSERT INTO temp_csv2pg SELECT nextval(''temp_csv2pg_id_seq''::regclass),'||v_pg2csvcat_id||',current_user,'''||rec_table.tablename::text||''',*  FROM '||
			rec_table.tablename||' WHERE parameter!=''hydraulics'';';
		ELSE
			EXECUTE 'INSERT INTO temp_csv2pg SELECT nextval(''temp_csv2pg_id_seq''::regclass),'||v_pg2csvcat_id||',current_user,'''||rec_table.tablename::text||''',*  FROM '||
			rec_table.tablename||';';
		END CASE;
  
		--add formating - spaces
		IF p_path IS NOT NULL THEN
			FOR num_col_rec IN 1..num_column::integer
			LOOP
				IF num_col_rec < num_column::integer THEN
					EXECUTE 'UPDATE temp_csv2pg SET csv'||num_col_rec||'=rpad(csv'||num_col_rec||',20) WHERE source='''||rec_table.tablename||''';';
				END IF;
			END LOOP;
		END IF;
	END LOOP;

	-- use the copy function of postgres to export to file in case of file must be provided as a parameter
	IF p_path IS NOT NULL THEN
		EXECUTE 'COPY (SELECT csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12,csv13,csv14,csv15,csv16,csv17,csv18 ,csv19 
		FROM temp_csv2pg WHERE csv2pgcat_id=10 and user_name=current_user order by id) TO '''||p_path||''' WITH (DELIMITER E''\t'', FORMAT CSV);';
	END IF;

	-- build return
	select (array_to_json(array_agg(row_to_json(row))))::json  -- spacer-19 it's used because a rare bug reading epanet when spacer=20 on target [PATTERNS]????
	into v_return 
		from ( select text from
		(select id, concat(rpad(csv1,18), ' ', csv2)as text from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source is null
		union
		select id, concat(rpad(csv1,18), ' ', csv2)as text from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source in ('header')
		union
		select id, csv1 as text from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source in ('vi_controls','vi_rules', 'vi_backdrop')
		union
		select id, concat(rpad(csv1,18),' ',rpad(csv2,18),' ', rpad(csv3,18),' ',rpad(csv4,18),' ',rpad(csv5,18),' ',rpad(csv6,18),' ',rpad(csv7,18),' ',
		rpad(csv8,18),' ',rpad(csv9,18),' ',rpad(csv10,18),' ',rpad(csv11,18),' ',rpad(csv12,18),' ',rpad(csv13,18),' ',rpad(csv14,18),' ',rpad(csv15,18),' ',
		rpad(csv15,18),' ',rpad(csv16,18),' ',rpad(csv17,18),' ', rpad(csv18,18), ' ', rpad(csv19,18),' ',rpad(csv20,18)) as text
		from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source not in ('header','vi_controls','vi_rules', 'vi_backdrop')
		order by id)a )row;
	
RETURN v_return;
        
END;$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

