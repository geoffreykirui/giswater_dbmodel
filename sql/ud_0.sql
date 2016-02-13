﻿/*
This file is part of Giswater
The program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.
This version of Giswater is provided by Giswater Association
*/

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- TOC entry 10 (class 2615 OID 151924)
-- Name: SCHEMA_NAME; Type: SCHEMA; Schema: -; Owner: -
--

--CREATE SCHEMA "SCHEMA_NAME";
SET search_path = "SCHEMA_NAME", public, pg_catalog;



-- -----------------------------
-- SEQUENCES
-- -----------------------------

CREATE SEQUENCE "SCHEMA_NAME"."version_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."node_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
	

CREATE SEQUENCE "SCHEMA_NAME"."arc_id_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

CREATE SEQUENCE "SCHEMA_NAME"."connec_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;

 
CREATE SEQUENCE "SCHEMA_NAME"."link_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."gully_seq"
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE SEQUENCE "SCHEMA_NAME"."node_flow_trace_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  

CREATE SEQUENCE "SCHEMA_NAME"."arc_flow_trace_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  

CREATE SEQUENCE "SCHEMA_NAME"."node_flow_exit_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;
  

CREATE SEQUENCE "SCHEMA_NAME"."arc_flow_exit_seq"
  START WITH 1
  INCREMENT BY 1
  NO MINVALUE
  NO MAXVALUE
  CACHE 1;




-- ----------------------------
-- Table system structure 
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."version" (
"id" int4 DEFAULT nextval('"SCHEMA_NAME".version_seq'::regclass) NOT NULL,
"giswater" varchar(16) COLLATE "default",
"wsoftware" varchar(16) COLLATE "default",
"postgres" varchar(512) COLLATE "default",
"postgis" varchar(512) COLLATE "default",
"date" timestamp(6) DEFAULT now(),
CONSTRAINT version_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;
 
CREATE TABLE "SCHEMA_NAME"."arc_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"type" varchar(18) COLLATE "default" NOT NULL,
"man_table" varchar(18) COLLATE "default" NOT NULL,
"epa_default" varchar(18) COLLATE "default" NOT NULL,
"epa_table" varchar(18) COLLATE "default" NOT NULL,
CONSTRAINT arc_type_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."node_type" (
"id" varchar(18) COLLATE "default" NOT NULL,
"type" varchar(18) COLLATE "default" NOT NULL,
"man_table" varchar(18) COLLATE "default" NOT NULL,
"epa_default" varchar(18) COLLATE "default" NOT NULL,
"epa_table" varchar(18) COLLATE "default" NOT NULL,
CONSTRAINT node_type_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


-- ----------------------------
-- Table structure for catalogs
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."cat_mat" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default",
"n" numeric(12,4),
CONSTRAINT cat_mat_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_arc" (
"id" varchar(30) COLLATE "default" NOT NULL,
"arctype_id" varchar(16) COLLATE "default",
"matcat_id" varchar (16) COLLATE "default",
"shape" varchar(16) COLLATE "default",
"tsect_id" varchar(16) COLLATE "default",
"curve_id" varchar(16) COLLATE "default",
"geom1" numeric(12,4),
"geom2" numeric(12,4) DEFAULT 0.00,
"geom3" numeric(12,4) DEFAULT 0.00,
"geom4" numeric(12,4) DEFAULT 0.00,
"geom_r" varchar(20) COLLATE "default",
"short_des" varchar(16) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_arc_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_node" (
"id" varchar(16) COLLATE "default" NOT NULL,
"nodetype_id" varchar(30) COLLATE "default",
"matcat_id" varchar (16) COLLATE "default",
"geom1" numeric (12,2),
"geom2" numeric (12,2),
"geom3" numeric (12,2),
"value" numeric (12,2),
"short_des" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_node_pkey PRIMARY KEY (id)

)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_connec" (
"id" varchar(30) COLLATE "default" NOT NULL,
"type" varchar(30) COLLATE "default" NOT NULL,
"matcat_id" varchar(16) COLLATE "default",
"matcat_2" varchar(16) COLLATE "default",
"matcat_3" varchar(16) COLLATE "default",
"dnom" int2,
"diameter" numeric (12,2),
"geom2" numeric (12,2),
"geom3" numeric (12,2),
"geom4" numeric (12,2),
"value" numeric (12,2),
"short_des" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
"link" varchar(512) COLLATE "default",
"url" varchar(512) COLLATE "default",
"picture" varchar(512) COLLATE "default",
"svg" varchar(50) COLLATE "default",
CONSTRAINT cat_connec_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_gully" (
"id" varchar(16) COLLATE "default" NOT NULL,
"type" varchar(16) COLLATE "default",
"matcat_id" varchar(16) COLLATE "default",
"matcat_2" varchar(16) COLLATE "default",
"matcat_3" varchar(16) COLLATE "default",
"number" integer,
"length" numeric(12,2),
"width" numeric(12,2),
"depth" numeric(12,2),
"area_tot" numeric(12,2),
"area_util" numeric(12,2),
"grate" varchar(30) COLLATE "default",
"recip" varchar(30) COLLATE "default",
"sandbox" varchar(30) COLLATE "default",
"siphon" varchar(30) COLLATE "default",
"n_barr_l" integer,
"n_barr_w" integer,
"n_barr_diag" integer,
"param_a" numeric(12,4),
"param_b" numeric(12,4),
"short_des" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
CONSTRAINT cat_gully_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_soil" (
"id" varchar(16) COLLATE "default" NOT NULL,
"short_des" varchar(30) COLLATE "default",
"descript" varchar(255) COLLATE "default",
CONSTRAINT cat_soil_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_manager" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_manager_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."cat_builder" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_builder_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;

CREATE TABLE "SCHEMA_NAME"."cat_work" (
"id" varchar(16) COLLATE "default" NOT NULL,
"descript" varchar(50) COLLATE "default",
"comment" varchar(512) COLLATE "default",
CONSTRAINT cat_work_pkey PRIMARY KEY (id)
)
WITH (OIDS=FALSE)
;




-- ----------------------------
-- Table structure
-- ----------------------------

CREATE TABLE "SCHEMA_NAME"."sector" (
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(100) COLLATE "default",
"the_geom" public.geometry (MULTIPOLYGON, 25831),
CONSTRAINT sector_pkey PRIMARY KEY (sector_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."dma" (
"dma_id" varchar(30) COLLATE "default" NOT NULL,
"sector_id" varchar(30) COLLATE "default" NOT NULL,
"descript" varchar(255) COLLATE "default",
"observ" character varying(512),
"event" character varying(30),
"the_geom" public.geometry (MULTIPOLYGON, 25831),
CONSTRAINT dma_pkey PRIMARY KEY (dma_id)
)
WITH (OIDS=FALSE)
;



CREATE TABLE "SCHEMA_NAME"."node" (
"node_id" varchar(16) COLLATE "default" NOT NULL,
"top_elev" numeric(12,4),
"ymax" numeric(12,4),
"nodecat_id" varchar(30) COLLATE "default",
"epa_type" varchar(16) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),

"function_type" varchar(18) COLLATE "default",
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"builtdate" varchar(20) COLLATE "default",
"text" varchar(50) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",

"db" numeric(12,4),
"i2" int2,
"i4" int4,
"t100" varchar(100) COLLATE "default",
"t500" varchar(500) COLLATE "default",

"the_geom" public.geometry (POINT, 25831),
CONSTRAINT node_pkey PRIMARY KEY (node_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."arc" (
"arc_id" varchar(16) COLLATE "default" NOT NULL,
"node_1" varchar(16) COLLATE "default",
"node_2" varchar(16) COLLATE "default",
"y1" numeric (12,3),
"y2" numeric (12,3),
"arccat_id" varchar(30) COLLATE "default",
"epa_type" varchar(16) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"direction" character varying(2),
"real_length" numeric (12,2),

"function_type" varchar(18) COLLATE "default",
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"builtdate" varchar(20) COLLATE "default",
"text" varchar(50) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",

"db" numeric(12,4),
"i2" int2,
"i4" int4,
"t100" varchar(100) COLLATE "default",
"t500" varchar(500) COLLATE "default",

"the_geom" public.geometry (LINESTRING, 25831),
CONSTRAINT arc_pkey PRIMARY KEY (arc_id)
)
WITH (OIDS=FALSE)
;

CREATE TABLE "SCHEMA_NAME"."connec" (
"connec_id" varchar DEFAULT nextval('"SCHEMA_NAME".connec_seq'::regclass) NOT NULL,
"top_elev" numeric(12,4),
"ymax" numeric(12,4),
"connecat_id" varchar(30) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"builtdate" varchar(20) COLLATE "default",
"text" varchar(50) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",
the_geom public.geometry (POINT, 25831),
CONSTRAINT connec_pkey PRIMARY KEY (connec_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."link" (
link_id varchar (16) DEFAULT nextval('"SCHEMA_NAME".link_seq'::regclass) NOT NULL,
connec_id varchar(16) COLLATE "default",
the_geom public.geometry (LINESTRING, 25831),
CONSTRAINT link_pkey PRIMARY KEY (link_id)
)
WITH (OIDS=FALSE)
;


CREATE TABLE "SCHEMA_NAME"."gully" (
"gully_id" varchar(16) COLLATE "default" NOT NULL,
"top_elev" numeric(12,4),
"catgully_id" varchar(18) COLLATE "default",
"sector_id" varchar(30) COLLATE "default",
"state" character varying(16),
"annotation" character varying(254),
"observ" character varying(254),
"comment" character varying(254),
"rotation" numeric (6,3),
"dma_id" varchar(30) COLLATE "default",
"soilcat_id" varchar(16) COLLATE "default",
"workcat_id" varchar(255) COLLATE "default",
"buildercat_id" varchar(30) COLLATE "default",
"category_type" varchar(18) COLLATE "default",
"fluid_type" varchar(18) COLLATE "default",
"location_type" varchar(18) COLLATE "default",
"builtdate" varchar(20) COLLATE "default",
"text" varchar(50) COLLATE "default",
"adress_01" varchar(50) COLLATE "default",
"adress_02" varchar(50) COLLATE "default",
"adress_03" varchar(50) COLLATE "default",
"descript" varchar(254) COLLATE "default",
"link" character varying(512),
"verified" varchar(4) COLLATE "default",
the_geom public.geometry (POINT, 25831),

CONSTRAINT gully_pkey PRIMARY KEY (gully_id)
)
WITH (OIDS=FALSE)
;



------
-- FK
------

ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_arc" ADD FOREIGN KEY ("arctype_id") REFERENCES "SCHEMA_NAME"."sys_arc_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("matcat_id") REFERENCES "SCHEMA_NAME"."cat_mat" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."cat_node" ADD FOREIGN KEY ("nodetype_id") REFERENCES "SCHEMA_NAME"."sys_node_type" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("nodecat_id") REFERENCES "SCHEMA_NAME"."cat_node" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("epa_type") REFERENCES "SCHEMA_NAME"."sys_node_epa" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."node" ADD FOREIGN KEY ("epa_type") REFERENCES "SCHEMA_NAME"."epa_node_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("arccat_id") REFERENCES "SCHEMA_NAME"."cat_arc" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("epa_type") REFERENCES "SCHEMA_NAME"."sys_arc_epa" ("id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("sector_id") REFERENCES "SCHEMA_NAME"."sector" ("sector_id") ON DELETE RESTRICT ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_1") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("node_2") REFERENCES "SCHEMA_NAME"."node" ("node_id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "SCHEMA_NAME"."arc" ADD FOREIGN KEY ("epa_type") REFERENCES "SCHEMA_NAME"."epa_arc_type" ("id") ON DELETE CASCADE ON UPDATE CASCADE;


