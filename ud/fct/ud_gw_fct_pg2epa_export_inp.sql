/*
This file is part of Giswater 3
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

--FUNCTION CODE:2528

DROP FUNCTION IF EXISTS  SCHEMA_NAME.gw_fct_utils_csv2pg_export_swmm_inp(character varying, text);
CREATE OR REPLACE FUNCTION SCHEMA_NAME.gw_fct_pg2epa_export_inp(p_result_id character varying,  p_path text)
RETURNS json AS
$BODY$

/*EXAMPLE
SELECT SCHEMA_NAME.gw_fct_pg2epa_export_inp('result_1', 'D:\dades\test_ud.inp')
*/

DECLARE
rec_table record;
column_number integer;
id_last integer;
num_col_rec record;
num_column text;
result_id_aux varchar;
title_aux varchar;
v_pg2csvcat_id integer = 10;
v_return json;

BEGIN

	-- Search path
	SET search_path = "SCHEMA_NAME", public;

	--Delete previous
	DELETE FROM temp_csv2pg WHERE user_name=current_user AND csv2pgcat_id=v_pg2csvcat_id;
      
	SELECT result_id INTO result_id_aux FROM inp_selector_result where cur_user=current_user;
	SELECT title INTO title_aux FROM inp_project_id where author=current_user;

	INSERT INTO temp_csv2pg (source, csv1,csv2pgcat_id) VALUES ('header','[TITLE]',v_pg2csvcat_id);
	INSERT INTO temp_csv2pg (source, csv1,csv2pgcat_id) VALUES ('header',';Created by Giswater, the water management open source tool',v_pg2csvcat_id);
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Project name: ',title_aux, v_pg2csvcat_id);
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Result name: ',p_result_id,v_pg2csvcat_id); 
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';Datetime: ',left((date_trunc('second'::text, now()))::text, 19),v_pg2csvcat_id); 
	INSERT INTO temp_csv2pg (source, csv1,csv2,csv2pgcat_id) VALUES ('header',';User: ',current_user, v_pg2csvcat_id);  

	--node
	FOR rec_table IN SELECT * FROM sys_csv2pg_config WHERE pg2csvcat_id=v_pg2csvcat_id AND csvversion::json->>'from'='5.0.022' order by id
	LOOP
		-- insert header
		INSERT INTO temp_csv2pg (csv1,csv2pgcat_id) VALUES (NULL,v_pg2csvcat_id); 
		EXECUTE 'INSERT INTO temp_csv2pg(csv2pgcat_id,csv1) VALUES ('||v_pg2csvcat_id||','''|| rec_table.target||''');';
	
		INSERT INTO temp_csv2pg (csv2pgcat_id,csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12) 
		SELECT v_pg2csvcat_id,rpad(concat(';;',c1),20),rpad(c2,20),rpad(c3,20),rpad(c4,20),rpad(c5,20),rpad(c6,20),rpad(c7,20),rpad(c8,20),rpad(c9,20),rpad(c10,20),rpad(c11,20),rpad(c12,20)
		FROM crosstab('SELECT table_name::text,  data_type::text, column_name::text FROM information_schema.columns WHERE table_schema =''SCHEMA_NAME'' and table_name='''||rec_table.tablename||'''::text') 
		AS rpt(table_name text, c1 text, c2 text, c3 text, c4 text, c5 text, c6 text, c7 text, c8 text, c9 text, c10 text, c11 text, c12 text);
	
		INSERT INTO temp_csv2pg (csv2pgcat_id) VALUES (10) RETURNING id INTO id_last;
	
		SELECT count(*)::text INTO num_column from information_schema.columns where table_name=rec_table.tablename AND table_schema='SCHEMA_NAME';
	
		--add underlines    
		FOR num_col_rec IN 1..num_column
		LOOP
			IF num_col_rec=1 then
				EXECUTE 'UPDATE temp_csv2pg set csv1=rpad('';;-------'',20) WHERE id='||id_last||';';
			ELSE
				EXECUTE 'UPDATE temp_csv2pg SET csv'||num_col_rec||'=rpad(''-------'',20) WHERE id='||id_last||';';
			END IF;
		END LOOP;
	
		-- insert values
	--	CASE WHEN rec_table.tablename='vi_options' and (SELECT value FROM vi_options WHERE parameter='hydraulics') is null THEN
			--EXECUTE 'INSERT INTO temp_csv2pg SELECT nextval(''temp_csv2pg_id_seq''::regclass),'||v_pg2csvcat_id||',current_user,'''||rec_table.tablename::text||''',*  FROM '||rec_table.tablename||' WHERE parameter!=''hydraulics'';';
	--	ELSE
			EXECUTE 'INSERT INTO temp_csv2pg SELECT nextval(''temp_csv2pg_id_seq''::regclass),'||v_pg2csvcat_id||',current_user,'''||rec_table.tablename::text||''',*  FROM '||rec_table.tablename||';';
	--	END CASE;
	

		IF p_path IS NOT NULL THEN
			--add formating - spaces
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
		EXECUTE 'COPY (SELECT csv1,csv2,csv3,csv4,csv5,csv6,csv7,csv8,csv9,csv10,csv11,csv12 FROM temp_csv2pg WHERE csv2pgcat_id=10 and user_name=current_user order by id) 
		TO '''||p_path||''' WITH (DELIMITER E''\t'', FORMAT CSV);';
	END IF;

	-- build return
	select (array_to_json(array_agg(row_to_json(row))))::json
	into v_return 
		from ( select text from
		(select id, concat(rpad(csv1,20), ' ', csv2)as text from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source is null
		union
		select id, csv1 as text from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source in ('vi_controls','vi_rules', 'vi_backdrop', 'vi_hydrographs','vi_polygons','vi_transects')
		union
		select id, concat(rpad(csv1,20), ' ', csv2)as text from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source in ('header', 'vi_adjustments','vi_evaporation','vi_temperature')
		union
		select id, concat(rpad(csv1,20), ' ', rpad(csv2,20), ' ', csv3)as text from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source in ('vi_files')
		union
		select id, concat(rpad(csv1,20),' ',rpad(csv2,20),' ', rpad(csv3,20),' ',rpad(csv4,20),' ',rpad(csv5,20),' ',rpad(csv6,20),' ',rpad(csv7,20),' ',
		rpad(csv8,20),' ',rpad(csv9,20),' ',rpad(csv10,20),' ',rpad(csv11,20),' ',rpad(csv12,20),' ',rpad(csv13,20),' ',rpad(csv14,20),' ',rpad(csv15,20),' ',
		rpad(csv15,20),' ',rpad(csv16,20),' ',rpad(csv17,20),' ', rpad(csv20,20), ' ', rpad(csv19,20),' ',rpad(csv20,20)) as text
		from temp_csv2pg where csv2pgcat_id  = 10 and user_name = current_user and source not in 
		('header','vi_controls','vi_rules', 'vi_backdrop', 'vi_adjustments','vi_evaporation', 'vi_files','vi_hydrographs','vi_polygons','vi_temperature','vi_transects')
		order by id)a )row;
	
RETURN v_return;
        
END;$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;